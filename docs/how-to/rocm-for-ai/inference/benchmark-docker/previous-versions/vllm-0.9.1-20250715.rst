:orphan:

.. meta::
   :description: Learn how to validate LLM inference performance on MI300X accelerators using AMD MAD and the
                 ROCm vLLM Docker image.
   :keywords: model, MAD, automation, dashboarding, validate

**********************************
vLLM inference performance testing
**********************************

.. caution::

   This documentation does not reflect the latest version of ROCm vLLM
   inference performance documentation. See :doc:`../vllm` for the latest version.

.. _vllm-benchmark-unified-docker-715:

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/previous-versions/vllm_0.9.1_20250715-benchmark_models.yaml

   {% set unified_docker = data.vllm_benchmark.unified_docker.latest %}
   {% set model_groups = data.vllm_benchmark.model_groups %}

   The `ROCm vLLM Docker <{{ unified_docker.docker_hub_url }}>`_ image offers
   a prebuilt, optimized environment for validating large language model (LLM)
   inference performance on AMD Instinct™ MI300X series accelerators. This ROCm vLLM
   Docker image integrates vLLM and PyTorch tailored specifically for MI300X series
   accelerators and includes the following components:

   .. list-table::
      :header-rows: 1

      * - Software component
        - Version

      * - `ROCm <https://github.com/ROCm/ROCm>`__
        - {{ unified_docker.rocm_version }}

      * - `vLLM <https://docs.vllm.ai/en/latest>`__
        - {{ unified_docker.vllm_version }}

      * - `PyTorch <https://github.com/ROCm/pytorch>`__
        - {{ unified_docker.pytorch_version }}

      * - `hipBLASLt <https://github.com/ROCm/hipBLASLt>`__
        - {{ unified_docker.hipblaslt_version }}

With this Docker image, you can quickly test the :ref:`expected
inference performance numbers <vllm-benchmark-performance-measurements-715>` for
MI300X series accelerators.

What's new
==========

The following is summary of notable changes since the :doc:`previous ROCm/vLLM Docker release <vllm-history>`.

* The ``--compilation-config-parameter`` is no longer required as its options are now enabled by default.
  This parameter has been removed from the benchmarking script.

* Resolved Llama 3.1 405 B custom all-reduce issue, eliminating the need for ``--disable-custom-all-reduce``.
  This parameter has been removed from the benchmarking script.

* Fixed a ``+rms_norm`` custom kernel issue.

* Added quick reduce functionality. Set ``VLLM_ROCM_QUICK_REDUCE_QUANTIZATION=FP`` to enable; supported modes are ``FP``, ``INT8``, ``INT6``, ``INT4``.

* Implemented a workaround to potentially mitigate GPU crashes experienced with the Command R+ model, pending a driver fix.

Supported models
================

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/previous-versions/vllm_0.9.1_20250715-benchmark_models.yaml

   {% set unified_docker = data.vllm_benchmark.unified_docker.latest %}
   {% set model_groups = data.vllm_benchmark.model_groups %}

   .. _vllm-benchmark-available-models-715:

   The following models are supported for inference performance benchmarking
   with vLLM and ROCm. Some instructions, commands, and recommendations in this
   documentation might vary by model -- select one to get started.

   .. raw:: html

      <div id="vllm-benchmark-ud-params-picker" class="container-fluid">
      <div class="row">
         <div class="col-2 me-2 model-param-head">Model group</div>
         <div class="row col-10">
   {% for model_group in model_groups %}
            <div class="col-3 model-param" data-param-k="model-group" data-param-v="{{ model_group.tag }}" tabindex="0">{{ model_group.group }}</div>
   {% endfor %}
         </div>
      </div>

      <div class="row mt-1">
         <div class="col-2 me-2 model-param-head">Model</div>
         <div class="row col-10">
   {% for model_group in model_groups %}
      {% set models = model_group.models %}
      {% for model in models %}
         {% if models|length % 3 == 0 %}
            <div class="col-4 model-param" data-param-k="model" data-param-v="{{ model.mad_tag }}" data-param-group="{{ model_group.tag }}" tabindex="0">{{ model.model }}</div>
         {% else %}
            <div class="col-6 model-param" data-param-k="model" data-param-v="{{ model.mad_tag }}" data-param-group="{{ model_group.tag }}" tabindex="0">{{ model.model }}</div>
         {% endif %}
      {% endfor %}
   {% endfor %}
         </div>
      </div>
      </div>

   .. _vllm-benchmark-vllm-715:

   {% for model_group in model_groups %}
      {% for model in model_group.models %}

   .. container:: model-doc {{model.mad_tag}}

      .. note::

         See the `{{ model.model }} model card on Hugging Face <{{ model.url }}>`_ to learn more about your selected model.
         Some models require access authorization prior to use via an external license agreement through a third party.

      {% endfor %}
   {% endfor %}

.. note::

   vLLM is a toolkit and library for LLM inference and serving. AMD implements
   high-performance custom kernels and modules in vLLM to enhance performance.
   See :ref:`fine-tuning-llms-vllm` and :ref:`mi300x-vllm-optimization` for
   more information.

.. _vllm-benchmark-performance-measurements-715:

Performance measurements
========================

To evaluate performance, the
`Performance results with AMD ROCm software <https://www.amd.com/en/developer/resources/rocm-hub/dev-ai/performance-results.html>`_
page provides reference throughput and latency measurements for inferencing popular AI models.

.. important::

   The performance data presented in
   `Performance results with AMD ROCm software <https://www.amd.com/en/developer/resources/rocm-hub/dev-ai/performance-results.html>`_
   only reflects the latest version of this inference benchmarking environment.
   The listed measurements should not be interpreted as the peak performance achievable by AMD Instinct MI325X and MI300X accelerators or ROCm software.

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

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/previous-versions/vllm_0.9.1_20250715-benchmark_models.yaml

   {% set unified_docker = data.vllm_benchmark.unified_docker.latest %}
   {% set model_groups = data.vllm_benchmark.model_groups %}

   Pull the Docker image
   =====================

   Download the `ROCm vLLM Docker image <{{ unified_docker.docker_hub_url }}>`_.
   Use the following command to pull the Docker image from Docker Hub.

   .. code-block:: shell

      docker pull {{ unified_docker.pull_tag }}

   Benchmarking
   ============

   Once the setup is complete, choose between two options to reproduce the
   benchmark results:

   .. _vllm-benchmark-mad-715:

   {% for model_group in model_groups %}
      {% for model in model_group.models %}

   .. container:: model-doc {{model.mad_tag}}

      .. tab-set::

         .. tab-item:: MAD-integrated benchmarking

            1. Clone the ROCm Model Automation and Dashboarding (`<https://github.com/ROCm/MAD>`__) repository to a local
               directory and install the required packages on the host machine.

               .. code-block:: shell

                  git clone https://github.com/ROCm/MAD
                  cd MAD
                  pip install -r requirements.txt

            2. Use this command to run the performance benchmark test on the `{{model.model}} <{{ model.url }}>`_ model
               using one GPU with the :literal:`{{model.precision}}` data type on the host machine.

               .. code-block:: shell

                  export MAD_SECRETS_HFTOKEN="your personal Hugging Face token to access gated models"
                  madengine run \
                      --tags {{model.mad_tag}} \
                      --keep-model-dir \
                      --live-output \
                      --timeout 28800

            MAD launches a Docker container with the name
            ``container_ci-{{model.mad_tag}}``. The latency and throughput reports of the
            model are collected in the following path: ``~/MAD/reports_{{model.precision}}/``.

            Although the :ref:`available models <vllm-benchmark-available-models-715>` are preconfigured
            to collect latency and throughput performance data, you can also change the benchmarking
            parameters. See the standalone benchmarking tab for more information.

            {% if model.tunableop %}

            .. note::

               For improved performance, consider enabling :ref:`PyTorch TunableOp <mi300x-tunableop>`.
               TunableOp automatically explores different implementations and configurations of certain PyTorch
               operators to find the fastest one for your hardware.

               By default, ``{{model.mad_tag}}`` runs with TunableOp disabled
               (see
               `<https://github.com/ROCm/MAD/blob/develop/models.json>`__).
               To enable it, include the ``--tunableop on`` argument in your
               run.

               Enabling TunableOp triggers a two-pass run -- a warm-up followed
               by the performance-collection run.

            {% endif %}

         .. tab-item:: Standalone benchmarking

            .. rubric:: Download the Docker image and required scripts

            1. Run the vLLM benchmark tool independently by starting the
               `Docker container <{{ unified_docker.docker_hub_url }}>`_
               as shown in the following snippet.

               .. code-block:: shell

                  docker pull {{ unified_docker.pull_tag }}
                  docker run -it \
                      --device=/dev/kfd \
                      --device=/dev/dri \
                      --group-add video \
                      --shm-size 16G \
                      --security-opt seccomp=unconfined \
                      --security-opt apparmor=unconfined \
                      --cap-add=SYS_PTRACE \
                      -v $(pwd):/workspace \
                      --env HUGGINGFACE_HUB_CACHE=/workspace \
                      --name test \
                      {{ unified_docker.pull_tag }}

            2. In the Docker container, clone the ROCm MAD repository and navigate to the
               benchmark scripts directory at ``~/MAD/scripts/vllm``.

               .. code-block:: shell

                  git clone https://github.com/ROCm/MAD
                  cd MAD/scripts/vllm

            3. To start the benchmark, use the following command with the appropriate options.

               .. dropdown:: Benchmark options
                  :open:

                  .. list-table::
                     :header-rows: 1
                     :align: center

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

                     * - ``$num_gpu``
                       - 1 or 8
                       - Number of GPUs

                     * - ``$datatype``
                       - ``float16`` or ``float8``
                       - Data type

                  The input sequence length, output sequence length, and tensor parallel (TP) are
                  already configured. You don't need to specify them with this script.

               Command:

               .. code-block::

                  ./vllm_benchmark_report.sh \
                      -s $test_option \
                      -m {{model.model_repo}} \
                      -g $num_gpu \
                      -d {{model.precision}}

               .. note::

                  For best performance, it's recommend to run with ``VLLM_V1_USE_PREFILL_DECODE_ATTENTION=1``.

                  If you encounter the following error, pass your access-authorized Hugging
                  Face token to the gated models.

                  .. code-block::

                     OSError: You are trying to access a gated repo.

                     # pass your HF_TOKEN
                     export HF_TOKEN=$your_personal_hf_token

            .. rubric:: Benchmarking examples

            Here are some examples of running the benchmark with various options:

            * Latency benchmark

              Use this command to benchmark the latency of the {{model.model}} model on eight GPUs with :literal:`{{model.precision}}` precision.

              .. code-block::

                 ./vllm_benchmark_report.sh \
                     -s latency \
                     -m {{model.model_repo}} \
                     -g 8 \
                     -d {{model.precision}}

              Find the latency report at ``./reports_{{model.precision}}_vllm_rocm{{unified_docker.rocm_version}}/summary/{{model.model_repo.split('/', 1)[1] if '/' in model.model_repo else model.model_repo}}_latency_report.csv``.

            * Throughput benchmark

              Use this command to benchmark the throughput of the {{model.model}} model on eight GPUs with :literal:`{{model.precision}}` precision.

              .. code-block:: shell

                 ./vllm_benchmark_report.sh \
                     -s throughput \
                     -m {{model.model_repo}} \
                     -g 8 \
                     -d {{model.precision}}

              Find the throughput report at ``./reports_{{model.precision}}_vllm_rocm{{unified_docker.rocm_version}}/summary/{{model.model_repo.split('/', 1)[1] if '/' in model.model_repo else model.model_repo}}_throughput_report.csv``.

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
      {% endfor %}
   {% endfor %}

Advanced usage
==============

For information on experimental features and known issues related to ROCm optimization efforts on vLLM,
see the developer's guide at `<https://github.com/ROCm/vllm/tree/f94ec9beeca1071cc34f9d1e206d8c7f3ac76129/docs/dev-docker>`__.

Reproducing the Docker image
----------------------------

To reproduce this ROCm/vLLM Docker image release, follow these steps:

1. Clone the `vLLM repository <https://github.com/ROCm/vllm>`__.

   .. code-block:: shell

      git clone https://github.com/ROCm/vllm.git

2. Checkout the specific release commit.

   .. code-block:: shell

      cd vllm
      git checkout b432b7a285aa0dcb9677380936ffa74931bb6d6f

3. Build the Docker image. Replace ``vllm-rocm`` with your desired image tag.

   .. code-block:: shell

      docker build -f docker/Dockerfile.rocm -t vllm-rocm .

Known issues and workarounds
============================

AITER does not support FP8 KV cache yet.

Further reading
===============

- To learn more about the options for latency and throughput benchmark scripts,
  see `<https://github.com/ROCm/vllm/tree/main/benchmarks>`_.

- To learn more about MAD and the ``madengine`` CLI, see the `MAD usage guide <https://github.com/ROCm/MAD?tab=readme-ov-file#usage-guide>`__.

- To learn more about system settings and management practices to configure your system for
  AMD Instinct MI300X series accelerators, see `AMD Instinct MI300X system optimization <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/system-optimization/mi300x.html>`_.

- For application performance optimization strategies for HPC and AI workloads,
  including inference with vLLM, see :doc:`/how-to/rocm-for-ai/inference-optimization/workload`.

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
