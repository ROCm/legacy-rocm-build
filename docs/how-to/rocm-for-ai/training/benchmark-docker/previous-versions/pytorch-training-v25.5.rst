.. meta::
   :description: How to train a model using PyTorch for ROCm.
   :keywords: ROCm, AI, LLM, train, PyTorch, torch, Llama, flux, tutorial, docker

**************************************
Training a model with PyTorch for ROCm
**************************************

.. caution::

   This documentation does not reflect the latest version of ROCm vLLM
   performance benchmark documentation. See :doc:`../pytorch-training` for the latest version.

PyTorch is an open-source machine learning framework that is widely used for
model training with GPU-optimized components for transformer-based models.

The `PyTorch for ROCm training Docker <https://hub.docker.com/layers/rocm/pytorch-training/v25.5/images/sha256-d47850a9b25b4a7151f796a8d24d55ea17bba545573f0d50d54d3852f96ecde5>`_
(``rocm/pytorch-training:v25.5``) image
provides a prebuilt optimized environment for fine-tuning and pretraining a
model on AMD Instinct MI325X and MI300X accelerators. It includes the following
software components to accelerate training workloads:

+--------------------------+--------------------------------+
| Software component       | Version                        |
+==========================+================================+
| ROCm                     | 6.3.4                          |
+--------------------------+--------------------------------+
| PyTorch                  | 2.7.0a0+git637433              |
+--------------------------+--------------------------------+
| Python                   | 3.10                           |
+--------------------------+--------------------------------+
| Transformer Engine       | 1.12.0.dev0+25a33da            |
+--------------------------+--------------------------------+
| Flash Attention          | 3.0.0                          |
+--------------------------+--------------------------------+
| hipBLASLt                | git53b53bf                     |
+--------------------------+--------------------------------+
| Triton                   | 3.2.0                          |
+--------------------------+--------------------------------+

.. _amd-pytorch-training-model-support:

Supported models
================

The following models are pre-optimized for performance on the AMD Instinct MI325X and MI300X accelerators.

* Llama 3.3 70B

* Llama 3.1 8B

* Llama 3.1 70B

* Llama 2 70B

* FLUX.1-dev

.. note::

   Only these models are supported in the following steps.

   Some models, such as Llama 3, require an external license agreement through
   a third party (for example, Meta).

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
doesn’t validate configurations and run conditions outside those described.

Benchmarking
============

Once the setup is complete, choose between two options to start benchmarking:

.. tab-set::

   .. tab-item:: MAD-integrated benchmarking

      Clone the ROCm Model Automation and Dashboarding (`<https://github.com/ROCm/MAD>`__) repository to a local
      directory and install the required packages on the host machine.

      .. code-block:: shell

         git clone https://github.com/ROCm/MAD
         cd MAD
         pip install -r requirements.txt

      For example, use this command to run the performance benchmark test on the Llama 3.1 8B model
      using one GPU with the float16 data type on the host machine.

      .. code-block:: shell

         export MAD_SECRETS_HFTOKEN="your personal Hugging Face token to access gated models"
         python3 tools/run_models.py --tags pyt_train_llama-3.1-8b --keep-model-dir --live-output --timeout 28800

      The available models for MAD-integrated benchmarking are:

      * ``pyt_train_llama-3.3-70b``

      * ``pyt_train_llama-3.1-8b``

      * ``pyt_train_llama-3.1-70b``

      * ``pyt_train_flux``

      MAD launches a Docker container with the name
      ``container_ci-pyt_train_llama-3.1-8b``, for example. The latency and throughput reports of the
      model are collected in the following path: ``~/MAD/perf.csv``.

   .. tab-item:: Standalone benchmarking

      .. rubric:: Download the Docker image and required packages

      Use the following command to pull the Docker image from Docker Hub.

      .. code-block:: shell

         docker pull rocm/pytorch-training:v25.5

      Run the Docker container.

      .. code-block:: shell

         docker run -it --device /dev/dri --device /dev/kfd --network host --ipc host --group-add video --cap-add SYS_PTRACE --security-opt seccomp=unconfined --privileged -v $HOME:$HOME -v  $HOME/.ssh:/root/.ssh --shm-size 64G --name training_env rocm/pytorch-training:v25.5

      Use these commands if you exit the ``training_env`` container and need to return to it.

      .. code-block:: shell

         docker start training_env
         docker exec -it training_env bash

      In the Docker container, clone the `<https://github.com/ROCm/MAD>`__
      repository and navigate to the benchmark scripts directory
      ``/workspace/MAD/scripts/pytorch_train``.

      .. code-block:: shell

         git clone https://github.com/ROCm/MAD
         cd MAD/scripts/pytorch_train

      .. rubric:: Prepare training datasets and dependencies

      The following benchmarking examples require downloading models and datasets
      from Hugging Face. To ensure successful access to gated repos, set your
      ``HF_TOKEN``.

      .. code-block:: shell

         export HF_TOKEN=$your_personal_hugging_face_access_token

      Run the setup script to install libraries and datasets needed for benchmarking.

      .. code-block:: shell

         ./pytorch_benchmark_setup.sh

      ``pytorch_benchmark_setup.sh`` installs the following libraries:

      .. list-table::
         :header-rows: 1

         * - Library
           - Benchmark model
           - Reference

         * - ``accelerate``
           - Llama 3.1 8B, FLUX
           - `Hugging Face Accelerate <https://huggingface.co/docs/accelerate/en/index>`_

         * - ``datasets``
           - Llama 3.1 8B, 70B, FLUX
           - `Hugging Face Datasets <https://huggingface.co/docs/datasets/v3.2.0/en/index>`_ 3.2.0

         * - ``torchdata``
           - Llama 3.1 70B
           - `TorchData <https://pytorch.org/data/beta/index.html>`_

         * - ``tomli``
           - Llama 3.1 70B
           - `Tomli <https://pypi.org/project/tomli/>`_

         * - ``tiktoken``
           - Llama 3.1 70B
           - `tiktoken <https://github.com/openai/tiktoken>`_

         * - ``blobfile``
           - Llama 3.1 70B
           - `blobfile <https://pypi.org/project/blobfile/>`_

         * - ``tabulate``
           - Llama 3.1 70B
           - `tabulate <https://pypi.org/project/tabulate/>`_

         * - ``wandb``
           - Llama 3.1 70B
           - `Weights & Biases <https://github.com/wandb/wandb>`_

         * - ``sentencepiece``
           - Llama 3.1 70B, FLUX
           - `SentencePiece <https://github.com/google/sentencepiece>`_ 0.2.0

         * - ``tensorboard``
           - Llama 3.1 70 B, FLUX
           - `TensorBoard <https://www.tensorflow.org/tensorboard>`_ 2.18.0

         * - ``csvkit``
           - FLUX
           - `csvkit <https://csvkit.readthedocs.io/en/latest/>`_ 2.0.1

         * - ``deepspeed``
           - FLUX
           - `DeepSpeed <https://github.com/deepspeedai/DeepSpeed>`_ 0.16.2

         * - ``diffusers``
           - FLUX
           - `Hugging Face Diffusers <https://huggingface.co/docs/diffusers/en/index>`_ 0.31.0

         * - ``GitPython``
           - FLUX
           - `GitPython <https://github.com/gitpython-developers/GitPython>`_ 3.1.44

         * - ``opencv-python-headless``
           - FLUX
           - `opencv-python-headless <https://pypi.org/project/opencv-python-headless/>`_ 4.10.0.84

         * - ``peft``
           - FLUX
           - `PEFT <https://huggingface.co/docs/peft/en/index>`_ 0.14.0

         * - ``protobuf``
           - FLUX
           - `Protocol Buffers <https://github.com/protocolbuffers/protobuf>`_ 5.29.2

         * - ``pytest``
           - FLUX
           - `PyTest <https://docs.pytest.org/en/stable/>`_ 8.3.4

         * - ``python-dotenv``
           - FLUX
           - `python-dotenv <https://pypi.org/project/python-dotenv/>`_ 1.0.1

         * - ``seaborn``
           - FLUX
           - `Seaborn <https://seaborn.pydata.org/>`_ 0.13.2

         * - ``transformers``
           - FLUX
           - `Transformers <https://huggingface.co/docs/transformers/en/index>`_ 4.47.0

      ``pytorch_benchmark_setup.sh`` downloads the following models from Hugging Face:

      * `meta-llama/Llama-3.1-70B-Instruct <https://huggingface.co/meta-llama/Llama-3.1-70B-Instruct>`_

      * `black-forest-labs/FLUX.1-dev <https://huggingface.co/black-forest-labs/FLUX.1-dev>`_

      Along with the following datasets:

      * `WikiText <https://huggingface.co/datasets/Salesforce/wikitext>`_

      * `UltraChat 200k <https://huggingface.co/datasets/HuggingFaceH4/ultrachat_200k>`_

      * `bghira/pseudo-camera-10k <https://huggingface.co/datasets/bghira/pseudo-camera-10k>`_

      .. rubric:: Pretraining

      To start the pretraining benchmark, use the following command with the
      appropriate options. See the following list of options and their descriptions.

      .. code-block:: shell

         ./pytorch_benchmark_report.sh -t $training_mode -m $model_repo -p $datatype -s $sequence_length

      .. list-table::
         :header-rows: 1

         * - Name
           - Options
           - Description

         * - ``$training_mode``
           - ``pretrain``
           - Benchmark pretraining

         * -
           - ``finetune_fw``
           - Benchmark full weight fine-tuning (Llama 3.1 70B with BF16)

         * -
           - ``finetune_lora``
           - Benchmark LoRA fine-tuning (Llama 3.1 70B with BF16)

         * -
           - ``HF_finetune_lora``
           - Benchmark LoRA fine-tuning with Hugging Face PEFT (Llama 2 70B with BF16)

         * - ``$datatype``
           - ``FP8`` or ``BF16``
           - Only Llama 3.1 8B supports FP8 precision.

         * - ``$model_repo``
           - ``Llama-3.3-70B``
           - `Llama 3.3 70B <https://huggingface.co/meta-llama/Llama-3.3-70B-Instruct>`_

         * - 
           - ``Llama-3.1-8B``
           - `Llama 3.1 8B <https://huggingface.co/meta-llama/Llama-3.1-8B-Instruct>`_

         * - 
           - ``Llama-3.1-70B``
           - `Llama 3.1 70B <https://huggingface.co/meta-llama/Llama-3.1-70B-Instruct>`_

         * - 
           - ``Llama-2-70B``
           - `Llama 2 70B <https://huggingface.co/meta-llama/Llama-2-70B>`_

         * - 
           - ``Flux``
           - `FLUX.1 [dev] <https://huggingface.co/black-forest-labs/FLUX.1-dev>`_

         * - ``$sequence_length``
           - Sequence length for the language model.
           - Between 2048 and 8192. 8192 by default.

      .. note::

         Occasionally, downloading the Flux dataset might fail. In the event of this
         error, manually download it from Hugging Face at
         `black-forest-labs/FLUX.1-dev <https://huggingface.co/black-forest-labs/FLUX.1-dev>`_
         and save it to `/workspace/FluxBenchmark`. This ensures that the test script can access
         the required dataset.

      .. rubric:: Fine-tuning

      To start the fine-tuning benchmark, use the following command. It will run the benchmarking example of Llama 3.1 70B
      with the WikiText dataset using the AMD fork of `torchtune <https://github.com/AMD-AIG-AIMA/torchtune>`_.

      .. code-block:: shell

         ./pytorch_benchmark_report.sh -t {finetune_fw, finetune_lora} -p BF16 -m Llama-3.1-70B

      Use the following command to run the benchmarking example of Llama 2 70B with the UltraChat 200k dataset using
      `Hugging Face PEFT <https://huggingface.co/docs/peft/en/index>`_.

      .. code-block:: shell

         ./pytorch_benchmark_report.sh -t HF_finetune_lora -p BF16 -m Llama-2-70B

      .. rubric:: Benchmarking examples

      Here are some example commands to get started pretraining and fine-tuning with various model configurations.

      * Example 1: Llama 3.1 70B with BF16 precision with `torchtitan <https://github.com/ROCm/torchtitan>`_.

        .. code-block:: shell

           ./pytorch_benchmark_report.sh -t pretrain -p BF16 -m Llama-3.1-70B -s 8192

      * Example 2: Llama 3.1 8B with FP8 precision using Transformer Engine (TE) and Hugging Face Accelerator.

        .. code-block:: shell

           ./pytorch_benchmark_report.sh -t pretrain -p FP8 -m Llama-3.1-70B -s 8192

      * Example 3: FLUX.1-dev with BF16 precision with FluxBenchmark.

        .. code-block:: shell

           ./pytorch_benchmark_report.sh -t pretrain -p BF16 -m Flux

      * Example 4: Torchtune full weight fine-tuning with Llama 3.1 70B

        .. code-block:: shell

           ./pytorch_benchmark_report.sh -t finetune_fw -p BF16 -m Llama-3.1-70B

      * Example 5: Torchtune LoRA fine-tuning with Llama 3.1 70B

        .. code-block:: shell

           ./pytorch_benchmark_report.sh -t finetune_lora -p BF16 -m Llama-3.1-70B

      * Example 6: Torchtune full weight fine-tuning with Llama-3.3-70B

        .. code-block:: shell

           ./pytorch_benchmark_report.sh -t finetune_fw -p BF16 -m Llama-3.3-70B

      * Example 7: Torchtune LoRA fine-tuning with Llama-3.3-70B

        .. code-block:: shell

           ./pytorch_benchmark_report.sh -t finetune_lora -p BF16 -m Llama-3.3-70B

      * Example 8: Torchtune QLoRA fine-tuning with Llama-3.3-70B

        .. code-block:: shell

           ./pytorch_benchmark_report.sh -t finetune_qlora -p BF16 -m Llama-3.3-70B

      * Example 9: Hugging Face PEFT LoRA fine-tuning with Llama 2 70B

        .. code-block:: shell

           ./pytorch_benchmark_report.sh -t HF_finetune_lora -p BF16 -m Llama-2-70B

