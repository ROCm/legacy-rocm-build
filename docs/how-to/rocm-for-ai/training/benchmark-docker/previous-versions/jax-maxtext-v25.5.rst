:orphan:

.. meta::
   :description: How to train a model using JAX MaxText for ROCm.
   :keywords: ROCm, AI, LLM, train, jax, torch, Llama, flux, tutorial, docker

**************************************
Training a model with MaxText for ROCm
**************************************

.. caution::

   This documentation does not reflect the latest version of ROCm JAX MaxText
   training performance documentation. See :doc:`../jax-maxtext` for the latest version.

MaxText is a high-performance, open-source framework built on the Google JAX
machine learning library to train LLMs at scale. The MaxText framework for
ROCm is an optimized fork of the upstream
`<https://github.com/AI-Hypercomputer/maxtext>`__ enabling efficient AI workloads
on AMD MI300X Series GPUs.

The MaxText for ROCm training Docker (``rocm/jax-training:maxtext-v25.5``) image
provides a prebuilt environment for training on AMD Instinct MI300X and MI325X GPUs,
including essential components like JAX, XLA, ROCm libraries, and MaxText utilities.
It includes the following software components:

+--------------------------+--------------------------------+
| Software component       | Version                        |
+==========================+================================+
| ROCm                     | 6.3.4                          |
+--------------------------+--------------------------------+
| JAX                      | 0.4.35                         |
+--------------------------+--------------------------------+
| Python                   | 3.10.12                        |
+--------------------------+--------------------------------+
| Transformer Engine       | 1.12.0.dev0+b8b92dc            |
+--------------------------+--------------------------------+
| hipBLASLt                | 0.13.0-ae9c477a                |
+--------------------------+--------------------------------+

Supported features and models
=============================

MaxText provides the following key features to train large language models efficiently:

- Transformer Engine (TE)

- Flash Attention (FA) 3

- GEMM tuning

- Multi-node support

.. _amd-maxtext-model-support-v255:

The following models are pre-optimized for performance on AMD Instinct MI300X Series GPUs.

* Llama 3.3 70B

* Llama 3.1 8B

* Llama 3.1 70B

* Llama 3 8B

* Llama 3 70B

* Llama 2 7B

* Llama 2 70B

* DeepSeek-V2-Lite

.. note::

   Some models, such as Llama 3, require an external license agreement through
   a third party (for example, Meta).

Unsupported features
--------------------

Currently, MaxText's default packed input format is not supported. Using this format
with the current Docker image results in incorrect attention calculations
across different input sequences. Support for packed input format is planned for a future release.

System validation
=================

Before running AI workloads, it's important to validate that your AMD hardware is configured
correctly and performing optimally.

If you have already validated your system settings, including aspects like NUMA auto-balancing, you
can skip this step. Otherwise, complete the procedures in the :ref:`System validation and
optimization <rocm-for-ai-system-optimization>` guide to properly configure your system settings
before starting training.

To test for optimal performance, consult the recommended :ref:`System health benchmarks
<rocm-for-ai-system-health-bench>`. This suite of tests will help you verify and fine-tune your
system's configuration.

Environment setup
=================

This Docker image is optimized for specific model configurations outlined
as follows. Performance can vary for other training workloads, as AMD
doesn’t validate configurations and run conditions outside those described.

.. _amd-maxtext-multi-node-setup-v255:

Multi-node setup
----------------

For multi-node environments, ensure you have all the necessary packages for
your network device, such as, RDMA. If you're not using a multi-node setup
with RDMA, skip ahead to :ref:`amd-maxtext-download-docker-v255`.

1. Install the following packages to build and install the RDMA driver.

   .. code-block:: shell

      sudo apt install iproute2 -y
      sudo apt install -y linux-headers-"$(uname-r)" libelf-dev
      sudo apt install -y gcc make libtool autoconf librdmacm-dev rdmacm-utils infiniband-diags ibverbs-utils perftest ethtool libibverbs-dev rdma-core strace libibmad5 libibnetdisc5 ibverbs-providers libibumad-dev libibumad3 libibverbs1 libnl-3-dev libnl-route-3-dev

   Refer to your NIC manufacturer's documentation for further steps on
   compiling and installing the RoCE driver. For example, for Broadcom,
   see `Compiling Broadcom NIC software from source <https://docs.broadcom.com/doc/957608-AN2XX#G3.484341>`_
   in `Ethernet networking guide for AMD Instinct MI300X GPU clusters <https://docs.broadcom.com/doc/957608-AN2XX>`_.

2. Set the following environment variables.

   a. Master address

      Change ``localhost`` to the master node's resolvable hostname or IP address:

      .. code-block:: bash

         export MASTER_ADDR="${MASTER_ADDR:-localhost}"

   b. Number of nodes

      Set the number of nodes you want to train on (for example, ``2``, ``4``, or ``8``):

      .. code-block:: bash

         export NNODES="${NNODES:-1}"

   c. Node ranks

      Set the rank of each node (``0`` for master, ``1`` for the first worker node, and so on)
      Node ranks should be unique across all nodes in the cluster.

      .. code-block:: bash

         export NODE_RANK="${NODE_RANK:-0}"

   d. Network interface

      Update the network interface in the script to match your system's network interface. To
      find your network interface, run the following (outside of any Docker container):

      .. code-block:: bash

         ip a

      Look for an active interface with an IP address in the same subnet as
      your other nodes. Then, update the following variable in the script, for
      example:

      .. code-block:: bash

         export NCCL_SOCKET_IFNAME=ens50f0np0

      This variable specifies which network interface to use for inter-node communication.
      Setting this variable to the incorrect interface can result in communication failures
      or significantly reduced performance.

   e. RDMA interface

      Ensure the :ref:`required packages <amd-maxtext-multi-node-setup-v255>` are installed on all nodes.
      Then, set the RDMA interfaces to use for communication.

      .. code-block:: bash

         # If using Broadcom NIC
         export NCCL_IB_HCA=rdma0,rdma1,rdma2,rdma3,rdma4,rdma5,rdma6,rdma7
         # If using Mellanox NIC
         export NCCL_IB_HCA=mlx5_0,mlx5_1,mlx5_2,mlx5_3,mlx5_4,mlx5_5,mlx5_8,mlx5_9

.. _amd-maxtext-download-docker-v255:

Pull the Docker image
---------------------

1. Use the following command to pull the Docker image from Docker Hub.

   .. code-block:: shell

      docker pull rocm/jax-training:maxtext-v25.5

2. Use the following command to launch the Docker container. Note that the benchmarking scripts
   used in the :ref:`following section <amd-maxtext-get-started-v255>` automatically launch the Docker container
   and execute the benchmark.

   .. code-block:: shell

      docker run -it --device /dev/dri --device /dev/kfd --network host --ipc host --group-add video --cap-add SYS_PTRACE --security-opt seccomp=unconfined --privileged -v $HOME/.ssh:/root/.ssh --shm-size 128G --name maxtext_training rocm/jax-training:maxtext-v25.5

.. _amd-maxtext-get-started-v255:

Getting started
===============

The following examples demonstrate how to get started with single node
and multi-node training using the benchmarking scripts provided at
`<https://github.com/ROCm/maxtext/>`__.

.. important::

   The provided scripts launch a Docker container and execute a benchmark. Ensure you run these commands outside of any existing Docker container.

Before running any benchmarks, ensure the ``$HF_HOME`` environment variable is
set correctly and points to your Hugging Face cache directory.

Single node training benchmarking examples
------------------------------------------

* Example 1: Single node training with Llama 2 7B

  Download the benchmarking script:

  .. code-block:: shell

     wget https://raw.githubusercontent.com/ROCm/maxtext/refs/heads/main/benchmarks/gpu-rocm/llama2_7b.sh

  Run the single node training benchmark:

  .. code-block:: shell

     IMAGE="rocm/jax-training:maxtext-v25.5" bash ./llama2_7b.sh

* Example 2: Single node training with Llama 2 70B

  Download the benchmarking script:

  .. code-block:: shell

     wget https://raw.githubusercontent.com/ROCm/maxtext/refs/heads/main/benchmarks/gpu-rocm/llama2_70b.sh

  Run the single node training benchmark:

  .. code-block:: shell

     IMAGE="rocm/jax-training:maxtext-v25.5" bash ./llama2_70b.sh

* Example 3: Single node training with Llama 3 8B

  Download the benchmarking script:

  .. code-block:: shell

     wget https://raw.githubusercontent.com/ROCm/maxtext/refs/heads/main/benchmarks/gpu-rocm/llama3_8b.sh

  Run the single node training benchmark:

  .. code-block:: shell

     IMAGE="rocm/jax-training:maxtext-v25.5" bash ./llama3_8b.sh

* Example 4: Single node training with Llama 3 70B

  Download the benchmarking script:

  .. code-block:: shell

     wget https://raw.githubusercontent.com/ROCm/maxtext/refs/heads/main/benchmarks/gpu-rocm/llama3_70b.sh

  Run the single node training benchmark:

  .. code-block:: shell

     IMAGE="rocm/jax-training:maxtext-v25.5" bash ./llama3_70b.sh

* Example 5: Single node training with Llama 3.3 70B

  Download the benchmarking script:

  .. code-block:: shell

     wget https://raw.githubusercontent.com/ROCm/maxtext/refs/heads/main/benchmarks/gpu-rocm/llama3.3_70b.sh

  Run the single node training benchmark:

  .. code-block:: shell

     IMAGE="rocm/jax-training:maxtext-v25.5" bash ./llama3.3_70b.sh

* Example 6: Single node training with DeepSeek V2 16B

  Download the benchmarking script:

  .. code-block:: shell

     wget https://raw.githubusercontent.com/ROCm/maxtext/refs/heads/main/benchmarks/gpu-rocm/deepseek_v2_16b.sh

  Run the single node training benchmark:

  .. code-block:: shell

     IMAGE="rocm/jax-training:maxtext-v25.5" bash ./deepseek_v2_16b.sh

  .. note::

     The reported TFLOP/s by MaxText for DeepSeek is not accurate. Use
     the tokens/s as a performance indicator.

Multi-node training benchmarking examples
-----------------------------------------

The following examples use SLURM for running on multiple nodes -- the commands might need to be adjusted for your
own cluster setup.

* Example 1: Multi-node training with Llama 2 7B

  Download the benchmarking script:

  .. code-block:: shell

     wget https://raw.githubusercontent.com/ROCm/maxtext/refs/heads/main/benchmarks/gpu-rocm/llama2_7b_multinode.sh

  Run the multi-node training benchmark. For example:

  .. code-block:: shell

     sbatch -N <num_nodes> llama2_7b_multinode.sh

* Example 2: Multi-node training with Llama 2 70B

  Download the benchmarking script:

  .. code-block:: shell

     wget https://raw.githubusercontent.com/ROCm/maxtext/refs/heads/main/benchmarks/gpu-rocm/llama2_70b_multinode.sh

  Run the multi-node training benchmark. For example:

  .. code-block:: shell

     sbatch -N <num_nodes> llama2_70b_multinode.sh

* Example 3: Multi-node training with Llama 3 8B model

  Download the benchmarking script:

  .. code-block:: shell

     wget https://raw.githubusercontent.com/ROCm/maxtext/refs/heads/main/benchmarks/gpu-rocm/llama3_8b_multinode.sh

  Run the multi-node training benchmark. For example:

  .. code-block:: shell

     sbatch -N <num_nodes> llama3_8b_multinode.sh

* Example 4: Multi-node training with Llama 3 70B model

  Download the benchmarking script:

  .. code-block:: shell

     wget https://raw.githubusercontent.com/ROCm/maxtext/refs/heads/main/benchmarks/gpu-rocm/llama3_70b_multinode.sh

  Run the multi-node training benchmark. For example:

  .. code-block:: shell

     sbatch -N <num_nodes> llama3_70b_multinode.sh

Previous versions
=================

See :doc:`jax-maxtext-history` to find documentation for previous releases
of the ``ROCm/jax-training`` Docker image.
