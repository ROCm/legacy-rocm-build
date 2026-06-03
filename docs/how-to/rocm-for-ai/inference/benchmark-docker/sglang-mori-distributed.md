# SGLang distributed inference with MoRI

This document provides a comprehensive guide for deploying a high-performance
SGLang distributed inference serving environment on an AMD Instinct MI355X GPU
cluster, utilizing the [MoRI (Modular RDMA
Interface)](https://github.com/rocm/mori) communication backend for optimized
inter-node collective operations. It also includes systematic instructions for
benchmarking 1P2D (1 prefill 2 decode, 3 nodes) configurations using automated
scripts.

## Prerequisites

The following configuration is required to implement this setup:

* **Nodes**: A minimum of three GPU nodes (virtual machines or physical
  machines) for wide expert parallelism (EP) evaluation.
* **GPUs**: 8x AMD Instinct MI355X GPU cards per node.
* **Networking**: 8x RDMA-capable NICs per node (AMD Pensando Pollara 400,
  NVIDIA Mellanox ConnectX-7, or Broadcom Thor 2), providing a dedicated 1:1
  mapping between GPUs and network interfaces for optimal inter-node
  communication.
* **Orchestration**: A Slurm cluster with at least three nodes — one for
  prefill service and two for decode services (EP16).

## System configuration

This section outlines the infrastructure setup required to support your AMD
Instinct MI355X cluster. It covers essential procedures for verifying software
baselines and firmware versions, configuring the AMD Pensando Pollara 400 AI
NICs for high-bandwidth networking, and applying thermal and Quality of Service
(QoS) tunings to ensure a stable, lossless RDMA fabric.

### Verify baseline software

The following table outlines the validated software stack. Use the provided
shell commands to verify the environment on each node before proceeding.

| Component | Version | Verification command |
| :--- | :--- | :--- |
| **OS** | Ubuntu 22.04.5 LTS | `cat /etc/os-release` |
| **Kernel** | 5.15.0-163-generic | `uname -r` |
| **ROCm** | 7.1.1 | `amd-smi version` |
| **PLDM bundle (firmware)** | 01.25.16.03 | [Verify BKC](#verify-best-known-configuration-bkc) |
| **AI NIC Firmware** | 1.117.5.a.45 | `dkms status` |
| **AI NIC Driver** | 25.11.1.001 | `dkms status` |

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
comply with the [MI355X Basic Health
Checks](https://instinct.docs.amd.com/projects/system-acceptance/en/latest/gpus/mi355x.html#basic-health-checks).
Key requirements include specific kernel boot arguments, minimum system memory
thresholds, PCIe Gen5 link stability, and so on.

### NIC installation

#### AMD Pensando Pollara 400 AI NIC installation

For detailed instructions on upgrading the firmware and installing drivers for
the AMD Pensando Pollara 400 AI NIC, refer to the [AMD Instinct System
Acceptance Guide](https://instinct.docs.amd.com/projects/system-acceptance/en/latest/network/nic-installation.html#amd-pensando-pollara-400-ai-nic).
After installation, verify the active firmware version on all NICs to ensure it
matches the software baseline. See [Verify baseline software](#verify-baseline-software).

To display the current firmware version for all AI NICs, use the following command.

```bash
sudo nicctl show version firmware
```

#### CX7 driver and firmware installation

1. Download and install the `DOCA 2.9.3` driver following the instructions in
   [NVIDIA DOCA 2.9.3 Downloads](https://developer.nvidia.com/doca-downloads).
2. Download the appropriate firmware for your hardware PSID from the
   [ConnectX-7 Firmware Download
   Center](https://network.nvidia.com/support/firmware/connectx7/) and flash
   the device.
3. To verify driver and firmware versions, use the following command. Replace
   `IB Device` with your specific backend interface.

   ```bash
   ethtool -i <IB Device>
   ```

#### Broadcom BNXT driver and firmware installation

Refer to your Broadcom representative for driver and firmware installation
instructions specific to your NIC model.

### Configure thermal management (fan speed)

For systems equipped with 400G optics, standard fan profiles are often
insufficient for maintaining stable operating temperatures. To prevent thermal
throttling or optics failure, the system fans must be set to `FullSpeed`.

* Requirement: A fan speed of approximately 25,000 RPM is required to maintain
  the AI NIC modules at an optimal operating temperature (~50°C).

* Constraint: Default profiles (typically around 4,000 RPM) and "Performance IO"
  settings (around 9,000 RPM) do not provide adequate airflow for 400G optical
  transceivers.

#### Configure fan speed via Redfish (Supermicro)

Run the following command to set the fan mode to `FullSpeed` through the BMC:

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

### Configure your backend network (netplan)

Configure the backend NICs for high-bandwidth inter-node communication. Suppose
the GPU’s eight network interface controllers (NICs) are `benic1p1` to
`benic8p1`. Each NIC must have its own subnet that is disjoint from the others.
Each node needs a unique IP address on each subnet. You should use the same
final octet in each subnet for a given node. For example, one node would have
the addresses `192.168.1.36`, `192.168.2.36`, and so on. Another node would
have `192.168.1.37`, `192.168.2.37`, and so on. Ensure MTU is set to `9000`.

```{note}
Ensure you identify the correct interface names for your system using `ip link`
before applying this configuration. The `macaddress:` values in the example
below are illustrative only and must be replaced with the actual MAC addresses
of your NICs, which you can find using `ip link show <interface>`.
```

For example, your `/etc/netplan/70-backend.yaml` should look like the
following:

```yaml
network:
  ethernets:
    benic8p1:
      addresses:
      - 192.168.8.38/31
      match:
        macaddress: 04:90:81:00:00:08
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
        macaddress: 04:90:81:00:00:07
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
        macaddress: 04:90:81:00:00:06
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
        macaddress: 04:90:81:00:00:05
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
        macaddress: 04:90:81:00:00:04
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
        macaddress: 04:90:81:00:00:03
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
        macaddress: 04:90:81:00:00:02
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
        macaddress: 04:90:81:00:00:01
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

To apply the configuration, use the following command.

```bash
sudo netplan apply
```

To verify your configuration, use the following command.

```bash
sudo apt install -y net-tools && ip -br a
```

### Configure quality of service (QoS) and congestion control (DCQCN)

To ensure lossless communication and optimal performance for RDMA traffic, the
network must be configured with specific QoS and Data Center Quantized
Congestion Notification (DCQCN) settings.

The following configuration:

* Enables RX and TX pause frames on the ports.
* Maps DSCP 24 (Data) to Q3 and DSCP 46 (CNP) to Q6, with all other DSCP to Q0.
* Enables PFC for Q3.
* Scheduling: 99% to Q3, 1% to Q0, and strict priority for Q6.

#### Configure DCQCN

Create and run a `/nfsdata/enable_dcqcn.sh` script to initialize congestion
control parameters.

``` bash
#!/bin/bash

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

#### Configure QoS and PFC

Create and run `/nfsdata/qos.sh` to set up traffic classes and scheduling.

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

#### Verify your configuration

Verify the configuration using `nicctl`.

* Verify QoS classification:

  ``` bash
  sudo nicctl show qos
  ```

  Expected QoS output:

  ``` bash
  NIC  : 00000000-0000-0000-0000-000000000001 (0000:f6:00.0)

  Port : 00000000-0001-4242-4242-000000000000

  Classification type         : DSCP

  DSCP-to-priority :
  DSCP bitmap               : 0xffffbffffeffffff ==> priority : 0
  DSCP bitmap               : 0x0000000001000000 ==> priority : 3
  DSCP bitmap               : 0x0000400000000000 ==> priority : 6
  DSCP                      : 0-23, 25-45, 47-63 ==> priority : 0
  DSCP                      : 24 ==> priority : 3
  DSCP                      : 46 ==> priority : 6
  ```

* Verify DCQCN and scheduling:

  ``` bash
  sudo nicctl show dcqcn
  ```

  Expected DCQCN and scheduling output:

  ``` bash
  NIC : 00000000-0000-0000-0000-000000000001 (0000:f6:00.0)
  ------------------------------------------------------------------------------------------

  Lif id                                     : 00000000-0100-0000-4242-000000000000
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

## Software installation

Next, install the core compute stack required to operate the AMD Instinct GPUs.
The following steps guide you through deploying the ROCm software stack and the
necessary kernel-mode drivers to enable hardware acceleration and optimize the
environment for distributed inference workloads.

### Install ROCm

Use the following commands to quickly install ROCm 7.1.1 on Ubuntu 22.04:

``` bash
wget https://repo.radeon.com/amdgpu-install/7.1.1/ubuntu/jammy/amdgpu-install_7.1.1.70101-1_all.deb
sudo apt install ./amdgpu-install_7.1.1.70101-1_all.deb
sudo apt update
sudo apt install python3-setuptools python3-wheel
sudo usermod -a -G render,video $LOGNAME # Add the current user to the render and video groups
sudo apt install rocm
```

For detailed installation instructions, refer to the [ROCm 7.1.1
documentation](https://rocm.docs.amd.com/projects/install-on-linux/en/docs-7.1.1/install/quick-start.html#rocm-installation).

### Install AMD GPU Driver (amdgpu)

Use the following commands to quickly install the AMD GPU Driver (ROCm 7.1.1)
on Ubuntu 22.04:

``` bash
wget https://repo.radeon.com/amdgpu-install/7.1.1/ubuntu/jammy/amdgpu-install_7.1.1.70101-1_all.deb
sudo apt install ./amdgpu-install_7.1.1.70101-1_all.deb
sudo apt update
sudo apt install "linux-headers-$(uname -r)" "linux-modules-extra-$(uname -r)"
sudo apt install amdgpu-dkms
```

For detailed installation instructions, refer to the [ROCm 7.1.1
documentation](https://rocm.docs.amd.com/projects/install-on-linux/en/docs-7.1.1/install/quick-start.html#amdgpu-driver-installation).

## Network verification and testing

Before deploying the inference engine, validate the health and performance of
the cluster interconnects.

### Verify network connectivity

Verify that all network interfaces are reachable across the cluster nodes.
Assuming `benic1p1` through `benic8p1` are the dedicated RoCE backend
interfaces, use the following ping loop to verify reachability across the
backend subnets (for instance, a target node at host IP suffix
`.38`).

```bash
# Test connectivity for RoCE subnets 192.168.x.38 (node B) through 192.168.x.37 (node A)
for i in {1..8}; do ping -c 1 192.168.${i}.38; done
```

### Validate your RDMA setup

Confirm that all eight RDMA network interfaces are in the `UP` state and
correctly configured with the required MTU and GID settings.

#### Verify link status MTU, NIC temperature, and NIC speed

```bash
sudo nicctl show port
```

The output should look something like this:

```bash
-------------------------------------------------------------------------------------

NIC  : 00000000-0000-0000-0000-000000000002 (0000:f6:00.0)

Port : 00000000-0002-4242-4242-000000000000 (eth1/1)
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
    MAC address                              : 04:90:81:00:00:00
    Transceiver type                         : QSFP_CMIS
    Transceiver state                        : SPROM-READ
    Transceiver PID                          : QSFP-400G-DR4
    Transceiver temperature (in C)           : 45
    Transceiver warning temperature (in C)   : 75
    Transceiver alarm temperature (in C)     : 80
-------------------------------------------------------------------------------------
```

#### Verify GID

Ensure each device has a valid GID mapped to its assigned IP address.

```bash
ibv_devinfo -v | grep GID
```

The output should look something like this:

```bash
      GID[  0]:               fe80::6a00:00ff:fe00:0001, RoCE v2
      GID[  1]:               ::ffff:192.168.7.36, RoCE v2
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

Perform a bandwidth test using ROCm GPU memory between two nodes. One acts as
a server and the other acts as a client. Replace `<SERVER_IP>` with the
appropriate IP.

```bash
# On Server Node
./ib_write_bw --use_rocm=0 -d ionic_0 --report_gbits -a

# On Client Node
./ib_write_bw --use_rocm=0 -d ionic_0 --report_gbits -a <SERVER_IP>
```

## SGLang serving and MoRI unit tests

### Install Docker Engine

Install the Docker engine to manage the containerized SGLang and MoRI serving
environments.

```bash
sudo apt update && sudo apt install -y docker.io
sudo usermod -aG docker "$USER"
```

### Launch the serving container

Deploy the SGLang MoRI serving container on each node.

```bash
CONTAINER_NAME=sglang_mori
IMAGE_NAME=rocm/sgl-dev:sglang-0.5.6.post1-rocm700-mi35x-mori-0113

docker run -it \
    --rm \
    --device /dev/dri --device /dev/kfd -v /dev/infiniband:/dev/infiniband \
    --network host --ipc host \
    --group-add video \
    --cap-add SYS_PTRACE \
    --security-opt seccomp=unconfined \
    --privileged \
    --shm-size 128G \
    --name ${CONTAINER_NAME} \
    ${IMAGE_NAME} /bin/bash
```

### Run MoRI inter-node unit tests

Before starting the SGLang service, run the MoRI unit test to verify that the
inter-node communication backend is correctly configured.

MoRI unit test uses 2 nodes as a minimal validation before running the full
1P2D (3 nodes) benchmark.

The key configuration variables are:

* `GLOO_SOCKET_IFNAME`: The network interface used for backend initialization (for example, `benic1p1`).
* `MORI_SOCKET_IFNAME`: The network interface used by MoRI's own bootstrap. Set it to the same backend interface as `GLOO_SOCKET_IFNAME`.
* `MORI_GPU_ARCHS`: The target GPU architecture. Set to `gfx950` for MI355X; otherwise the test may auto-select the wrong arch (for example, `gfx942`).
* `<MASTER_IP>`: The IP address of the primary node's backend interface.

Performance reference data can be found in the [ROCm/MoRI
repository](https://github.com/ROCm/mori?tab=readme-ov-file#mori-ep).

```{note}
The `rocm/sgl-dev:sglang-0.5.6.post1-rocm700-mi35x-mori-0113` image ships MoRI
under `/sgl-workspace/mori`. If `/sgl-workspace/mori` or the example test
scripts (for example, `test_dispatch_combine_internode.py`) are missing, clone
the repository:

`git clone https://github.com/ROCm/mori.git /sgl-workspace/mori`
```

```bash
# Set up environment inside the container
cd /sgl-workspace/mori

# prettytable is required to render the benchmark result table:
pip install prettytable

export PYTHONPATH=/sgl-workspace/mori:$PYTHONPATH
export MORI_GPU_ARCHS=gfx950                    # MI355X arch; avoids auto-selecting gfx942
export GLOO_SOCKET_IFNAME=<BACKEND_INTERFACE>   # e.g. benic1p1
export MORI_SOCKET_IFNAME=<BACKEND_INTERFACE>   # MoRI bootstrap interface; same as GLOO_SOCKET_IFNAME

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

## End-to-end 1P2D performance testing

This section guides you through running distributed inference benchmarks using
the SGLang disagg recipe.

### Download the model and setup your run environment

This performance test supports the following models:

* [DeepSeek-V3](https://huggingface.co/deepseek-ai/DeepSeek-V3)
* [DeepSeek-R1](https://huggingface.co/deepseek-ai/DeepSeek-R1)
* [DeepSeek-R1-0528](https://huggingface.co/deepseek-ai/DeepSeek-R1-0528)

To set up your environment and download the models using the Hugging Face CLI,
use the following commands. Modify the `hf download` command
to download the desired model.

```bash
# Set up a virtual environment and install the Hugging Face CLI
sudo apt update && sudo apt install -y python3-venv
python3 -m venv ~/venvs/hf
source ~/venvs/hf/bin/activate
pip install huggingface_hub

# Download the model to the shared NFS mount point
# Replace 'deepseek-ai/DeepSeek-R1-0528' with your desired model
hf download --token <your_hf_token> \
    deepseek-ai/DeepSeek-R1-0528 \
    --local-dir /mount/point/models/DeepSeek-R1
```

### Clone the SGLang disaggregation recipe

Clone the [ROCm/distributed_inference](https://github.com/ROCm/distributed_inference)
repository to the shared file system:

```bash
git clone https://github.com/ROCm/distributed_inference.git
cd distributed_inference
```

```{note}
In the 1P2D configuration, the prefill service and benchmark process run on the
same node, while remaining nodes handle decode services.
```

### Configure InfiniBand devices

Identify and configure the available InfiniBand devices.

1. List available devices using the following command.

   ```bash
   ibv_devinfo -l
   ```

   Example output:

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

2. Update environment variables. Edit `set_env_vars.sh` and set the
   following variables:

   ```bash
   export IBDEVICES=ionic_0,ionic_1,ionic_2,ionic_3,ionic_4,ionic_5,ionic_6,ionic_7

   # Must be >= chunked_prefill_size / dp_size.
   # Default recipe: 262144 / 8 = 32768. set_env_vars.sh's value (16384) is
   # too small and causes an AssertionError on prefill startup.
   export SGLANG_MORI_NUM_MAX_DISPATCH_TOKENS_PER_RANK=32768

   # Must be large enough for the dispatch buffer. The default 4 GB heap
   # causes an out-of-memory error at first inference with a 32768-token budget.
   export MORI_SHMEM_HEAP_SIZE=16G
   ```

### Configure the script and submit the job

```{important}
Two `set_env_vars.sh` variables must be set before submitting the job, or
the prefill service crashes at startup:

* `SGLANG_MORI_NUM_MAX_DISPATCH_TOKENS_PER_RANK` — SGLang asserts this value is
  ≥ `chunked_prefill_size / dp_size`. For the default DeepSeek-R1 recipe
  (262144 / 8 = 32768), `set_env_vars.sh`'s shipped value of 16384 triggers an
  `AssertionError` on the prefill node only (decode is exempt). Raising this to
  32768 fixes the crash.
* `MORI_SHMEM_HEAP_SIZE` — Raising the dispatch budget to 32768 tokens exceeds
  MoRI's default 4 GB static heap and causes an out-of-memory error at first
  inference. Set this to `16G` (MoRI's own inter-node test default).

These values are set in the preceding [Configure InfiniBand
devices](#configure-infiniBand-devices) step.
```

1. To set the required configuration parameters, update the following
   environment variables in `run_submit_disagg.sh` to match your cluster setup:

   ```bash
   # SLURM Job Configuration
   export SLURM_ACCOUNT="<your_slurm_account>"  # The account name for SLURM job accounting and resource allocation
   export SLURM_PARTITION="compute" # The specific cluster partition (queue) to submit the job to
   export TIME_LIMIT="24:00:00"     # Maximum wall time for the job (Hours:Minutes:Seconds)

   # Model Configuration
   export MODEL_PATH="/nfsdata"     # Base directory where the model weights are stored
   export MODEL_NAME="DeepSeek-R1"  # Specific model directory name (joined with MODEL_PATH)
   export CONTAINER_IMAGE="lmsysorg/sglang-rocm:v0.5.12.post1-rocm720-mi35x-20260529" # Docker image to use for the environment

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

2. Then submit the batch job into slurm cluster through `bash ./run_submit_disagg.sh`.

   ```bash
   bash ./run_submit_disagg.sh
   ```

### Log file analysis

1. After submission, retrieve the SLURM job ID:

   ```bash
   squeue
   ```

   Example output:

   ```bash
   JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
   123   compute       1p2d   alice  R    00:10:32      4 node[01-04]
   ```

2. A directory named `slurm_job-$SLURM_JOB_ID` is created in `/tmp` on each
   participating node. The directory contains:

   | Log File | Description |
   | :--------| :-----------|
   | `pd_sglang_bench_serving.sh_NODE${NODE_RANK}.log` | Main service log per node |
   | `decode_NODE${NODE_RANK}.log` | SGLang decode service details |
   | `prefill_NODE${NODE_RANK}.log` | SGLang prefill service details |

3. The benchmark results will be displayed in
   `pd_sglang_bench_serving.sh_NODE${NODE_RANK}.log`. Key metrics include:

   ```{note}
   The following benchmark utility output is provided for reference only and
   should not be used to compare performance. See the
   [InferenceX](https://inferencex.semianalysis.com/) website for validated
   performance results.
   ```

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

## Troubleshooting

The following section outlines common issues and their solutions.

### Bandwidth test failures

1. Use ROCm-optimized `rdma-perftest`, not the generic `perftest`

    ```bash
    which ib_write_bw
    ```

2. Confirm the `SERVER_IP` is accessible

    ```bash
    ping <SERVER_IP>
    ```

3. Check system logs, use `dmesg` for kernel-level errors

    ``` bash
    sudo dmesg -T | grep -i 'error|warn|fail|exception'
    ```

### Slurm job fails

Common causes and solutions for Slurm job submission failures include:

1. Shared storage access:
   * Verify that both `sglang_disagg` and model directories are located in a shared NFS mount accessible to all compute nodes.
   * Ensure proper permissions: `chmod -R 755 /shared/path/sglang_disagg /shared/path/models`

2. Log analysis:
   * Examine `pd_sglang_bench_serving.sh_NODE${NODE_RANK}.log` on each participating node for detailed error messages.
   * Check for common issues like missing dependencies, GPU allocation failures, or network connectivity problems.

3. Configuration validation:
   * Verify SLURM parameters in `run_submit_disagg.sh`:
     * `SLURM_ACCOUNT`: Ensure your account has access to the cluster
     * `SLURM_PARTITION`: Confirm the partition exists and is accessible
     * `MODEL_PATH`: Check that the path is correct and accessible from compute nodes
     * `MODEL_NAME`: Verify the model subdirectory exists within `MODEL_PATH`
   * Use `sinfo` to check partition and node availability.
