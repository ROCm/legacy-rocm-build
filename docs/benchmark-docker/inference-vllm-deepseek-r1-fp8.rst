************************************************
Benchmark DeepSeek R1 FP8 inference with vLLM
************************************************

This section provides instructions to test the inference performance of DeepSeek R1
with FP8 precision on the vLLM inference engine. The provided Docker image integrates
`ROCm 7.0 <https://rocm.docs.amd.com/en/docs-7.0.0/about/release-notes.html>`__ with vLLM.
This benchmark supports AMD Instinct MI355X, MI350X, MI325X, and MI300X GPUs.

Follow these steps to pull the required image, spin up the container with the
appropriate options, download the model, and run the benchmark.

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

See the model card on Hugging Face at
`deepseek-ai/DeepSeek-R1-0528 <https://huggingface.co/deepseek-ai/DeepSeek-R1-0528>`__.

.. code-block:: shell

   model=deepseek-ai/DeepSeek-R1-0528

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

2. Start the server.

   .. code-block:: shell

      model=deepseek-ai/DeepSeek-R1-0528
      max_model_len=16384           # Must be >= the input + the output lengths.
      max_seq_len_to_capture=10240  # Beneficial to set this to max_model_len.
      max_num_seqs=1024
      max_num_batched_tokens=131072 # Smaller values may result in better TTFT but worse TPOT / throughput.
      tensor_parallel_size=8

      # Note: this flag may not be compatible with MI325X GPUs
      export VLLM_ROCM_QUICK_REDUCE_QUANTIZATION=INT4

      # Note: Using `--kv-cache-dtype fp8` with DeepSeek may cause accuracy issues
      vllm serve ${model} \
          --host localhost \
          --port 8000 \
          --swap-space 64 \
          --tensor-parallel-size ${tensor_parallel_size} \
          --max-num-seqs ${max_num_seqs} \
          --no-enable-prefix-caching \
          --max-num-batched-tokens ${max_num_batched_tokens} \
          --max-model-len ${max_model_len} \
          --block-size 1 \
          --gpu-memory-utilization 0.95 \
          --max-seq-len-to-capture ${max_seq_len_to_capture} \
          --async-scheduling

       # Wait for model to load and server is ready to accept requests.

3. Open another terminal on the same machine, connect to your running
   ``vllm-server`` container, and run the benchmark with the appropriate
   options. For example:

   .. code-block:: shell

      # Connect to server
      docker exec -it vllm-server bash

      # Run the client benchmark
      input_tokens=8192
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
