.. meta::
   :description: Multi-node setup for AI training
   :keywords: gpu, system, health, validation, bench, perf, performance, rvs, rccl, babel, mi300x, mi325x, flops, bandwidth, rbt, training

.. _rocm-for-ai-multi-node-setup:

*********************************
Multi-node setup for AI workloads
*********************************

AMD provides ready-to-use Docker images for AMD Instinct™ MI300X and MI325X
GPUs containing ROCm-capable deep learning frameworks and essential
software components. These Docker images can run and leverage multiple nodes if
they are available. This page describes how to enable the multi-node training
of AI workloads on AMD Instinct GPUs.

Prerequisites
=============

Before starting, ensure your environment meets the following requirements:

* Multi-node networking: your cluster should have a configured multi-node network. For setup
  instructions, see the `Multi-node network configuration for AMD Instinct
  GPUs
  <https://instinct.docs.amd.com/projects/gpu-cluster-networking/en/latest/how-to/multi-node-config.html>`__
  guide in the Instinct documentation.

* ROCm Docker container to simplify environment setup for AI workloads. See the following resources to get started:

  * :doc:`Training a model with Megatron-LM and ROCm <../training/benchmark-docker/megatron-lm>`

  * :doc:`Training a model with PyTorch and ROCm <../training/benchmark-docker/pytorch-training>`

  * :doc:`Training a model with JAX MaxText and ROCm <../training/benchmark-docker/jax-maxtext>`

* Slurm workload manager to run the :ref:`provided examples <multi-node-setup-training-examples>`.

Install required packages
=========================

To run multi-node workloads, ensure you have all the required packages installed based on your
network device. For example, on Ubuntu systems:

.. code-block:: shell

   apt install -y iproute2

   apt install -y linux-headers-"$(uname -r)" libelf-dev

   apt install -y gcc make libtool autoconf librdmacm-dev rdmacm-utils infiniband-diags ibverbs-utils perftest ethtool libibverbs-dev rdma-core strace libibmad5 libibnetdisc5 ibverbs-providers libibumad-dev libibumad3 libibverbs1 libnl-3-dev libnl-route-3-dev

Compile and install the RoCE library
------------------------------------

If you're using Broadcom NICs, you need to compile and install the RoCE (RDMA
over Converged Ethernet) library. See `RoCE cluster network configuration guide
for AMD Instinct GPUs
<https://instinct.docs.amd.com/projects/gpu-cluster-networking/en/latest/how-to/roce-network-config.html>`__
for more information.

See the `Ethernet networking guide for AMD
Instinct MI300X GPU clusters: Compiling Broadcom NIC software from source
<https://docs.broadcom.com/doc/957608-AN2XX#page=81>`_ for more details.

.. important::

   It is crucial to install the exact same version of the RoCE library that
   is installed on your host system. Also, ensure that the path to these
   libraries on the host is correctly mounted into your Docker container.
   Failure to do so can lead to compatibility issues and communication
   failures.

1. Set ``BUILD_DIR`` to the path on the host system where the Broadcom drivers and ``bnxt_rocelib`` source are located.
   Then, navigate to the ``bnxt_rocelib`` directory.

   .. code-block:: shell

      export BUILD_DIR=/path/to/your/broadcom_drivers_on_host
      cd $BUILD_DIR/drivers_linux/bnxt_rocelib/

2. The ``bnxt_rocelib`` directory contains a version of ``libbnxt_re`` in a zipped ``.tar.gz`` file.

   .. code-block:: shell

      tar -xf libbnxt_re-a.b.c.d.tar.gz
      cd libbnxt_re-a.b.c.d

3. Compile and install the RoCE library.

   .. code-block:: shell

      sh autogen.sh
      ./configure
      make
      find /usr/lib64/ /usr/lib -name "libbnxt_re-rdmav*.so" -exec mv {} {}.inbox \;
      make install all
      sh -c "echo /usr/local/lib >> /etc/ld.so.conf"
      ldconfig
      cp -f bnxt_re.driver /etc/libibverbs.d/
      find . -name "*.so" -exec md5sum {} \;
      BUILT_MD5SUM=$(find . -name "libbnxt_re-rdmav*.so" -exec md5sum {} \; | cut -d " " -f 1)

Environment setup
=================

Before running multi-node workloads, set these essential environment variables:

Master address
--------------

By default, ``localhost`` is used for single-node configurations. Change
``localhost`` to the master node's resolvable hostname or IP address:

.. code-block:: bash

   export MASTER_ADDR="${MASTER_ADDR:-localhost}"

Number of nodes
---------------

Set the number of nodes you want to train on (for example, ``2``, ``4``, or ``8``):

.. code-block:: bash

   export NNODES="${NNODES:-<num_nodes>}"

Node ranks
----------

Set the rank of each node (``0`` for master, ``1`` for the first worker node, and so on).
Node ranks should be unique across all nodes in the cluster.

.. code-block:: bash

   export NODE_RANK="${NODE_RANK:-<node_rank>}"

Network interface
-----------------

Update the network interface in the script to match your system's network interface. To
find your network interface, run the following (outside of any Docker container):

.. code-block:: bash

   ip a

Look for an active interface (status "UP") with an IP address in the same subnet as
your other nodes. Then, update the following variable in the script, for
example:

.. code-block:: bash

   export NCCL_SOCKET_IFNAME=ens50f0np0

This variable specifies which network interface to use for inter-node communication.
Setting this variable to the incorrect interface can result in communication failures
or significantly reduced performance.

.. tip::

  This command sets ``NCCL_SOCKET_IFNAME``'s value to the last RDMA interface.

  .. code-block:: bash

     export NCCL_SOCKET_IFNAME=$(rdma link show | awk '{print $NF}' | sort | tail -n1)

RDMA/IB interface
-----------------

Set the RDMA interfaces to be used for communication. NICs can come from different vendors and the names of the RDMA interface can be different. To get the list of all the RDMA/IB devices, run:

.. code-block:: bash

   ibv_devices

The command below gets the list of all RDMA/IB devices and puts them in a
comma-separated format. If
(``rdma0,rdma1,rdma2,rdma3,rdma4,rdma5,rdma6,rdma7``) are your RDMA
interfaces, then set:

.. code-block:: bash

   # If using Broadcom NIC
   export NCCL_IB_HCA=rdma0,rdma1,rdma2,rdma3,rdma4,rdma5,rdma6,rdma7
   # If using Mellanox NIC
   # export NCCL_IB_HCA=mlx5_0,mlx5_1,mlx5_2,mlx5_3,mlx5_4,mlx5_5,mlx5_8,mlx5_9

.. tip::

  Alternatively, if you want to choose the RDMA interface automatically, you
  can use the following. This command will sort the RDMA interfaces and then
  select the first eight RDMA interfaces.

  .. code-block:: bash

     export NCCL_IB_HCA=$(ibv_devices | awk 'NR>2 {print $1}' | sort | head -n 8 | paste -sd,)

Global ID index
---------------

Update the global ID index if you're using RoCE.

.. code-block:: bash

   export NCCL_IB_GID_INDEX=3

.. _multi-node-setup-training-examples:

Multi-node training examples
============================

The following examples use the Slurm workload manager to launch jobs on
multiple nodes. To run these scripts as-is, you must have a Slurm environment
configured. The scripts are designed to work with both Broadcom Thor 2 and
Mellanox NICs by automatically installing the required libraries and setting
the necessary environment variables. For systems with Broadcom NICs, the
scripts assume the host's RoCE library is located in the ``/opt`` directory.

The following benchmarking examples demonstrate the training of a Llama 3 8B model
across multiple 8-GPU nodes, using FSDP for intra-node parallelism and DP for
inter-node parallelism.

.. _rocm-for-ai-multi-node-setup-jax-train-example:

JAX MaxText
-----------

1. Download the desired multi-node benchmarking script from `<https://github.com/ROCm/MAD/tree/develop/scripts/jax-maxtext/gpu-rocm>`__.

   .. code-block:: shell

      wget https://raw.githubusercontent.com/ROCm/MAD/refs/heads/develop/scripts/jax-maxtext/gpu-rocm/llama3_8b_multinode.sh

   Or clone the `<https://github.com/ROCm/MAD>`__ repository.

   .. code-block:: shell

      git clone https://github.com/ROCm/MAD
      cd scripts/jax-maxtext/gpu-rocm

2. Run the benchmark for multi-node training.

   .. code-block:: shell

      sbatch -N <num_nodes> llama3_8b_multinode.sh

.. _rocm-for-ai-multi-node-setup-pyt-train-example:

PyTorch training
----------------

.. note::

   The ROCm PyTorch Training Docker image now focuses on :doc:`Training a model
   with Primus and PyTorch <../training/benchmark-docker/primus-pytorch>`. The
   following example refers to the legacy workflow :ref:`Training a
   model with PyTorch <amd-pytorch-training-multinode-examples-v259>`.

1. Download the ``run_multinode_train.sh`` benchmarking script from `<https://github.com/ROCm/MAD/tree/develop/scripts/pytorch_train>`__.

   .. code-block:: shell

      wget https://raw.githubusercontent.com/ROCm/MAD/refs/heads/develop/scripts/pytorch_train/run_multinode_train.sh

   Or clone the `<https://github.com/ROCm/MAD>`__ repository.

   .. code-block:: shell

      git clone https://github.com/ROCm/MAD
      cd scripts/pytorch_train

2. Run the benchmark for multi-node training.

   .. code-block:: shell

      sbatch -N <num_nodes> run_multinode_train.sh

.. seealso::

   See :ref:`Training a model with PyTorch <amd-pytorch-training-multinode-examples-v259>` for more examples and information.

Megatron-LM
-----------

.. note::

   The Megatron-LM Docker image now focuses on :ref:`Training a model with
   Primus and Megatron <amd-primus-megatron-multi-node-examples>`. The
   following example refers to the legacy Megatron-LM :ref:`Training a model
   with Megatron-LM <amd-megatron-lm-multi-node-examples>` and might have
   limited support.

1. Download the ``train_llama_slurm.sh`` benchmarking script from
   `<https://github.com/ROCm/Megatron-LM/blob/rocm_dev/examples/llama/train_llama_slurm.sh>`__.

2. Set the network interface parameters as per the above guidelines and run the script.

   .. code-block:: shell

      cd </path/to/your/Megatron-LM>
      export NETWORK_INTERFACE=$NCCL_SOCKET_IFNAME
      export NCCL_IB_HCA=$NCCL_IB_HCA
      export IMAGE=docker.io/rocm/megatron-lm:latest OR your preferred image
      export DATA_CACHE_PATH=/nfs/mounted/repo

      sbatch –N <num_nodes> examples/llama/train_llama_slurm.sh <MODEL_SIZE> <MBS> <GBS> <SEQ_LENGTH> <FSDP> <RECOMPUTE>

2. For example, to run a Llama 3 8B workload in BF16 precision, use the following command.

   .. code-block:: shell

      MODEL_NAME=llama3 sbatch –N 8 examples/llama/train_llama_slurm.sh 8 2 128 8192 0 0
      # Other parameters, such as TP, FP8 datatype, can be adjusted in the script.

Further reading
===============

* `Multi-node network configuration for AMD Instinct GPUs <https://instinct.docs.amd.com/projects/gpu-cluster-networking/en/latest/how-to/multi-node-config.html>`__

* `Ethernet networking guide for AMD Instinct MI300X GPU clusters: Compiling Broadcom NIC software from source <https://docs.broadcom.com/doc/957608-AN2XX#page=81>`__
