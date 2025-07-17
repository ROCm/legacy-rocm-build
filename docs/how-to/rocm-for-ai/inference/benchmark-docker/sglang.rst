.. meta::
   :description: Learn how to validate LLM inference performance on MI300X accelerators using AMD MAD and the
                 ROCm vLLM Docker image.
   :keywords: model, MAD, automation, dashboarding, validate

************************************
SGLang inference performance testing
************************************

.. _sglang-benchmark-unified-docker:

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/sglang-benchmark-models.yaml

   {% set unified_docker = data.sglang_benchmark.unified_docker.latest %}
   {% set model_groups = data.sglang_benchmark.model_groups %}

   `SGLang <https://docs.sglang.ai>`_ is a high-performance inference and
   serving engine for large language models (LLMs) and vision models. The
   ROCm-enabled `SGLang Docker <{{ unified_docker.docker_hub_url }}>`_ image
   bundles SGLang with PyTorch, optimized for AMD Instinct MI300X series
   accelerators. It includes the following software components:

   .. list-table::
      :header-rows: 1

      * - Software component
        - Version

      * - `ROCm <https://github.com/ROCm/ROCm>`_
        - {{ unified_docker.rocm_version }}

      * - `SGLang <https://docs.sglang.ai/index.html>`_
        - {{ unified_docker.sglang_version }} 

      * - `PyTorch <https://github.com/pytorch/pytorch>`_
        - {{ unified_docker.pytorch_version }} 

   System validation
   =================

   Before running AI workloads, it's important to validate that your AMD hardware is configured
   correctly and performing optimally.

   To optimize performance, disable automatic NUMA balancing. Otherwise, the GPU
   might hang until the periodic balancing is finalized. For more information,
   see the :ref:`system validation steps <rocm-for-ai-system-optimization>`.

   .. code-block:: shell

      # disable automatic NUMA balancing
      sh -c 'echo 0 > /proc/sys/kernel/numa_balancing'
      # check if NUMA balancing is disabled (returns 0 if disabled)
      cat /proc/sys/kernel/numa_balancing
      0

   To test for optimal performance, consult the recommended :ref:`System health benchmarks
   <rocm-for-ai-system-health-bench>`. This suite of tests will help you verify and fine-tune your
   system's configuration.

   Pull the Docker image
   =====================

   Download the `SGLang Docker image <{{ unified_docker.docker_hub_url }}>`_.
   Use the following command to pull the Docker image from Docker Hub.

   .. code-block:: shell

      docker pull {{ unified_docker.pull_tag }}

   Benchmarking
   ============

   Once the setup is complete, choose one of the following methods to benchmark inference performance with
   `DeepSeek-R1-Distill-Qwen-32B <https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-32B>`_.

   .. _sglang-benchmark-mad:

   {% for model_group in model_groups %}
      {% for model in model_group.models %}

   .. container:: model-doc {{model.mad_tag}}

      .. tab-set::

         .. tab-item:: MAD-integrated benchmarking

            Clone the ROCm Model Automation and Dashboarding (`<https://github.com/ROCm/MAD>`__) repository to a local
            directory and install the required packages on the host machine.

            .. code-block:: shell

               git clone https://github.com/ROCm/MAD
               cd MAD
               pip install -r requirements.txt

            Use this command to run the performance benchmark test on the `{{model.model}} <{{ model.url }}>`_ model
            using one GPU with the ``{{model.precision}}`` data type on the host machine.

            .. code-block:: shell

               export MAD_SECRETS_HFTOKEN="your personal Hugging Face token to access gated models"
               python3 tools/run_models.py --tags {{model.mad_tag}} --keep-model-dir --live-output --timeout 28800

            MAD launches a Docker container with the name
            ``container_ci-{{model.mad_tag}}``. The latency and throughput reports of the
            model are collected in the following path: ``~/MAD/perf_DeepSeek-R1-Distill-Qwen-32B.csv``.

            Although the DeepSeek-R1-Distill-Qwen-32B is preconfigured
            to collect latency and throughput performance data, you can also change the benchmarking
            parameters. See the standalone benchmarking tab for more information.

         .. tab-item:: Standalone benchmarking

            .. rubric:: Download the Docker image and required scripts

            Run the SGLang benchmark script independently by starting the
            `Docker container <{{ unified_docker.docker_hub_url }}>`_
            as shown in the following snippet.

            .. code-block:: shell

               docker pull {{ unified_docker.pull_tag }}
               docker run -it --device=/dev/kfd --device=/dev/dri --group-add video --shm-size 16G --security-opt seccomp=unconfined --security-opt apparmor=unconfined --cap-add=SYS_PTRACE -v $(pwd):/workspace --env HUGGINGFACE_HUB_CACHE=/workspace --name test {{ unified_docker.pull_tag }}

            In the Docker container, clone the ROCm MAD repository and navigate to the
            benchmark scripts directory at ``~/MAD/scripts/sglang``.

            .. code-block:: shell

               git clone https://github.com/ROCm/MAD
               cd MAD/scripts/sglang

            To start the benchmark, use the following command with the appropriate options.

            .. code-block:: shell

               ./sglang_benchmark_report.sh -s $test_option -m {{model.model_repo}} -g $num_gpu -d $datatype [-a $dataset]

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
                 - 8
                 - Number of GPUs

               * - ``$datatype``
                 - ``bfloat16``
                 - Data type

               * - ``$dataset``
                 - random
                 - Dataset

            .. note::

               The input sequence length, output sequence length, and tensor parallel (TP) are
               already configured. You don't need to specify them with this script.

            .. note::

               If you encounter the following error, pass your access-authorized Hugging
               Face token to the gated models.

               .. code-block:: shell-session

                  OSError: You are trying to access a gated repo.
                  # pass your HF_TOKEN
                  export HF_TOKEN=$your_personal_hf_token

            .. rubric:: Benchmarking examples

            Here are some examples of running the benchmark with various options.

            * Latency benchmark

              Use this command to benchmark the latency of the {{model.model}} model on eight GPUs with ``{{model.precision}}`` precision.

              .. code-block:: shell

                 ./sglang_benchmark_report.sh -s latency -m {{model.model_repo}} -g 8 -d {{model.precision}}

              Find the latency report at ``./reports_{{model.precision}}/summary/{{model.model_repo.split('/', 1)[1] if '/' in model.model_repo else model.model_repo}}_latency_report.csv``.

            * Throughput benchmark

              Use this command to benchmark the throughput of the {{model.model}} model on eight GPUs with ``{{model.precision}}`` precision.

              .. code-block:: shell

                 ./sglang_benchmark_report.sh -s throughput -m {{model.model_repo}} -g 8 -d {{model.precision}} -a random

              Find the throughput report at ``./reports_{{model.precision}}/summary/{{model.model_repo.split('/', 1)[1] if '/' in model.model_repo else model.model_repo}}_throughput_report.csv``.

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

Further reading
===============

- To learn more about the options for latency and throughput benchmark scripts,
  see `<https://github.com/sgl-project/sglang/tree/main/benchmark/blog_v0_2>`__.

- To learn more about system settings and management practices to configure your system for
  MI300X accelerators, see `AMD Instinct MI300X system optimization <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/system-optimization/mi300x.html>`_

- To learn how to run LLM models from Hugging Face or your own model, see
  :doc:`Running models from Hugging Face <../hugging-face-models>`.

- To learn how to optimize inference on LLMs, see
  :doc:`Inference optimization <../../inference-optimization/index>`.

- To learn how to fine-tune LLMs, see
  :doc:`Fine-tuning LLMs <../../fine-tuning/index>`.
