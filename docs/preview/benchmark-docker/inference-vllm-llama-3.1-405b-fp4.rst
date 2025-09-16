************************************************
Benchmark Llama 3.1 405B FP4 inference with vLLM
************************************************

This section provides instructions to test the inference performance of Llama
3.1 405B on the vLLM inference engine. The accompanying Docker image integrates
`ROCm 7.0 <https://rocm.docs.amd.com/en/latest/>`__ with vLLM, and is tailored
for AMD Instinct MI355X, MI350X, and MI300X series accelerators. This benchmark
does not support other GPUs.

Follow these steps to pull the required image, spin up the container with the
appropriate options, download the model, and run the throughput test.

Pull the Docker image
=====================

Use the following command to pull the `Docker image <https://hub.docker.com/layers/rocm/7.0-preview/rocm7.0_preview_ubuntu_22.04_vllm_0.10.1_instinct_rc1/images/sha256-eee29678dc4dc8f2e054de889555be6f4fd74e58053bf7277d56ace1a850513e>`__.

.. code-block:: shell

   docker pull rocm/7.0:rocm7.0_ubuntu_22.04_vllm_0.10.1_instinct_20250915

Download the model
==================

See the model card on Hugging Face at
`amd/Llama-3.1-405B-Instruct-MXFP4-Preview
<https://huggingface.co/amd/Llama-3.1-405B-Instruct-MXFP4-Preview>`__. This
model uses microscaling 4-bit floating point (MXFP4) quantization via `AMD
Quark <https://quark.docs.amd.com/latest/>`_ for efficient inference on AMD
accelerators.

.. code-block:: shell

   pip install huggingface_hub[cli] hf_transfer hf_xet
   HF_HUB_ENABLE_HF_TRANSFER=1 \
   HF_HOME=/data/huggingface-cache \
   HF_TOKEN="<HF_TOKEN>" \
   huggingface-cli download amd/Llama-3.1-405B-Instruct-MXFP4-Preview --exclude "original/*"

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
        -e VLLM_USE_V1=1 \
        -e VLLM_V1_USE_PREFILL_DECODE_ATTENTION=1 \
        -e AMDGCN_USE_BUFFER_OPS=1 \
        -e VLLM_USE_AITER_TRITON_ROPE=1 \
        -e TRITON_HIP_ASYNC_COPY_BYPASS_PERMUTE=1 \
        -e TRITON_HIP_USE_ASYNC_COPY=1 \
        -e TRITON_HIP_USE_BLOCK_PINGPONG=1 \
        -e TRITON_HIP_ASYNC_FAST_SWIZZLE=1 \
        -e VLLM_ROCM_USE_AITER=1 \
        -e VLLM_ROCM_USE_AITER_RMSNORM=1 \
        -e VLLM_TRITON_FP4_GEMM_USE_ASM=1 \
        -e VLLM_TRITON_FP4_GEMM_SPLITK_USE_BF16=1 \
        -e TRITON_HIP_PRESHUFFLE_SCALES=0 \
        -e VLLM_TRITON_FP4_GEMM_BPRESHUFFLE=0 \
        --name vllm-server \
        rocm/7.0:rocm7.0_ubuntu_22.04_vllm_0.10.1_instinct_20250915

2. Start the server.

   .. code-block:: shell

      max_model_len=10240
      max_num_seqs=1024
      max_num_batched_tokens=131072
      max_seq_len_to_capture=16384
      tensor_parallel_size=8

      vllm serve amd/Llama-3.1-405B-Instruct-MXFP4-Preview \
          --host localhost \
          --port 8000 \
          --swap-space 64 \
          --disable-log-requests \
          --dtype auto \
          --max-model-len ${max_model_len} \
          --tensor-parallel-size ${tensor_parallel_size} \
          --max-num-seqs ${max_num_seqs} \
          --distributed-executor-backend mp \
          --kv-cache-dtype fp8 \
          --gpu-memory-utilization 0.92 \
          --max-seq-len-to-capture ${max_seq_len_to_capture} \
          --max-num-batched-tokens ${max_num_batched_tokens} \
          --no-enable-prefix-caching \
          --async-scheduling

          # Wait for model to load and server is ready to accept requests

3. Open another terminal on the same machine and run the benchmark with the following options.

   .. code-block:: shell

      # Connect to server
      docker exec -it vllm-server bash

      # Run the client benchmark
      input_tokens=1024
      output_tokens=1024
      max_concurrency=4
      num_prompts=32

      python3 /app/vllm/benchmarks/benchmark_serving.py --host localhost --port 8000 \
          --model amd/Llama-3.1-405B-Instruct-MXFP4-Preview \ 
          --dataset-name random \
          --random-input-len ${input_tokens} \
          --random-output-len ${output_tokens} \
          --max-concurrency ${max_concurrency} \
          --num-prompts ${num_prompts} \
          --percentile-metrics ttft,tpot,itl,e2el \
          --ignore-eos

