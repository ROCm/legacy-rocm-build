# vLLM distributed inference with MoRI

This document provides an end-to-end guide for deploying vLLM with
[MoRI (Modular RDMA Interface)](https://github.com/rocm/mori) on AMD Instinct MI355X
clusters. It covers system preparation (firmware, drivers, ROCm, RDMA networking,
QoS/DCQCN), container setup, inter-node MoRI validation, and launching a
prefill-decode (PD) disaggregated serving cluster using vLLM with the MoRI-IO KV
transfer backend and vllm-router. The serving example deploys `amd/Kimi-K2.5-MXFP4`
in a 1P1D configuration across two nodes.

## Prerequisites

The following hardware configuration is required to implement this setup:

* **Nodes**: A minimum of two GPU nodes (virtual machines or physical machines)
  for prefill-decode (PD) disaggregated serving.
* **GPUs**: 8x AMD Instinct MI355X GPU cards per node.
* **Networking**: 8x RDMA-capable NICs per node (AMD Pensando Pollara 400, NVIDIA
  Mellanox ConnectX-7, or Broadcom Thor 2), providing a dedicated 1:1 mapping between
  GPUs and network interfaces for optimal inter-node communication.

## System configuration

This section outlines infrastructure steps required to prepare your cluster for
high-performance AI workloads. It covers validating your system's software
baselines and firmware versions, configuring high-bandwidth backend networking
for inter-node communication, setting up QoS and congestion control, and
establishing shared storage to ensure a synchronized distributed computing
environment.

### Verify baseline software

The following table outlines the validated software baseline. Ensure your
environment satisfies the
[ROCm 7.1.1 compatibility matrix](https://rocm.docs.amd.com/en/docs-7.1.1/compatibility/compatibility-matrix.html)
for your specific GPU and OS combination. Use the provided commands to verify
the environment on each node before proceeding.

| Component | Version | Verification command |
| :--- | :--- | :--- |
| **OS** | Ubuntu 22.04.5 LTS | `cat /etc/os-release` |
| **Kernel** | 5.15.0-163-generic | `uname -r` |
| **ROCm** | 7.1.1 | `amd-smi version` |
| **PLDM bundle (firmware)** | 01.25.16.03 | [Verify BKC](#verify-best-known-configuration-bkc) |
| **AI NIC firmware** | 1.117.5.a.45 | `dkms status` |
| **AI NIC driver** | 25.11.1.001 | `dkms status` |
| **CX7 firmware** | 28.46.3048 | `dkms status` |
| **CX7 driver** | 24.10-3.2.5 | `dkms status` |
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
matches the software baseline. See [Verify baseline
software](#verify-baseline-software).

To display the current firmware version for all AI NICs, use the following
command.

``` bash
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

* A fan speed of approximately 25,000 RPM is required to maintain the AI NIC
  modules at an optimal operating temperature of approximately 50°C.
* Default profiles (approximately 4,000 RPM) or "Performance IO" settings
  (approximately 9,000 RPM) do not provide adequate airflow for 400G optical
  transceivers.

Execute the following command to set the fan mode to `FullSpeed` via the BMC
(Supermicro):

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
the GPU's eight network interface controllers (NICs) are `benic1p1` to
`benic8p1`. Each NIC must have its own subnet that is disjoint from the others.
Each node needs a unique IP address on each subnet. Use the same final octet in
each subnet for a given node. For example, one node would have the addresses
`192.168.1.36`, `192.168.2.36`, and so on. Another node would have
`192.168.1.37`, `192.168.2.37`, and so on. Ensure MTU is set to `9000`.

```{note}
Ensure you identify the correct interface names for your system using `ip link`
before applying this configuration. The `macaddress:` values in the example
below are illustrative only and must be replaced with the actual MAC addresses
of your NICs, which you can find using `ip link show <interface>`.
```

For example, your `/etc/netplan/70-backend.yaml` might include something like
the following:

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
Congestion Notification (DCQCN) settings. The following configuration:

* Enables RX and TX pause frames on the ports.
* Maps DSCP 24 (Data) to Q3 and DSCP 46 (CNP) to Q6, with all other DSCP to Q0.
* Enables PFC for Q3.
* Scheduling: 99% to Q3, 1% to Q0, and strict priority for Q6.

#### Configure DCQCN

Create and execute `/nfsdata/enable_dcqcn.sh` to initialize congestion control
parameters.

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
    --rate-increase-threshold $RATE_INCREASE_THRESHOLD \
    --rate-increase-interval $RATE_INCREASE_INTERVAL \
    --cnp-dscp $CNP_DSCP
done
```

#### Configure QoS and PFC

Create and execute `/nfsdata/qos.sh` to set up traffic classes and scheduling.

``` bash
#!/bin/bash

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

#### Verify QoS and DCQCN

To verify the QoS classification:

```bash
sudo nicctl show qos
```

Expected output:

```bash
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

To verify DCQCN and scheduling:

```bash
sudo nicctl show dcqcn
```

Expected output:

```bash
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

Next, install the essential software stack required to operate the AMD Instinct
GPUs and high-speed networking components.

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

Use the following commands to quickly install the AMD GPU Driver (ROCm 7.1.1) on Ubuntu 22.04:

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
# Test connectivity across RoCE subnets 192.168.1.x through 192.168.8.x
for i in {1..8}; do ping -c 1 192.168.${i}.38; done
```

### Validate your RDMA setup

#### Verify link status, MTU, NIC temperature, and NIC speed

```bash
sudo nicctl show port
```

Expected output:

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

Expected output:

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

Perform a bandwidth test using ROCm GPU memory between two nodes. One acts
as a server and the other acts as a client. For 400G interfaces, the expected
peak throughput is approximately 390 Gbps. Replace `<SERVER_IP>` with the
appropriate IP.

```bash
# On Server Node
./ib_write_bw --use_rocm=0 -d <mlx5_0/ionic_0/rdma0> --report_gbits -a

# On Client Node
./ib_write_bw --use_rocm=0 -d <mlx5_0/ionic_0/rdma0> --report_gbits -a <SERVER_IP>
```

## vLLM serving and MoRI unit tests

### Install Docker Engine

Install the Docker engine to manage the containerized vLLM and MoRI serving
environments.

```bash
sudo apt update && sudo apt install -y docker.io
sudo usermod -aG docker "$USER"
```

### Download the model

This guide uses the
[amd/Kimi-K2.5-MXFP4](https://huggingface.co/amd/Kimi-K2.5-MXFP4) model.
Use the following commands to install the Hugging Face CLI and download the
model to your shared NFS directory:

```bash
# Set up a virtual environment and install the Hugging Face CLI
sudo apt update && sudo apt install -y python3-venv
python3 -m venv ~/venvs/hf
source ~/venvs/hf/bin/activate
pip install huggingface_hub

# Download the model to the shared NFS mount point
hf download --token <your_hf_token> \
    amd/Kimi-K2.5-MXFP4 \
    --local-dir /mount/point/models/Kimi-K2.5-MXFP4
```

### Launch the serving container

Deploy the vLLM MoRI serving Docker container on each node.

```bash
CONTAINER_NAME=vllm_mori
IMAGE_NAME=vllm/vllm-openai-rocm:nightly

docker run -it --rm --init \
    --entrypoint bash \
    --device /dev/dri --device /dev/kfd \
    -v /dev/infiniband:/dev/infiniband \
    --network host --ipc host \
    --group-add video --cap-add SYS_PTRACE \
    --security-opt seccomp=unconfined --privileged \
    --ulimit memlock=-1 --ulimit stack=67108864 \
    --shm-size 128G \
    -v /mount/point/models:/models \
    --name ${CONTAINER_NAME} \
    ${IMAGE_NAME}
```

### Run MoRI inter-node unit tests

Before starting the vLLM service, run the MoRI unit test to verify that the
inter-node communication backend is correctly configured.

The key configuration variables are:

* `GLOO_SOCKET_IFNAME`: The network interface used for backend initialization (for example, `benic1p1`).
* `MORI_SOCKET_IFNAME`: The network interface used by MoRI's own bootstrap. Set it to the same backend interface as `GLOO_SOCKET_IFNAME`.
* `MORI_GPU_ARCHS`: The target GPU architecture. Set to `gfx950` for MI355X; otherwise the test may auto-select the wrong arch (for example, `gfx942`).
* `<MASTER_IP>`: The IP address of the primary node's backend interface.

Performance reference data can be found in the [ROCm/MoRI
repository](https://github.com/ROCm/mori?tab=readme-ov-file#mori-ep).

```{note}
The `vllm/vllm-openai-rocm:nightly` image does not ship `/app/mori`, and the
example test scripts (for example, `test_dispatch_combine_internode.py`) are not
included in the `amd_mori` pip package. Clone the MoRI repository before running
the unit test.
```

```bash
# Set up environment inside the container

# /app/mori and the example tests are not in the image — clone the repo:
git clone https://github.com/ROCm/mori.git /app/mori
cd /app/mori

# prettytable is required to render the benchmark result table:
pip install prettytable

export PYTHONPATH=/app/mori:$PYTHONPATH
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

### Deploy and serve the model with PD disaggregation

To deploy `amd/Kimi-K2.5-MXFP4` with 1P1D (one prefill node and one decode
node) across two nodes, use the following serving scripts.

#### List available InfiniBand devices

Identify the available InfiniBand devices inside the container:

```bash
ibv_devinfo -l
```

Expected output:

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

#### Create serving scripts

Node 0 serves as both the prefill node and the router, while Node 1 runs the
decode service. The router script runs on the **host** and launches a separate
router container; the prefill and decode scripts run inside the vLLM serving
container.

* Node 0 (Router): `vllm_router.sh` — run on the host

   ```{note}
   Run this script on the host, not inside the vLLM container. It launches
   `vllm/vllm-router:nightly` as a separate container.
   ```

   ```bash
   ROUTER_IMAGE="${ROUTER_IMAGE:-vllm/vllm-router:nightly}"
   ROUTER_CNAME="${ROUTER_CNAME:-vllm-router}"
   docker run --rm -d \
       --name ${ROUTER_CNAME} \
       --network host \
       ${ROUTER_IMAGE} \
       bash -lc 'exec vllm-router \
           --vllm-pd-disaggregation \
           --kv-connector moriio \
           --vllm-discovery-address 0.0.0.0:36367 \
           --port 30000 \
           --host 0.0.0.0 \
           --policy consistent_hash \
           --prefill-policy consistent_hash \
           --decode-policy consistent_hash \
           --log-level info \
           2>&1 | tee vllm_router.log'
   ```

* Node 0 (Prefill node): `vllm_node0.sh`

   ```bash
   #!/bin/bash

   # vLLM core
   export VLLM_SERVER_DEV_MODE=0
   export VLLM_DISABLE_REQUEST_ID_RANDOMIZATION=1

   # AITER acceleration
   export VLLM_ROCM_USE_AITER=1
   export VLLM_ROCM_USE_AITER_PAGED_ATTN=0
   export VLLM_ROCM_USE_AITER_RMSNORM=1
   export VLLM_USE_AITER_TRITON_SILU_MUL=0
   export VLLM_ENGINE_READY_TIMEOUT_S=3600

   # UCX transport (for Nixl RDMA KV transfer)
   export UCX_TLS=tcp,self,shm,rocm_ipc,rocm_copy,cma
   export UCX_SOCKADDR_TLS_PRIORITY=tcp
   export UCX_MEMTYPE_CACHE=y
   export UCX_RNDV_SCHEME=get_zcopy
   export UCX_RNDV_THRESH=4k
   export UCX_ROCM_IPC_MIN_ZCOPY=0
   export UCX_LOG_LEVEL=warn
   export UCX_IB_GID_INDEX=1              # RoCEv2: use IPv4-mapped GID for inter-node RDMA routing
   export UCX_IB_TRAFFIC_CLASS=96         # QoS: adjust per cluster (96 for Pensando ionic)
   export UCX_NET_DEVICES=ionic_0:1       # First IB device for UCX; adjust to match your NIC

   # NCCL / GLOO network binding (replace device names with output from ibv_devinfo -l)
   export NCCL_IB_HCA=ionic_0,ionic_1,ionic_2,ionic_3,ionic_4,ionic_5,ionic_6,ionic_7
   export GLOO_SOCKET_IFNAME=<BACKEND_INTERFACE>   # e.g. benic1p1
   export NCCL_SOCKET_IFNAME=<BACKEND_INTERFACE>

   # ROCm / MoRI-IO
   export HSA_ENABLE_SDMA=1
   export PROXY_STREAM_IDLE_TIMEOUT=300

   # Nixl side channel (set to this node's RDMA IP, e.g. 192.168.x.x)
   export VLLM_NIXL_SIDE_CHANNEL_HOST=<RDMA_IP>
   export VLLM_NIXL_SIDE_CHANNEL_PORT=5600

   vllm serve /models/Kimi-K2.5-MXFP4 \
       --served-model-name Kimi-K2.5-MXFP4 \
       --port 2584 \
       --trust-remote-code \
       --kv-transfer-config '{"kv_connector": "MoRIIOConnector", "kv_role": "kv_producer", "kv_connector_extra_config": {"proxy_ip": "<NODE0_IP>", "proxy_ping_port": "36367", "http_port": "2584"}}' \
       --tensor-parallel-size 8 \
       --compilation-config '{"cudagraph_mode":"PIECEWISE"}' \
       --no-enable-prefix-caching \
       --block-size 1 \
       --gpu-memory-utilization 0.90 \
       --mm-encoder-tp-mode data 2>&1 | tee serving_node0.log
   ```

* Node 1 (Decode node): `vllm_node1.sh`

   ```bash
   #!/bin/bash

   # vLLM core
   export VLLM_SERVER_DEV_MODE=0
   export VLLM_DISABLE_REQUEST_ID_RANDOMIZATION=1

   # AITER acceleration
   export VLLM_ROCM_USE_AITER=1
   export VLLM_ROCM_USE_AITER_PAGED_ATTN=0
   export VLLM_ROCM_USE_AITER_RMSNORM=1
   export VLLM_USE_AITER_TRITON_SILU_MUL=0
   export VLLM_ENGINE_READY_TIMEOUT_S=3600

   # UCX transport (for Nixl RDMA KV transfer)
   export UCX_TLS=tcp,self,shm,rocm_ipc,rocm_copy,cma
   export UCX_SOCKADDR_TLS_PRIORITY=tcp
   export UCX_MEMTYPE_CACHE=y
   export UCX_RNDV_SCHEME=get_zcopy
   export UCX_RNDV_THRESH=4k
   export UCX_ROCM_IPC_MIN_ZCOPY=0
   export UCX_LOG_LEVEL=warn
   export UCX_IB_GID_INDEX=1             # RoCEv2: use IPv4-mapped GID for inter-node RDMA routing
   export UCX_IB_TRAFFIC_CLASS=96        # QoS: adjust per cluster (96 for Pensando ionic)
   export UCX_NET_DEVICES=ionic_0:1      # First IB device for UCX; adjust to match your NIC

   # NCCL / GLOO network binding (replace device names with output from ibv_devinfo -l)
   export NCCL_IB_HCA=ionic_0,ionic_1,ionic_2,ionic_3,ionic_4,ionic_5,ionic_6,ionic_7
   export GLOO_SOCKET_IFNAME=<BACKEND_INTERFACE>   # e.g. benic1p1
   export NCCL_SOCKET_IFNAME=<BACKEND_INTERFACE>

   # ROCm / MoRI-IO
   export HSA_ENABLE_SDMA=1
   export PROXY_STREAM_IDLE_TIMEOUT=300

   # Nixl side channel (set to this node's RDMA IP, e.g. 192.168.x.x)
   export VLLM_NIXL_SIDE_CHANNEL_HOST=<RDMA_IP>
   export VLLM_NIXL_SIDE_CHANNEL_PORT=5600

   vllm serve /models/Kimi-K2.5-MXFP4 \
       --served-model-name Kimi-K2.5-MXFP4 \
       --port 2584 \
       --trust-remote-code \
       --kv-transfer-config '{"kv_connector": "MoRIIOConnector", "kv_role": "kv_consumer", "kv_connector_extra_config": {"proxy_ip": "<NODE0_IP>", "proxy_ping_port": "36367", "http_port": "2584"}}' \
       --tensor-parallel-size 8 \
       --enable-expert-parallel \
       --all2all-backend mori_low_latency \
       --compilation-config '{"cudagraph_mode":"PIECEWISE"}' \
       --no-enable-prefix-caching \
       --block-size 1 \
       --gpu-memory-utilization 0.90 \
       --mm-encoder-tp-mode data 2>&1 | tee serving_node1.log
   ```

#### Run the serving scripts

Replace the following placeholders in each script before running:

* `<NODE0_IP>`: management IP of Node 0
* `<RDMA_IP>`: each node's RDMA IP (find with `hostname -I | tr ' ' '\n' | grep '^192\.168\.'`)
* `<BACKEND_INTERFACE>`: backend network interface name (for example, `benic1p1`)

```bash
# On Node 0 (Prefill + Router)
bash vllm_router.sh
bash vllm_node0.sh

# On Node 1 (Decode)
bash vllm_node1.sh
```
