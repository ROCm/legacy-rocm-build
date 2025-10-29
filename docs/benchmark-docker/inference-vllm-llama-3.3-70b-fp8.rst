************************************************
Benchmark Llama 3.3/3.1 FP8 inference with vLLM
************************************************

This section provides instructions to test the inference performance of Llama
3.3 70B and Llama 3.1 405B with FP8 precision on the vLLM inference engine. The provided Docker image integrates
`ROCm 7.0 <https://rocm.docs.amd.com/en/docs-7.0.0/about/release-notes.html>`__ with vLLM.
This benchmark supports AMD Instinct MI355X, MI350X, MI325X, and MI300X GPUs.

Follow these steps to pull the required image, spin up the container with the
appropriate options, download the model, and run the throughput test.

Pull the Docker image
=====================

Use the following command to pull the `Docker image <https://hub.docker.com/r/rocm/7.x-preview/tags>`__.

.. code-block:: shell

   docker pull rocm/7.x-preview:rocm7.2_preview_ubuntu_22.04_vlm_0.10.1_instinct_20251029

Download the model
==================

While vLLM can download model weights at runtime, it's recommended to
download ahead of time. You will need:

* A valid `Hugging Face access token <https://huggingface.co/docs/hub/security-tokens>`__.
  Remember to set ``HF_TOKEN`` to your access token.

* Access granted to the specific model from your Hugging Face account

In the following snippet, set ``HF_TOKEN`` to your access token.

.. tab-set::

   .. tab-item:: Llama 3.3 70B FP8
      :sync: Llama-3.3-70B-Instruct-FP8-KV

      See the model card on Hugging Face at
      `amd/Llama-3.3-70B-Instruct-FP8-KV <https://huggingface.co/amd/Llama-3.3-70B-Instruct-FP8-KV>`__.
      This model uses FP8 quantization via `AMD Quark
      <https://quark.docs.amd.com/latest/>`_ for efficient inference on AMD
      accelerators.

      .. code-block:: shell

         model=amd/Llama-3.3-70B-Instruct-FP8-KV

         pip install huggingface_hub[cli] hf_transfer hf_xet
         HF_HUB_ENABLE_HF_TRANSFER=1 \
         HF_HOME=/data/huggingface-cache \
         HF_TOKEN="<HF_TOKEN>" \ # Replace with your HF_TOKEN Hugging Face access token.
         huggingface-cli download ${model} --exclude "original/*"

   .. tab-item:: Llama 3.1 405B FP8
      :sync: Llama-3.1-405B-Instruct-FP8-KV

      See the model card on Hugging Face at
      `amd/Llama-3.1-405B-Instruct-FP8-KV <https://huggingface.co/amd/Llama-3.1-405B-Instruct-FP8-KV>`__.
      This model uses FP8 quantization via `AMD Quark
      <https://quark.docs.amd.com/latest/>`_ for efficient inference on AMD
      accelerators.

      .. code-block:: shell

         model=amd/Llama-3.1-405B-Instruct-FP8-KV

         pip install huggingface_hub[cli] hf_transfer hf_xet
         HF_HUB_ENABLE_HF_TRANSFER=1 \
         HF_HOME=/data/huggingface-cache \
         HF_TOKEN="<HF_TOKEN>" \ # Replace with your HF_TOKEN Hugging Face access token.
         huggingface-cli download ${model} --exclude "original/*"

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
        rocm/7.x-preview:rocm7.2_preview_ubuntu_22.04_vlm_0.10.1_instinct_20251029

2. Start the server. On MI300X and MI325X GPUs, include ``--dtype float16`` in your ``vllm serve`` arguments.
   This is not necessary on MI350X and MI355X GPUs.

   .. tab-set::

      .. tab-item:: Llama 3.3 70B FP8
         :sync: Llama-3.3-70B-Instruct-FP8-KV

         .. code-block:: shell

            model=amd/Llama-3.3-70B-Instruct-FP8-KV

      .. tab-item:: Llama 3.1 405B FP8
         :sync: Llama-3.1-405B-Instruct-FP8-KV

         .. code-block:: shell

            model=amd/Llama-3.1-405B-Instruct-FP8-KV

   .. code-block:: shell

      max_model_len=10240           # Must be >= the input + the output lengths.
      max_seq_len_to_capture=10240  # Beneficial to set this to max_model_len.
      max_num_seqs=1024
      max_num_batched_tokens=131072 # Smaller values may result in better TTFT but worse TPOT / throughput.
      tensor_parallel_size=8

      # Note: this flag may not be compatible with MI325X GPUs
      export VLLM_ROCM_QUICK_REDUCE_QUANTIZATION=INT4

      # 0 is recommended for most configurations.
      # 1 (the default) is faster for input lengths of 8192 with concurrency > 16.
      export VLLM_ROCM_USE_AITER_MHA=0

      vllm serve ${model} \
          --host localhost \
          --port 8000 \
          --swap-space 64 \
          --max-model-len ${max_model_len} \
          --tensor-parallel-size ${tensor_parallel_size} \
          --max-num-seqs ${max_num_seqs} \
          --distributed-executor-backend mp \
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

      .. tab-item:: Llama 3.3 70B FP8
         :sync: Llama-3.3-70B-Instruct-FP8-KV

         .. code-block:: shell

            model=amd/Llama-3.3-70B-Instruct-FP8-KV

      .. tab-item:: Llama 3.1 405B FP8
         :sync: Llama-3.1-405B-Instruct-FP8-KV

         .. code-block:: shell

            model=amd/Llama-3.1-405B-Instruct-FP8-KV

   .. code-block:: shell

      # Run the client benchmark
      input_tokens=1024
      output_tokens=1024
      max_concurrency=4
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
