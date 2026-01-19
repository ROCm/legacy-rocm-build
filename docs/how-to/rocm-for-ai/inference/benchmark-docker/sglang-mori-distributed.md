# SGLang distributed inference with MoRI

This document provides a comprehensive guide for deploying a high-performance
SGLang distributed inference serving environment on an **AMD MI355X** cluster,
utilizing the [MoRI (Modular RDMA Interface)](https://github.com/rocm/mori)
communication backend for optimized inter-node collective operations. It also
includes systematic instructions for benchmarking **1P2D** configurations using
automated scripts.

## Prerequisites

The following configuration is required to implement this setup:

* **Nodes:** A minimum of three GPU nodes (Virtual machines or Physical
    machines) for wide EP evaluation.
* **Accelerators:** 8x AMD Instinct™ MI355X GPU cards per node.
* **Networking:**   8x AMD Pensando™ Pollara 400 AI NICs per node, providing
  a dedicated 1:1 mapping between GPUs and network interfaces for optimal
  inter-node communication.
* **Orchestration:** A Slurm cluster with at least three nodes -- one for
  prefill service and two for decode services (EP16)

## System Optimization and Software Deployment

## 1. System Configuration

### 1.1 Software Baseline (Verified Versions)

The following table outlines the validated software stack. Use the provided
commands to verify the environment on each node before proceeding.

| Component | Version | Verification command |
| :--- | :--- | :--- |
| **OS** | Ubuntu 22.04.5 LTS | `cat /etc/os-release` |
| **Kernel** | 5.15.0-163-generic | `uname -r` |
| **ROCm™** | 7.1.1 | `amd-smi version` |
| **BKC** | 25.16.03 | *See Section 1.2* |
| **AI NIC Firmware** | 1.117.5.a.45 | `dkms status` |
| **AI NIC Driver** | 25.11.1.001 | `dkms status` |

```{important}
**Mandatory Health Check**: Before proceeding with software deployment,
verify that all cluster nodes comply with the [MI355X Basic Health
Checks](https://instinct.docs.amd.com/projects/system-acceptance/en/latest/gpus/mi355x.html#basic-health-checks).
Key requirements include specific kernel boot arguments, minimum system
memory thresholds, PCIe Gen5 link stability, and so on.
```

### 1.2 Best Known Configuration (BKC) Verification

The BKC ensures firmware compatibility across the cluster. For Supermicro (SMCi) or Dell systems, BKC bundle versions typically include a `.76` suffix (e.g., `BKC_X24.12.04.76_SECURE`).

To verify the active BKC and IFWI (Integrated Firmware Image) versions via the Redfish API:

1. **Prepare Credentials**: Identify your BMC IP, username, and password.
2. **Execute Redfish Queries**: Use the following commands to check the active firmware inventory.

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

<br>

### 1.3 AMD Pensando Pollara 400 AI NIC Installation

For detailed instructions on upgrading the firmware and installing drivers for the **AMD Pensando™ Pollara 400 AI NIC**, refer to the official [AMD Instinct™ System Acceptance Guide](https://instinct.docs.amd.com/projects/system-acceptance/en/latest/network/nic-installation.html#amd-pensando-pollara-400-ai-nic).
After installation, verify the active firmware version on all NICs to ensure it matches the software baseline (Section 1.1).    

Display the current firmware version for all AI NICs
``` bash
sudo nicctl show version firmware
```
<br>

### 1.4 Thermal Management (Fan Speed Configuration)

For systems equipped with 400G optics, standard fan profiles are often insufficient for maintaining stable operating temperatures. To prevent thermal throttling or optics failure, the system fans must be set to **FullSpeed**.

*   **Requirement**: A fan speed of ~25,000 RPM is required to maintain the AI NIC modules at an optimal operating temperature (~50°C).
*   **Constraint**: Default profiles (typically ~4,000 RPM) or "Performance IO" settings (~9,000 RPM) do not provide adequate airflow for 400G optical transceivers.

#### 1.4.1 Configure Fan Speed via Redfish (Supermicro)

Execute the following command to set the fan mode to `FullSpeed` via the BMC:
``` bash
# Define BMC connection variables
BMC_IP="<BMC_IP>"
AUTH="<username>:<password>"

# Set Fan Mode to FullSpeed
curl -X PATCH "https://${BMC_IP}/redfish/v1/Managers/1/Oem/Supermicro/FanMode" \
     -k -u "${AUTH}" \
     -H "Content-Type: application/json" \
     -d '{"Mode": "FullSpeed"}'
```

<br>

### 1.5 Backend Network Configuration (Netplan)
Configure the backend NICs for high-bandwidth inter-node communication. Suppose the GPU’s eight network interface controllers (NICs) are benic1p1 to benic8p1. Each NIC must have its own subnet that is disjoint from the others. Each node needs a unique IP address on each subnet. We recommend using the same final octet in each subnet for a given node. For example, one node would have the addresses `192.168.1.36`, `192.168.2.36`, and so on. Another node would have `192.168.1.37`, `192.168.2.37`, and so on. Ensure MTU is set to `9000`.

**Example `vim /etc/netplan/70-backend.yaml`:**
```yaml

network:
  ethernets:
    benic8p1:
      addresses:
      - 192.168.8.38/31
      match:
        macaddress: 04:90:81:2a:34:08
      mtu: 9000
      routes:
      - table: 108
        to: 0.0.0.0/0
        via: 192.168.8.39
      routing-policy:
      - from: 192.168.8.38
        table: 108
      set-name: benic8p1
    benic7p1:
      addresses:
      - 192.168.7.38/31
      match:
        macaddress: 04:90:81:2b:82:40
      mtu: 9000
      routes:
      - table: 107
        to: 0.0.0.0/0
        via: 192.168.7.39
      routing-policy:
      - from: 192.168.7.38
        table: 107
      set-name: benic7p1
    benic6p1:
      addresses:
      - 192.168.6.38/31
      match:
        macaddress: 04:90:81:30:c9:30
      mtu: 9000
      routes:
      - table: 106
        to: 0.0.0.0/0
        via: 192.168.6.39
      routing-policy:
      - from: 192.168.6.38
        table: 106
      set-name: benic6p1
    benic5p1:
      addresses:
      - 192.168.5.38/31
      match:
        macaddress: 04:90:81:2a:23:40
      mtu: 9000
      routes:
      - table: 105
        to: 0.0.0.0/0
        via: 192.168.5.39
      routing-policy:
      - from: 192.168.5.38
        table: 105
      set-name: benic5p1
    benic4p1:
      addresses:
      - 192.168.4.38/31
      match:
        macaddress: 04:90:81:2d:69:60
      mtu: 9000
      routes:
      - table: 104
        to: 0.0.0.0/0
        via: 192.168.4.39
      routing-policy:
      - from: 192.168.4.38
        table: 104
      set-name: benic4p1
    benic3p1:
      addresses:
      - 192.168.3.38/31
      match:
        macaddress: 04:90:81:2a:2c:40
      mtu: 9000
      routes:
      - table: 103
        to: 0.0.0.0/0
        via: 192.168.3.39
      routing-policy:
      - from: 192.168.3.38
        table: 103
      set-name: benic3p1
    benic2p1:
      addresses:
      - 192.168.2.38/31
      match:
        macaddress: 04:90:81:30:d5:30
      mtu: 9000
      routes:
      - table: 102
        to: 0.0.0.0/0
        via: 192.168.2.39
      routing-policy:
      - from: 192.168.2.38
        table: 102
      set-name: benic2p1
    benic1p1:
      addresses:
      - 192.168.1.38/31
      match:
        macaddress: 04:90:81:30:e4:00
      mtu: 9000
      routes:
      - table: 101
        to: 0.0.0.0/0
        via: 192.168.1.39
      routing-policy:
      - from: 192.168.1.38
        table: 101
      set-name: benic1p1
```
*Apply configuration:* `sudo netplan apply`    
*Verify the configuration:* `sudo apt install -y net-tools && ip -br a`   

<br>

### 1.6 Quality of Service (QoS) and Congestion Control (DCQCN)

To ensure lossless communication and optimal performance for RDMA traffic, the network must be configured with specific QoS and Data Center Quantized Congestion Notification (DCQCN) settings.
The following configuration achieves:
•	It enables RX and TX Pause frames on the ports
•	Maps DSCP 24 (Data) to Q3 and DSCP 46 (CNP) to Q6, all other DSCP to Q0
•	Enables PFC for Q3
•	Scheduling : 99% to Q3, 1% to Q0 and strict priority for Q6

#### 1.6.1 Configure DCQCN
Create and execute `/nfsdata/enable_dcqcn.sh` to initialize congestion control parameters.
``` bash
# !/bin/bash

TOKEN_BUCKET_SIZE=800000
AI_RATE=160
ALPHA_UPDATE_INTERVAL=1
ALPHA_UPDATE_G=512
INITIAL_ALPHA_VALUE=64
RATE_INCREASE_BYTE_COUNT=431068
HAI_RATE=300
RATE_REDUCE_MONITOR_PERIOD=1
RATE_INCREASE_THRESHOLD=1
RATE_INCREASE_INTERVAL=1
CNP_DSCP=46

ROCE_DEVICES=$(ibv_devices | grep ionic_ | awk '{print $1}' | paste -sd " ")
for roce_dev in $ROCE_DEVICES
do
    sudo nicctl update dcqcn -r $roce_dev -i 1 \
    --token-bucket-size $TOKEN_BUCKET_SIZE \
    --ai-rate $AI_RATE \
    --alpha-update-interval $ALPHA_UPDATE_INTERVAL \
    --alpha-update-g $ALPHA_UPDATE_G \
    --initial-alpha-value $INITIAL_ALPHA_VALUE \
    --rate-increase-byte-count $RATE_INCREASE_BYTE_COUNT \
    --hai-rate $HAI_RATE \
    --rate-reduce-monitor-period $RATE_REDUCE_MONITOR_PERIOD \
    --rate-increase-threshold $RATE_INCREASE_THRESHOLD  \
    --rate-increase-interval $RATE_INCREASE_INTERVAL \
    --cnp-dscp $CNP_DSCP
done
```
<br>

#### 1.6.2 Configure QoS and PFC
Create and execute `/nfsdata/qos.sh` to set up traffic classes and scheduling.
``` bash
#!/bin/bash
# qos.sh

# Enable PFC and Auto-negotiation on all ports
for i in $(sudo nicctl show port | grep Port | awk {'print $3'}); do sudo nicctl update port -p $i --pause-type pfc --rx-pause enable --tx-pause enable; done
for i in $(sudo nicctl show port | grep Port | awk '{print $3}'); do sudo nicctl update port --port $i --auto-neg enable; done

# Define Priorities
cts_dscp=46
cts_prio=6
data_dscp=24
data_prio=3
default_prio=0
cnp_dscp=46
cnp_prio=6

sudo nicctl update qos pfc --priority 0 --no-drop disable
sudo nicctl update qos dscp-to-purpose --dscp 48 --purpose none
sudo nicctl update qos dscp-to-purpose --dscp 46 --purpose none
sudo nicctl update qos --classification-type pcp
sudo nicctl update qos --classification-type dscp
sudo nicctl update qos dscp-to-priority --dscp 0-63 --priority 0
sudo nicctl update qos dscp-to-priority --dscp 0-23,25-45,47-63 --priority $default_prio
sudo nicctl update qos dscp-to-priority --dscp $cts_dscp --priority $cts_prio
sudo nicctl update qos dscp-to-priority --dscp $data_dscp --priority $data_prio
sudo nicctl update qos dscp-to-priority --dscp $cnp_dscp --priority $cnp_prio
sudo nicctl update qos pfc --priority $data_prio --no-drop enable
sudo nicctl update qos scheduling --priority $data_prio,$default_prio,$cts_prio --dwrr 99,1,0 --rate-limit 0,0,10
```
<br>

#### 1.6.3  Verification
Verify the configuration using nicctl.
##### 1.6.3.1 Verify QoS Classification: 
     ``` bash
     sudo nicctl show qos
     ```
     **Expected QoS output:**
     ``` bash
     NIC  : 42424650-4c32-3531-3230-303443000000 (0000:f6:00.0)
     
     Port : 04908130-a7a0-4242-4242-000011010000
     
     Classification type         : DSCP 
     
     DSCP-to-priority :
     DSCP bitmap               : 0xffffbffffeffffff ==> priority : 0
     DSCP bitmap               : 0x0000000001000000 ==> priority : 3
     DSCP bitmap               : 0x0000400000000000 ==> priority : 6
     DSCP                      : 0-23, 25-45, 47-63 ==> priority : 0
     DSCP                      : 24 ==> priority : 3 
     DSCP                      : 46 ==> priority : 6 
     ```
##### 1.6.3.2 Verify DCQCN and Scheduling: 
     ``` bash
     sudo nicctl show dcqcn
     ``` 
     **Expected DCQCN and Scheduling Output:**
     ``` bash 
     NIC : 42424650-4c32-3531-3230-303443000000 (0000:f6:00.0)
     ------------------------------------------------------------------------------------------
     
     Lif id                                     : 43000070-0100-0000-4242-04908130a7a0
     ROCE device                                : ionic_7
     DCQCN profile id                         : 1
     Status                                   : Enabled
     Rate increase in AI phase                : 160
     Rate increase byte count                 : 431068
     Alpha update G value                     : 512
     Alpha update interval                    : 1
     Rate increase in HAI phase               : 300
     Initial alpha value                      : 64
     Rate reduce monitor period               : 1
     Rate increase threshold                  : 1
     Rate increase interval                   : 1
     Token bucket size                        : 800000
     DSCP value used for CNP                  : 46
     
     
     PFC :
     PFC priority bitmap       : 0x8
     PFC no-drop priorities    : 3 
     
     Scheduling :
     --------------------------------------------
     Priority  Scheduling  Bandwidth Rate-limit  
               Type        (in %age) (in Gbps)   
     --------------------------------------------
     0         DWRR        1         N/A         
     3         DWRR        99        N/A     
     6         strict      N/A       10     
     ```
<br>
 
### 1.7 NFS Configuration
Setting up a shared NFS volume facilitates centralized storage for models, recipes, and logs across the cluster. Use the following commands to install the necessary client tools and mount the remote directory. Replace `nfs_server_ip:/shared/folder` and `/mount/point` with your specific server details and desired local mount path.

``` bash
sudo apt update && sudo apt install -y nfs-common
sudo mkdir -p /mount/point
sudo mount -t nfs nfs_server_ip:/shared/folder /mount/point
echo "nfs_server_ip:/shared/folder /mount/point nfs _netdev,nofail,x-systemd.automount,x-systemd.idle-timeout=600,vers=4.2 0 0" | sudo tee -a /etc/fstab
```

<div style="page-break-after: always;"></div>

## 2. Software Configuration

### 2.1 ROCm Installation
For comprehensive installation instructions, refer to the [official ROCm documentation](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/quick-start.html#rocm-installation). The following commands provide a quick-start for ROCm 7.1.1 on Ubuntu 22.04 (Jammy):
``` bash
wget https://repo.radeon.com/amdgpu-install/7.1.1/ubuntu/jammy/amdgpu-install_7.1.1.70101-1_all.deb
sudo apt install ./amdgpu-install_7.1.1.70101-1_all.deb
sudo apt update
sudo apt install python3-setuptools python3-wheel
sudo usermod -a -G render,video $LOGNAME # Add the current user to the render and video groups
sudo apt install rocm
```
<br>

### 2.2 AMD GPU Driver Installation 
For comprehensive installation instructions, refer to the [official documentation](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/quick-start.html#amdgpu-driver-installation). The following commands provide a quick-start for AMD GPU driver 6.16.6 on Ubuntu 22.04 (Jammy):
``` bash
wget https://repo.radeon.com/amdgpu-install/7.1.1/ubuntu/jammy/amdgpu-install_7.1.1.70101-1_all.deb
sudo apt install ./amdgpu-install_7.1.1.70101-1_all.deb
sudo apt update
sudo apt install "linux-headers-$(uname -r)" "linux-modules-extra-$(uname -r)"
sudo apt install amdgpu-dkms
```
<div style="page-break-after: always;"></div>

## 3. Verification & Testing

### 3.1 Network Connectivity Verification
Verify that all network interfaces are reachable across the cluster nodes. Assuming `eth0` is the management interface, and `benic1p1-benic8p1` are the dedicated RoCE backend interfaces, use the following loop to test reachability to a remote node (e.g., a target node with host IP suffix `.38`).

```bash
# Test connectivity for RoCE subnets 192.168.x.38 (node B) through 192.168.x.37 (node A)
for i in {1..8}; do ping -c 1 192.168.${i}.38; done
```
<br>

### 3.2 Validate RDMA Setup
Confirm that all eight RDMA network interfaces are in the `UP` state and correctly configured with the required MTU and GID settings.

#### 1. Verify Link Status MTU, NIC temperature and NIC speed.
```bash
sudo nicctl show port
```
The example output would be like:
```bash
-------------------------------------------------------------------------------------

NIC  : 42424650-4c32-3531-3530-314343000000 (0000:f6:00.0)

Port : 04908132-5d88-4242-4242-000011010000 (eth1/1)
  Spec:
    Ifindex                                  : 0x11010000
    Type                                     : ETH
    speed                                    : 400G
    Admin state                              : UP
    FEC type                                 : RS
    Pause type                               : PFC
    Number of lanes                          : 4
    MTU                                      : 9216
    TX pause                                 : enabled
    RX pause                                 : enabled
    Auto negotiation                         : enabled
  Status:
    Physical port                            : 1
    Operational status                       : UP
    Link FSM state                           : UP
    FEC type                                 : RS
    Cable type                               : Fiber
    Number of lanes                          : 4
    speed                                    : 400G
    Auto negotiation                         : disabled
    MAC ID                                   : 0
    MAC channel                              : 0
    MAC address                              : 04:90:81:32:5d:88
    Transceiver type                         : QSFP_CMIS
    Transceiver state                        : SPROM-READ
    Transceiver PID                          : QSFP-400G-DR4
    Transceiver temperature (in C)           : 45
    Transceiver warning temperature (in C)   : 75
    Transceiver alarm temperature (in C)     : 80
-------------------------------------------------------------------------------------
```

#### 2. Verify GID
Ensure each device has a valid GID mapped to its assigned IP address.
```bash
ibv_devinfo -v | grep GID
```
The example output would be like:
```bash
      GID[  0]:               fe80::690:81ff:fe30:a7a0, RoCE v2
      GID[  1]:               ::ffff:192.168.7.36, RoCE v2
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
Perform a bandwidth test using ROCm GPU memory between two nodes. One node serves as a server and the other as a client.
```bash
# On Server Node
./ib_write_bw --use_rocm=0 -d rdma0 -a -q 2 --report_gbits
# On Client Node
./ib_write_bw --use_rocm=0 -d rdma0 -a -q 2 --report_gbits <SERVER_IP>
```
<div style="page-break-after: always;"></div>


## 4. SGLang Serving and MoRI Unit Test

### 4.1 Docker Installation
Install the Docker engine to manage the containerized vLLM and MoRI serving environments.

```bash
sudo apt update && sudo apt install -y docker.io
```
<br>

### 4.2 Launch the Serving Container
Deploy the SGLang + MoRI serving container on each node.

```bash
CONTAINER_NAME=sglang_mori
IMAGE_NAME=rocm/sgl-dev:sglang-0.5.6.post1-rocm700-mi35x-mori-1224

docker run -it \
    --rm \
    --device /dev/dri --device /dev/kfd --device=/dev/infiniBand \
    --network host --ipc host \
    --group-add video \
    --cap-add SYS_PTRACE \
    --security-opt seccomp=unconfined \
    --privileged \
    --shm-size 128G \
    --name ${CONTAINER_NAME} \
    ${IMAGE_NAME} /bin/bash
```
<div style="page-break-after: always;"></div>

### 4.3 MoRI Inter-node Unittest
Before starting the vLLM service, run the MoRI unit test to verify that the inter-node communication backend is correctly configured. 

MoRI unit test uses 2 nodes as a minimal validation before running the full 1P2D (3 nodes) benchmark.

**Key Configuration Variables:**
*   `GLOO_SOCKET_IFNAME`: The network interface used for backend initialization (e.g., `eth0`).
*   `<MASTER_IP>`: The IP address of the primary node's backend interface.

Performance reference data can be found in the [official MoRI repository](https://github.com/ROCm/mori?tab=readme-ov-file#mori-ep).

```bash
# Set up environment inside the container
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
<div style="page-break-after: always;"></div>

## 5. End-to-End 1P2D Performance Testing

This section guides you through running distributed inference benchmarks using the SGLang disagg recipe. For detailed implementation details, refer to the [SGLang Disaggregation Recipe](https://github.com/billishyahao/sglang_disagg/blob/9n_cluster/README.md).

### 5.1 Model Download and Setup

**Supported Models:**
- **DeepSeek-V3** ([Hugging Face](https://huggingface.co/deepseek-ai/DeepSeek-V3))
- **DeepSeek-R1** ([Hugging Face](https://huggingface.co/deepseek-ai/DeepSeek-R1))
- **DeepSeek-R1-0528** ([Hugging Face](https://huggingface.co/deepseek-ai/DeepSeek-R1-0528))

*Additional model support is being developed.*

**Download Instructions:**
```bash
# Set up a virtual environment and install the Hugging Face CLI
sudo apt update && sudo apt install -y python3-venv
python3 -m venv ~/venvs/hf
source ~/venvs/hf/bin/activate
pip install huggingface_hub

# Download the model to the shared NFS mount point
# Replace 'deepseek-ai/DeepSeek-R1-0528' with your desired model
huggingface-cli download --token <your_hf_token> \
    deepseek-ai/DeepSeek-R1-0528 \
    --local-dir /mount/point/models/DeepSeek-R1
```
<br>

### 5.2 Repository Setup

Clone the SGLang disaggregation repository to the **shared folder** and switch to the appropriate branch:

```bash
git clone https://github.com/billishyahao/sglang_disagg.git
git checkout 9n_cluster
cd sglang_disagg
```

> [!NOTE]
> In the 1P2D configuration, the prefill service and benchmark process run on the same node, while remaining nodes handle decode services.

<br>

### 5.3 InfiniBand Device Configuration

Identify and configure the available InfiniBand devices:

**List Available Devices:**
```bash
ibv_devinfo -l
```

**Example Output:**
```bash
8 HCAs found:
        ionic_0
        ionic_1
        ionic_2
        ionic_3
        ionic_4
        ionic_5
        ionic_6
        ionic_7
```

**Update Environment Variables:**
Edit `set_env_vars.sh` and add the comma-separated list of your system's IB devices:

```bash
export IBDEVICES=ionic_0,ionic_1,ionic_2,ionic_3,ionic_4,ionic_5,ionic_6,ionic_7
```
<br>

### 5.4 Job Submission and Configuration

**Configuration Parameters:**
Update the following environment variables in `run_submit_disagg.sh` to match your cluster setup:

```bash
# SLURM Job Configuration
export SLURM_ACCOUNT="amd"       # The account name for SLURM job accounting and resource allocation
export SLURM_PARTITION="compute" # The specific cluster partition (queue) to submit the job to
export TIME_LIMIT="24:00:00"     # Maximum wall time for the job (Hours:Minutes:Seconds)

# Model Configuration
export MODEL_PATH="/nfsdata"     # Base directory where the model weights are stored
export MODEL_NAME="DeepSeek-R1"  # Specific model directory name (joined with MODEL_PATH)
export CONTAINER_IMAGE="rocm/sgl-dev:sglang-0.5.6.post1-rocm700-mi35x-mori-1224" # Docker image to use for the environment

# Cluster Topology (Disaggregation Setup)
export PREFILL_NODES=1           # Number of prefill nodes
export PREFILL_WORKERS=1         # Number of prefill workers
export DECODE_NODES=2            # Number of decode nodes
export DECODE_WORKERS=2          # Number of decode workers

# Benchmark/Workload Parameters
export ISL=1024                  # Input Sequence Length (number of tokens in the prompt)
export OSL=1024                  # Output Sequence Length (number of tokens to generate)
export CONCURRENCIES="2048"      # Total number of concurrent requests to simulate in the benchmark. The value can be "32,64,128"
export REQUEST_RATE="inf"        # Request per second rate. "inf" means send all requests immediately

# Parallelism Strategies
export PREFILL_ENABLE_EP=true    # Enable Expert Parallelism (EP) for the prefill phase 
export PREFILL_ENABLE_DP=true    # Enable Data Parallelism (DP) for the prefill phase
export DECODE_ENABLE_EP=true     # Enable Expert Parallelism (EP) for the decode phase
export DECODE_ENABLE_DP=true     # Enable Data Parallelism (DP) for the decode phase
```
Then submit the batch job into slurm cluster through `bash ./run_submit_disagg.sh`

**Submit the Job:**
```bash
bash ./run_submit_disagg.sh
```
<br>

### 5.5 Log File Analysis

**Identify the Job ID:**
After submission, retrieve the SLURM job ID:
```bash
squeue
```

**Example Output:**
```bash
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
123   compute       1p2d   alice  R    00:10:32      4 node[01-04]
```

**Log File Locations:**
A directory named `slurm_job-$SLURM_JOB_ID` is created in `/tmp` on each participating node. The directory contains:

| Log File | Description |
| :--------| :-----------|
| `pd_sglang_bench_serving.sh_NODE${NODE_RANK}.log` | Main service log per node |
| `decode_NODE${NODE_RANK}.log` | SGLang decode service details |
| `prefill_NODE${NODE_RANK}.log` | SGLang prefill service details |

**Performance Metrics:**
The benchmark results will be displayed in `pd_sglang_bench_serving.sh_NODE${NODE_RANK}.log`. Key metrics include:

Note that the benchmark utility output below is provided for reference only and should not be used to compare performance. Please visit the InferenceMAX official website for validated performance results.

``` bash
============ Serving Benchmark Result ============
Successful requests:                     20480
Benchmark duration (s):                  1194.25
Total input tokens:                      20971520
Total generated tokens:                  20971520
Request throughput (req/s):              17.15
Output token throughput (tok/s):         17560.38
Total Token throughput (tok/s):          35120.76
---------------Time to First Token----------------
Mean TTFT (ms):                          21601.77
Median TTFT (ms):                        24525.21
P99 TTFT (ms):                           85417.53
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          92.41
Median TPOT (ms):                        85.46
P99 TPOT (ms):                           138.67
---------------Inter-token Latency----------------
Mean ITL (ms):                           92.41
Median ITL (ms):                         74.76
P99 ITL (ms):                            263.07
----------------End-to-end Latency----------------
Mean E2EL (ms):                          116133.48
Median E2EL (ms):                        110349.39
P99 E2EL (ms):                           227243.97
==================================================
```

<div style="page-break-after: always;"></div>

## Troubleshootings
### 6.1 Bandwidth test failures
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
<br>

### 6.2 Slurm Job Failure

**Common causes and solutions for Slurm job submission failures:**

1. **Shared Storage Access:**
   - Verify that both `sglang_disagg` and model directories are located in a shared NFS mount accessible to all compute nodes.
   - Ensure proper permissions: `chmod -R 755 /shared/path/sglang_disagg /shared/path/models`

2. **Log Analysis:**
   - Examine `pd_sglang_bench_serving.sh_NODE${NODE_RANK}.log` on each participating node for detailed error messages.
   - Check for common issues like missing dependencies, GPU allocation failures, or network connectivity problems.

3. **Configuration Validation:**
   - Verify SLURM parameters in `run_submit_disagg.sh`:
     - `SLURM_ACCOUNT`: Ensure your account has access to the cluster
     - `SLURM_PARTITION`: Confirm the partition exists and is accessible
     - `MODEL_PATH`: Check that the path is correct and accessible from compute nodes
     - `MODEL_NAME`: Verify the model subdirectory exists within `MODEL_PATH`
   - Use `sinfo` to check partition and node availability.
