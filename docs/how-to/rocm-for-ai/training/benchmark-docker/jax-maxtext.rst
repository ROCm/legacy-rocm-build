.. meta::
   :description: How to train a model using JAX MaxText for ROCm.
   :keywords: ROCm, AI, LLM, train, jax, torch, Llama, flux, tutorial, docker

********************************************
Training a model with Primus and JAX MaxText
********************************************

The JAX MaxText for ROCm training Docker image provides a prebuilt environment
for training on AMD Instinct MI355X, MI350X, MI325X, and MI300X GPUs, with
essential components such as JAX, XLA, ROCm libraries, and MaxText utilities.

The image also integrates with `Primus <https://github.com/AMD-AGI/Primus>`__,
a high-level training framework that supports multiple backends. You can use
the unified ``primus-cli`` to run training jobs using the JAX MaxText backend.

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
      {% endfor %}

MaxText with on ROCm provides the following key features to train large language models efficiently:

- Transformer Engine (TE)

- Flash Attention (FA) 3 -- with or without sequence input packing

- GEMM tuning

- Multi-node support

- NANOO FP8 (for MI300X series GPUs) and FP8 (for MI355X and MI350X) quantization support

.. _amd-maxtext-model-support-v26.3:

Supported models
================

The following models are pre-optimized for performance on AMD Instinct
GPUs. Some instructions, commands, and available training
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

   {% set docker = data.dockers[0] %}

   .. code-block:: shell

      docker pull {{ docker.pull_tag }}

.. _amd-maxtext-multi-node-setup-v26.3:

Multi-node configuration
------------------------

See :doc:`/how-to/rocm-for-ai/system-setup/multi-node-setup` to configure your
environment for multi-node training.

.. _amd-maxtext-get-started-v26.3:

Benchmarking
============

Once the setup is complete, choose between two options to reproduce the
benchmark results:

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/jax-maxtext-benchmark-models.yaml

   .. _vllm-benchmark-mad:

   {% set docker = data.dockers[0] %}
   {% set model_groups = data.model_groups %}
   {% for model_group in model_groups %}
      {% for model in model_group.models %}

   .. container:: model-doc {{model.mad_tag}}

      .. tab-set::

         {% if model.primus_config_name %}
         .. tab-item:: Primus benchmarking

            .. container:: model-doc {{ model.mad_tag }}

               The following run commands are tailored to {{ model.model }}.
               See :ref:`amd-maxtext-model-support-v26.3` to switch to another available model.

               .. rubric:: Download the Docker image and required packages

               1. Pull the ``{{ docker.pull_tag }}`` Docker image from Docker Hub.

                  .. code-block:: shell

                     docker pull {{ docker.pull_tag }}

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
                         -v $HF_HOME:/hf_cache \
                         -e HF_HOME=/hf_cache \
                         -e MAD_SECRETS_HFTOKEN=$MAD_SECRETS_HFTOKEN
                         --shm-size 64G \
                         --name training_env \
                         {{ docker.pull_tag }}

                  Use these commands if you exit the ``training_env`` container and need to return to it.

                  .. code-block:: shell

                     docker start training_env
                     docker exec -it training_env bash

               3. Clone the Primus repository.

                  .. code-block:: shell

                     git clone https://github.com/AMD-AIG-AIMA/Primus.git
                     cd Primus
                     git checkout main
                     git submodule update --init third_party/maxtext/

               .. rubric:: Run the training job with primus-cli

               For detailed usage instructions for ``primus-cli``, see the
               `Primus CLI User Guide
               <https://github.com/AMD-AGI/Primus/blob/main/docs/cli/PRIMUS-CLI-GUIDE.md>`__.

               Use the following examples to run training with ``primus-cli``:

               - Direct mode: run directly on the current host or within an existing Docker container

                 .. tab-set::

                    .. tab-item:: MI355X
                       :sync: mi355x

                       .. code-block:: shell

                          ./primus-cli direct \
                            -- train pretrain \
                            --config examples/maxtext/configs/MI355X/{{ model.primus_config_name }}

                    .. tab-item:: MI300X
                       :sync: mi300x

                       .. code-block:: shell

                          ./primus-cli direct \
                            -- train pretrain \
                            --config examples/maxtext/configs/MI300X/{{ model.primus_config_name }}

               - Container mode: run in Docker containers

                 .. tab-set::

                    .. tab-item:: MI355X
                       :sync: mi355x

                       .. code-block:: shell

                          ./primus-cli container --image {{ docker.pull_tag }} \
                            -- train pretrain \
                            --config examples/maxtext/configs/MI355X/{{ model.primus_config_name }}

                    .. tab-item:: MI300X
                       :sync: mi300x

                       .. code-block:: shell

                          ./primus-cli container --image rocm/jax-training:maxtext-v26.3 \
                            -- train pretrain \
                            --config examples/maxtext/configs/MI300X/{{ model.primus_config_name }}


               - Slurm mode: run distributed training on a Slurm cluster

                 .. tab-set::

                    .. tab-item:: MI355X
                       :sync: mi355x

                       .. code-block:: shell

                          # Use a custom config file, where you can specify
                          # the Docker image and set environment variables.
                          ./primus-cli --config my_maxtext_config.yaml slurm srun -N 8 \
                            -- train pretrain \
                            --config examples/maxtext/configs/MI355X/{{ model.primus_config_name }}

                    .. tab-item:: MI300X
                       :sync: mi300x

                       .. code-block:: shell

                          # Use a custom config file, where you can specify
                          # the Docker image and set environment variables.
                          ./primus-cli --config my_maxtext_config.yaml slurm srun -N 8 \
                            -- train pretrain \
                            --config examples/maxtext/configs/MI300X/{{ model.primus_config_name }}
         {% endif %}

         {% if model.mad_tag and "single-node" in model.doc_options %}
         .. tab-item:: MAD-integrated benchmarking

            The following run command is tailored to {{ model.model }}.
            See :ref:`amd-maxtext-model-support-v26.3` to switch to another available model.

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

            The following commands are optimized for {{ model.model }}. See
            :ref:`amd-maxtext-model-support-v26.3` to switch to another
            available model. Some instructions and resources might not be
            available for all models and configurations.

            .. rubric:: Download the Docker image and required scripts

            Run the JAX MaxText benchmark tool independently by starting the
            Docker container as shown in the following snippet.

            .. code-block:: shell

               docker pull {{ docker.pull_tag }}

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

               For quantized training, run the script with the appropriate option for your Instinct GPU.

               .. tab-set::

                  .. tab-item:: MI355X and MI350X

                     For ``fp8`` quantized training on MI355X and MI350X GPUs, use the following command:

                     .. code-block:: shell

                        ./jax-maxtext_benchmark_report.sh -m {{ model.model_repo }} -q fp8

                  {% if model.model_repo not in ["Llama-3.1-70B", "Llama-3.3-70B"] %}
                  .. tab-item:: MI325X and MI300X

                     For ``nanoo_fp8`` quantized training on MI300X series GPUs, use the following command:

                     .. code-block:: shell

                        ./jax-maxtext_benchmark_report.sh -m {{ model.model_repo }} -q nanoo_fp8
                  {% endif %}

            {% endif %}
            {% if model.multinode_config and "multi-node" in model.doc_options %}
            .. rubric:: Multi-node training

            The following SLURM scripts will launch the Docker container and
            run the benchmark. Run them outside of any Docker container. The
            unified multi-node benchmark script accepts a configuration file
            that specifies the model and training parameters.

            .. code-block:: shell

               sbatch -N <NUM_NODES> jax_maxtext_multinode_benchmark.sh <config_file.yml> [docker_image]

            <NUM_NODES>
               The number of nodes to use for training (for example, 2, 4,
               8).

            <config_file.yml>
               Path to the YAML configuration file containing model and
               training parameters. Configuration files are available in the
               ``scripts/jax-maxtext/env_scripts/`` directory for different
               models and GPU architectures.

            [docker_image] (optional)
               The Docker image to use. If not specified, it defaults to
               ``rocm/jax-training:maxtext-v26.3``.

            For example, to run a multi-node training benchmark on {{ model.model }}:

            .. tab-set::

               {% if model.multinode_config.gfx950 %}
               .. tab-item:: MI355X and MI350X (gfx950)

                  .. code-block:: bash

                     sbatch -N 4 jax_maxtext_multinode_benchmark.sh {{ model.multinode_config.gfx950 }}
               {% endif %}

               {% if model.multinode_config.gfx942 %}
               .. tab-item:: MI325X and MI300X (gfx942)

                  .. code-block:: bash

                     sbatch -N 4 jax_maxtext_multinode_benchmark.sh {{ model.multinode_config.gfx942 }}
               {% endif %}

         {% else %}
            .. rubric:: Multi-node training

            For multi-node training examples, choose a model from :ref:`amd-maxtext-model-support-v26.3`
            with an available `multi-node training script <https://github.com/ROCm/MAD/tree/develop/scripts/jax-maxtext/env_scripts>`__.
         {% endif %}
      {% endfor %}
   {% endfor %}

Profiling with JAX XPlane Profiler
===================================

MaxText has built-in XPlane profiling support via JAX's profiler. Traces
capture GPU kernel timelines, RCCL collectives, HLO graphs, and more. The
output can be viewed in TensorBoard's Trace Viewer or analyzed with
TraceLens.

Key MaxText profiler flags
--------------------------

The following MaxText config keys control profiling:

.. code-block:: text

   profiler=xplane                    # Use xplane format (produces .xplane.pb files)
   skip_first_n_steps_for_profiler=2  # Skip compilation/warmup steps
   profiler_steps=5                   # Number of steps to profile
   upload_all_profiler_results=True   # Save all GPU profiles (not just GPU0)

``steps`` should be greater than ``skip_first_n_steps_for_profiler`` +
``profiler_steps`` (for example, ``steps=12`` with ``skip=2`` and
``profile=5`` gives 5 warmup + 5 profiled + 2 cooldown).
``skip_first_n_steps_for_profiler=2`` skips step 0 (compilation) and step
1 (warmup). ``profiler_steps=5`` is typically sufficient; more steps
produce larger ``.xplane.pb`` files.

Profiling with MAD or madengine
-------------------------------

The model YAML configs under ``scripts/jax-maxtext/env_scripts/`` include
a ``profiler`` key (set to ``""`` by default). To enable profiling when
running through MAD or madengine, edit the YAML config for your model and
set the profiler fields:

.. code-block:: yaml

   profiler: "xplane"
   skip_first_n_steps_for_profiler: 2
   profiler_steps: 5
   upload_all_profiler_results: True
   steps: 12

Then run the benchmark as usual:

.. code-block:: shell

   export MAD_SECRETS_HFTOKEN="your personal Hugging Face token to access gated models"
   madengine run \
       --tags jax_maxtext_train_llama-3.1-8b \
       --keep-model-dir \
       --live-output \
       --timeout 28800

Use ``--keep-model-dir`` so the container's output directory is preserved
after the run. Profile output is written under the ``base_output_directory``
specified in the YAML.

Example: Profile a model standalone in Docker
----------------------------------------------

.. code-block:: shell

   #!/bin/bash
   set -e

   IMAGE="$1"       # Docker image, e.g. rocm/jax-training:maxtext-v26.3
   TAG="$2"         # Short tag for output folder, e.g. v26.3_llama2_7b
   PROFILE_DIR="/path/to/profiles/${TAG}"

   mkdir -p "${PROFILE_DIR}"

   docker run --rm --privileged --network=host \
     --device=/dev/dri --device=/dev/kfd --ipc=host \
     -v "${PROFILE_DIR}:/mnt/profile" \
     "${IMAGE}" bash -c '
   export XLA_PYTHON_CLIENT_MEM_FRACTION=.97
   export LD_LIBRARY_PATH=/usr/local/lib/:/opt/rocm/lib:$LD_LIBRARY_PATH
   export XLA_FLAGS="--xla_gpu_enable_latency_hiding_scheduler=True --xla_gpu_enable_command_buffer= <your other XLA flags>"
   export GPU_MAX_HW_QUEUES=2

   cd /workspace/maxtext

   python3 -m MaxText.train src/MaxText/configs/base.yml \
     run_name=profile \
     base_output_directory=/mnt/profile \
     hardware=gpu \
     steps=12 \
     model_name=<your-model> \
     dataset_type=synthetic \
     enable_checkpointing=False \
     enable_goodput_recording=False \
     monitor_goodput=False \
     <your model-specific flags> \
     profiler=xplane \
     skip_first_n_steps_for_profiler=2 \
     profiler_steps=5 \
     upload_all_profiler_results=True
   ' 2>&1 | tee "${PROFILE_DIR}/run.log"

   echo "Profile files:"
   find "${PROFILE_DIR}" -name "*.xplane.pb" -o -name "*.trace.json.gz" 2>/dev/null

Output structure
----------------

MaxText writes profiles in TensorBoard format:

.. code-block:: text

   <base_output_directory>/
   └── profile/
       └── tensorboard/
           └── plugins/
               └── profile/
                   └── <YYYY_MM_DD_HH_MM_SS>/
                       ├── <hostname>.xplane.pb          # Raw XPlane proto (GPU timelines)
                       ├── <hostname>.trace.json.gz       # Trace viewer data
                       └── *.hlo_proto.pb                 # HLO graphs for each compiled module

Viewing traces in TensorBoard
-----------------------------

.. code-block:: shell

   pip install tensorboard tensorboard-plugin-profile

   # Point --logdir at the directory containing the tensorboard/ folder
   tensorboard --logdir /path/to/profiles/<TAG>/profile --port 6006

Navigate to **Profile > Trace Viewer** in the TensorBoard UI. Zoom into a
single training step (skip the first profiled step as it may have residual
warmup) and look at individual GPU streams to see compute/RCCL overlap.

To keep profile files small, use ``profiler_steps=5`` to keep
``.xplane.pb`` files under approximately 100 MB. Too many steps can produce
files over 500 MB that TensorBoard struggles to load. Use
``enable_checkpointing=False`` to avoid checkpoint I/O noise in the trace,
and ``dataset_type=synthetic`` to eliminate data loading variability.

Profiling with rocprofv3
========================

If you need to collect a trace without the JAX profiler, use ``rocprofv3``:

.. code-block:: shell

   rocprofv3 --hip-trace --kernel-trace --memory-copy-trace --rccl-trace \
       --output-format pftrace -d ./v3_traces -- <command>

Replace ``<command>`` with the command you want to profile, such as
``./jax-maxtext_benchmark_report.sh -m Llama-2-7B``. Use ``-d
<TRACE_DIRECTORY>`` to specify where the ``.json`` traces are saved. The
resulting traces can be opened in `Perfetto <https://ui.perfetto.dev/>`__.

Known issues
============

- You might see NaNs in the losses while using real data (not synthetic
  data) when setting ``packing=True`` and ``NVTE_CK_IS_V3_ATOMIC_FP32=0``.
  Set ``NVTE_CK_IS_V3_ATOMIC_FP32=1`` for production training when using
  real data and input sequence packing (``packing=True``).

- There is a known slight performance regression for DeepSeek-V2-lite
  (16B) in v26.3. This is being tracked and will be addressed in a future
  release.

- **JAX 0.9.1 Early Access known issues:**

  - There is a known performance regression for MoE models
    (DeepSeek-V2-lite and Mixtral-8x7B).

  - The trace viewer in profiling may be missing some information in the
    flame graph.

- Shardy is a new config in JAX 0.6.0. You might get related errors if
  it's not configured correctly. To disable it, set ``shardy=False``
  during the training run. See the `Shardy migration guide
  <https://docs.jax.dev/en/latest/shardy_jax_migration.html>`__ to
  enable it.

Further reading
===============

- To learn more about MAD and the ``madengine`` CLI, see the `MAD usage guide <https://github.com/ROCm/MAD?tab=readme-ov-file#usage-guide>`__.

- To learn more about system settings and management practices to configure your system for
  AMD Instinct MI300X Series GPUs, see `AMD Instinct MI300X system optimization <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/system-optimization/mi300x.html>`_.

- For a list of other ready-made Docker images for AI with ROCm, see
  `AMD Infinity Hub <https://www.amd.com/en/developer/resources/infinity-hub.html#f-amd_hub_category=AI%20%26%20ML%20Models>`_.

Previous versions
=================

See :doc:`previous-versions/jax-maxtext-history` to find documentation for previous releases
of the ``ROCm/jax-training`` Docker image.
