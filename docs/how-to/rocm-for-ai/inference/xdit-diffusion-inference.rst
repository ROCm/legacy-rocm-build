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

   The `rocm/pytorch-xdit <{{ docker.docker_hub_url }}>`_ Docker image offers a prebuilt, optimized environment based on `xDiT <https://github.com/xdit-project/xDiT>`_ for
   benchmarking diffusion model video and image generation on gfx942 and gfx950 series (AMD Instinct™ MI300X, MI325X, MI350X, and MI355X) GPUs.
   The image runs ROCm **{{docker.ROCm}}** (preview) based on `TheRock <https://github.com/ROCm/TheRock>`_
   and includes the following components:

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

               {{ model.benchmark_command
                  | map('replace', '{model_repo}', model.model_repo)
                  | map('trim')
                  | join('\n               ') }}

            The generated video will be stored under the results directory.

            {% if model.model == "FLUX.1" %}You may also use ``run_usp.py`` which implements USP without modifying the default diffusers pipeline. {% endif %}

      {% endfor %}
    {% endfor %}
