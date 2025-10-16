.. meta::
   :description: Learn to validate diffusion model video generation on MI300X, MI350X and MI355X accelerators using
                 prebuilt and optimized docker images.
   :keywords: xDiT, diffusion, video, video generation, validate, benchmark

********************
xDiT video inference
********************

.. _xdit-video-diffusion:

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/xdit-inference-models.yaml

    {% set docker = data.xdit_video_diffusion.docker %}
    {% set model_groups = data.xdit_video_diffusion.model_groups%}

    The `amdsiloai/pytorch-xdit Docker <{{ docker.docker_hub_url }}>`_ image offers a prebuilt, optimized environment based on `xDiT <https://github.com/xdit-project/xDiT>`_ for
    benchmarking diffusion model video generation on gfx942 series (AMD Instinct™ MI300X) and
    gfx950 series (AMD Instinct™ MI350X and MI355X) accelerators.

    Follow this guide to pull the required image, spin up a container, download the model and run a benchmark.

    .. _xdit-video-diffusion-supported-models:

    Supported models
    ================

    The following models are supported for inference performance benchmarking.
    Some instructions, commands, and recommendations in this documentation might
    vary by model -- select one to get started.

    .. raw:: html
        
        <div id="vllm-benchmark-ud-params-picker" class="container-fluid">
            <div class="row gx-0">
                <div class="col-2 me-1 px-2 model-param-head">Model</div>
                <div class="row col-10 pe-0">
        {% for model_group in model_groups %}
                <div class="col-3 px-2 model-param" data-param-k="model-group" data-param-v="{{ model_group.tag }}" tabindex="0">{{ model_group.group }}</div>
        {% endfor %}
                </div>
            </div>

            <div class="row gx-0 pt-1">
                <div class="col-2 me-1 px-2 model-param-head">Variant</div>
                <div class="row col-10 pe-0">
        {% for model_group in model_groups %}
            {% set models = model_group.models %}
            {% for model in models %}
                {% if models|length % 3 == 0 %}
                <div class="col-4 px-2 model-param" data-param-k="model" data-param-v="{{ model.model_name }}" data-param-group="{{ model_group.tag }}" tabindex="0">{{ model.model }}</div>
                {% else %}
                <div class="col-6 px-2 model-param" data-param-k="model" data-param-v="{{ model.model_name }}" data-param-group="{{ model_group.tag }}" tabindex="0">{{ model.model }}</div>
                {% endif %}
            {% endfor %}
        {% endfor %}
                </div>
            </div>
        </div>

    {% for model_group in model_groups %}
        {% for model in model_group.models %}

    .. container:: model-doc {{model.model_name}}

        To learn more about your specific model see the `{{ model.model }} model card on Hugging Face <{{ model.url }}>`_ 
        or visit the `GitHub page <{{ model.github }}>`_. Note that some models require access authorization before use via an
        external license agreement through a third party.

        {% endfor %}
    {% endfor %}

    Pull the Docker image
    ===================== 

    For this tutorial it's recommended to use the following docker image, which can be pulled
    with the command

    .. code-block:: shell

        docker pull amdsiloai/pytorch-xdit:v25.9

    .. admonition:: Release notes for v25.9

        - Initial release
        - ROCm: 7.0.0rc
        - Add support for gfx942 series (AMD Instinct™ MI300X) and gfx950 series (AMD Instinct™ MI350X and MI355X)
        - Add support for Wan 2.1, Wan 2.2 and HunyanVideo with MIOpen optimizations

    .. admonition:: OOB Tuning

        Currently only MI300X has been tuned for in the gfx942 series. Other variants might not perform optimally out-of-the-box.

    Validate and Benchmark
    ======================

    Once the image has been downloaded you can follow these steps to 
    run benchmarks and generate a video.

    .. warning::
        If your host/OS ROCm installation is below 6.4.2 (see with ``apt show rocm-libs``) you need to export
        the ``HSA_NO_SCRATCH_RECLAIM=1`` environment variable inside the container, or the workload will crash.
        If possible, ask your system administrator to upgrade ROCm.

    {% for model_group in model_groups %}
        {% for model in model_group.models %}

    .. container:: model-doc {{model.model_name}}

        .. tab-set::

            .. tab-item:: Standalone benchmarking

                The following commands are written for {{ model.model }}.
                See :ref:`xdit-video-diffusion-supported-models` to switch to another available model.

                .. rubric:: Choose Your Setup Method
                
                You can either use an existing HuggingFace cache or download the model fresh inside the container.

                .. tab-set::

                    .. tab-item:: Option 1: Use Existing HuggingFace Cache 

                        If you already have models downloaded on your host system, you can mount your existing cache.

                        **Step 1:** Set your HuggingFace cache location

                        .. code-block:: shell

                            export HF_HOME=/your/hf_cache/location

                        **Step 2:** Download the model (if not already cached)

                        .. code-block:: shell

                            huggingface-cli download {{ model.model_repo }} {% if model.revision %} --revision {{ model.revision }} {% endif %}

                        **Step 3:** Launch the container with mounted cache

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
                                -e CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 \
                                -e HF_HOME=$HF_HOME \
                                -v $HF_HOME:$HF_HOME \
                                {{ docker.pull_tag }}

                    .. tab-item:: Option 2: Download Inside Container

                        If you prefer to keep the container self-contained or don't have an existing cache.

                        **Step 1:** Launch the container

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
                                -e CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 \
                                {{ docker.pull_tag }}

                        **Step 2:** Inside the container, set the HuggingFace cache location and download the model

                        .. code-block:: shell

                            export HF_HOME=/your/hf_cache/location
                            huggingface-cli download {{ model.model_repo }} {% if model.revision %} --revision {{ model.revision }} {% endif %}

                        .. warning::
                            Models will be downloaded to the container's filesystem and will be lost when the container is removed unless you persist the data with a volume.

                .. rubric:: Run model

                To run benchmarks use the following command

                .. code-block:: shell
                    {% if model.model == "Hunyuan Video" %}
                        cd /app/Hunyuanvideo
                        mkdir results

                        torchrun --nproc_per_node=8 run.py \
                            --model tencent/HunyuanVideo \
                            --prompt "In the large cage, two puppies were wagging their tails at each other." \
                            --height 720 --width 1280 --num_frames 129 \
                            --num_inference_steps 50 --warmup_steps 1 --n_repeats 1 \
                            --ulysses_degree 8 \
                            --enable_tiling --enable_slicing \
                            --use_torch_compile \
                            --bench_output results
                    {% endif %}
                    {% if model.model == "Wan2.1" %}
                        cd Wan2.1
                        mkdir results

                        torchrun --nproc_per_node=8 run.py \
                            --task i2v-14B \
                            --size 720*1280 --frame_num 81 \
                            --ckpt_dir "${HF_HOME}/hub/models--Wan-AI--Wan2.1-I2V-14B-720P/snapshots/8823af45fcc58a8aa999a54b04be9abc7d2aac98/" \
                            --image "/app/Wan2.1/examples/i2v_input.JPG" \
                            --ulysses_size 8 --ring_size 1 \
                            --prompt "Summer beach vacation style, a white cat wearing sunglasses sits on a surfboard. The fluffy-furred feline gazes directly at the camera with a relaxed expression. Blurred beach scenery forms the background featuring crystal-clear waters, distant green hills, and a blue sky dotted with white clouds. The cat assumes a naturally relaxed posture, as if savoring the sea breeze and warm sunlight. A close-up shot highlights the feline's intricate details and the refreshing atmosphere of the seaside." \
                            --benchmark_output_directory results --save_file video.mp4 --num_benchmark_steps 1 \
                            --offload_model 0 \
                            --vae_dtype bfloat16
                    {% endif %}
                    {% if model.model == "Wan2.2" %}
                        cd Wan2.2
                        mkdir results

                        torchrun --nproc_per_node=8 run.py \
                            --task i2v-A14B \
                            --size 720*1280 --frame_num 81 \
                            --ckpt_dir "${HF_HOME}/hub/models--Wan-AI--Wan2.2-I2V-A14B/snapshots/206a9ee1b7bfaaf8f7e4d81335650533490646a3/" \
                            --image "/app/Wan2.2/examples/i2v_input.JPG" \
                            --ulysses_size 8 --ring_size 1 \
                            --prompt "Summer beach vacation style, a white cat wearing sunglasses sits on a surfboard. The fluffy-furred feline gazes directly at the camera with a relaxed expression. Blurred beach scenery forms the background featuring crystal-clear waters, distant green hills, and a blue sky dotted with white clouds. The cat assumes a naturally relaxed posture, as if savoring the sea breeze and warm sunlight. A close-up shot highlights the feline's intricate details and the refreshing atmosphere of the seaside." \
                            --benchmark_output_directory results --save_file video.mp4 --num_benchmark_steps 1 \
                            --offload_model 0 \
                            --vae_dtype bfloat16
                    {% endif %}

            {% if model.model in ["Wan2.1", "Wan2.2"] %}
                For additional performance improvements, consider adding the ``--compile`` flag to the above command. Note that this can significantly increase startup time on the first call.
            {% endif %}

                The generated video will be stored under the results directory. For the actual benchmark step runtimes, see {% if model.model == "Hunyuan Video" %}stdout.{% elif model.model in ["Wan2.1", "Wan2.2"] %}results/outputs/rank0_*.json{% endif %}

        {% endfor %}
    {% endfor %}