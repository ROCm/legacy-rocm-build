************************************************
Benchmark DeepSeek R1 FP8 inference with vLLM
************************************************

This section provides instructions to test the inference performance of DeepSeek R1
with FP8 precision on the vLLM inference engine. The accompanying Docker image integrates
`ROCm 7.0 <https://rocm.docs.amd.com/en/latest/>`__ with vLLM, and is tailored
for AMD Instinct MI355X, MI350X, and MI300X series accelerators. This benchmark
does not support other GPUs.

Follow these steps to pull the required image, spin up the container with the
appropriate options, download the model, and run the benchmark.

Pull the Docker image
=====================

Use the following command to pull the `Docker image <https://hub.docker.com/r/rocm/7.0/tags>`__.

.. code-block:: shell

   docker pull rocm/7.0:rocm7.0_ubuntu_22.04_vllm_0.10.1_instinct_20250915

Download the model
==================

See the model card on Hugging Face at
`deepseek-ai/DeepSeek-R1-0528 <https://huggingface.co/deepseek-ai/DeepSeek-R1-0528>`__.

.. code-block:: shell

   pip install huggingface_hub[cli] hf_transfer hf_xet
   HF_HUB_ENABLE_HF_TRANSFER=1 \
   HF_HOME=/data/huggingface-cache \
   HF_TOKEN="<HF_TOKEN>" \
   huggingface-cli download deepseek-ai/DeepSeek-R1-0528 --exclude "original/*"

Run the inference benchmark
===========================

.. _docker-run-vllm-ds:

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
        -e VLLM_USE_AITER_TRITON_ROPE=1 \
        -e VLLM_ROCM_USE_AITER=1 \
        -e VLLM_ROCM_USE_AITER_PAGED_ATTN=0 \
        -e VLLM_ROCM_USE_AITER_RMSNORM=1 \
        -e VLLM_USE_AITER_TRITON_SILU_MUL=0 \
        --name vllm-server \
        rocm/7.0:rocm7.0_ubuntu_22.04_vllm_0.10.1_instinct_20250915

2. Start the server.

   .. code-block:: shell

      max_model_len=10240
      max_num_seqs=1024
      max_num_batched_tokens=131072
      max_seq_len_to_capture=10240
      tensor_parallel_size=8

      vllm serve deepseek-ai/DeepSeek-R1-0528 \
          --host localhost \
          --port 8000 \
          --swap-space 64 \
          --max-model-len ${max_model_len} \
          --tensor-parallel-size ${tensor_parallel_size} \
          --max-num-seqs ${max_num_seqs} \
          --gpu-memory-utilization 0.95 \
          --max-seq-len-to-capture ${max_seq_len_to_capture} \
          --max-num-batched-tokens ${max_num_batched_tokens} \
          --no-enable-prefix-caching \
          --block-size 1 \
          --async-scheduling

          # Wait for model to load and server is ready to accept requests

3. Open another terminal on the same machine and run the benchmark with the following options.

   .. code-block:: shell

      # Connect to server
      docker exec -it vllm-server bash

      # Run the client benchmark
      input_tokens=8192
      output_tokens=1024
      max_concurrency=4
      num_prompts=32

      python3 /app/vllm/benchmarks/benchmark_serving.py --host localhost --port 8000 \
          --model deepseek-ai/DeepSeek-R1-0528 \ 
          --dataset-name random \
          --random-input-len ${input_tokens} \
          --random-output-len ${output_tokens} \
          --max-concurrency ${max_concurrency} \
          --num-prompts ${num_prompts} \
          --percentile-metrics ttft,tpot,itl,e2el \
          --ignore-eos
