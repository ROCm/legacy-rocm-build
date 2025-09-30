.. meta::
   :description: Learn how to validate LLM inference performance on MI300X accelerators using AMD MAD and the ROCm vLLM Docker image.
   :keywords: model, MAD, automation, dashboarding, validate

**********************************
vLLM inference performance testing
**********************************

.. _vllm-benchmark-unified-docker-909:

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/vllm-benchmark-models.yaml

   {% set docker = data.dockers[0] %}

   The `ROCm vLLM Docker <{{ docker.docker_hub_url }}>`_ image offers
   a prebuilt, optimized environment for validating large language model (LLM)
   inference performance on AMD Instinct™ MI300X series GPUs. This ROCm vLLM
   Docker image integrates vLLM and PyTorch tailored specifically for MI300X series
   GPUs and includes the following components:

   .. list-table::
      :header-rows: 1

      * - Software component
        - Version

      {% for component_name, component_version in docker.components.items() %}
      * - {{ component_name }}
        - {{ component_version }}
      {% endfor %}

With this Docker image, you can quickly test the :ref:`expected
inference performance numbers <vllm-benchmark-performance-measurements-909>` for
MI300X series GPUs.

What's new
==========

The following is summary of notable changes since the :doc:`previous ROCm/vLLM Docker release <previous-versions/vllm-history>`.

* Upgraded to vLLM v0.10.1.

* Set ``VLLM_V1_USE_PREFILL_DECODE_ATTENTION=1`` by default for better performance.

* Set ``VLLM_ROCM_USE_AITER_RMSNORM=0`` by default to avoid various issues with torch compile.

.. _vllm-benchmark-supported-models-909:

Supported models
================

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/vllm-benchmark-models.yaml

   {% set docker = data.dockers[0] %}
   {% set model_groups = data.model_groups %}

   .. _vllm-benchmark-available-models-909:

   The following models are supported for inference performance benchmarking
   with vLLM and ROCm. Some instructions, commands, and recommendations in this
   documentation might vary by model -- select one to get started.

   .. raw:: html

      <div id="vllm-benchmark-ud-params-picker" class="container-fluid">
         <div class="row gx-0">
            <div class="col-2 me-1 px-2 model-param-head">Model</div>
            <div class="row col-10 pe-0">
      {% for model_group in model_groups %}
               <div class="col-3 px-2 model-param" data-param-k="model-group" data-param-v="{{ model_group.tag }}" tabindex="0">{{ model_group.group }}</div>
      {% endfor %}
            </div>
         </div>

         <div class="row gx-0 pt-1">
            <div class="col-2 me-1 px-2 model-param-head">Variant</div>
            <div class="row col-10 pe-0">
      {% for model_group in model_groups %}
         {% set models = model_group.models %}
         {% for model in models %}
            {% if models|length % 3 == 0 %}
               <div class="col-4 px-2 model-param" data-param-k="model" data-param-v="{{ model.mad_tag }}" data-param-group="{{ model_group.tag }}" tabindex="0">{{ model.model }}</div>
            {% else %}
               <div class="col-6 px-2 model-param" data-param-k="model" data-param-v="{{ model.mad_tag }}" data-param-group="{{ model_group.tag }}" tabindex="0">{{ model.model }}</div>
            {% endif %}
         {% endfor %}
      {% endfor %}
            </div>
         </div>
      </div>

   .. _vllm-benchmark-vllm-909:

   {% for model_group in model_groups %}
      {% for model in model_group.models %}

   .. container:: model-doc {{ model.mad_tag }}

      .. note::

         See the `{{ model.model }} model card on Hugging Face <{{ model.url }}>`_ to learn more about your selected model.
         Some models require access authorization prior to use via an external license agreement through a third party.
      {% if model.precision == "float8" and model.model_repo.startswith("amd") %}
         This model uses FP8 quantization via `AMD Quark <https://quark.docs.amd.com/latest/>`__ for efficient inference on AMD GPUs.
      {% endif %}

      {% endfor %}
   {% endfor %}

.. _vllm-benchmark-performance-measurements-909:

Performance measurements
========================

To evaluate performance, the
`Performance results with AMD ROCm software <https://www.amd.com/en/developer/resources/rocm-hub/dev-ai/performance-results.html>`_
page provides reference throughput and serving measurements for inferencing popular AI models.

.. important::

   The performance data presented in
   `Performance results with AMD ROCm software <https://www.amd.com/en/developer/resources/rocm-hub/dev-ai/performance-results.html>`_
   only reflects the latest version of this inference benchmarking environment.
   The listed measurements should not be interpreted as the peak performance achievable by AMD Instinct MI325X and MI300X GPUs or ROCm software.

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

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/vllm-benchmark-models.yaml

   {% set docker = data.dockers[0] %}
   {% set model_groups = data.model_groups %}

   Pull the Docker image
   =====================

   Download the `ROCm vLLM Docker image <{{ docker.docker_hub_url }}>`_.
   Use the following command to pull the Docker image from Docker Hub.

   .. code-block:: shell

      docker pull {{ docker.pull_tag }}

   Benchmarking
   ============

   Once the setup is complete, choose between two options to reproduce the
   benchmark results:

   .. _vllm-benchmark-mad-909:

   {% for model_group in model_groups %}
      {% for model in model_group.models %}

   .. container:: model-doc {{model.mad_tag}}

      .. tab-set::

         .. tab-item:: MAD-integrated benchmarking

            The following run command is tailored to {{ model.model }}.
            See :ref:`vllm-benchmark-supported-models-909` to switch to another available model.

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
            ``container_ci-{{model.mad_tag}}``. The throughput and serving reports of the
            model are collected in the following paths: ``{{ model.mad_tag }}_throughput.csv``
            and ``{{ model.mad_tag }}_serving.csv``.

            Although the :ref:`available models
            <vllm-benchmark-available-models-909>` are preconfigured to collect
            offline throughput and online serving performance data, you can
            also change the benchmarking parameters. See the standalone
            benchmarking tab for more information.

            {% if model.tunableop %}

            .. note::

               For improved performance, consider enabling :ref:`PyTorch TunableOp <mi300x-tunableop>`.
               TunableOp automatically explores different implementations and configurations of certain PyTorch
               operators to find the fastest one for your hardware.

               By default, ``{{model.mad_tag}}`` runs with TunableOp disabled (see
               `<https://github.com/ROCm/MAD/blob/develop/models.json>`__). To enable it, include
               the ``--tunableop on`` argument in your run.

               Enabling TunableOp triggers a two-pass run -- a warm-up followed by the
               performance-collection run.

            {% endif %}

         .. tab-item:: Standalone benchmarking

            The following commands are optimized for {{ model.model }}.
            See :ref:`vllm-benchmark-supported-models-909` to switch to another available model.

            .. seealso::

               For more information on configuration, see the `config files
               <https://github.com/ROCm/MAD/tree/develop/scripts/vllm/configs>`__
               in the MAD repository. Refer to the `vLLM engine <https://docs.vllm.ai/en/latest/configuration/engine_args.html#engineargs>`__
               for descriptions of available configuration options
               and `Benchmarking vLLM <https://github.com/vllm-project/vllm/blob/main/benchmarks/README.md>`__ for
               additional benchmarking information.

            .. rubric:: Launch the container

            You can run the vLLM benchmark tool independently by starting the
            `Docker container <{{ docker.docker_hub_url }}>`_ as shown
            in the following snippet.

            .. code-block:: shell

               docker pull {{ docker.pull_tag }}
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
                   {{ docker.pull_tag }}

            .. rubric:: Throughput command

            Use the following command to start the throughput benchmark.

            .. code-block:: shell

               model={{ model.model_repo }}
               tp={{ model.config.tp }}
               num_prompts=1024
               in=128
               out=128
               dtype={{ model.config.dtype }}
               kv_cache_dtype={{ model.config.kv_cache_dtype }}
               max_num_seqs=1024
               max_seq_len_to_capture={{ model.config.max_seq_len_to_capture }}
               max_num_batched_tokens={{ model.config.max_num_batched_tokens }}
               max_model_len={{ model.config.max_model_len }}

               vllm bench throughput --model $model \
                   -tp $tp \
                   --num-prompts $num_prompts \
                   --input-len $in \
                   --output-len $out \
                   --dtype $dtype \
                   --kv-cache-dtype $kv_cache_dtype \
                   --max-num-seqs $max_num_seqs \
                   --max-seq-len-to-capture $max_seq_len_to_capture \
                   --max-num-batched-tokens $max_num_batched_tokens \
                   --max-model-len $max_model_len \
                   --trust-remote-code \
                   --output-json ${model}_throughput.json \
                   --gpu-memory-utilization 0.9

            .. rubric:: Serving command

            1. Start the server using the following command:

               .. code-block:: shell

                  model={{ model.model_repo }}
                  tp={{ model.config.tp }}
                  dtype={{ model.config.dtype }}
                  kv_cache_dtype={{ model.config.kv_cache_dtype }}
                  max_num_seqs=256
                  max_seq_len_to_capture={{ model.config.max_seq_len_to_capture }}
                  max_num_batched_tokens={{ model.config.max_num_batched_tokens }}
                  max_model_len={{ model.config.max_model_len }}

                  vllm serve $model \
                      -tp $tp \
                      --dtype $dtype \
                      --kv-cache-dtype $kv_cache_dtype \
                      --max-num-seqs $max_num_seqs \
                      --max-seq-len-to-capture $max_seq_len_to_capture \
                      --max-num-batched-tokens $max_num_batched_tokens \
                      --max-model-len $max_model_len \
                      --no-enable-prefix-caching \
                      --swap-space 16 \
                      --disable-log-requests \
                      --trust-remote-code \
                      --gpu-memory-utilization 0.9

               Wait until the model has loaded and the server is ready to accept requests.

            2. On another terminal on the same machine, run the benchmark:

               .. code-block:: shell

                  # Connect to the container
                  docker exec -it test bash

                  # Wait for the server to start
                  until curl -s http://localhost:8000/v1/models; do sleep 30; done

                  # Run the benchmark
                  model={{ model.model_repo }}
                  max_concurrency=1
                  num_prompts=10
                  in=128
                  out=128
                  vllm bench serve --model $model \
                      --percentile-metrics "ttft,tpot,itl,e2el" \
                      --dataset-name random \
                      --ignore-eos \
                      --max-concurrency $max_concurrency \
                      --num-prompts $num_prompts \
                      --random-input-len $in \
                      --random-output-len $out \
                      --trust-remote-code \
                      --save-result \
                      --result-filename ${model}_serving.json

            .. note::

               For improved performance with certain Mixture of Experts models, such as Mixtral 8x22B,
               try adding ``export VLLM_ROCM_USE_AITER=1`` to your commands.

               If you encounter the following error, pass your access-authorized Hugging
               Face token to the gated models.

               .. code-block::

                  OSError: You are trying to access a gated repo.

                  # pass your HF_TOKEN
                  export HF_TOKEN=$your_personal_hf_token

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
see the developer's guide at `<https://github.com/ROCm/vllm/blob/documentation/docs/dev-docker/README.md>`__.

Reproducing the Docker image
----------------------------

To reproduce this ROCm/vLLM Docker image release, follow these steps:

1. Clone the `vLLM repository <https://github.com/ROCm/vllm>`__.

   .. code-block:: shell

      git clone https://github.com/ROCm/vllm.git

2. Checkout the specific release commit.

   .. code-block:: shell

      cd vllm
      git checkout 6663000a391911eba96d7864a26ac42b07f6ef29

3. Build the Docker image. Replace ``vllm-rocm`` with your desired image tag.

   .. code-block:: shell

      docker build -f docker/Dockerfile.rocm -t vllm-rocm .

Further reading
===============

- To learn more about the options for latency and throughput benchmark scripts,
  see `<https://github.com/ROCm/vllm/tree/main/benchmarks>`_.

- To learn more about MAD and the ``madengine`` CLI, see the `MAD usage guide <https://github.com/ROCm/MAD?tab=readme-ov-file#usage-guide>`__.

- To learn more about system settings and management practices to configure your system for
  AMD Instinct MI300X series GPUs, see `AMD Instinct MI300X system optimization <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/system-optimization/mi300x.html>`_.

- See :ref:`fine-tuning-llms-vllm` and :ref:`mi300x-vllm-optimization` for
  a brief introduction to vLLM and optimization strategies.

- For application performance optimization strategies for HPC and AI workloads,
  including inference with vLLM, see :doc:`/how-to/rocm-for-ai/inference-optimization/workload`.

- For a list of other ready-made Docker images for AI with ROCm, see
  `AMD Infinity Hub <https://www.amd.com/en/developer/resources/infinity-hub.html#f-amd_hub_category=AI%20%26%20ML%20Models>`_.

Previous versions
=================

See :doc:`previous-versions/vllm-history` to find documentation for previous releases
of the ``ROCm/vllm`` Docker image.
