:orphan:

.. meta::
   :description: Learn how to validate LLM inference performance on MI300X accelerators using AMD MAD and the unified
                 ROCm Docker image.
   :keywords: model, MAD, automation, dashboarding, validate

**********************************
vLLM inference performance testing
**********************************

.. caution::

   This documentation does not reflect the latest version of ROCm vLLM
   inference performance documentation. See :doc:`../vllm` for the latest version.

.. _vllm-benchmark-unified-docker:

The `ROCm vLLM Docker <https://hub.docker.com/r/rocm/vllm/tags>`_ image offers
a prebuilt, optimized environment designed for validating large language model
(LLM) inference performance on the AMD Instinct™ MI300X accelerator. This
ROCm vLLM Docker image integrates vLLM and PyTorch tailored specifically for the
MI300X accelerator and includes the following components:

* `ROCm 6.2.0 <https://github.com/ROCm/ROCm>`_

* `vLLM 0.4.3 <https://docs.vllm.ai/en/latest>`_

* `PyTorch 2.4.0 <https://github.com/pytorch/pytorch>`_

* Tuning files (in CSV format)

With this Docker image, you can quickly validate the expected inference
performance numbers on the MI300X accelerator. This topic also provides tips on
optimizing performance with popular AI models.

.. _vllm-benchmark-vllm:

.. note::

   vLLM is a toolkit and library for LLM inference and
   serving. It deploys the PagedAttention algorithm, which reduces memory
   consumption and increases throughput by leveraging dynamic key and value
   allocation in GPU memory. vLLM also incorporates many LLM acceleration
   and quantization algorithms. In addition, AMD implements high-performance
   custom kernels and modules in vLLM to enhance performance further. See
   :ref:`fine-tuning-llms-vllm` and :ref:`mi300x-vllm-optimization` for more
   information.

Getting started
===============

Use the following procedures to reproduce the benchmark results on an
MI300X accelerator with the prebuilt vLLM Docker image.

.. _vllm-benchmark-get-started:

1. Disable NUMA auto-balancing.

   To optimize performance, disable automatic NUMA balancing. Otherwise, the GPU
   might hang until the periodic balancing is finalized. For more information,
   see the :ref:`system validation steps <rocm-for-ai-system-optimization>`.

   .. code-block:: shell

      # disable automatic NUMA balancing
      sh -c 'echo 0 > /proc/sys/kernel/numa_balancing'
      # check if NUMA balancing is disabled (returns 0 if disabled)
      cat /proc/sys/kernel/numa_balancing
      0

2. Download the :ref:`ROCm vLLM Docker image <vllm-benchmark-unified-docker>`.

   Use the following command to pull the Docker image from Docker Hub.

   .. code-block:: shell

      docker pull rocm/vllm:rocm6.2_mi300_ubuntu22.04_py3.9_vllm_7c5fd50

Once setup is complete, you can choose between two options to reproduce the
benchmark results:

-  :ref:`MAD-integrated benchmarking <vllm-benchmark-mad-v043>`

-  :ref:`Standalone benchmarking <vllm-benchmark-standalone-v043>`

.. _vllm-benchmark-mad-v043:

MAD-integrated benchmarking
===========================

Clone the ROCm Model Automation and Dashboarding (`<https://github.com/ROCm/MAD>`__) repository to a local
directory and install the required packages on the host machine.

.. code-block:: shell

   git clone https://github.com/ROCm/MAD
   cd MAD
   pip install -r requirements.txt

Use this command to run a performance benchmark test of the Llama 3.1 8B model
on one GPU with ``float16`` data type in the host machine.

.. code-block:: shell

   export MAD_SECRETS_HFTOKEN="your personal Hugging Face token to access gated models"
   python3 tools/run_models.py --tags pyt_vllm_llama-3.1-8b --keep-model-dir --live-output --timeout 28800

ROCm MAD launches a Docker container with the name
``container_ci-pyt_vllm_llama-3.1-8b``. The latency and throughput reports of the
model are collected in the following path: ``~/MAD/reports_float16/``

Although the following eight models are pre-configured to collect latency and
throughput performance data, users can also change the benchmarking parameters.
Refer to the :ref:`Standalone benchmarking <vllm-benchmark-standalone-v043>` section.

Available models
----------------

.. hlist::
   :columns: 3

   * ``pyt_vllm_llama-3.1-8b``

   * ``pyt_vllm_llama-3.1-70b``

   * ``pyt_vllm_llama-3.1-405b``

   * ``pyt_vllm_llama-2-7b``

   * ``pyt_vllm_mistral-7b``

   * ``pyt_vllm_qwen2-7b``

   * ``pyt_vllm_jais-13b``

   * ``pyt_vllm_jais-30b``

.. _vllm-benchmark-standalone-v043:

Standalone benchmarking
=======================

You can run the vLLM benchmark tool independently by starting the
:ref:`Docker container <vllm-benchmark-get-started>` as shown in the following
snippet.

.. code-block::

   docker pull rocm/vllm:rocm6.2_mi300_ubuntu22.04_py3.9_vllm_7c5fd50
   docker run -it --device=/dev/kfd --device=/dev/dri --group-add video --shm-size 128G --security-opt seccomp=unconfined --security-opt apparmor=unconfined --cap-add=SYS_PTRACE -v $(pwd):/workspace --env HUGGINGFACE_HUB_CACHE=/workspace --name unified_docker_vllm rocm/vllm:rocm6.2_mi300_ubuntu22.04_py3.9_vllm_7c5fd50

In the Docker container, clone the ROCm MAD repository and navigate to the
benchmark scripts directory at ``~/MAD/scripts/vllm``.

.. code-block::

   git clone https://github.com/ROCm/MAD
   cd MAD/scripts/vllm

Multiprocessing distributed executor
--------------------------------------

To optimize vLLM performance, add the multiprocessing API server argument ``--distributed-executor-backend mp``.

Command
^^^^^^^^^^^^^^^^^^^^^^^^^

To start the benchmark, use the following command with the appropriate options.
See :ref:`Options <vllm-benchmark-standalone-options-v043>` for the list of
options and their descriptions.

.. code-block:: shell

   ./vllm_benchmark_report.sh -s $test_option -m $model_repo -g $num_gpu -d $datatype

See the :ref:`examples <vllm-benchmark-run-benchmark-v043>` for more information.

.. note::

   The input sequence length, output sequence length, and tensor parallel (TP) are
   already configured. You don't need to specify them with this script.

.. note::

   If you encounter the following error, pass your access-authorized Hugging
   Face token to the gated models.

   .. code-block:: shell

      OSError: You are trying to access a gated repo.

      # pass your HF_TOKEN
      export HF_TOKEN=$your_personal_hf_token

.. _vllm-benchmark-standalone-options-v043:

Options
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1

   * - Name
     - Options
     - Description

   * - ``$test_option``
     - latency
     - Measure decoding token latency

   * -
     - throughput
     - Measure token generation throughput

   * -
     - all
     - Measure both throughput and latency

   * - ``$model_repo``
     - ``meta-llama/Meta-Llama-3.1-8B-Instruct``
     - Llama 3.1 8B

   * - (``float16``)
     - ``meta-llama/Meta-Llama-3.1-70B-Instruct``
     - Llama 3.1 70B

   * -
     - ``meta-llama/Meta-Llama-3.1-405B-Instruct``
     - Llama 3.1 405B

   * -
     - ``meta-llama/Llama-2-7b-chat-hf``
     - Llama 2 7B

   * -
     - ``mistralai/Mixtral-8x7B-Instruct-v0.1``
     - Mixtral 8x7B

   * -
     - ``mistralai/Mixtral-8x22B-Instruct-v0.1``
     - Mixtral 8x22B

   * -
     - ``mistralai/Mistral-7B-Instruct-v0.3``
     - Mixtral 7B

   * -
     - ``Qwen/Qwen2-7B-Instruct``
     - Qwen2 7B

   * -
     - ``core42/jais-13b-chat``
     - JAIS 13B

   * -
     - ``core42/jais-30b-chat-v3``
     - JAIS 30B

   * - ``$num_gpu``
     - 1 or 8
     - Number of GPUs

   * - ``$datatype``
     - ``float16``
     - Data type

.. _vllm-benchmark-run-benchmark-v043:

Running the benchmark on the MI300X accelerator
-----------------------------------------------

Here are some examples of running the benchmark with various options.
See :ref:`Options <vllm-benchmark-standalone-options-v043>` for the list of
options and their descriptions.

Latency benchmark example
^^^^^^^^^^^^^^^^^^^^^^^^^
 
Use this command to benchmark the latency of the Llama 3.1 8B model on one GPU with the ``float16`` data type.

.. code-block::

   ./vllm_benchmark_report.sh -s latency -m meta-llama/Meta-Llama-3.1-8B-Instruct -g 1 -d float16

Find the latency report at:

- ``./reports_float16/summary/Meta-Llama-3.1-8B-Instruct_latency_report.csv``

Throughput benchmark example
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use this command to benchmark the throughput of the Llama 3.1 8B model on one GPU with the ``float16`` and ``float8`` data types.

.. code-block:: shell

   ./vllm_benchmark_report.sh -s throughput -m meta-llama/Meta-Llama-3.1-8B-Instruct -g 1 -d float16

Find the throughput reports at:

- ``./reports_float16/summary/Meta-Llama-3.1-8B-Instruct_throughput_report.csv``

.. raw:: html

   <style>
   mjx-container[jax="CHTML"][display="true"] {
       text-align: left;
       margin: 0;
   }

   </style>

.. note::

   Throughput is calculated as:

   - .. math:: throughput\_tot = requests \times (\mathsf{\text{input lengths}} + \mathsf{\text{output lengths}}) / elapsed\_time

   - .. math:: throughput\_gen = requests \times \mathsf{\text{output lengths}} / elapsed\_time

Further reading
===============

- For application performance optimization strategies for HPC and AI workloads,
  including inference with vLLM, see :doc:`/how-to/rocm-for-ai/inference-optimization/workload`.

- To learn more about the options for latency and throughput benchmark scripts,
  see `<https://github.com/ROCm/vllm/tree/main/benchmarks>`_.

- To learn more about system settings and management practices to configure your system for
  MI300X series accelerators, see `AMD Instinct MI300X system optimization <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/system-optimization/mi300x.html>`_

- To learn how to run community models from Hugging Face on AMD GPUs, see
  :doc:`Running models from Hugging Face </how-to/rocm-for-ai/inference/hugging-face-models>`.

- To learn how to fine-tune LLMs and optimize inference, see
  :doc:`Fine-tuning LLMs and inference optimization </how-to/rocm-for-ai/fine-tuning/fine-tuning-and-inference>`.

- For a list of other ready-made Docker images for AI with ROCm, see
  `AMD Infinity Hub <https://www.amd.com/en/developer/resources/infinity-hub.html#f-amd_hub_category=AI%20%26%20ML%20Models>`_.

Previous versions
=================

See :doc:`vllm-history` to find documentation for previous releases
of the ``ROCm/vllm`` Docker image.
