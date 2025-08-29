******************************************
Benchmark GPT OSS 120B inference with vLLM
******************************************

This section provides instructions to test the inference performance of OpenAI
GPT OSS 120B on the vLLM inference engine. The accompanying Docker image integrates
the ROCm 7.0 Beta with vLLM, and is tailored for AMD Instinct
MI355X, MI350X, and MI300X series accelerators. This benchmark does not support other
GPUs.

Follow these steps to pull the required image, spin up the container with the
appropriate options, download the model, and run the throughput test.

Pull the Docker image
=====================

Use the following command to pull the `Docker image <https://hub.docker.com/layers/rocm/7.0-preview/rocm7.0_preview_ubuntu_22.04_vllm_0.10.1_instinct_beta/images/sha256-ac5bf30a1ce1daf41cc68081ce41b76b1fba6bf44c8fab7ccba01f86d8f619b8>`__.

.. code-block:: shell

   docker pull rocm/7.0-preview:rocm7.0_preview_ubuntu_22.04_vllm_0.10.1_instinct_beta

Download the model
==================

See the model card on Hugging Face at `openai/gpt-oss-120b
<https://huggingface.co/openai/gpt-oss-120b>`__.

.. code-block:: shell

   pip install huggingface_hub[cli] hf_transfer hf_xet
   HF_HUB_ENABLE_HF_TRANSFER=1 \
   HF_HOME=/data/huggingface-cache \
   HF_TOKEN="<HF_TOKEN>" \
   huggingface-cli download openai/gpt-oss-120b --local-dir /data/gpt-oss-120b

Run the inference benchmark
===========================

1. Start the container using the following command.

   .. code-block:: shell

      docker run -it \
          --network host \
          --ipc host \
          --privileged \
          --cap-add=CAP_SYS_ADMIN \
          --device=/dev/kfd \
          --device=/dev/dri \
          --device=/dev/mem \
          --cap-add=SYS_PTRACE \
          --security-opt seccomp=unconfined \
          --shm-size 32G \
          -v /data/huggingface-cache:/root/.cache/huggingface/hub/ \
          -v "$PWD/.vllm_cache/":/root/.cache/vllm/ \
          -v /data/gpt-oss-120b:/data/gpt-oss-120b \
          --name vllm-server \
          rocm/7.0-preview:rocm7.0_preview_ubuntu_22.04_vllm_0.10.1_instinct_beta

2. Set environment variables and start the server.

   .. code-block:: shell

      export VLLM_ROCM_USE_AITER=1
      export VLLM_DISABLE_COMPILE_CACHE=1
      export VLLM_USE_AITER_UNIFIED_ATTENTION=1
      export VLLM_ROCM_USE_AITER_MHA=0
      export VLLM_USE_AITER_TRITON_FUSED_SPLIT_QKV_ROPE=1
      export VLLM_USE_AITER_TRITON_FUSED_ADD_RMSNORM_PAD=1
      export TRITON_HIP_PRESHUFFLE_SCALES=1
      export VLLM_USE_AITER_TRITON_GEMM=1
      export HSA_NO_SCRATCH_RECLAIM=1

      vllm serve /data/gpt-oss-120b/ \
          --tensor-parallel 1 \
          --no-enable-prefix-caching --disable-log-requests \
          --compilation-config '{"compile_sizes": [1, 2, 4, 8, 16, 24, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192], "cudagraph_capture_sizes":[8192,4096,2048,1024,1008,992,976,960,944,928,912,896,880,864,848,832,816,800,784,768,752,736,720,704,688,672,656,640,624,608,592,576,560,544,528,512,496,480,464,448,432,416,400,384,368,352,336,320,304,288,272,256,248,240,232,224,216,208,200,192,184,176,168,160,152,144,136,128,120,112,104,96,88,80,72,64,56,48,40,32,24,16,8,4,2,1], "full_cuda_graph": true}' \
          --block-size 64 \
          --swap-space 16 \
          --gpu-memory-utilization 0.95 \
          --async-scheduling

3. Run the benchmark with the following options.

   .. code-block:: shell

      vllm bench serve \
          --model /data/gpt-oss-120b \
          --backend vllm \
          --host 0.0.0.0 \
          --dataset-name "random" \
          --random-input-len 1024 \
          --random-output-len 1024 \
          --random-prefix-len 0 \
          --num-prompts  32 \
          --max-concurrency 16 \
          --request-rate "inf" \
          --ignore-eos
