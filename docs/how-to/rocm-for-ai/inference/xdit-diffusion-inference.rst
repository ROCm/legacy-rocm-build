.. meta::
   :description: Learn to validate diffusion model video generation on MI300X, MI350X and MI355X accelerators using
                 prebuilt and optimized docker images.
   :keywords: xDiT, diffusion, video, video generation, image, image generation, validate, benchmark

************************
xDiT diffusion inference
************************

.. _xdit-video-diffusion:

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/xdit-inference-models.yaml

   {% set docker = data.docker %}

   The `rocm/pytorch-xdit <{{ docker.docker_hub_url }}>`_ Docker image offers
   a prebuilt, optimized environment based on `xDiT
   <https://github.com/xdit-project/xDiT>`_ for benchmarking diffusion model
   video and image generation on AMD Instinct MI355X, MI350X (gfx950), MI325X,
   and MI300X (gfx942) GPUs.

   The image runs a preview version of ROCm using the new `TheRock
   <https://github.com/ROCm/TheRock>`__ build system and includes the following
   components:

   .. dropdown:: Software components - {{ docker.pull_tag.split('-')|last }}

      .. list-table::
         :header-rows: 1

         * - Software component
           - Version

         {% for component_name, component_data in docker.components.items() %}
         * - `{{ component_name }} <{{ component_data.url }}>`_
           - {{ component_data.version }}
         {% endfor %}

Follow this guide to pull the required image, spin up a container, download the model, and run a benchmark.
For preview and development releases, see `amdsiloai/pytorch-xdit <https://hub.docker.com/r/amdsiloai/pytorch-xdit>`_.

What's new
==========
.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/xdit-inference-models.yaml

   {% set docker = data.docker %}

   {% for item in docker.whats_new %}
   * {{ item }}
   {% endfor %}

.. _xdit-video-diffusion-supported-models:

Supported models
================

The following models are supported for inference performance benchmarking.
Some instructions, commands, and recommendations in this documentation might
vary by model -- select one to get started.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/xdit-inference-models.yaml

   {% set docker = data.docker %}

   .. raw:: html

      <div id="vllm-benchmark-ud-params-picker" class="container-fluid">
          <div class="row gx-0">
              <div class="col-2 me-1 px-2 model-param-head">Model</div>
              <div class="row col-10 pe-0">
        {% for model_group in docker.supported_models %}
               <div class="col-6 px-2 model-param" data-param-k="model-group" data-param-v="{{ model_group.js_tag }}" tabindex="0">{{ model_group.group }}</div>
        {% endfor %}
              </div>
          </div>

          <div class="row gx-0 pt-1">
              <div class="col-2 me-1 px-2 model-param-head">Variant</div>
              <div class="row col-10 pe-0">
        {% for model_group in docker.supported_models %}
            {% set models = model_group.models %}
            {% for model in models %}
                {% if models|length % 3 == 0 %}
                <div class="col-4 px-2 model-param" data-param-k="model" data-param-v="{{ model.js_tag }}" data-param-group="{{ model_group.js_tag }}" tabindex="0">{{ model.model }}</div>
                {% else %}
                <div class="col-6 px-2 model-param" data-param-k="model" data-param-v="{{ model.js_tag }}" data-param-group="{{ model_group.js_tag }}" tabindex="0">{{ model.model }}</div>
                {% endif %}
            {% endfor %}
        {% endfor %}
              </div>
          </div>
      </div>

   {% for model_group in docker.supported_models %}
       {% for model in model_group.models %}

   .. container:: model-doc {{ model.js_tag }}

      .. note::

         To learn more about your specific model see the `{{ model.model }} model card on Hugging Face <{{ model.url }}>`_
         or visit the `GitHub page <{{ model.github }}>`__. Note that some models require access authorization before use via an
         external license agreement through a third party.

       {% endfor %}
   {% endfor %}

Performance measurements
========================

To evaluate performance, the `Performance results with AMD ROCm software
<https://www.amd.com/en/developer/resources/rocm-hub/dev-ai/performance-results.html#tabs-a8543b7e6d-item-9eda09e707-tab>`__
page provides reference throughput and serving measurements for inferencing popular AI models.

.. important::

   The performance data presented in `Performance results with AMD ROCm
   software
   <https://www.amd.com/en/developer/resources/rocm-hub/dev-ai/performance-results.html#tabs-a8543b7e6d-item-9eda09e707-tab>`__
   only reflects the latest version of this inference benchmarking environment.
   The listed measurements should not be interpreted as the peak performance
   achievable by AMD Instinct GPUs or ROCm software.

System validation
=================

Before running AI workloads, it's important to validate that your AMD hardware is configured
correctly and performing optimally.

If you have already validated your system settings, including aspects like NUMA auto-balancing, you
can skip this step. Otherwise, complete the procedures in the :ref:`System validation and
optimization <rocm-for-ai-system-optimization>` guide to properly configure your system settings
before starting.

To test for optimal performance, consult the recommended :ref:`System health benchmarks
<rocm-for-ai-system-health-bench>`. This suite of tests will help you verify and fine-tune your
system's configuration.

Pull the Docker image
=====================

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/xdit-inference-models.yaml

   {% set docker = data.docker %}

   For this tutorial, it's recommended to use the latest ``{{ docker.pull_tag }}`` Docker image.
   Pull the image using the following command:

   .. code-block:: shell

      docker pull {{ docker.pull_tag }}

Validate and benchmark
======================

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/xdit-inference-models.yaml

   {% set docker = data.docker %}

   Once the image has been downloaded you can follow these steps to
   run benchmarks and generate outputs.

   {% for model_group in docker.supported_models %}
     {% for model in model_group.models %}

   .. container:: model-doc {{model.js_tag}}

      The following commands are written for {{ model.model }}.
      See :ref:`xdit-video-diffusion-supported-models` to switch to another available model.

     {% endfor %}
   {% endfor %}

Choose your setup method
------------------------

You can either use an existing Hugging Face cache or download the model fresh inside the container.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/xdit-inference-models.yaml

   {% set docker = data.docker %}

   {% for model_group in docker.supported_models %}
     {% for model in model_group.models %}
   .. container:: model-doc {{model.js_tag}}

      .. tab-set::

         .. tab-item:: Option 1: Use existing Hugging Face cache

            If you already have models downloaded on your host system, you can mount your existing cache.

            1. Set your Hugging Face cache location.

               .. code-block:: shell

                  export HF_HOME=/your/hf_cache/location

            2. Download the model (if not already cached).

               .. code-block:: shell

                  huggingface-cli download {{ model.model_repo }} {% if model.revision %} --revision {{ model.revision }} {% endif %}

            3. Launch the container with mounted cache.

               .. code-block:: shell

                  docker run \
                      -it --rm \
                      --cap-add=SYS_PTRACE \
                      --security-opt seccomp=unconfined \
                      --user root \
                      --device=/dev/kfd \
                      --device=/dev/dri \
                      --group-add video \
                      --ipc=host \
                      --network host \
                      --privileged \
                      --shm-size 128G \
                      --name pytorch-xdit \
                      -e HSA_NO_SCRATCH_RECLAIM=1 \
                      -e OMP_NUM_THREADS=16 \
                      -e CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 \
                      -e HF_HOME=/app/huggingface_models \
                      -v $HF_HOME:/app/huggingface_models \
                      {{ docker.pull_tag }}

         .. tab-item:: Option 2: Download inside container

            If you prefer to keep the container self-contained or don't have an existing cache.

            1. Launch the container

               .. code-block:: shell

                  docker run \
                      -it --rm \
                      --cap-add=SYS_PTRACE \
                      --security-opt seccomp=unconfined \
                      --user root \
                      --device=/dev/kfd \
                      --device=/dev/dri \
                      --group-add video \
                      --ipc=host \
                      --network host \
                      --privileged \
                      --shm-size 128G \
                      --name pytorch-xdit \
                      -e HSA_NO_SCRATCH_RECLAIM=1 \
                      -e OMP_NUM_THREADS=16 \
                      -e CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 \
                      {{ docker.pull_tag }}

            2. Inside the container, set the Hugging Face cache location and download the model.

               .. code-block:: shell

                  export HF_HOME=/app/huggingface_models
                  huggingface-cli download {{ model.model_repo }} {% if model.revision %} --revision {{ model.revision }} {% endif %}

               .. warning::

                  Models will be downloaded to the container's filesystem and will be lost when the container is removed unless you persist the data with a volume.
     {% endfor %}
   {% endfor %}

Run inference
=============

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/xdit-inference-models.yaml

   {% set docker = data.docker %}

   {% for model_group in docker.supported_models %}
     {% for model in model_group.models %}

   .. container:: model-doc {{ model.js_tag }}

      .. tab-set::

         .. tab-item:: MAD-integrated benchmarking

            1. Clone the ROCm Model Automation and Dashboarding (`<https://github.com/ROCm/MAD>`__) repository to a local
               directory and install the required packages on the host machine.

               .. code-block:: shell

                  git clone https://github.com/ROCm/MAD
                  cd MAD
                  pip install -r requirements.txt

            2. On the host machine, use this command to run the performance benchmark test on
               the `{{model.model}} <{{ model.url }}>`_ model using one node.

               .. code-block:: shell

                  export MAD_SECRETS_HFTOKEN="your personal Hugging Face token to access gated models"
                  madengine run \
                      --tags {{model.mad_tag}} \
                      --keep-model-dir \
                      --live-output
                     
            MAD launches a Docker container with the name
            ``container_ci-{{model.mad_tag}}``. The throughput and serving reports of the
            model are collected in the following paths: ``{{ model.mad_tag }}_throughput.csv``
            and ``{{ model.mad_tag }}_serving.csv``.

         .. tab-item:: Standalone benchmarking

            To run the benchmarks for {{ model.model }}, use the following command:

            .. code-block:: shell
            {% if model.model == "Hunyuan Video" %}
               cd /app/Hunyuanvideo
               mkdir results

               torchrun --nproc_per_node=8 run.py \
                  --model {{ model.model_repo }} \
                  --prompt "In the large cage, two puppies were wagging their tails at each other." \
                  --height 720 --width 1280 --num_frames 129 \
                  --num_inference_steps 50 --warmup_steps 1 --n_repeats 1 \
                  --ulysses_degree 8 \
                  --enable_tiling --enable_slicing \
                  --use_torch_compile \
                  --bench_output results

            {% endif %}
            {% if model.model == "Wan2.1" %}
               cd /app/Wan
               mkdir results

               torchrun --nproc_per_node=8 /app/Wan/run.py \
                  --task i2v \
                  --height 720 \
                  --width 1280 \
                  --model {{ model.model_repo }} \
                  --img_file_path /app/Wan/i2v_input.JPG \
                  --ulysses_degree 8 \
                  --seed 42 \
                  --num_frames 81 \
                  --prompt "Summer beach vacation style, a white cat wearing sunglasses sits on a surfboard. The fluffy-furred feline gazes directly at the camera with a relaxed expression. Blurred beach scenery forms the background featuring crystal-clear waters, distant green hills, and a blue sky dotted with white clouds. The cat assumes a naturally relaxed posture, as if savoring the sea breeze and warm sunlight. A close-up shot highlights the feline's intricate details and the refreshing atmosphere of the seaside." \
                  --num_repetitions 1 \
                  --num_inference_steps 40 \
                  --use_torch_compile

            {% endif %}
            {% if model.model == "Wan2.2" %}
               cd /app/Wan
               mkdir results

               torchrun --nproc_per_node=8 /app/Wan/run.py \
                  --task i2v \
                  --height 720 \
                  --width 1280 \
                  --model {{ model.model_repo }} \
                  --img_file_path /app/Wan/i2v_input.JPG \
                  --ulysses_degree 8 \
                  --seed 42 \
                  --num_frames 81 \
                  --prompt "Summer beach vacation style, a white cat wearing sunglasses sits on a surfboard. The fluffy-furred feline gazes directly at the camera with a relaxed expression. Blurred beach scenery forms the background featuring crystal-clear waters, distant green hills, and a blue sky dotted with white clouds. The cat assumes a naturally relaxed posture, as if savoring the sea breeze and warm sunlight. A close-up shot highlights the feline's intricate details and the refreshing atmosphere of the seaside." \
                  --num_repetitions 1 \
                  --num_inference_steps 40 \
                  --use_torch_compile

            {% endif %}

            {% if model.model == "FLUX.1" %}
               cd /app/Flux
               mkdir results

               torchrun --nproc_per_node=8 /app/Flux/run.py \
                  --model {{ model.model_repo }} \
                  --seed 42 \
                  --prompt "A small cat" \
                  --height 1024 \
                  --width 1024 \
                  --num_inference_steps 25 \
                  --max_sequence_length 256 \
                  --warmup_steps 5 \
                  --no_use_resolution_binning \
                  --ulysses_degree 8 \
                  --use_torch_compile \
                  --num_repetitions 50

            {% endif %}

            {% if model.model == "FLUX.1 Kontext" %}
               cd /app/Flux
               mkdir results

               torchrun --nproc_per_node=8 /app/Flux/run_usp.py \
                  --model {{ model.model_repo }} \
                  --seed 42 \
                  --prompt "Add a cool hat to the cat" \
                  --height 1024 \
                  --width 1024 \
                  --num_inference_steps 30 \
                  --max_sequence_length 512 \
                  --warmup_steps 5 \
                  --no_use_resolution_binning \
                  --ulysses_degree 8 \
                  --use_torch_compile \
                  --img_file_path /app/Flux/cat.png \
                  --model_type flux_kontext \
                  --guidance_scale 2.5 \
                  --num_repetitions 25

            {% endif %}

            {% if model.model == "FLUX.2" %}
               cd /app/Flux
               mkdir results

               torchrun --nproc_per_node=8 /app/Flux/run_usp.py \
                  --model {{ model.model_repo }} \
                  --seed 42 \
                  --prompt "Add a cool hat to the cat" \
                  --height 1024 \
                  --width 1024 \
                  --num_inference_steps 50 \
                  --max_sequence_length 512 \
                  --warmup_steps 5 \
                  --no_use_resolution_binning \
                  --ulysses_degree 8 \
                  --use_torch_compile \
                  --img_file_paths /app/Flux/cat.png \
                  --model_type flux2 \
                  --guidance_scale 4.0 \
                  --num_repetitions 25

            {% endif %}

            {% if model.model == "stable-diffusion-3.5-large" %}
               cd /app/StableDiffusion3.5 
               mkdir results

               torchrun --nproc_per_node=8 /app/StableDiffusion3.5/run.py \
                  --model {{ model.model_repo }} \
                  --num_inference_steps 28 \
                  --prompt "A capybara holding a sign that reads Hello World" \
                  --use_torch_compile \
                  --pipefusion_parallel_degree 4 \
                  --use_cfg_parallel \
                  --num_repetitions 50 \
                  --dtype torch.float16 \
                  --output_path results

            {% endif %}

            The generated video will be stored under the results directory. For the actual benchmark step runtimes, see {% if model.model == "Hunyuan Video" %}stdout.{% elif model.model in ["Wan2.1", "Wan2.2"] %}results/outputs/rank0_*.json{% elif model.model in ["FLUX.1", "FLUX.1 Kontext", "FLUX.2"] %}results/timing.json{% elif model.model == "stable-diffusion-3.5-large"%}benchmark_results.csv{% endif %}

            {% if model.model == "FLUX.1" %}You may also use ``run_usp.py`` which implements USP without modifying the default diffusers pipeline. {% endif %}

      {% endfor %}
    {% endfor %}

Previous versions
=================

See :doc:`benchmark-docker/previous-versions/xdit-history` to find documentation for previous releases
of xDiT diffusion inference performance testing.
