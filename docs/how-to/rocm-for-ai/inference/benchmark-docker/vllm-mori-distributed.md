# vLLM distributed inference with MoRI

This document provides a comprehensive guide for setting up a high-performance
vLLM serving environment on an AMD MI300X or MI325X GPU cluster using the [MoRI
(Modular RDMA Interface)](https://github.com/rocm/mori) communication backend.
It also includes detailed instructions on how to reproduce the benchmark
results published in the AMD ROCm blog [Practical, Fault-Robust Distributed
Inference for DeepSeek on AMD
MI300X](https://rocm.blogs.amd.com/software-tools-optimization/wide-ep-deepseek/README.html).

## Prerequisites

The following hardware configuration is required to implement this setup:

* **Nodes**: A minimum of two GPU nodes (virtual machines or physical machines)
  for wide EP evaluation.
* **AMD GPUs**: 8x AMD Instinct MI300X/MI325X GPU cards per node.
* **Networking**: 8x NVIDIA Mellanox ConnectX-7 (CX7) NICs per node, providing
  a dedicated 1:1 mapping between GPUs and network interfaces for optimal
  inter-node communication.

## System Optimization and Software Deployment

## 1. System Configuration

### 1.1 Software Baseline (Verified Versions)

This setup has been validated using the **AI/ML Ready Image (ROCm 7-based)** on
**DigitalOcean AMD GPU Droplets**. The following table outlines the software
stack versions and the commands for verification:

| Component | Version | Verification command |
| :--- | :--- | :--- |
| **OS** | Ubuntu 24.04.3 LTS | `cat /etc/os-release` |
| **Kernel** | 6.8.0-87-generic |`uname -r `|
| **ROCm** | 7.0.2 | `amd-smi version` |
| **BKC** | 25.16.03 |  |
| **CX7 Firmware** | 28.46.3048 | `dkms status` |
| **CX7 Driver** | 24.10-3.2.5 | `dkms status` |
| **GPU Driver** | DOCA 2.9.3 | `dpkg -l | grep doca` |

```{important}
**Mandatory Health Check**: Before proceeding with software deployment,
verify that all cluster nodes comply with the [MI300X Basic Health
Checks](https://instinct.docs.amd.com/projects/system-acceptance/en/latest/gpus/mi300x.html#basic-health-checks)
or [MI325X Basic Health
Checks](https://instinct.docs.amd.com/projects/system-acceptance/en/latest/gpus/mi325x.html#basic-health-checks).
Key requirements include specific kernel boot arguments, minimum system
memory thresholds, PCIe Gen5 link stability, and so on.
```

### 1.2 Backend Network Configuration (Netplan)
Configure the backend NICs for high-bandwidth inter-node communication. Suppose the GPU’s eight network interface controllers (NICs) are eth2 to eth9. Each NIC must have its own subnet that is disjoint from the others. For example, eth2 could use `192.168.50.0/24`, eth3 could use `192.168.51.0/24`, and so on. Each node needs a unique IP address on each subnet. We recommend using the same final octet in each subnet for a given node. For example, one node would have the addresses `192.168.50.2`, `192.168.51.2`, and so on. Another node would have `192.168.50.3`, `192.168.51.3`, and so on. Ensure MTU is set to `4200`.

**Example `/etc/netplan/50-backend.yaml`:**
```yaml
eth2:
  dhcp4: false
  dhcp6: false
  link-local: []          
  addresses:
    - 192.168.50.2/24
  mtu: 4200
eth3:
  dhcp4: false
  dhcp6: false
  link-local: []
  addresses:
    - 192.168.51.2/24
  mtu: 4200
eth4:
  dhcp4: false
  dhcp6: false
  link-local: []
  addresses:
    - 192.168.52.2/24
  mtu: 4200
eth5:
  dhcp4: false
  dhcp6: false
  link-local: []
  addresses:
    - 192.168.53.2/24
  mtu: 4200
eth6:
  dhcp4: false
  dhcp6: false
  link-local: []
  addresses:
    - 192.168.54.2/24
  mtu: 4200
eth7:
  dhcp4: false
  dhcp6: false
  link-local: []
  addresses:
    - 192.168.55.2/24
  mtu: 4200 
eth8:
  dhcp4: false
  dhcp6: false
  link-local: []
  addresses:
    - 192.168.56.2/24
  mtu: 4200
eth9:
  dhcp4: false
  dhcp6: false
  link-local: []
  addresses:
    - 192.168.57.2/24
  mtu: 4200
```
*Apply configuration:* `sudo netplan apply`    
*Verify the configuration:* `sudo apt install -y net-tools && ip -br a`    

<br>

### 1.3 NFS Configuration
Setting up a shared NFS volume facilitates centralized storage for models, recipes, and logs across the cluster. Use the following commands to install the necessary client tools and mount the remote directory. Replace `nfs_server_ip:/shared/folder` and `/mount/point` with your specific server details and desired local mount path.

``` bash
sudo apt update && sudo apt install -y nfs-common
sudo mkdir -p /mount/point
sudo mount -t nfs nfs_server_ip:/shared/folder /mount/point
echo "nfs_server_ip:/shared/folder /mount/point nfs _netdev,nofail,x-systemd.automount,x-systemd.idle-timeout=600,vers=4.2 0 0" | sudo tee -a /etc/fstab
```

<br>

### 1.4 Static Hostname Resolution for Backend Initialization (Optional)
If the high-speed RDMA/IB interfaces are used for the initial distributed coordination (e.g., `MASTER_ADDR`), you must configure static hostname resolution. This ensures that cluster hostnames resolve to the backend network IPs rather than the management or local loopback addresses.

**Configuration Steps:**
1. Open `/etc/hosts` on all nodes: `sudo vim /etc/hosts`
2. Add the backend IP and hostname mappings.
3. Comment out any default local mappings (e.g., `127.0.1.1`) for the current hostname to avoid resolution conflicts.

**Example `/etc/hosts` entries:**
```text
# Map hostnames to backend network IPs
192.168.50.2 mori_test_01
192.168.50.3 mori_test_02

# Comment out the default entry to ensure resolution via the backend IP
# 127.0.1.1 mori_test_01 mori_test_01 
```

<div style="page-break-after: always;"></div>

## 2. Software Configuration

### 2.1 CX7 Driver and Firmware Installation
1.  **Driver Installation:** Download and install `DOCA 2.9.3` from the [NVIDIA official website](https://developer.nvidia.com/doca-downloads).
2.  **Firmware Installation:** Download the appropriate firmware for your hardware PSID from the [NVIDIA official website](https://network.nvidia.com/support/firmware/connectx7/) and flash the device.
3.  **Verify Driver and Firmware Version:** `ethtool -i <IB Device>`  
<br>

### 2.2 ROCm Installation
For comprehensive installation instructions, refer to the [official ROCm documentation](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/quick-start.html#rocm-installation). The following commands provide a quick-start for ROCm 7.0.2 on Ubuntu 24.04 (Noble):
``` bash
wget https://repo.radeon.com/amdgpu-install/7.0.2/ubuntu/noble/amdgpu-install_7.0.2.70002-1_all.deb
sudo apt install ./amdgpu-install_7.0.2.70002-1_all.deb
sudo apt update
sudo apt install python3-setuptools python3-wheel
sudo usermod -a -G render,video $LOGNAME # Add the current user to the render and video groups
sudo apt install rocm
```
<br>

### 2.3 AMD GPU Driver Installation 
For comprehensive installation instructions, refer to the [official documentation](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/quick-start.html#amdgpu-driver-installation). The following commands provide a quick-start for AMD GPU driver 6.14.14 on Ubuntu 24.04 (Noble):
``` bash
wget https://repo.radeon.com/amdgpu-install/7.0.2/ubuntu/noble/amdgpu-install_7.0.2.70002-1_all.deb
sudo apt install ./amdgpu-install_7.0.2.70002-1_all.deb
sudo apt update
sudo apt install "linux-headers-$(uname -r)" "linux-modules-extra-$(uname -r)"
sudo apt install amdgpu-dkms
```

<div style="page-break-after: always;"></div>

## 3. Verification & Testing

### 3.1 Network Connectivity Verification
Verify that all network interfaces are reachable across the cluster nodes. Assuming `eth0` is the management interface, `eth1` is for the VPC, and `eth2-eth9` are the dedicated RoCE backend interfaces, use the following loop to test reachability to a remote node (e.g., a target node with host IP suffix `.3`).

```bash
# Test connectivity for RoCE subnets 192.168.50.x through 192.168.57.x
for i in {0..7}; do ping -c 1 192.168.5${i}.3; done
```

### 3.2 Validate RDMA Setup
Confirm that all eight RDMA network interfaces are in UP state. Verify the MTU setting of `4096` and ensure each device has a valid GID mapped to its assigned IP address.
``` bash
ibv_devinfo -v 
```
The example output would be like:
``` bash
hca_id: mlx5_0
        transport:                      InfiniBand (0)
        fw_ver:                         28.46.3048
        ...
        board_id:                       MT_0000000838
        phys_port_cnt:                  1
                port:   1
                        state:                  PORT_ACTIVE (4)
                        max_mtu:                4096 (5)
                        active_mtu:             4096 (5)
                        sm_lid:                 0
                        port_lid:               0
                        port_lmc:               0x00
                        link_layer:             Ethernet
                        ...
                        GID[  0]:               fe80:0000:0000:0000:d894:24ff:fe4a:96e2, RoCE v1
                        GID[  1]:               fe80::d894:24ff:fe4a:96e2, RoCE v2
                        GID[  2]:               0000:0000:0000:0000:0000:ffff:c0a8:3903, RoCE v1
                        GID[  3]:               ::ffff:192.168.57.3, RoCE v2
```
<br>

### 3.3 RDMA Bandwidth Benchmarks
Verify the inter-node RDMA performance to ensure the network fabric can saturate the link bandwidth.

#### 1. Install RDMA Performance Tools
Build the ROCm-optimized `rdma-perftest` suite from source:
```bash
sudo apt install -y libibumad-dev libpci-dev libibverbs-dev librdmacm-dev ibverbs-utils libtool
git clone https://github.com/ROCm/rdma-perftest
cd rdma-perftest/
./autogen.sh
./configure --enable-rocm --with-rocm=/opt/rocm
make -j$(nproc)
sudo make install
```

#### 2. Bandwidth Test (GPU Memory)
Perform a bandwidth test using ROCm GPU memory between two nodes. One serves a server and the other serves as a client. For 400G interfaces, the expected peak throughput is approximately **390 Gbps**.

```bash
# On Server Node
./ib_write_bw --use_rocm=0 -d mlx5_0 --report_gbits -a

# On Client Node
./ib_write_bw --use_rocm=0 -d mlx5_0 --report_gbits -a <SERVER_IP>
```

<div style="page-break-after: always;"></div>

## 4. vLLM Serving and Mori Unit Test

### 4.1 Docker Installation
Install the Docker engine to manage the containerized vLLM and Mori serving environments.

```bash
sudo apt update && sudo apt install -y docker.io
```

### 4.2 Download DeepSeek PTPC Model
The setup utilizes the [DeepSeek-R1-FP8-Dynamic](https://huggingface.co/EmbeddedLLM/deepseek-r1-FP8-Dynamic) model optimized for PTPC. Use the following commands to install the Hugging Face CLI and download the model to your shared NFS directory:

```bash
# Set up a virtual environment and install the Hugging Face CLI
sudo apt update && sudo apt install -y python3-venv
python3 -m venv ~/venvs/hf
source ~/venvs/hf/bin/activate
pip install huggingface_hub

# Download the model to the shared NFS mount point
huggingface-cli download --token <your_hf_token> \
    EmbeddedLLM/deepseek-r1-FP8-Dynamic \
    --local-dir /mount/point/models/EmbeddedLLM/deepseek-r1-FP8-Dynamic
```

### 4.3 Launch the Serving Container
Deploy the vLLM + Mori serving container on each node.

```bash
CONTAINER_NAME=vllm_mori
IMAGE_NAME=aigmkt/vllm:mori_rocm6.4.1_20251105

docker run -it \
    --rm \
    --device /dev/dri --device /dev/kfd --device=/dev/infiniBand \
    --network host --ipc host \
    --group-add video \
    --cap-add SYS_PTRACE \
    --security-opt seccomp=unconfined \
    --privileged \
    -v /mount/point/models:/models \
    --shm-size 128G \
    --name ${CONTAINER_NAME} \
    ${IMAGE_NAME} /bin/bash
```
<br>

### 4.4 Mori Inter-node Unittest
Before starting the vLLM service, run the Mori unit test to verify that the inter-node communication backend is correctly configured. 

**Key Configuration Variables:**
*   `GLOO_SOCKET_IFNAME`: The network interface used for backend initialization (e.g., `eth2`).
*   `<MASTER_IP>`: The IP address of the primary node's backend interface.

Performance reference data can be found in the [official Mori repository](https://github.com/ROCm/mori?tab=readme-ov-file#mori-ep).

```bash
# Set up environment inside the container
cd /app/mori
export PYTHONPATH=/app/mori:$PYTHONPATH
export GLOO_SOCKET_IFNAME=<BACKEND_INTERFACE>

# Node 0 (Primary)
torchrun --nnodes=2 --node_rank=0 --nproc_per_node=1 \
    --master_addr="<MASTER_IP>" --master_port=1234 \
    examples/ops/dispatch_combine/test_dispatch_combine_internode.py \
    --cmd bench --kernel-type v1

# Node 1 (Secondary)
torchrun --nnodes=2 --node_rank=1 --nproc_per_node=1 \
    --master_addr="<MASTER_IP>" --master_port=1234 \
    examples/ops/dispatch_combine/test_dispatch_combine_internode.py \
    --cmd bench --kernel-type v1
```
<br>

### 4.5 vLLM + Mori Serving
To deploy DeepSeek-R1 (PTPC) with Expert Parallelism 16 (EP16) across two nodes, use the following serving scripts.

#### 1. Serving Scripts
Create these scripts inside the container on each respective node.

**Node 0 (Master Node): `ep16_node0.sh`**
```bash 
#!/bin/bash

# Add VLLM_ENFORCE_EPLB=1 to enforce EP balance
export VLLM_ROCM_USE_AITER=1
export VLLM_ROCM_USE_AITER_MOE=1
export VLLM_LOGGING_LEVEL=INFO
export VLLM_USE_V1=1
export VLLM_ROCM_USE_AITER_MLA=1
export VLLM_ROCM_USE_AITER_FUSION_SHARED_EXPERTS=0
export VLLM_ALL2ALL_BACKEND=mori

vllm serve /models/EmbeddedLLM/deepseek-r1-FP8-Dynamic/ \
    -dp 16 \
    --enable-expert-parallel \
    --data-parallel-size-local 8 \
    --data-parallel-address ${IP} \
    --data-parallel-rpc-port 1212 \
    --served-model-name deepseek \
    --port 8777 \
    --block-size 1 \
    --distributed-executor-backend mp \
    --gpu-memory-utilization 0.8 \
    --max-model-len 8192 \
    --max-num-batched-tokens 4096 \
    --max-num-seqs 4096 \
    --compilation-config '{"cudagraph_mode": "FULL_DECODE_ONLY", "custom_ops": ["+quant_fp8"]}' \
    --cuda-graph-sizes 1 2 4 8 16 32 64 128 256 \
    --kv-cache-dtype fp8 \
    --no-enable-prefix-caching \
    --trust-remote-code 2>&1 | tee serving_node0_ep16.log
```
**Node 1: `ep16_node1.sh`**
```bash
#!/bin/bash

# Add VLLM_ENFORCE_EPLB=1 to enforce EP balance
export VLLM_ROCM_USE_AITER=1
export VLLM_ROCM_USE_AITER_MOE=1
export VLLM_LOGGING_LEVEL=INFO
export VLLM_USE_V1=1
export VLLM_ROCM_USE_AITER_MLA=1
export VLLM_ROCM_USE_AITER_FUSION_SHARED_EXPERTS=0
export VLLM_ALL2ALL_BACKEND=mori

vllm serve /models/EmbeddedLLM/deepseek-r1-FP8-Dynamic/ \
        -dp 16 \
        --enable-expert-parallel \
        --headless \
        --data-parallel-size-local 8 \
        --data-parallel-start-rank 8 \
        --data-parallel-address ${IP} \
        --data-parallel-rpc-port 1212 \
        --served-model-name deepseek \
        --port 8777 \
        --block-size 1 \
        --distributed-executor-backend mp \
        --gpu_memory_utilization 0.8 \
        --max-model-len 8192 \
        --max_num_batched_token 4096 \
        --max-num-seqs 4096 \
        --compilation-config '{"cudagraph_mode": "FULL_DECODE_ONLY", "custom_ops": ["+quant_fp8"]}' \
        --cuda-graph-sizes 1 2 4 8 16 32 64 128 256 \
        --kv-cache-dtype fp8 \
        --no-enable-prefix-caching \
        --trust-remote-code 2>&1 | tee serving_node1_ep16.log
```
#### 2. Execution
Execute the scripts on each node to launch the distributed serving instance. Replace `<MASTER_IP>` with the backend network IP of Node 0.

```bash
# On Node 0 (Primary)
export NCCL_SOCKET_IFNAME=<BACKEND_INTERFACE>
export GLOO_SOCKET_IFNAME=<BACKEND_INTERFACE>
IP=<MASTER_IP> bash ep16_node0.sh

# On Node 1 (Secondary)
export NCCL_SOCKET_IFNAME=<BACKEND_INTERFACE>
export GLOO_SOCKET_IFNAME=<BACKEND_INTERFACE>
IP=<MASTER_IP> bash ep16_node1.sh
```

<div style="page-break-after: always;"></div>

## 5. Reproducing Blog Performance Data

This section details how to reproduce the performance metrics published in the
AMD ROCm Blog: [Practical, Fault-Robust Distributed Inference for DeepSeek on
AMD
MI300X](https://rocm.blogs.amd.com/software-tools-optimization/wide-ep-deepseek/README.html).

### 5.1 Configuration for EP16 (16 GPUs)
To achieve the reported throughput, Expert Parallelism 16 (EP16) is used across the decode nodes.

#### Benchmark Targets:
*   **Decode Throughput:** ~12.4k output tokens/s per node.

### 5.2 Performance Reproduction Commands

#### Decode Benchmark

To reproduce the 12.4k output tokens/s, use the following configuration:

```bash
#!/bin/bash

MAX_CONCURRENCY=${1:-3072}
TIMES=2
NUM_PROMPTS=$((MAX_CONCURRENCY*TIMES))
vllm bench serve \
    --max-concurrency $MAX_CONCURRENCY \
    --num-prompts $NUM_PROMPTS \
    --model /models/EmbeddedLLM/deepseek-r1-FP8-Dynamic/ \
    --served-model-name deepseek \
    --port 8777 \
    --ignore-eos \
    --trust-remote-code \
    --dataset-name random \
    --seed 2025 \
    --random-input-len 2048 \
    --random-output-len 1024 2>&1 | tee bench_decode_${MAX_CONCURRENCY}_isl_2k_osl_1k.log
```

To calculate the per-node throughput for comparison with the blog data, take
the reported **Peak output token throughput (tok/s)** from the benchmark
results and divide it by the total number of nodes in the cluster.

## Troubleshooting

### Bandwidth (BW) test fails with error

1. Use ROCm-optimized `rdma-perftest`, not the generic `perftest`

    ``` bash
    which ib_write_bw
    ```

2. Confirm the `SERVER_IP` is accesible

    ``` bash
    ping <SERVER_IP>
    ```

3. Check system logs, use `dmesg` for kernel-level errors

    ``` bash
    sudo dmesg -T | grep -i 'error|warn|fail|exception'
    ```

### Fail to launch vLLM EP 16 with Mori backend

1. Error: `Waiting for init message from front-end.` Check the connectivity of the `IP`. Disable firewall/selinux or allow traffic for port `1212`.

2. Verify serfver name resolution, ensure server names are correctly mapped in `/etc/hosts`

3. Confirm whether environment variable `GLOO_SOCKET_IFNAME` is set before running the vLLM serving script
