:orphan:

.. meta::
   :description: How to train a model using PyTorch for ROCm.
   :keywords: ROCm, AI, LLM, train, PyTorch, torch, Llama, flux, tutorial, docker

**************************************
Training a model with PyTorch on ROCm
**************************************

.. note::

   Primus with the PyTorch torchtitan backend is intended to supersede the :doc:`ROCm PyTorch training <pytorch-training>` workflow.
   See :doc:`primus-pytorch` for details.

PyTorch is an open-source machine learning framework that is widely used for
model training with GPU-optimized components for transformer-based models.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/pytorch-training-benchmark-models.yaml

   {% set dockers = data.dockers %}
   {% set docker = dockers[0] %}
   The `PyTorch for ROCm training Docker <{{ docker.docker_hub_url }}>`__
   (``{{ docker.pull_tag }}``) image provides a prebuilt optimized environment for fine-tuning and pretraining a
   model on AMD Instinct MI325X and MI300X accelerators. It includes the following software components to accelerate
   training workloads:

   .. list-table::
      :header-rows: 1

      * - Software component
        - Version

      {% for component_name, component_version in docker.components.items() %}
      * - {{ component_name }}
        - {{ component_version }}
      {% endfor %}

.. _amd-pytorch-training-model-support:

Supported models
================

The following models are pre-optimized for performance on the AMD Instinct MI325X and MI300X accelerators.
Some instructions, commands, and training recommendations in this documentation might
vary by model -- select one to get started.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/pytorch-training-benchmark-models.yaml

   {% set unified_docker = data.dockers[0] %}
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


   .. _amd-pytorch-training-supported-training-modes:

   The following table lists supported training modes per model.

   .. dropdown:: Supported training modes

      .. list-table::
         :header-rows: 1

         * - Model
           - Supported training modes

      {% for model_group in model_groups %}
         {% set models = model_group.models %}
         {% for model in models %}
         {% if model.training_modes %}
         * - {{ model.model }}
           - ``{{ model.training_modes | join('``, ``') }}``

         {% endif %}
         {% endfor %}
      {% endfor %}

      .. note::

         Some model and fine-tuning combinations are not listed. This is
         because the `upstream torchtune repository <https://github.com/pytorch/torchtune>`__
         doesn't provide default YAML configurations for them.
         For advanced usage, you can create a custom configuration to enable
         unlisted fine-tuning methods by using an existing file in the
         ``/workspace/torchtune/recipes/configs`` directory as a template.

.. _amd-pytorch-training-performance-measurements:

Performance measurements
========================

To evaluate performance, the
`Performance results with AMD ROCm software <https://www.amd.com/en/developer/resources/rocm-hub/dev-ai/performance-results.html#tabs-a8deaeb413-item-21cea50186-tab>`_
page provides reference throughput and latency measurements for training
popular AI models.

.. note::

   The performance data presented in
   `Performance results with AMD ROCm software <https://www.amd.com/en/developer/resources/rocm-hub/dev-ai/performance-results.html#tabs-a8deaeb413-item-21cea50186-tab>`_
   should not be interpreted as the peak performance achievable by AMD
   Instinct MI325X and MI300X accelerators or ROCm software.

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

Run training
============

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/pytorch-training-benchmark-models.yaml

   {% set unified_docker = data.dockers[0] %}
   {% set model_groups = data.model_groups %}

   Once the setup is complete, choose between two options to start benchmarking training:

   .. tab-set::

      .. tab-item:: MAD-integrated benchmarking

   {% for model_group in model_groups %}
      {% for model in model_group.models %}

         The following run command is tailored to {{ model.model }}.
         See :ref:`amd-pytorch-training-model-support` to switch to another available model.

         1. Clone the ROCm Model Automation and Dashboarding (`<https://github.com/ROCm/MAD>`__) repository to a local
            directory and install the required packages on the host machine.

            .. code-block:: shell

               git clone https://github.com/ROCm/MAD
               cd MAD
               pip install -r requirements.txt

         .. container:: model-doc {{ model.mad_tag }}

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

         The following commands are tailored to {{ model.model }}.
         See :ref:`amd-pytorch-training-model-support` to switch to another available model.

      {% endfor %}
   {% endfor %}

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

            .. container:: model-doc pyt_train_llama-3.1-8b

               ``pytorch_benchmark_setup.sh`` installs the following libraries for Llama 3.1 8B:

               .. list-table::
                  :header-rows: 1

                  * - Library
                    - Reference

                  * - ``accelerate``
                    - `Hugging Face Accelerate <https://huggingface.co/docs/accelerate/en/index>`_

                  * - ``datasets``
                    - `Hugging Face Datasets <https://huggingface.co/docs/datasets/v3.2.0/en/index>`_ 3.2.0

            .. container:: model-doc pyt_train_llama-3.1-70b

               ``pytorch_benchmark_setup.sh`` installs the following libraries for Llama 3.1 70B:

               .. list-table::
                  :header-rows: 1

                  * - Library
                    - Reference

                  * - ``datasets``
                    - `Hugging Face Datasets <https://huggingface.co/docs/datasets/v3.2.0/en/index>`_ 3.2.0

                  * - ``torchdata``
                    - `TorchData <https://pytorch.org/data/beta/index.html>`_

                  * - ``tomli``
                    - `Tomli <https://pypi.org/project/tomli/>`_

                  * - ``tiktoken``
                    - `tiktoken <https://github.com/openai/tiktoken>`_

                  * - ``blobfile``
                    - `blobfile <https://pypi.org/project/blobfile/>`_

                  * - ``tabulate``
                    - `tabulate <https://pypi.org/project/tabulate/>`_

                  * - ``wandb``
                    - `Weights & Biases <https://github.com/wandb/wandb>`_

                  * - ``sentencepiece``
                    - `SentencePiece <https://github.com/google/sentencepiece>`_ 0.2.0

                  * - ``tensorboard``
                    - `TensorBoard <https://www.tensorflow.org/tensorboard>`_ 2.18.0

            .. container:: model-doc pyt_train_flux

               ``pytorch_benchmark_setup.sh`` installs the following libraries for FLUX:

               .. list-table::
                  :header-rows: 1

                  * - Library
                    - Reference

                  * - ``accelerate``
                    - `Hugging Face Accelerate <https://huggingface.co/docs/accelerate/en/index>`_

                  * - ``datasets``
                    - `Hugging Face Datasets <https://huggingface.co/docs/datasets/v3.2.0/en/index>`_ 3.2.0

                  * - ``sentencepiece``
                    - `SentencePiece <https://github.com/google/sentencepiece>`_ 0.2.0

                  * - ``tensorboard``
                    - `TensorBoard <https://www.tensorflow.org/tensorboard>`_ 2.18.0

                  * - ``csvkit``
                    - `csvkit <https://csvkit.readthedocs.io/en/latest/>`_ 2.0.1

                  * - ``deepspeed``
                    - `DeepSpeed <https://github.com/deepspeedai/DeepSpeed>`_ 0.16.2

                  * - ``diffusers``
                    - `Hugging Face Diffusers <https://huggingface.co/docs/diffusers/en/index>`_ 0.31.0

                  * - ``GitPython``
                    - `GitPython <https://github.com/gitpython-developers/GitPython>`_ 3.1.44

                  * - ``opencv-python-headless``
                    - `opencv-python-headless <https://pypi.org/project/opencv-python-headless/>`_ 4.10.0.84

                  * - ``peft``
                    - `PEFT <https://huggingface.co/docs/peft/en/index>`_ 0.14.0

                  * - ``protobuf``
                    - `Protocol Buffers <https://github.com/protocolbuffers/protobuf>`_ 5.29.2

                  * - ``pytest``
                    - `PyTest <https://docs.pytest.org/en/stable/>`_ 8.3.4

                  * - ``python-dotenv``
                    - `python-dotenv <https://pypi.org/project/python-dotenv/>`_ 1.0.1

                  * - ``seaborn``
                    - `Seaborn <https://seaborn.pydata.org/>`_ 0.13.2

                  * - ``transformers``
                    - `Transformers <https://huggingface.co/docs/transformers/en/index>`_ 4.47.0

            ``pytorch_benchmark_setup.sh`` downloads the following datasets from Hugging Face:

            * `bghira/pseudo-camera-10k <https://huggingface.co/datasets/bghira/pseudo-camera-10k>`_

   {% for model_group in model_groups %}
      {% for model in model_group.models %}
         {% set training_modes = model.training_modes %}
         {% set training_mode_descs = {
            "pretrain": "Benchmark pre-training.",
            "HF_pretrain": "Llama 3.1 8B pre-training with FP8 precision."
         } %}
         {% set available_modes = training_modes | select("in", ["pretrain", "HF_pretrain"]) | list %}
         {% if available_modes %}

         .. container:: model-doc {{ model.mad_tag }}

            .. rubric:: Pre-training

            To start the pre-training benchmark, use the following command with the
            appropriate options. See the following list of options and their descriptions.

            .. code-block:: shell

               ./pytorch_benchmark_report.sh -t {% if available_modes | length == 1 %}{{ available_modes[0] }}{% else %}$training_mode{% endif %} \
                   -m {{ model.model_repo }} \
                   -p $datatype \
                   -s $sequence_length

            {% if model.mad_tag == "pyt_train_flux" %}
            .. container:: model-doc {{ model.mad_tag }}

               .. note::

                  Currently, FLUX models are not supported out-of-the-box on {{ unified_docker.pull_tag }}.
                  To use FLUX, refer to ``rocm/pytorch-training`` Docker: :doc:`previous-versions/pytorch-training-v25.6`

                  Occasionally, downloading the Flux dataset might fail. In the event of this
                  error, manually download it from Hugging Face at
                  `black-forest-labs/FLUX.1-dev <https://huggingface.co/black-forest-labs/FLUX.1-dev>`_
                  and save it to `/workspace/FluxBenchmark`. This ensures that the test script can access
                  the required dataset.
            {% endif %}

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
                 - ``BF16``{% if model.mad_tag == "pyt_train_llama-3.1-8b" %} or ``FP8``{% endif %}
                 - Only Llama 3.1 8B supports FP8 precision.

               * - ``$sequence_length``
                 - Sequence length for the language model.
                 - Between 2048 and 8192. 8192 by default.
         {% endif %}

         {% set training_mode_descs = {
            "finetune_fw": "Full weight fine-tuning (BF16 and FP8 supported).",
            "finetune_lora": "LoRA fine-tuning (BF16 supported).",
            "finetune_qlora": "QLoRA fine-tuning (BF16 supported).",
            "HF_finetune_lora": "LoRA fine-tuning with Hugging Face PEFT.",
         } %}
         {% set available_modes = training_modes | select("in", ["finetune_fw", "finetune_lora", "finetune_qlora", "HF_finetune_lora"]) | list %}
         {% if available_modes %}
         .. container:: model-doc {{ model.mad_tag }}

            .. rubric:: Fine-tuning

            To start the fine-tuning benchmark, use the following command with the
            appropriate options. See the following list of options and their descriptions.
            See :ref:`supported training modes <amd-pytorch-training-supported-training-modes>`.

            .. code-block:: shell

               ./pytorch_benchmark_report.sh -t $training_mode \
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
                 - ``BF16``{% if "finetune_fw" in available_modes %} or ``FP8``{% endif %}
                 - All models support BF16.{% if "finetune_fw" in available_modes %} FP8 is only available for full weight fine-tuning.{% endif %}

               * - ``$sequence_length``
                 - Between 2048 and 16384.
                 - Sequence length for the language model.

            {% if model.mad_tag in ["pyt_train_llama3.2-vision-11b", "pyt_train_llama-3.2-vision-90b"] %}
            .. note::

               For LoRA and QLoRA support with vision models (Llama 3.2 11B and 90B),
               use the following torchtune commit for compatibility:

               .. code-block:: shell

                  git checkout 48192e23188b1fc524dd6d127725ceb2348e7f0e

            {% elif model.mad_tag in ["pyt_train_llama-2-7b", "pyt_train_llama-2-13b", "pyt_train_llama-2-70b"] %}
            .. note::

               You might encounter the following error with Llama 2: ``ValueError: seq_len (16384) of
               input tensor should be smaller than max_seq_len (4096)``.
               This error indicates that an input sequence is longer than the model's maximum context window.

               Ensure your tokenized input does not exceed the model's ``max_seq_len`` (4096
               tokens in this case). You can resolve this by truncating the input or splitting
               it into smaller chunks before passing it to the model.

               Note on reproducibility: The results in this guide are based on
               commit ``b4c98ac`` from the upstream
               `<https://github.com/pytorch/torchtune>`__ repository. For the
               latest updates, you can use the main branch.

            {% endif %}
         {% endif %}
      {% endfor %}
   {% endfor %}

            .. rubric:: Benchmarking examples

            For examples of benchmarking commands, see `<https://github.com/ROCm/MAD/tree/develop/benchmark/pytorch_train#benchmarking-examples>`__.

Multi-node training
-------------------

Pre-training
~~~~~~~~~~~~

Multi-node training with torchtitan is supported. The provided SLURM script is pre-configured for Llama 3 70B.

To launch the training job on a SLURM cluster for Llama 3 70B, run the following commands from the MAD repository.

.. code-block:: shell

   # In the MAD repository
   cd scripts/pytorch_train
   sbatch run_slurm_train.sh

Fine-tuning
~~~~~~~~~~~

Multi-node training with torchtune is supported. The provided SLURM script is pre-configured for Llama 3.3 70B.

To launch the training job on a SLURM cluster for Llama 3.3 70B, run the following commands from the MAD repository.

.. code-block:: shell

   huggingface-cli login # Get access to HF Llama model space
   huggingface-cli download meta-llama/Llama-3.3-70B-Instruct --local-dir ./models/Llama-3.3-70B-Instruct # Download the Llama 3.3 model locally
   # In the MAD repository
   cd scripts/pytorch_train
   sbatch Torchtune_Multinode.sh

.. note::

   Information regarding benchmark setup:

   * By default, Llama 3.3 70B is fine-tuned using ``alpaca_dataset``.
   * You can adjust the torchtune `YAML configuration file
     <https://github.com/pytorch/torchtune/blob/main/recipes/configs/llama3_3/70B_full_multinode.yaml>`__
     if you're using a different model.
   * The number of nodes and other parameters can be tuned in the SLURM script ``Torchtune_Multinode.sh``.
   * Set the ``mounting_paths`` inside the SLURM script.

Once the run is finished, you can find the log files in the ``result_torchtune/`` directory.

Further reading
===============

- To learn more about MAD and the ``madengine`` CLI, see the `MAD usage guide <https://github.com/ROCm/MAD?tab=readme-ov-file#usage-guide>`__.

- To learn more about system settings and management practices to configure your system for
  AMD Instinct MI300X series accelerators, see `AMD Instinct MI300X system optimization <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/system-optimization/mi300x.html>`_.

- For a list of other ready-made Docker images for AI with ROCm, see
  `AMD Infinity Hub <https://www.amd.com/en/developer/resources/infinity-hub.html#f-amd_hub_category=AI%20%26%20ML%20Models>`_.

Previous versions
=================

See :doc:`previous-versions/pytorch-training-history` to find documentation for previous releases
of the ``ROCm/pytorch-training`` Docker image.
