*****************************************************
Benchmarking Llama 3 8B pre-training with Megatron-LM
*****************************************************

This section details how to benchmark Llama 3 8B pre-training using the
Megatron-LM framework. It includes configurations for both ``FP8`` and
``BF16`` precision to measure throughput.
The accompanying Docker image integrates the ROCm 7.0 Alpha with Megatron-LM, and is
tailored for AMD Instinct MI355X and MI350X accelerators. This
benchmark does not support other accelerators.

Follow these steps to pull the required image, spin up the container with the
appropriate options, download the model, and run the throughput test.

1. Pull the Docker image.

   .. code-block:: shell

      docker pull rocm/7.0-preview:rocm7.0_preview_pytorch_training_mi35X_alpha

2. Start the container.

   .. code-block:: shell

      docker run -it --device /dev/dri --device /dev/kfd \
          --network host --ipc host --group-add video \
          --cap-add SYS_PTRACE --security-opt seccomp=unconfined --privileged \
          -v $HOME:$HOME \
          -v $HOME/.ssh:/root/.ssh \
          --shm-size 64G \
          -w /workspace/Megatron-LM \
          --name training_benchmark \
          rocm/7.0-preview:rocm7.0_preview_pytorch_training_mi35X_alpha

   .. note::

      This containerized environment includes all necessary dependencies and pre-tuned
      configurations for the supported models and precision types.

3. Run the training script for Llama 3 8B with the appropriate options for your desired precision.

   .. tab-set::

      .. tab-item:: FP8 precision

         .. code-block:: shell

            bash examples/llama/train_llama3.sh \
                TEE_OUTPUT=1 \
                MBS=4 \
                BS=512 \
                TP=1 \
                TE_FP8=1 \
                SEQ_LENGTH=8192 \
                MODEL_SIZE=8 \
                TOTAL_ITERS=10 \
                GEMM_TUNING=0

      .. tab-item:: BF16 precision

         .. code-block:: shell

            bash examples/llama/train_llama3.sh
                TEE_OUTPUT=1 \
                MBS=4 \
                BS=256 \
                TP=1 \
                TE_FP8=0 \
                SEQ_LENGTH=8192 \
                MODEL_SIZE=8 \
                TOTAL_ITERS=10

   .. note::

      The ``train_llama3.sh`` script accepts the following options:

      * ``MBS``: Micro-batch size per GPU

      * ``BS``: Global batch size

      * ``TP``: Tensor parallelism

      * ``SEQ_LENGTH``: Maximum input token sequence length

      * ``TE_FP8``: Toggle to enable FP8

      * ``TOTAL_ITERS``: Number of training iterations to execute
