**********************************************
Benchmark GPT OSS 120B inference with vLLM
**********************************************

This section provides instructions to test the inference performance of OpenAI
GPT OSS 120B on the vLLM inference engine. The provided Docker
image integrates `ROCm 7.0
<https://rocm.docs.amd.com/en/docs-7.0.0/about/release-notes.html>`__ with
vLLM. This benchmark supports AMD Instinct MI355X, MI350X, MI325X, and MI300X
GPUs.

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

See the model card on Hugging Face at
`openai/gpt-oss-120b <https://huggingface.co/openai/gpt-oss-120b>`__.

.. code-block:: shell

   model=openai/gpt-oss-120b

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

      .. tab-item:: MI355X and MI350X
         :sync: mi35x

         .. code-block:: shell

            model=openai/gpt-oss-120b
            max_model_len=10368           # 1.125 x (input sequence length + output sequence length); e.g. 1.125 x (8192 + 1024) = 10368.
            max_seq_len_to_capture=10368  # Beneficial to set this to max_model_len.
            max_num_seqs=1024             # Set to max_concurrency of the client to get better throughput.
            tensor_parallel_size=8

            export VLLM_USE_AITER_UNIFIED_ATTENTION=1
            export VLLM_ROCM_USE_AITER_MHA=0
            export VLLM_ROCM_USE_AITER_FUSED_MOE_A16W4=1

            vllm serve ${model} \
                --port 8000 \
                --swap-space 64 \
                --max-model-len ${max_model_len} \
                --tensor-parallel-size ${tensor_parallel_size} \
                --max-num-seqs ${max_num_seqs} \
                --gpu-memory-utilization 0.95 \
                --max-seq-len-to-capture ${max_seq_len_to_capture} \
                --compilation-config '{"compile_sizes":[1,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,118,120,122,124,126,128,256,512,1024,2048,8192] , "cudagraph_capture_sizes":[1,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,118,120,122,124,126,128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248,256,264,272,280,288,296,304,312,320,328,336,344,352,360,368,376,384,392,400,408,416,424,432,440,448,456,464,472,480,488,496,504,512,520,528,536,544,552,560,568,576,584,592,600,608,616,624,632,640,648,656,664,672,680,688,696,704,712,720,728,736,744,752,760,768,776,784,792,800,808,816,824,832,840,848,856,864,872,880,888,896,904,912,920,928,936,944,952,960,968,976,984,992,1000,1008,1016,1024,2048,4096,8192] , "cudagraph_mode": "FULL_AND_PIECEWISE"}' \
                --block-size=64 \
                --no-enable-prefix-caching \
                --async-scheduling

             # Wait for model to load and server is ready to accept requests.

      .. tab-item:: MI325X and MI300X
         :sync: mi30x

         .. code-block:: shell

            model=openai/gpt-oss-120b
            max_model_len=10368           # 1.125 x (input sequence length + output sequence length); e.g. 1.125 x (8192 + 1024) = 10368.
            max_seq_len_to_capture=10368  # Beneficial to set this to max_model_len.
            max_num_seqs=1024             # Set to max_concurrency of the client to get better throughput.
            tensor_parallel_size=8

            export VLLM_USE_AITER_UNIFIED_ATTENTION=1
            export VLLM_ROCM_USE_AITER_MHA=0
            export VLLM_ROCM_USE_AITER_TRITON_BF16_GEMM=0

            # Set this flag for MI300X only; it is not yet compatible with MI325X.
            # export VLLM_ROCM_QUICK_REDUCE_QUANTIZATION=INT4

            vllm serve ${model} \
                --port 8000 \
                --swap-space 64 \
                --max-model-len ${max_model_len} \
                --tensor-parallel-size ${tensor_parallel_size} \
                --max-num-seqs ${max_num_seqs} \
                --gpu-memory-utilization 0.95 \
                --max-seq-len-to-capture ${max_seq_len_to_capture} \
                --compilation-config '{"cudagraph_mode": "FULL_AND_PIECEWISE"}' \
                --block-size=64 \
                --no-enable-prefix-caching \
                --async-scheduling

             # Wait for model to load and server is ready to accept requests.

3. Open another terminal on the same machine, connect to your running
   ``vllm-server`` container, and run the benchmark with the appropriate
   options. For example:

   .. code-block:: shell

      # Connect to server
      docker exec -it vllm-server bash

   .. code-block:: shell

      # Run the client benchmark
      model=openai/gpt-oss-120b
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
