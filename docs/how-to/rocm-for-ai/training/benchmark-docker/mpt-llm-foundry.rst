.. meta::
   :description: How to train a model using LLM Foundry for ROCm.
   :keywords: ROCm, AI, LLM, train, PyTorch, torch, Llama, flux, tutorial, docker

******************************************
Training MPT-30B with LLM Foundry and ROCm
******************************************

MPT-30B is a 30 billion parameter decoder-style transformer-based model from
the Mosaic Pretrained Transformer (MPT) family -- learn more about it in
MosaicML's research blog `MPT-30B: Raising the bar for open-source foundation
models <https://www.databricks.com/blog/mpt-30b>`_.

`<https://github.com/ROCm/MAD>`__ provides a complete Docker-based training
environment for the MPT-30B model using the LLM Foundry framework. This
Docker image packages the following software components to train on AMD
Instinct MI300X series accelerators:

+--------------------------+--------------------------------+
| Software component       | Version                        |
+==========================+================================+
| ROCm                     | 6.3.1                          |
+--------------------------+--------------------------------+
| PyTorch                  | 2.7.0a0+git3a58512             |
+--------------------------+--------------------------------+
| Flash Attention          | 3.0.0                          |
+--------------------------+--------------------------------+

Using this image, you can build, run, and test the training process
for MPT-30B with access to detailed logs and performance metrics.

System validation
=================

If you have already validated your system settings, including NUMA
auto-balancing, skip this step. Otherwise, complete the :ref:`system validation
and optimization steps <train-a-model-system-validation>` to set up your system
before starting training.

Getting started
===============

The following procedures help you set up the training environment in a
reproducible Docker container. This training environment is tailored for
training MPT-30B using LLM Foundry and specific model configurations outlined.
Other configurations and run conditions outside those described in this
document are not validated.

.. tab-set::

   .. tab-item:: MAD-integrated benchmarking

      Clone the ROCm Model Automation and Dashboarding (`<https://github.com/ROCm/MAD>`__) repository to a local
      directory and install the required packages on the host machine.

      .. code-block:: shell

         git clone https://github.com/ROCm/MAD
         cd MAD
         pip install -r requirements.txt

      Use this command to run the performance benchmark.

      .. code-block:: shell

         python3 tools/run_models.py --tags pyt_mpt30b_training --keep-model-dir --live-output --clean-docker-cache

      .. note::

         For improved performance (training throughput), consider enabling TunableOp.
         By default, ``pyt_mpt30b_training`` runs with TunableOp disabled. To enable it,
         run ``tools/run_models.py`` with the ``--tunableop on`` argument or edit the
         ``models.json`` configuration before running training.

         Although this might increase the initial training time, it can result in a performance gain.

      .. tip::

         If you experience any data download failures, set the
         ``MAD_SECRETS_HFTOKEN`` variable to your Hugging Face access token. See
         `User access tokens <https://huggingface.co/docs/hub/security-tokens>`_
         for details.

         .. code-block:: shell

            export MAD_SECRETS_HFTOKEN="your personal Hugging Face token to access gated models"

   .. tab-item:: Standalone benchmarking

      To set up the appropriate training environment, clone the
      `<https://github.com/ROCm/MAD>`__ repo and build the Docker image.
      In this snippet, the image is named ``mosaic_mpt30_image``.

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

      To start the training, use the following command -- it uses the hyperparameters described in
      ``mpt-30b-instruct.yaml``.

      .. code-block:: shell

         source run.sh

      .. note::

         For improved performance (training throughput), consider enabling TunableOp.
         To enable it, add the ``--tunableop on`` flag.

         .. code-block:: shell

            source run.sh --tunableop on

         Although this might increase the initial training time, it can result in a performance gain.
