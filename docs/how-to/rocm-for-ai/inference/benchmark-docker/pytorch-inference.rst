.. meta::
   :description: Learn how to validate LLM inference performance on MI300X accelerators using AMD MAD and the
                 ROCm PyTorch Docker image.
   :keywords: model, MAD, automation, dashboarding, validate, pytorch

*************************************
PyTorch inference performance testing
*************************************

.. _pytorch-inference-benchmark-docker:

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/pytorch-inference-benchmark-models.yaml

   {% set unified_docker = data.pytorch_inference_benchmark.unified_docker.latest %}
   {% set model_groups = data.pytorch_inference_benchmark.model_groups %}

   The `ROCm PyTorch Docker <https://hub.docker.com/r/rocm/pytorch/tags>`_ image offers a prebuilt,
   optimized environment for testing model inference performance on AMD Instinct™ MI300X series
   accelerators. This guide demonstrates how to use the AMD Model Automation and Dashboarding (MAD)
   tool with the ROCm PyTorch container to test inference performance on various models efficiently.

   .. _pytorch-inference-benchmark-available-models:

   Supported models
   ================

   The following models are supported for inference performance benchmarking
   with PyTorch and ROCm. Some instructions, commands, and recommendations in this
   documentation might vary by model -- select one to get started.

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

         <div class="row gx-0 pt-1" style="display: none;">
            <div class="col-2 me-1 px-2 model-param-head">Variant</div>
            <div class="row col-10 pe-0">
      {% for model_group in model_groups %}
         {% set models = model_group.models %}
         {% for model in models %}
            {% if models|length % 3 == 0 %}
               <div class="col-4 px-2 model-param" data-param-k="model" data-param-v="{{ model.mad_tag }}" data-param-group="{{ model_group.tag }}" tabindex="0">{{ model.model }}</div>
            {% else %}
               <div class="col-6 px-2 model-param" data-param-k="model" data-param-v="{{ model.mad_tag }}" data-param-group="{{ model_group.tag }}" tabindex="0">{{ model.model }}</div>
            {% endif %}
         {% endfor %}
      {% endfor %}
            </div>
         </div>
      </div>

   {% for model_group in model_groups %}
      {% for model in model_group.models %}

   .. container:: model-doc {{model.mad_tag}}

      .. note::

         See the `{{ model.model }} model card on Hugging Face <{{ model.url }}>`_ to learn more about your selected model.
         Some models require access authorization before use via an external license agreement through a third party.

      {% endfor %}
   {% endfor %}

   System validation
   =================

   Before running AI workloads, it's important to validate that your AMD hardware is configured
   correctly and performing optimally.

   To optimize performance, disable automatic NUMA balancing. Otherwise, the GPU
   might hang until the periodic balancing is finalized. For more information,
   see the :ref:`system validation steps <rocm-for-ai-system-optimization>`.

   .. code-block:: shell

      # disable automatic NUMA balancing
      sh -c 'echo 0 > /proc/sys/kernel/numa_balancing'
      # check if NUMA balancing is disabled (returns 0 if disabled)
      cat /proc/sys/kernel/numa_balancing
      0

   To test for optimal performance, consult the recommended :ref:`System health benchmarks
   <rocm-for-ai-system-health-bench>`. This suite of tests will help you verify and fine-tune your
   system's configuration.

   Pull the Docker image
   =====================

   .. container:: model-doc pyt_chai1_inference

      Use the following command to pull the `ROCm PyTorch Docker image <https://hub.docker.com/layers/rocm/pytorch/rocm6.2.3_ubuntu22.04_py3.10_pytorch_release_2.3.0_triton_llvm_reg_issue/images/sha256-b736a4239ab38a9d0e448af6d4adca83b117debed00bfbe33846f99c4540f79b>`__ from Docker Hub.

      .. code-block:: shell

         docker pull rocm/pytorch:rocm6.2.3_ubuntu22.04_py3.10_pytorch_release_2.3.0_triton_llvm_reg_issue

      .. note::

         The Chai-1 benchmark uses a specifically selected Docker image using ROCm 6.2.3 and PyTorch 2.3.0 to address an accuracy issue.

   .. container:: model-doc pyt_clip_inference pyt_mochi_video_inference pyt_wan2.1_inference pyt_janus_pro_inference pyt_hy_video

      Use the following command to pull the `ROCm PyTorch Docker image <https://hub.docker.com/layers/rocm/pytorch/latest/images/sha256-05b55983e5154f46e7441897d0908d79877370adca4d1fff4899d9539d6c4969>`__ from Docker Hub.

      .. code-block:: shell

         docker pull rocm/pytorch:latest

   .. _pytorch-benchmark-get-started:

   Benchmarking
   ============

   .. _pytorch-inference-benchmark-mad:

   {% for model_group in model_groups %}
      {% for model in model_group.models %}

   .. container:: model-doc {{model.mad_tag}}

      To simplify performance testing, the ROCm Model Automation and Dashboarding
      (`<https://github.com/ROCm/MAD>`__) project provides ready-to-use scripts and configuration.
      To start, clone the  MAD repository to a local directory and install the required packages on the
      host machine.

      .. code-block:: shell

         git clone https://github.com/ROCm/MAD
         cd MAD
         pip install -r requirements.txt

      Use this command to run the performance benchmark test on the `{{model.model}} <{{ model.url }}>`_ model
      using one GPU with the ``{{model.precision}}`` data type on the host machine.

      .. code-block:: shell

         export MAD_SECRETS_HFTOKEN="your personal Hugging Face token to access gated models"
         madengine run \
             --tags {{model.mad_tag}} \
             --keep-model-dir \
             --live-output \
             --timeout 28800

      MAD launches a Docker container with the name
      ``container_ci-{{model.mad_tag}}``. The latency and throughput reports of the
      model are collected in ``perf_{{model.mad_tag}}.csv``.

      {% if model.mad_tag != "pyt_janus_pro_inference" %}
      .. note::

         For improved performance, consider enabling TunableOp. By default,
         ``{{model.mad_tag}}`` runs with TunableOp disabled (see
         `<https://github.com/ROCm/MAD/blob/develop/models.json>`__). To enable
         it, include the ``--tunableop on`` argument in your run.

         Enabling TunableOp triggers a two-pass run -- a warm-up followed by the performance-collection run.
         Although this might increase the initial training time, it can result in a performance gain.
      {% endif %}

      {% endfor %}
   {% endfor %}

Further reading
===============

- To learn more about MAD and the ``madengine`` CLI, see the `MAD usage guide <https://github.com/ROCm/MAD?tab=readme-ov-file#usage-guide>`__.

- To learn more about system settings and management practices to configure your system for
  AMD Instinct MI300X series accelerators, see `AMD Instinct MI300X system optimization <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/system-optimization/mi300x.html>`_.

- For application performance optimization strategies for HPC and AI workloads,
  including inference with vLLM, see :doc:`../../inference-optimization/workload`.

- To learn how to run LLM models from Hugging Face or your model, see
  :doc:`Running models from Hugging Face <../hugging-face-models>`.

- To learn how to optimize inference on LLMs, see
  :doc:`Inference optimization <../../inference-optimization/index>`.

- To learn how to fine-tune LLMs, see
  :doc:`Fine-tuning LLMs <../../fine-tuning/index>`.
