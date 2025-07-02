*****************************************************
Benchmarking Llama 3 70B pre-training with torchtitan
*****************************************************

This guide provides instructions for benchmarking the pre-training throughput
of the Llama 3 70B model using torchtitan. By following these steps, you will
use a pre-configured Docker container, download the necessary Llama 3 assets,
and run the training script to measure performance in either ``FP8`` or ``BF16``
precision.
The accompanying Docker image integrates the ROCm 7.0 Alpha with torchtitan, and is
tailored for next-generation AMD Instinct MI355X and MI350X accelerators. This
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
          -v $HOME:$HOME -v \
          $HOME/.ssh:/root/.ssh \
          --shm-size 64G \
          -w /workspace/torchtitan \
          --name training_benchmark \
          rocm/7.0-preview:rocm7.0_preview_pytorch_training_mi35X_alpha

   .. note::

      This containerized environment includes all necessary dependencies and pre-tuned
      configurations for the supported models and precision types.

3. Download the Llama 3 tokenizer. Make sure to set ``HF_TOKEN`` using a valid Hugging Face access
   token with Llama model permissions.

   .. code-block:: shell

      export HF_TOKEN= #{your huggingface token with Llama 3 access}
      python scripts/download_tokenizer.py --repo_id meta-llama/Meta-Llama-3-70B --tokenizer_path "original" --hf_token=${HF_TOKEN}

4. Run the training script for Llama 3 70B with the appropriate configuration file for your desired
   precision.

   .. tab-set::

      .. tab-item:: FP8 precision

         .. code-block:: shell

            CONFIG_FILE="./llama3_70b_fsdp_fp8.toml" ./run_train.sh

      .. tab-item:: BF16 precision

         .. code-block:: shell

            CONFIG_FILE="./llama3_70b_fsdp_bf16.toml" ./run_train.sh

   .. note::

      These configuration files define batch size, FSDP strategy, optimizer settings, and precision
      type for each benchmarking run.
