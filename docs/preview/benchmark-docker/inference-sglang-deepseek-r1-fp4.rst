**************************************************
Benchmarking DeepSeek R1 FP4 inference with SGLang
**************************************************

This section provides instructions to test the inference performance of DeepSeek R1
with FP4 precision via the SGLang serving framework.
The accompanying Docker image integrates the ROCm 7.0 Alpha with SGLang, and is
tailored for AMD Instinct MI355X and MI350X accelerators. This
benchmark does not support other accelerators.

Follow these steps to pull the required image, spin up the container with the
appropriate options, download the model, and run the throughput test.

1. Pull the Docker image.

   .. code-block:: shell

      docker pull rocm/7.0-preview:rocm7.0_preview_ubuntu_22.04_sglang_0.4.6.post4_mi35X_alpha

2. Download the model.

   .. code-block:: shell

      pip install huggingface_hub[cli] hf_transfer hf_xet
      HF_HUB_ENABLE_HF_TRANSFER=1 \
      HF_HOME=/data/huggingface-cache \
      HF_TOKEN="<HF_TOKEN>" \
      huggingface-cli download amd/DeepSeek-R1-MXFP4-Preview --exclude "original/*"

3. Run the inference benchmark.

   Start the container using the following command.

   .. code-block:: shell

      docker run -it --rm --ipc=host --network host --security-opt seccomp=unconfined \
          --device=/dev/kfd --device=/dev/dri \
          -v /data:/data \
          -e HF_HOME=/data/huggingface-cache \
          -e HF_HUB_OFFLINE=1 \
          -e NCCL_MIN_NCHANNELS=112 \
          -e SGLANG_JPVILLAM_UPCAST_LINEAR=0 \
          -e TRITON_ALLOW_NON_CONSTEXPR_GLOBALS=1 \
          -e AMDGCN_USE_BUFFER_OPS=1 \
          -e TRITON_HIP_ASYNC_COPY_BYPASS_PERMUTE=1 \
          -e TRITON_HIP_ASYNC_FAST_SWIZZLE=1 \
          -e TRITON_HIP_USE_ASYNC_COPY=1 \
          -e TRITON_HIP_USE_BLOCK_PINGPONG=0 \
          -e SGLANG_MXFP4_WEIGHT=0 \
          -e SGLANG_AITER_MOE=1 \
          -e SGLANG_AITER_NORM=1 \
          -e AITER_GEMM=1 \
          -e AITER_MLA_DECODE=1 \
          -e AITER_PREFILL=1 \
          -e AITER_ROPE=1 \
          rocm/7.0-preview:rocm7.0_preview_ubuntu_22.04_sglang_0.4.6.post4_mi35X_alpha

   Start the server.

   .. code-block:: shell

      python3 -m sglang.launch_server \
          --model-path amd/DeepSeek-R1-MXFP4-Preview \
          --host localhost \
          --port 8000 \
          --log-requests \
          --tensor-parallel-size 8 \
          --trust-remote-code \
          --chunked-prefill-size 131072 \
          --mem-fraction-static 0.95 \
          --disable-radix-cache \
          --n-share-experts-fusion 8 \
          --num-continuous-decode-steps 4 \
          --enable-torch-compile \
          --torch-compile-max-bs 64 

   Run the benchmark with the following options.

   .. code-block:: shell

      input_tokens=3200 
      output_tokens=800 
      max_concurrency=1 
      num_prompts=$((max_concurrency*8)) 

      python3 -m sglang.bench_serving \
          --host localhost \
          --port 8000 \
          --model amd/DeepSeek-R1-MXFP4-Preview \
          --dataset-name random \
          --random-input ${input_tokens} \
          --random-output ${output_tokens} \
          --random-range-ratio 1.0 \
          --max-concurrency ${max_concurrency} \
          --num-prompt ${num_prompts}

