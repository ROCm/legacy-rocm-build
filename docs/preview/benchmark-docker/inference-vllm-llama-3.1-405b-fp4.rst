***************************************************
Benchmarking Llama 3.1 405B FP4 inference with vLLM
***************************************************

.. note::

   For the latest iteration of AI training and inference performance for ROCm
   7.0, see `Infinity Hub
   <https://www.amd.com/en/developer/resources/infinity-hub.html#q=ROCm%207>`__
   and the `ROCm 7.0 AI training and inference performance
   <https://rocm.docs.amd.com/en/docs-7.0-docker/benchmark-docker/index.html>`__
   documentation.

This section provides instructions to test the inference performance of Llama
3.1 405B on the vLLM inference engine. The accompanying Docker image integrates
the ROCm 7.0 Alpha with vLLM, and is tailored for AMD Instinct
MI355X and MI350X accelerators. This benchmark does not support other
accelerators.

Follow these steps to pull the required image, spin up the container with the
appropriate options, download the model, and run the throughput test.

1. Pull the `Docker image <https://hub.docker.com/layers/rocm/7.0-preview/rocm7.0_preview_ubuntu_22.04_vllm_0.9.1_mi35x_alpha/images/sha256-3ab87887724b75e5d1d2306a04afae853849ec3aabf8f9ee6335d766b3d0eaa0>`__.

   .. code-block:: shell

      docker pull rocm/7.0-preview:rocm7.0_preview_ubuntu_22.04_vllm_0.9.1_mi35x_alpha

2. Download the model.

   .. code-block:: shell

      pip install huggingface_hub[cli] hf_transfer hf_xet
      HF_HUB_ENABLE_HF_TRANSFER=1 \
      HF_HOME=/data/huggingface-cache \
      HF_TOKEN="<HF_TOKEN>" \
      huggingface-cli download amd/Llama-3.1-405B-Instruct-MXFP4-Preview --exclude "original/*"

   .. note::

      This model uses microscaling 4-bit floating point (MXFP4) quantization
      via `AMD Quark <https://quark.docs.amd.com/latest/>`_ for efficient
      inference on AMD accelerators. See the model card on Hugging Face at
      `amd/Llama-3.1-405B-Instruct-MXFP4-Preview
      <https://huggingface.co/amd/Llama-3.1-405B-Instruct-MXFP4-Preview>`__.

3. Run the inference benchmark.

   Start the container using the following command.

   .. code-block:: shell

      docker run -it \
          --ipc=host \
          --network=host \
          --privileged \
          --cap-add=CAP_SYS_ADMIN \
          --cap-add=SYS_PTRACE \
          --security-opt seccomp=unconfined \
          -e USE_FASTSAFETENSOR=1 \
          -e SAFETENSORS_FAST_GPU=1 \
          -e VLLM_TRITON_FP4_GEMM_USE_ASM=1 \
          -e VLLM_USE_AITER_TRITON_ROPE=1 \
          -e VLLM_USE_AITER_TRITON_SILU_MUL=1 \
          -e TRITON_HIP_ASYNC_COPY_BYPASS_PERMUTE=1 \
          -e AMDGCN_USE_BUFFER_OPS=1 \
          -e TRITON_HIP_USE_ASYNC_COPY=1 \
          -e TRITON_HIP_USE_BLOCK_PINGPONG=1 \
          -e TRITON_HIP_ASYNC_FAST_SWIZZLE=1 \
          -e TRITON_HIP_PRESHUFFLE_SCALES=1 \
          -e VLLM_ROCM_USE_AITER=1 \
          -e VLLM_ROCM_USE_AITER_PAGED_ATTN=1 \
          -e VLLM_ROCM_USE_AITER_RMSNORM=1 \
          -e VLLM_USE_V1=0 \
          rocm/7.0-preview:rocm7.0_preview_ubuntu_22.04_vllm_0.9.1_mi35x_alpha

   Run the ``benchmark_throughput.py`` script.

   .. code-block:: shell

      input_tokens=128
      output_tokens=128
      num_prompts=16384
      max_num_seqs=1024
      max_num_batched_tokens=16384
      max_model_len=8192 

      python3 /app/vllm/benchmarks/benchmark_throughput.py \
            --model amd/Llama-3.1-405B-Instruct-MXFP4-Preview \
            --input-len ${input_tokens} \
            --output-len ${output_tokens} \
            --tensor-parallel-size 1 \
            --num-prompts ${num_prompts} \
            --dtype auto \
            --gpu-memory-utilization 0.98 \
            --max-model-len ${max_model_len} \
            --distributed-executor-backend mp \
            --max-num-batched-tokens ${max_num_batched_tokens} \
            --no-enable-prefix-caching \
            --max-num-seqs ${max_num_seqs} \
            --disable-detokenize \
            --kv-cache-dtype fp8 \
            --num-scheduler-steps 128 
