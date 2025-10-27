.. meta::
   :description: How to train a model using LLM Foundry for ROCm.
   :keywords: ROCm, AI, LLM, train, PyTorch, torch, Llama, flux, tutorial, docker

******************************************
Training MPT-30B with LLM Foundry on ROCm
******************************************

MPT-30B is a 30-billion parameter decoder-style transformer-based model from
the Mosaic Pretrained Transformer (MPT) family -- learn more about it in
MosaicML's research blog `MPT-30B: Raising the bar for open-source foundation
models <https://www.databricks.com/blog/mpt-30b>`_.

ROCm and `<https://github.com/ROCm/MAD>`__ provide a pre-configured training
environment for the MPT-30B model using the ``rocm/pytorch-training:v25.5``
base `Docker image <https://hub.docker.com/layers/rocm/pytorch-training/v25.5/images/sha256-d47850a9b25b4a7151f796a8d24d55ea17bba545573f0d50d54d3852f96ecde5>`_
and the `LLM Foundry <https://github.com/mosaicml/llm-foundry>`_ framework.
This environment packages the following software components to train
on AMD Instinct MI300X Series GPUs:

+--------------------------+--------------------------------+
| Software component       | Version                        |
+==========================+================================+
| ROCm                     | 6.3.4                          |
+--------------------------+--------------------------------+
| PyTorch                  | 2.7.0a0+git6374332             |
+--------------------------+--------------------------------+
| Flash Attention          | 3.0.0.post1                    |
+--------------------------+--------------------------------+

Using this image, you can build, run, and test the training process
for MPT-30B with access to detailed logs and performance metrics.

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

Getting started
===============

The following procedures help you set up the training environment in a
reproducible Docker container. This training environment is tailored for
training MPT-30B using LLM Foundry and the specific model configurations outlined.
Other configurations and run conditions outside those described in this
document are not validated.

.. tab-set::

   .. tab-item:: MAD-integrated benchmarking

      On your host machine, clone the ROCm Model Automation and Dashboarding
      (`<https://github.com/ROCm/MAD>`__) repository to a local directory and
      install the required packages.

      .. code-block:: shell

         git clone https://github.com/ROCm/MAD
         cd MAD
         pip install -r requirements.txt

      Use this command to initiate the MPT-30B training benchmark.

      .. code-block:: shell

         madengine run \
             --tags pyt_mpt30b_training \
             --keep-model-dir \
             --live-output \
             --clean-docker-cache

      .. tip::

         If you experience data download failures, set the
         ``MAD_SECRETS_HFTOKEN`` variable to your Hugging Face access token. See
         `User access tokens <https://huggingface.co/docs/hub/security-tokens>`_
         for details.

         .. code-block:: shell

            export MAD_SECRETS_HFTOKEN="your personal Hugging Face token to access gated models"

      .. note::

         For improved performance (training throughput), consider enabling TunableOp.
         By default, ``pyt_mpt30b_training`` runs with TunableOp disabled. To enable it,
         run ``madengine run`` with the ``--tunableop on`` argument or edit the
         ``models.json`` configuration before running training.

         Although this might increase the initial training time, it can result in a performance gain.

   .. tab-item:: Standalone benchmarking

      To set up the training environment, clone the
      `<https://github.com/ROCm/MAD>`__ repo and build the Docker image. In
      this snippet, the image is named ``mosaic_mpt30_image``.

      .. code-block:: shell

         git clone https://github.com/ROCm/MAD
         cd MAD

         docker build --build-arg MAD_SYSTEM_GPU_ARCHITECTURE=gfx942 -f docker/pyt_mpt30b_training.ubuntu.amd.Dockerfile -t mosaic_mpt30_image .

      Start a ``mosaic_mpt30_image`` container using the following command.

      .. code-block:: shell

         docker run -it --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --shm-size=8G mosaic_mpt30_image

      In the Docker container, clone the `<https://github.com/ROCm/MAD>`__
      repository and navigate to the benchmark scripts directory at
      ``/workspace/MAD/scripts/pyt_mpt30b_training``.

      .. code-block:: shell

         git clone https://github.com/ROCm/MAD
         cd MAD/scripts/pyt_mpt30b_training

      To initiate the training process, use the following command. This script uses the hyperparameters defined in
      ``mpt-30b-instruct.yaml``.

      .. code-block:: shell

         source run.sh

      .. note::

         For improved performance (training throughput), consider enabling TunableOp.
         To enable it, add the ``--tunableop on`` flag.

         .. code-block:: shell

            source run.sh --tunableop on

         Although this might increase the initial training time, it can result in a performance gain.

Interpreting the output
=======================

The training output will be displayed in the terminal and simultaneously saved
to the ``output.txt`` file in the current directory. Key performance metrics will
also be extracted and appended to the ``perf_pyt_mpt30b_training.csv`` file.

Key performance metrics include:

- Training logs: Real-time display of loss metrics, accuracy, and training progress.

- Model checkpoints: Periodically saved model snapshots for potential resume or evaluation.

- Performance metrics: Detailed summaries of training speed and training loss metrics.

  - Performance (throughput/samples_per_sec)

    Overall throughput, measuring the total samples processed per second. Higher values indicate better hardware utilization.

  - Performance per device (throughput/samples_per_sec)

    Throughput on a per-device basis, showing how each GPU or CPU is performing.

  - Language Cross Entropy (metrics/train/LanguageCrossEntropy)

    Measures prediction accuracy. Lower cross entropy suggests the model’s output is closer to the expected distribution.

  - Training loss (loss/train/total)

    Overall training loss. A decreasing trend indicates the model is learning effectively.

Further reading
===============

- To learn more about MAD and the ``madengine`` CLI, see the `MAD usage guide <https://github.com/ROCm/MAD?tab=readme-ov-file#usage-guide>`__.

- To learn more about system settings and management practices to configure your system for
  AMD Instinct MI300X Series GPUs, see `AMD Instinct MI300X system optimization <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/system-optimization/mi300x.html>`_.

- For a list of other ready-made Docker images for AI with ROCm, see
  `AMD Infinity Hub <https://www.amd.com/en/developer/resources/infinity-hub.html#f-amd_hub_category=AI%20%26%20ML%20Models>`_.
