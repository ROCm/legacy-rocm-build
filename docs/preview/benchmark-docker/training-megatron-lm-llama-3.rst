***********************************************
Benchmark Llama 3 pre-training with Megatron-LM
***********************************************

This page describes how to benchmark Llama 3 8B and 70B pre-training using the
Megatron-LM framework. It includes configurations for both
FP8 and BF16 precision to measure throughput. The accompanying Docker
image integrates a Beta preview build of ROCm 7.0 with Megatron-LM
-- and is tailored for AMD Instinct MI355X and MI350X accelerators.
This benchmark does not support other accelerators.

Follow these steps to pull the required image, spin up the container with the
appropriate options, download the model, and run the throughput test.

Pull the Docker image
=====================

Use the following command to pull the `Docker image <https://hub.docker.com/layers/rocm/7.0-preview/rocm7.0_preview_pytorch_training_mi35X_alpha/images/sha256-734c76d4d68ab23b47f4bf012863793df11f83714c35683fb5c15bc48d0a6dd2>`__.

.. code-block:: shell

   docker pull rocm/7.0-preview:rocm7.0_preview_pytorch_training_mi35x_beta


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
          -w /workspace/Megatron-LM \
          --name training_benchmark \
          rocm/7.0-preview:rocm7.0_preview_pytorch_training_mi35x_beta

   .. note::

      This containerized environment includes all necessary dependencies and pre-tuned
      configurations for the supported models and precision types.

2. Run the training script with the following options for your desired precision.

   .. tab-set::

      .. tab-item:: Llama 3 8B

         .. tab-set::

            .. tab-item:: BF16

               .. code-block:: shell

                  TEE_OUTPUT=1 \
                  MBS=4 \
                  BS=512 \
                  TP=1 \
                  TE_FP8=0 \
                  SEQ_LENGTH=8192 \
                  MODEL_SIZE=8 \
                  TOTAL_ITERS=10 \
                  GEMM_TUNING=1 \
                  bash examples/llama/train_llama3.sh

            .. tab-item:: FP8

               .. code-block:: shell

                  TEE_OUTPUT=1 \
                  MBS=4 \
                  BS=512 \
                  TP=1 \
                  TE_FP8=1 \
                  SEQ_LENGTH=8192 \
                  MODEL_SIZE=8 \
                  TOTAL_ITERS=10 \
                  GEMM_TUNING=0 \
                  bash examples/llama/train_llama3.sh

      .. tab-item:: Llama 3 70B

         .. tab-set::

            .. tab-item:: BF16

               .. code-block:: shell

                  CKPT_FORMAT=torch_dist \
                  TEE_OUTPUT=1 \
                  MBS=3 \
                  BS=24 \
                  TP=1 \
                  TE_FP8=0 \
                  FSDP=1 \
                  RECOMPUTE=1 \
                  SEQ_LENGTH=8192 \
                  MODEL_SIZE=70 \
                  TOTAL_ITERS=10 \
                  bash examples/llama/train_llama3.sh

            .. tab-item:: FP8

               .. code-block:: shell

                  CKPT_FORMAT=torch_dist \
                  TEE_OUTPUT=1 \
                  RECOMPUTE=1 \
                  MBS=3 \
                  BS=24 \
                  TP=1 \
                  TE_FP8=1 \
                  SEQ_LENGTH=8192 \
                  MODEL_SIZE=70 \
                  FSDP=1 \
                  TOTAL_ITERS=10 \
                  NUM_LAYERS=40 \
                  bash examples/llama/train_llama3.sh

   .. rubric:: Options

   The ``train_llama3.sh`` script accepts the following options:

   * ``MBS``: Micro-batch size per GPU

   * ``BS``: Global batch size

   * ``TP``: Tensor parallelism

   * ``SEQ_LENGTH``: Maximum input token sequence length

   * ``TE_FP8``: Toggle to enable FP8

   * ``TOTAL_ITERS``: Number of training iterations to execute

