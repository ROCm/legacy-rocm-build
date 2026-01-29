# vLLM distributed inference with MoRI

This document provides a comprehensive guide for setting up a high-performance
vLLM serving environment on an AMD Instinct MI300X or MI325X GPU cluster using
the [MoRI (Modular RDMA Interface)](https://github.com/rocm/mori) communication
backend. It also includes detailed instructions on how to reproduce the
benchmark results published in the AMD ROCm blog [Practical, Fault-Robust
Distributed Inference for DeepSeek on AMD
MI300X](https://rocm.blogs.amd.com/software-tools-optimization/wide-ep-deepseek/README.html).

## Prerequisites

The following hardware configuration is required to implement this setup:

* **Nodes**: A minimum of two GPU nodes (virtual machines or physical machines)
  for wide expert parallelism (EP) evaluation.
* **GPUs**: 8x AMD Instinct MI300X/MI325X GPU cards per node.
* **Networking**: 8x NVIDIA Mellanox ConnectX-7 (CX7) NICs per node, providing
  a dedicated 1:1 mapping between GPUs and network interfaces for optimal
  inter-node communication.

## System configuration

This section outlines infrastructure steps required to prepare your cluster for
high-performance AI workloads. It covers validating your system's software
baselines and firmware versions, configuring high-bandwidth backend networking
for inter-node communication, and establish shared storage to ensure
    a synchronized distributed computing environment.

### Verify baseline software

This setup has been validated using the **AI/ML Ready Image (ROCm 7-based)** on
Digital Ocean AMD GPU Droplets. The following table outlines the software
stack versions and appropriate shell commands for verification:

| Component | Version | Verification command |
| :--- | :--- | :--- |
| **OS** | Ubuntu 24.04.3 LTS | `cat /etc/os-release` |
| **Kernel** | 6.8.0-87-generic | `uname -r` |
| **ROCm** | 7.0.2 | `amd-smi version` |
| **PLDM bundle (firmware) for MI300X** | 01.25.03.12 | [Verify BKC](#verify-best-known-configuration-bkc) |
| **PLDM bundle (firmware) for MI325X** | 01.25.03.03 | [Verify BKC](#verify-best-known-configuration-bkc) |
| **CX7 Firmware** | 28.46.3048 | `dkms status` |
| **CX7 Driver** | 24.10-3.2.5 | `dkms status` |
| **DOCA** | 2.9.3 | `dpkg -l \| grep doca` |

### Verify best known configuration (BKC)

The BKC defines a validated configuration of GPU firmware, baseboard firmware,
ROCm user space components, the AMD GPU Driver, and virtualization tooling.
These components are tested together to attain best performance and compatibility.

While AMD publishes the AMD GPU driver and ROCm user space components, your
server OEM or infrastructure provider distributes the firmware packages. AMD
supplies those firmware images (PLDM bundles), which the OEM integrates and
distributes.

To verify the active BKC and IFWI (Integrated Firmware Image) versions via the
Redfish API:

1. Prepare credentials: Identify your BMC IP, username, and password.
2. Run Redfish queries: Use the following commands to check the active
   firmware inventory.

     ``` bash
     # Define BMC connection variables
     BMC_IP="<BMC_IP>"
     AUTH="<username>:<password>"

     # Query active BKC bundle version
     curl -X GET "https://${BMC_IP}/redfish/v1/UpdateService/FirmwareInventory/bundle_active" \
          -u "${AUTH}" -k | json_pp

     # Query active IFWI (Integrated Firmware Image)
     curl -X GET "https://${BMC_IP}/redfish/v1/UpdateService/FirmwareInventory/firmware_active" \
          -u "${AUTH}" -k | json_pp
     ```

### Run basic system health checks

Before proceeding with software deployment, verify that all cluster nodes
comply with the [MI300X Basic Health
Checks](https://instinct.docs.amd.com/projects/system-acceptance/en/latest/gpus/mi300x.html#basic-health-checks)
or [MI325X Basic Health
Checks](https://instinct.docs.amd.com/projects/system-acceptance/en/latest/gpus/mi325x.html#basic-health-checks).
Key requirements include specific kernel boot arguments, minimum system memory
thresholds, PCIe Gen5 link stability, and so on.

### Configure your backend network (netplan)

Configure the backend NICs for high-bandwidth inter-node communication. Suppose
the GPU’s eight network interface controllers (NICs) are eth2 to eth9. Each NIC
must have its own subnet that is disjoint from the others. For example, `eth2`
could use `192.168.50.0/24`, `eth3` could use `192.168.51.0/24`, and so on.
Each node needs a unique IP address on each subnet. You should use the same
final octet in each subnet for a given node. For example, one node would have
the addresses `192.168.50.2`, `192.168.51.2`, and so on. Another node might
have `192.168.50.3`, `192.168.51.3`, and so on. Ensure MTU is set to `4200`.

```{note}
Ensure you identify the correct interface names for your system using ip link
before applying this configuration.
```

For example, your `/etc/netplan/50-backend.yaml` might include something like
the following:

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

To apply the configuration, use the following command.

```bash
sudo netplan apply
```

To verify your configuration, use the following command.

```bash
sudo apt install -y net-tools && ip -br a
```

### Configure your network file system (NFS)

Setting up a shared NFS volume facilitates centralized storage for models,
recipes, and logs across the cluster. Use the following commands to install the
necessary client tools and mount the remote directory.

```{important}
Replace `nfs_server_ip:/shared/folder` and `/mount/point` with your specific
server details and desired local mount path.
```

``` bash
sudo apt update && sudo apt install -y nfs-common
sudo mkdir -p /mount/point
sudo mount -t nfs nfs_server_ip:/shared/folder /mount/point
echo "nfs_server_ip:/shared/folder /mount/point nfs _netdev,nofail,x-systemd.automount,x-systemd.idle-timeout=600,vers=4.2 0 0" | sudo tee -a /etc/fstab
```

### Configure static hostname resolution for backend initialization (optional)

If the high-speed RDMA/IB interfaces are used for the initial distributed
coordination (such as `MASTER_ADDR`), you must configure static hostname
resolution. This ensures that cluster host names resolve to the backend network
IPs rather than the management or local loopback addresses.

Follow these steps to configure static hostname resolution:

1. Edit `/etc/hosts` on all nodes: for example, using `sudo vim /etc/hosts`.
2. Add the backend IP and hostname mappings.
3. Comment out any default local mappings (such as `127.0.1.1`) for the current
   hostname to avoid resolution conflicts.

For example, your `/etc/hosts` entries might look like:

```text
# Map host names to backend network IPs
192.168.50.2 mori_test_01
192.168.50.3 mori_test_02

# Comment out the default entry to ensure resolution via the backend IP
# 127.0.1.1 mori_test_01 mori_test_01
```

## Software installation

Next, install the essential software stack required to operate the AMD Instinct
GPUs and high-speed networking components. Follow these steps to deploy the
NVIDIA DOCA drivers for Mellanox ConnectX-7 NICs, the ROCm software stack, and
the necessary kernel modules to enable hardware acceleration.

### Install CX7 driver and firmware

1. Download and install the `DOCA 2.9.3` driver following the instructions in
   [NVIDIA DOCA 2.9.3
   Downloads](https://developer.nvidia.com/doca-2-9-3-download-archive?deployment_platform=Host-Server&deployment_package=DOCA-Host&target_os=Linux&Architecture=x86_64&Profile=doca-all&Distribution=Ubuntu&version=24.04&installer_type=deb_local).

2. Download the appropriate firmware for your hardware PSID from the [NVIDIA
   official website](https://network.nvidia.com/support/firmware/connectx7/)
   and flash the device.

3. To verify driver and firmware versions, use the following command. Replace
   `IB Device` with your specific backend interface.

   ```bash
   ethtool -i <IB Device>
   ```

### Install ROCm

Use the following commands to quickly install ROCm 7.0.2 on Ubuntu 24.04:

``` bash
wget https://repo.radeon.com/amdgpu-install/7.0.2/ubuntu/noble/amdgpu-install_7.0.2.70002-1_all.deb
sudo apt install ./amdgpu-install_7.0.2.70002-1_all.deb
sudo apt update
sudo apt install python3-setuptools python3-wheel
sudo usermod -a -G render,video $LOGNAME # Add the current user to the render and video groups
sudo apt install rocm
```

For detailed installation instructions, refer to the [ROCm 7.0.2
documentation](https://rocm.docs.amd.com/projects/install-on-linux/en/docs-7.0.2/install/quick-start.html#rocm-installation).

### Install AMD GPU Driver (amdgpu)

Use the following commands to quickly install the AMD GPU Driver (ROCm 7.0.2) on Ubuntu 24.04:

``` bash
wget https://repo.radeon.com/amdgpu-install/7.0.2/ubuntu/noble/amdgpu-install_7.0.2.70002-1_all.deb
sudo apt install ./amdgpu-install_7.0.2.70002-1_all.deb
sudo apt update
sudo apt install "linux-headers-$(uname -r)" "linux-modules-extra-$(uname -r)"
sudo apt install amdgpu-dkms
```

For detailed installation instructions, refer to the [ROCm 7.0.2
documentation](https://rocm.docs.amd.com/projects/install-on-linux/en/docs-7.0.2/install/quick-start.html#amdgpu-driver-installation).

## Network verification and testing

Before deploying the inference engine, validate the health and performance of
the cluster interconnects.

### Verify network connectivity

Verify that all network interfaces are reachable across the cluster nodes.
Assuming `eth0` is the management interface, `eth1` is for the VPC, and `eth2`
through `eth9` are the dedicated RoCE backend interfaces, use the following
loop to test reachability to a remote node (for instance, a target node with
host IP suffix `.3`).

```bash
# Test connectivity for RoCE subnets 192.168.50.x through 192.168.57.x
for i in {0..7}; do ping -c 1 192.168.5${i}.3; done
```

### Validate your RDMA setup

Confirm that all eight RDMA network interfaces are in `UP` state. Verify the MTU
setting of `4096` and ensure each device has a valid GID mapped to its assigned
IP address.

``` bash
ibv_devinfo -v
```

The output should look something like this:

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

### Run RDMA bandwidth benchmarks

Verify the inter-node RDMA performance to ensure the network fabric can
saturate the link bandwidth.

#### Install RDMA Performance Tools

To get started, build the ROCm-optimized `rdma-perftest` test suite from
source:

```bash
sudo apt install -y libibumad-dev libpci-dev libibverbs-dev librdmacm-dev ibverbs-utils libtool
git clone https://github.com/ROCm/rdma-perftest
cd rdma-perftest/
./autogen.sh
./configure --enable-rocm --with-rocm=/opt/rocm
make -j$(nproc)
sudo make install
```

#### Run a bandwidth test (GPU memory)

Perform a bandwidth test using ROCm GPU memory between two nodes. One acts
as a server and the other acts as a client. For 400G interfaces, the expected
peak throughput is approximately 390 Gbps. Replace `<SERVER_IP>` with the
appropriate IP.

```bash
# On Server Node
./ib_write_bw --use_rocm=0 -d mlx5_0 --report_gbits -a

# On Client Node
./ib_write_bw --use_rocm=0 -d mlx5_0 --report_gbits -a <SERVER_IP>
```

## vLLM serving and MoRI unit tests

### Install Docker Engine

Install the Docker engine to manage the containerized vLLM and MoRI serving
environments.

```bash
sudo apt update && sudo apt install -y docker.io
```

### Download the DeepSeek PTPC model

This guide uses the
[DeepSeek-R1-FP8-Dynamic](https://huggingface.co/EmbeddedLLM/deepseek-r1-FP8-Dynamic)
model optimized for PTPC. Use the following commands to install the Hugging
Face CLI and download the model to your shared NFS directory:

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

### Launch the serving container

Deploy the vLLM MoRI serving Docker container on each node.

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

### Run MoRI inter-node unit tests

Before starting the vLLM service, run the MoRI unit test to verify that the
inter-node communication backend is correctly configured.

The key configuration variables are:

* `GLOO_SOCKET_IFNAME`: The network interface used for backend initialization such as `eth2`.
* `<MASTER_IP>`: The IP address of the primary node's backend interface.

```{note}
You can find reference performance data in the [ROCm/MoRI
repository](https://github.com/ROCm/mori?tab=readme-ov-file#mori-ep).
```

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

### Deploy and serve the model

To deploy DeepSeek-R1 (PTPC) with Expert Parallelism 16 (EP16) across two
nodes, use the following serving scripts.

#### Create serving scripts

Create the following scripts inside the container on each node.

* Node 0 (master node): `ep16_node0.sh`

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

* Node 1: `ep16_node1.sh`

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

#### Run the serving scripts

Run the scripts on each node to launch the distributed serving instance.
Replace `<MASTER_IP>` with the backend network IP of Node 0.

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

## Reproducing performance

This section details how to reproduce the performance metrics published in the
AMD ROCm Blog: [Practical, Fault-Robust Distributed Inference for DeepSeek on
AMD
MI300X](https://rocm.blogs.amd.com/software-tools-optimization/wide-ep-deepseek/README.html).

### Configuration for EP16 (16 GPUs)

To achieve the reported throughput, expert parallelism 16 (EP16) is used across
the decode nodes.

#### Benchmark target

* Decode throughput: ~12.4k output tokens/s per node.

### Performance reproduction commands

Use the following configurations to reproduce published performance metrics.

#### Decode benchmark

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

The following section outlines common issues and their solutions.

### Bandwidth test fails with error

1. Use ROCm-optimized `rdma-perftest`, not the generic `perftest`.

    ``` bash
    which ib_write_bw
    ```

2. Confirm the `SERVER_IP` is accessible.

    ``` bash
    ping <SERVER_IP>
    ```

3. Check system logs, use `dmesg` for kernel-level errors.

    ``` bash
    sudo dmesg -T | grep -i 'error|warn|fail|exception'
    ```

### vLLM EP 16 with MoRI backend fails to launch

1. Error: `Waiting for init message from front-end.` Check the connectivity of the `IP`. Disable firewall/selinux or allow traffic for port `1212`.

2. Verify server name resolution. Ensure server names are correctly mapped in `/etc/hosts`.

3. Confirm whether environment variable `GLOO_SOCKET_IFNAME` is set before running the vLLM serving script.
