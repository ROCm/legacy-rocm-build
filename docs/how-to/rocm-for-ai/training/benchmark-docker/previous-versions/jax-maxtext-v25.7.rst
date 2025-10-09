:orphan:

.. meta::
   :description: How to train a model using JAX MaxText for ROCm.
   :keywords: ROCm, AI, LLM, train, jax, torch, Llama, flux, tutorial, docker

******************************************
Training a model with JAX MaxText on ROCm
******************************************

.. caution::

   This documentation does not reflect the latest version of ROCm JAX MaxText
   training performance documentation. See :doc:`../jax-maxtext` for the latest version.

MaxText is a high-performance, open-source framework built on the Google JAX
machine learning library to train LLMs at scale. The MaxText framework for
ROCm is an optimized fork of the upstream
`<https://github.com/AI-Hypercomputer/maxtext>`__ enabling efficient AI workloads
on AMD MI300X series GPUs.

The MaxText for ROCm training Docker image
provides a prebuilt environment for training on AMD Instinct MI300X and MI325X GPUs,
including essential components like JAX, XLA, ROCm libraries, and MaxText utilities.
It includes the following software components:

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/jax-maxtext-benchmark-models.yaml

   {% set dockers = data.dockers %}
   .. tab-set::

      {% for docker in dockers %}
      {% set jax_version = docker.components["JAX"] %}

      .. tab-item:: ``{{ docker.pull_tag }}``
         :sync: {{ docker.pull_tag }}

         .. list-table::
            :header-rows: 1

            * - Software component
              - Version

            {% for component_name, component_version in docker.components.items() %}
            * - {{ component_name }}
              - {{ component_version }}

            {% endfor %}
         {% if jax_version == "0.6.0" %}
         .. note::

            Shardy is a new config in JAX 0.6.0. You might get related errors if it's
            not configured correctly. For now you can turn it off by setting
            ``shardy=False`` during the training run. You can also follow the `migration
            guide <https://docs.jax.dev/en/latest/shardy_jax_migration.html>`__ to enable
            it.
         {% endif %}

      {% endfor %}

MaxText with on ROCm provides the following key features to train large language models efficiently:

- Transformer Engine (TE)

- Flash Attention (FA) 3 -- with or without sequence input packing

- GEMM tuning

- Multi-node support

- NANOO FP8 quantization support

.. _amd-maxtext-model-support-v257:

Supported models
================

The following models are pre-optimized for performance on AMD Instinct MI300
series GPUs. Some instructions, commands, and available training
configurations in this documentation might vary by model -- select one to get
started.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/jax-maxtext-benchmark-models.yaml

   {% set model_groups = data.model_groups %}
   .. raw:: html

      <div id="vllm-benchmark-ud-params-picker" class="container-fluid">
         <div class="row gx-0">
            <div class="col-2 me-1 px-2 model-param-head">Model</div>
            <div class="row col-10 pe-0">
      {% for model_group in model_groups %}
               <div class="col-4 px-2 model-param" data-param-k="model-group" data-param-v="{{ model_group.tag }}" tabindex="0">{{ model_group.group }}</div>
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

.. note::

   Some models, such as Llama 3, require an external license agreement through
   a third party (for example, Meta).

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

Pull the Docker image
---------------------

Use the following command to pull the Docker image from Docker Hub.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/jax-maxtext-benchmark-models.yaml

   {% set dockers = data.dockers %}
   .. tab-set::

      {% for docker in dockers %}
      {% set jax_version = docker.components["JAX"] %}

      .. tab-item:: JAX {{ jax_version }}
         :sync: {{ docker.pull_tag }}

         .. code-block:: shell

            docker pull {{ docker.pull_tag }}

      {% endfor %}

.. _amd-maxtext-multi-node-setup-v257:

Multi-node configuration
------------------------

See :doc:`/how-to/rocm-for-ai/system-setup/multi-node-setup` to configure your
environment for multi-node training.

.. _amd-maxtext-get-started-v257:

Benchmarking
============

Once the setup is complete, choose between two options to reproduce the
benchmark results:

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/jax-maxtext-benchmark-models.yaml

   .. _vllm-benchmark-mad:

   {% set dockers = data.dockers %}
   {% set model_groups = data.model_groups %}
   {% for model_group in model_groups %}
      {% for model in model_group.models %}

   .. container:: model-doc {{model.mad_tag}}

      .. tab-set::

         {% if model.mad_tag and "single-node" in model.doc_options %}
         .. tab-item:: MAD-integrated benchmarking

            1. Clone the ROCm Model Automation and Dashboarding (`<https://github.com/ROCm/MAD>`__) repository to a local
               directory and install the required packages on the host machine.

               .. code-block:: shell

                  git clone https://github.com/ROCm/MAD
                  cd MAD
                  pip install -r requirements.txt

            2. Use this command to run the performance benchmark test on the {{ model.model }} model
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
            model are collected in the following path: ``~/MAD/perf.csv/``.
         {% endif %}

         .. tab-item:: Standalone benchmarking

            .. rubric:: Download the Docker image and required scripts

            Run the JAX MaxText benchmark tool independently by starting the
            Docker container as shown in the following snippet.

            .. tab-set::
               {% for docker in dockers %}
               {% set jax_version = docker.components["JAX"] %}

               .. tab-item:: JAX {{ jax_version }}
                  :sync: {{ docker.pull_tag }}

                  .. code-block:: shell

                     docker pull {{ docker.pull_tag }}
               {% endfor %}

            {% if model.model_repo and "single-node" in model.doc_options %}
            .. rubric:: Single node training

            1. Set up environment variables.

               .. code-block:: shell

                  export MAD_SECRETS_HFTOKEN=<Your Hugging Face token>
                  export HF_HOME=<Location of saved/cached Hugging Face models>

               ``MAD_SECRETS_HFTOKEN`` is your Hugging Face access token to access models, tokenizers, and data.
               See `User access tokens <https://huggingface.co/docs/hub/en/security-tokens>`__.

               ``HF_HOME`` is where ``huggingface_hub`` will store local data. See `huggingface_hub CLI <https://huggingface.co/docs/huggingface_hub/main/en/guides/cli#huggingface-cli-download>`__.
               If you already have downloaded or cached Hugging Face artifacts, set this variable to that path.
               Downloaded files typically get cached to ``~/.cache/huggingface``.

            2. Launch the Docker container.

               .. tab-set::
                  {% for docker in dockers %}
                  {% set jax_version = docker.components["JAX"] %}

                  .. tab-item:: JAX {{ jax_version }}
                     :sync: {{ docker.pull_tag }}

                     .. code-block:: shell

                        docker run -it \
                            --device=/dev/dri \
                            --device=/dev/kfd \
                            --network host \
                            --ipc host \
                            --group-add video \
                            --cap-add=SYS_PTRACE \
                            --security-opt seccomp=unconfined \
                            --privileged \
                            -v $HOME:$HOME \
                            -v $HOME/.ssh:/root/.ssh \
                            -v $HF_HOME:/hf_cache \
                            -e HF_HOME=/hf_cache \
                            -e MAD_SECRETS_HFTOKEN=$MAD_SECRETS_HFTOKEN
                            --shm-size 64G \
                            --name training_env \
                            {{ docker.pull_tag }}
                  {% endfor %}

            3. In the Docker container, clone the ROCm MAD repository and navigate to the
               benchmark scripts directory at ``MAD/scripts/jax-maxtext``.

               .. code-block:: shell

                  git clone https://github.com/ROCm/MAD
                  cd MAD/scripts/jax-maxtext

            4. Run the setup scripts to install libraries and datasets needed
               for benchmarking.

               .. code-block:: shell

                  ./jax-maxtext_benchmark_setup.sh -m {{ model.model_repo }}

            5. To run the training benchmark without quantization, use the following command:

               .. code-block:: shell

                  ./jax-maxtext_benchmark_report.sh -m {{ model.model_repo }}

               For quantized training, use the following command:

               .. code-block:: shell

                  ./jax-maxtext_benchmark_report.sh -m {{ model.model_repo }} -q nanoo_fp8

            {% endif %}
            {% if model.multinode_training_script and "multi-node" in model.doc_options %}
            .. rubric:: Multi-node training

            The following examples use SLURM to run on multiple nodes.

            .. note::

               The following scripts will launch the Docker container and run the
               benchmark. Run them outside of any Docker container.

            1. Make sure ``$HF_HOME`` is set before running the test. See
               `ROCm benchmarking <https://github.com/ROCm/MAD/blob/develop/scripts/jax-maxtext/gpu-rocm/readme.md>`__
               for more details on downloading the Llama models before running the
               benchmark.

            2. To run multi-node training for {{ model.model }},
               use the
               `multi-node training script <https://github.com/ROCm/MAD/blob/develop/scripts/jax-maxtext/gpu-rocm/{{ model.multinode_training_script }}>`__
               under the ``scripts/jax-maxtext/gpu-rocm/`` directory.

            3. Run the multi-node training benchmark script.

               .. code-block:: shell

                  sbatch -N <num_nodes> {{ model.multinode_training_script }}

         {% else %}
            .. rubric:: Multi-node training

            For multi-node training examples, choose a model from :ref:`amd-maxtext-model-support-v257`
            with an available `multi-node training script <https://github.com/ROCm/MAD/tree/develop/scripts/jax-maxtext/gpu-rocm>`__.
         {% endif %}
      {% endfor %}
   {% endfor %}

Further reading
===============

- To learn more about MAD and the ``madengine`` CLI, see the `MAD usage guide <https://github.com/ROCm/MAD?tab=readme-ov-file#usage-guide>`__.

- To learn more about system settings and management practices to configure your system for
  AMD Instinct MI300X series GPUs, see `AMD Instinct MI300X system optimization <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/system-optimization/mi300x.html>`_.

- For a list of other ready-made Docker images for AI with ROCm, see
  `AMD Infinity Hub <https://www.amd.com/en/developer/resources/infinity-hub.html#f-amd_hub_category=AI%20%26%20ML%20Models>`_.

Previous versions
=================

See :doc:`jax-maxtext-history` to find documentation for previous releases
of the ``ROCm/jax-training`` Docker image.
