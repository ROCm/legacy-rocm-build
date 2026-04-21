************************************************
Benchmark Llama 3.3/3.1 FP4 inference with vLLM
************************************************

This section provides instructions to test the inference performance of Llama
3.3 70B and Llama 3.1 405B with MXFP4 precision on the vLLM inference engine.
The provided Docker image integrates `ROCm 7.0
<https://rocm.docs.amd.com/en/docs-7.0.0/about/release-notes.html>`__ with vLLM.
This benchmark supports AMD Instinct MI355X and MI350X GPUs.

Follow these steps to pull the required image, spin up the container with the
appropriate options, download the model, and run the throughput test.

Pull the Docker image
=====================

Use the following command to pull the `Docker image <https://hub.docker.com/r/rocm/7.0/tags>`__.

.. code-block:: shell

   docker pull rocm/7.0:rocm7.0_ubuntu_22.04_vllm_0.10.1_instinct_20250927_rc1

Download the model
==================

While vLLM can download model weights at runtime, it's recommended to
download ahead of time. You will need:

* A valid `Hugging Face access token <https://huggingface.co/docs/hub/security-tokens>`__.
  Remember to set ``HF_TOKEN`` to your access token.

* Access granted to the specific model from your Hugging Face account

.. tab-set::

   .. tab-item:: Llama 3.3 70B MXFP4
      :sync: Llama-3.3-70B-Instruct-MXFP4-Preview

      See the model card on Hugging Face at
      `amd/Llama-3.3-70B-Instruct-MXFP4-Preview <https://huggingface.co/amd/Llama-3.3-70B-Instruct-MXFP4-Preview>`__.
      This model uses FP4 quantization via `AMD Quark
      <https://quark.docs.amd.com/latest/>`_ for efficient inference on AMD
      accelerators.

      .. code-block:: shell

         model=amd/Llama-3.3-70B-Instruct-MXFP4-Preview

         pip install huggingface_hub hf_transfer hf_xet
         HF_HUB_ENABLE_HF_TRANSFER=1 \
         HF_HOME=/data/huggingface-cache \
         HF_TOKEN="<HF_TOKEN>" \ # Replace with your HF_TOKEN Hugging Face access token.
         hf download ${model} --exclude "original/*"

   .. tab-item:: Llama 3.1 405B MXFP4
      :sync: Llama-3.1-405B-Instruct-MXFP4-Preview

      See the model card on Hugging Face at
      `amd/Llama-3.1-405B-Instruct-MXFP4-Preview <https://huggingface.co/amd/Llama-3.1-405B-Instruct-MXFP4-Preview>`__.
      This model uses FP4 quantization via `AMD Quark
      <https://quark.docs.amd.com/latest/>`_ for efficient inference on AMD
      accelerators.

      .. code-block:: shell

         model=amd/Llama-3.1-405B-Instruct-MXFP4-Preview

         pip install huggingface_hub hf_transfer hf_xet
         HF_HUB_ENABLE_HF_TRANSFER=1 \
         HF_HOME=/data/huggingface-cache \
         HF_TOKEN="<HF_TOKEN>" \ # Replace with your HF_TOKEN Hugging Face access token.
         hf download ${model} --exclude "original/*"

Run the inference benchmark
===========================

1. Start the container using the following command.

   .. code-block:: shell

      docker run -it \
        --ipc=host \
        --network=host \
        --privileged \
        --cap-add=CAP_SYS_ADMIN \
        --device=/dev/kfd \
        --device=/dev/dri \
        --cap-add=SYS_PTRACE \
        --security-opt seccomp=unconfined \
        -v /data:/data \
        -e HF_HOME=/data/huggingface-cache \
        -e HF_HUB_OFFLINE=1 \
        --name vllm-server \
        rocm/7.0:rocm7.0_ubuntu_22.04_vllm_0.10.1_instinct_20250927_rc1

2. Start the server.

   .. tab-set::

      .. tab-item:: Llama 3.3 70B MXFP4
         :sync: Llama-3.3-70B-Instruct-MXFP4-Preview

         .. code-block:: shell

            model=amd/Llama-3.3-70B-Instruct-MXFP4-Preview

      .. tab-item:: Llama 3.1 405B MXFP4
         :sync: Llama-3.1-405B-Instruct-MXFP4-Preview

         .. code-block:: shell

            model=amd/Llama-3.1-405B-Instruct-MXFP4-Preview

   .. code-block:: shell

      max_model_len=10240           # Must be >= the input + the output lengths.
      max_seq_len_to_capture=10240  # Beneficial to set this to max_model_len.
      max_num_seqs=1024
      max_num_batched_tokens=131072 # Smaller values may result in better TTFT but worse TPOT / throughput.
      tensor_parallel_size=8

      # At high concurrency (> 16 for input length 1024, > 4 for input length 8192)
      export VLLM_TRITON_FP4_GEMM_USE_ASM=1

      # At low concurrency (<= 16 for input length 1024, <= 4 for input length 8192),
      # uncomment these lines:
      # export VLLM_TRITON_FP4_GEMM_USE_ASM=0
      # export VLLM_ROCM_USE_AITER_TRITON_BF16_GEMM=0

      # 0 is recommended for most configurations.
      # 1 (the default) is faster for input lengths of 8192 with concurrency > 16.
      export VLLM_ROCM_USE_AITER_MHA=0

      export VLLM_ROCM_QUICK_REDUCE_QUANTIZATION=INT4

      vllm serve ${model} \
          --host localhost \
          --port 8000 \
          --swap-space 64 \
          --max-model-len ${max_model_len} \
          --tensor-parallel-size ${tensor_parallel_size} \
          --max-num-seqs ${max_num_seqs} \
          --kv-cache-dtype fp8 \
          --gpu-memory-utilization 0.94 \
          --max-seq-len-to-capture ${max_seq_len_to_capture} \
          --max-num-batched-tokens ${max_num_batched_tokens} \
          --no-enable-prefix-caching \
          --async-scheduling

          # Wait for model to load and server is ready to accept requests.

3. Open another terminal on the same machine, connect to your running
   ``vllm-server`` container, and run the benchmark with the appropriate
   options. For example:

   .. code-block:: shell

      # Connect to server
      docker exec -it vllm-server bash

   .. tab-set::

      .. tab-item:: Llama 3.3 70B MXFP4
         :sync: Llama-3.3-70B-Instruct-MXFP4-Preview

         .. code-block:: shell

            model=amd/Llama-3.3-70B-Instruct-MXFP4-Preview

      .. tab-item:: Llama 3.1 405B MXFP4
         :sync: Llama-3.1-405B-Instruct-MXFP4-Preview

         .. code-block:: shell

            model=amd/Llama-3.1-405B-Instruct-MXFP4-Preview

   .. code-block:: shell

      # Run the client benchmark
      input_tokens=1024
      output_tokens=1024
      max_concurrency=64
      num_prompts=32

      python3 /app/vllm/benchmarks/benchmark_serving.py --host localhost --port 8000 \
          --model ${model} \
          --dataset-name random \
          --random-input-len ${input_tokens} \
          --random-output-len ${output_tokens} \
          --max-concurrency ${max_concurrency} \
          --num-prompts ${num_prompts} \
          --percentile-metrics ttft,tpot,itl,e2el \
          --ignore-eos
