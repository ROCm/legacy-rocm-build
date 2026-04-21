***********************************************
Benchmark DeepSeek R1 FP8 inference with SGLang
***********************************************

This section provides instructions to test the inference performance of DeepSeek R1
with FP8 precision via the SGLang serving framework.
The accompanying Docker image integrates ROCm 7.0 with SGLang, and is
supported on AMD Instinct MI355X, MI350X, MI325X, and MI300X GPUs.

Follow these steps to pull the required image, spin up the container with the
appropriate options, download the model, and run the benchmark.

Pull the Docker image
=====================

Use the following command to pull the appropriate `Docker image <https://hub.docker.com/r/rocm/7.0/tags>`__
for your system.

.. tab-set::

   .. tab-item:: MI355X and MI350X
      :sync: mi35x

      .. code-block:: shell

         docker pull rocm/7.0:rocm7.0_ubuntu_22.04_sgl-dev-v0.5.2-rocm7.0-mi35x-20250915

   .. tab-item:: MI300X series
      :sync: mi30x

      .. code-block:: shell

         docker pull rocm/7.0:rocm7.0_ubuntu_22.04_sgl-dev-v0.5.2-rocm7.0-mi30x-20250915

Download the model
==================

See the model card on Hugging Face at `deepseek-ai/DeepSeek-R1-0528
<https://huggingface.co/deepseek-ai/DeepSeek-R1-0528>`__.

.. code-block:: shell

   pip install huggingface_hub hf_transfer hf_xet
   HF_HUB_ENABLE_HF_TRANSFER=1 \
   HF_HOME=/data/huggingface-cache \
   HF_TOKEN="<HF_TOKEN>" \
   hf download deepseek-ai/DeepSeek-R1-0528 --exclude "original/*"

Run the inference benchmark
===========================

1. Start the container using the following command.

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: mi35x

         .. code-block:: shell

            docker run -it \
                --user root \
                --group-add video \
                --cap-add=SYS_PTRACE \
                --security-opt seccomp=unconfined \
                -w /app/ \
                --ipc=host \
                --network=host \
                --shm-size 64G \
                --mount type=bind,src=/data,dst=/data \
                --device=/dev/kfd \
                --device=/dev/dri \
                -e SGLANG_USE_AITER=1 \
                rocm/7.0:rocm7.0_ubuntu_22.04_sgl-dev-v0.5.2-rocm7.0-mi35x-20250915

      .. tab-item:: MI300X series
         :sync: mi30x

         .. code-block:: shell

            docker run -it \
                --user root \
                --group-add video \
                --cap-add=SYS_PTRACE \
                --security-opt seccomp=unconfined \
                -w /app/ \
                --ipc=host \
                --network=host \
                --shm-size 64G \
                --mount type=bind,src=/data,dst=/data \
                --device=/dev/kfd \
                --device=/dev/dri \
                -e SGLANG_USE_AITER=1 \
                rocm/7.0:rocm7.0_ubuntu_22.04_sgl-dev-v0.5.2-rocm7.0-mi30x-20250915

2. Start the server.

   .. code-block:: shell

      python3 -m sglang.launch_server \
          --model-path deepseek-ai/DeepSeek-R1-0528 \
          --host localhost \
          --port 8000 \
          --tensor-parallel-size 8 \
          --trust-remote-code \
          --chunked-prefill-size 196608 \
          --mem-fraction-static 0.8 \
          --disable-radix-cache \
          --num-continuous-decode-steps 4 \
          --max-prefill-tokens 196608 \
          --cuda-graph-max-bs 128 &

3. Run the benchmark with the following options.

   .. code-block:: shell

      input_tokens=1024
      output_tokens=1024
      max_concurrency=64
      num_prompts=128

      python3 -m sglang.bench_serving \
          --host localhost \
          --port 8000 \
          --model deepseek-ai/DeepSeek-R1-0528 \
          --dataset-name random \
          --random-input ${input_tokens} \
          --random-output ${output_tokens} \
          --random-range-ratio 1.0 \
          --max-concurrency ${max_concurrency} \
          --num-prompt ${num_prompts}

