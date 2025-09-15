***********************************************
Benchmark Mixtral 8x7b pre-training with MaxText
***********************************************

This page describes how to benchmark the Mixtral 8x7B pre-training using the
MaxText framework. It includes configurations for both
FP8 and BF16 precision to measure throughput. The accompanying Docker
image integrates a Beta preview build of ROCm 7.0 with MaxText
-- and is tailored for AMD Instinct MI355X and MI350X accelerators.
This benchmark does not support other accelerators.

Follow these steps to pull the required image, spin up the container with the
appropriate options, download the model, and run the throughput test.

Pull the Docker image
=====================

Use the following command to pull the `Docker image <https://hub.docker.com/layers/rocm/7.0-preview/rocm7.0_preview_pytorch_training_mi35x_beta/images/sha256-d47db310d1913c1de526b25c06ac6bd4c9f53c199a5a04677afc57526f259234>`__.

.. code-block:: shell

   docker pull rocm/pyt-megatron-lm-jax-nightly-private:jax_gfx950_20250911

Run the training benchmark
==========================

1. Start the container using the following command.

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
          -w /workspace/maxtext \
          --name training_benchmark \
          rocm/pyt-megatron-lm-jax-nightly-private:jax_gfx950_20250911

   .. note::

      This containerized environment includes all necessary dependencies and pre-tuned
      configurations for the supported models and precision types.

2. Run the training script with the following options for your desired precision.

   .. tab-set::

      .. tab-item:: Mixtral 8x7B

         .. tab-set::

            .. tab-item:: BF16

               .. code-block:: shell

                  wget https://raw.githubusercontent.com/ROCm/MAD/refs/heads/develop/scripts/jax-maxtext/env_scripts/mixtral_8x7b.yml
                  wget https://raw.githubusercontent.com/ROCm/MAD/refs/heads/develop/scripts/jax-maxtext/env_scripts/mixtral_8x7b_env.sh
                  bash mixtral_8x7b_env.sh
                  python3 -m MaxText.train mixtral_8x7b.yml

            .. tab-item:: FP8

               .. code-block:: shell

                  wget https://raw.githubusercontent.com/ROCm/MAD/refs/heads/develop/scripts/jax-maxtext/env_scripts/mixtral_8x7b.yml
                  wget https://raw.githubusercontent.com/ROCm/MAD/refs/heads/develop/scripts/jax-maxtext/env_scripts/mixtral_8x7b_env.sh
                  bash mixtral_8x7b_env.sh
                  python3 -m MaxText.train mixtral_8x7b.yml quantization=fp8

   .. rubric:: Options

   The ``MaxText.train`` script accepts the following options:

   * ``per_device_batch_size``: Per-device batch size

   * ``quantization``: quantization

   * ``max_target_length``: Maximum input token sequence length

   * ``steps``: Number of training iterations to execute

   Please see this base [config](https://github.com/AI-Hypercomputer/maxtext/blob/main/src/MaxText/configs/base.yml)
   for full list of settings you can change.

Other supported models
==========================
   * Llama-2-7B FP8 and BF16
   * Llama-2-70B FP8 and BF16
   * Llama-3.1-8B FP8 and BF16
   * Llama-3.1-70B BF16
   * Llama-3.3-70B BF16
   * DeepSeekV2-Lite FP8 and BF16

Known Issue
==========================
There is a known issue of getting "Memory Access Fault" error on selected models and configurations. A fix will be updated in later versions.
