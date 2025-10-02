**********************************************
Benchmark Llama 3 pre-training with torchtitan
**********************************************

This page describes how to benchmark Llama 3 8B and 70B pre-training using
torchtitan. The provided Docker image integrates
ROCm 7.0 with torchtitan -- and is tailored for AMD Instinct MI355X and MI350X
GPUs.

Follow these steps to pull the required image, spin up the container with the
appropriate options, download the model, and run the throughput test.

Pull the Docker image
=====================

Use the following command to pull the `Docker image <https://hub.docker.com/r/rocm/7.0/tags>`__.

.. code-block:: shell

   docker pull rocm/7.0:rocm7.0_pytorch_training_instinct_20250915

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
          -w /workspace/torchtitan \
          --name training_benchmark \
          rocm/7.0:rocm7.0_pytorch_training_instinct_20250915

   .. note::

      This containerized environment includes all necessary dependencies and pre-tuned
      configurations for the supported models and precision types.

2. Download the Llama 3 tokenizer. Make sure to set ``HF_TOKEN`` using
   a valid Hugging Face access token with Llama model permissions.

   .. tab-set::

      .. tab-item:: Llama 3 8B
         :sync: 8b

         .. code-block:: shell

            export HF_TOKEN=#{your huggingface token with Llama 3 access}
            python3 scripts/download_tokenizer.py \
                --repo_id meta-llama/Meta-Llama-3-8B \
                --tokenizer_path "original" \
                --hf_token=${HF_TOKEN}

      .. tab-item:: Llama 3 70B
         :sync: 70b

         .. code-block:: shell

            export HF_TOKEN=#{your huggingface token with Llama 3 access}
            python3 scripts/download_tokenizer.py \
                --repo_id meta-llama/Meta-Llama-3-70B \
                --tokenizer_path "original" \
                --hf_token=${HF_TOKEN}

3. Run the training script with the following options for your desired precision.

   .. tab-set::

      .. tab-item:: Llama 3 8B
         :sync: 8b

         .. tab-set::

            .. tab-item:: BF16

               .. code-block:: shell

                  CONFIG_FILE="./llama3_8b_fsdp_bf16.toml" ./run_train.sh

            .. tab-item:: FP8

               .. code-block:: shell

                  CONFIG_FILE="./llama3_8b_fsdp_fp8.toml" ./run_train.sh

      .. tab-item:: Llama 3 70B
         :sync: 70b

         .. tab-set::

            .. tab-item:: BF16

               .. code-block:: shell

                  CONFIG_FILE="./llama3_70b_fsdp_bf16.toml" ./run_train.sh

            .. tab-item:: FP8

               .. code-block:: shell

                  CONFIG_FILE="./llama3_70b_fsdp_fp8.toml" ./run_train.sh
