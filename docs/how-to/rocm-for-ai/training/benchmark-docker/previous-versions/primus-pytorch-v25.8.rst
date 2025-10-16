:orphan:

.. meta::
   :description: How to train a model using PyTorch for ROCm.
   :keywords: ROCm, AI, LLM, train, PyTorch, torch, Llama, flux, tutorial, docker

****************************************
Training a model with Primus and PyTorch
****************************************

.. caution::

   This documentation does not reflect the latest version of ROCm Primus PyTorch training
   performance benchmark documentation. See :doc:`../primus-pytorch` for the latest version.

`Primus <https://github.com/AMD-AGI/Primus>`__ is a unified and flexible
LLM training framework designed to streamline training. It streamlines LLM
training on AMD Instinct GPUs using a modular, reproducible configuration paradigm.
Primus now supports the PyTorch torchtitan backend.

.. note::

   Primus with the PyTorch torchtitan backend is designed to replace the :doc:`ROCm PyTorch training <../pytorch-training>` workflow.
   See :doc:`../pytorch-training` to see steps to run workloads without Primus.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/previous-versions/primus-pytorch-v25.8-benchmark-models.yaml

   {% set dockers = data.dockers %}
   {% set docker = dockers[0] %}
   For ease of use, AMD provides a ready-to-use Docker image -- ``{{
   docker.pull_tag }}`` -- for MI300X series GPUs containing essential
   components for Primus and PyTorch training with
   Primus Turbo optimizations.

   .. list-table::
      :header-rows: 1

      * - Software component
        - Version

      {% for component_name, component_version in docker.components.items() %}
      * - {{ component_name }}
        - {{ component_version }}
      {% endfor %}

.. _amd-primus-pytorch-model-support-v258:

Supported models
================

The following models are pre-optimized for performance on the AMD Instinct MI325X and MI300X GPUs.
Some instructions, commands, and training recommendations in this documentation might
vary by model -- select one to get started.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/previous-versions/primus-pytorch-v25.8-benchmark-models.yaml

   {% set unified_docker = data.dockers[0] %}
   {% set model_groups = data.model_groups %}
   .. raw:: html

      <div id="vllm-benchmark-ud-params-picker" class="container-fluid">
         <div class="row gx-0" style="display: none;">
            <div class="col-2 me-1 px-2 model-param-head">Model</div>
            <div class="row col-10 pe-0">
      {% for model_group in model_groups %}
               <div class="col-3 px-2 model-param" data-param-k="model-group" data-param-v="{{ model_group.tag }}" tabindex="0">{{ model_group.group }}</div>
      {% endfor %}
            </div>
         </div>

         <div class="row gx-0 pt-1">
            <div class="col-2 me-1 px-2 model-param-head">Model</div>
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

.. seealso::

   For additional workloads, including Llama 3.3, Llama 3.2, Llama 2, GPT OSS, Qwen, and Flux models,
   see the documentation :doc:`../pytorch-training` (without Primus)

.. _amd-primus-pytorch-performance-measurements-v258:

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

This Docker image is optimized for specific model configurations outlined
below. Performance can vary for other training workloads, as AMD
doesn’t test configurations and run conditions outside those described.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/previous-versions/primus-pytorch-v25.8-benchmark-models.yaml

   {% set unified_docker = data.dockers[0] %}

   Pull the Docker image
   =====================

   Use the following command to pull the `Docker image <{{ unified_docker.docker_hub_url }}>`_ from Docker Hub.

   .. code-block:: shell

      docker pull {{ unified_docker.pull_tag }}

   Run training
   ============

   {% set model_groups = data.model_groups %}

   Once the setup is complete, choose between the following two workflows to start benchmarking training.
   For fine-tuning workloads and multi-node training examples, see :doc:`../pytorch-training` (without Primus).

   .. tab-set::

      .. tab-item:: MAD-integrated benchmarking

   {% for model_group in model_groups %}
      {% for model in model_group.models %}

         .. container:: model-doc {{ model.mad_tag }}

            The following run command is tailored to {{ model.model }}.
            See :ref:`amd-primus-pytorch-model-support-v258` to switch to another available model.

            1. Clone the ROCm Model Automation and Dashboarding (`<https://github.com/ROCm/MAD>`__) repository to a local
               directory and install the required packages on the host machine.

               .. code-block:: shell

                  git clone https://github.com/ROCm/MAD
                  cd MAD
                  pip install -r requirements.txt

            2. For example, use this command to run the performance benchmark test on the {{ model.model }} model
               using one node with the {{ model.precision }} data type on the host machine.

               .. code-block:: shell

                  export MAD_SECRETS_HFTOKEN="your personal Hugging Face token to access gated models"
                  madengine run \
                      --tags {{ model.mad_tag }} \
                      --keep-model-dir \
                      --live-output \
                      --timeout 28800

               MAD launches a Docker container with the name
               ``container_ci-{{ model.mad_tag }}``. The latency and throughput reports of the
               model are collected in ``~/MAD/perf.csv``.

      {% endfor %}
   {% endfor %}

      .. tab-item:: Standalone benchmarking

   {% for model_group in model_groups %}
      {% for model in model_group.models %}

         .. container:: model-doc {{ model.mad_tag }}

            The following run commands are tailored to {{ model.model }}.
            See :ref:`amd-primus-pytorch-model-support-v258` to switch to another available model.

            .. rubric:: Download the Docker image and required packages

            1. Use the following command to pull the Docker image from Docker Hub.

               .. code-block:: shell

                  docker pull {{ unified_docker.pull_tag }}

            2. Run the Docker container.

               .. code-block:: shell

                  docker run -it \
                      --device /dev/dri \
                      --device /dev/kfd \
                      --network host \
                      --ipc host \
                      --group-add video \
                      --cap-add SYS_PTRACE \
                      --security-opt seccomp=unconfined \
                      --privileged \
                      -v $HOME:$HOME \
                      -v $HOME/.ssh:/root/.ssh \
                      --shm-size 64G \
                      --name training_env \
                      {{ unified_docker.pull_tag }}

               Use these commands if you exit the ``training_env`` container and need to return to it.

               .. code-block:: shell

                  docker start training_env
                  docker exec -it training_env bash

            3. In the Docker container, clone the `<https://github.com/ROCm/MAD>`__
               repository and navigate to the benchmark scripts directory
               ``/workspace/MAD/scripts/pytorch_train``.

               .. code-block:: shell

                  git clone https://github.com/ROCm/MAD
                  cd MAD/scripts/pytorch_train

            .. rubric:: Prepare training datasets and dependencies

            1. The following benchmarking examples require downloading models and datasets
               from Hugging Face. To ensure successful access to gated repos, set your
               ``HF_TOKEN``.

               .. code-block:: shell

                  export HF_TOKEN=$your_personal_hugging_face_access_token

            2. Run the setup script to install libraries and datasets needed for benchmarking.

               .. code-block:: shell

                  ./pytorch_benchmark_setup.sh

            .. rubric:: Pretraining

            To start the pretraining benchmark, use the following command with the
            appropriate options. See the following list of options and their descriptions.

            .. code-block:: shell

               ./pytorch_benchmark_report.sh -t pretrain \
                   -m {{ model.model_repo }} \
                   -p $datatype \
                   -s $sequence_length


            .. list-table::
               :header-rows: 1

               * - Name
                 - Options
                 - Description

               {% for mode in available_modes %}
               * - {% if loop.first %}``$training_mode``{% endif %}
                 - ``{{ mode }}``
                 - {{ training_mode_descs[mode] }}
               {% endfor %}

               * - ``$datatype``
                 - ``BF16``{% if model.mad_tag == "primus_pyt_train_llama-3.1-8b" %} or ``FP8``{% endif %}
                 - Currently, only Llama 3.1 8B supports FP8 precision.

               * - ``$sequence_length``
                 - Sequence length for the language model.
                 - Between 2048 and 8192. 8192 by default.

            .. rubric:: Benchmarking examples

            Use the following command to run train {{ model.model }} with BF16 precision using Primus torchtitan.

            .. code-block:: shell

               ./pytorch_benchmark_report.sh -m {{ model.model_repo }}

            To train {{ model.model }} with FP8 precision, use the following command.

            .. code-block:: shell

               ./pytorch_benchmark_report.sh -m {{ model.model_repo }} -p FP8
      {% endfor %}
   {% endfor %}

Further reading
===============

- For an introduction to Primus, see `Primus: A Lightweight, Unified Training
  Framework for Large Models on AMD GPUs <https://rocm.blogs.amd.com/software-tools-optimization/primus/README.html>`__.

- To learn more about MAD and the ``madengine`` CLI, see the `MAD usage guide <https://github.com/ROCm/MAD?tab=readme-ov-file#usage-guide>`__.

- To learn more about system settings and management practices to configure your system for
  AMD Instinct MI300X series GPUs, see `AMD Instinct MI300X system optimization <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/system-optimization/mi300x.html>`_.

- For a list of other ready-made Docker images for AI with ROCm, see
  `AMD Infinity Hub <https://www.amd.com/en/developer/resources/infinity-hub.html#f-amd_hub_category=AI%20%26%20ML%20Models>`_.

Previous versions
=================

See :doc:`pytorch-training-history` to find documentation for previous releases
of the ``ROCm/pytorch-training`` Docker image.
