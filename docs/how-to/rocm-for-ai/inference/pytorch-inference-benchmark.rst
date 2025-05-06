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

   .. raw:: html

      <div id="vllm-benchmark-ud-params-picker" class="container-fluid">
        <div class="row">
          <div class="col-2 me-2 model-param-head">Model</div>
          <div class="row col-10">
   {% for model_group in model_groups %}
            <div class="col-6 model-param" data-param-k="model-group" data-param-v="{{ model_group.tag }}" tabindex="0">{{ model_group.group }}</div>
   {% endfor %}
          </div>
        </div>

        <div class="row mt-1" style="display: none;">
          <div class="col-2 me-2 model-param-head">Model variant</div>
          <div class="row col-10">
   {% for model_group in model_groups %}
      {% set models = model_group.models %}
      {% for model in models %}
            <div class="col-12 model-param" data-param-k="model" data-param-v="{{ model.mad_tag }}" data-param-group="{{ model_group.tag }}" tabindex="0">{{ model.model }}</div>
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

   Getting started
   ===============

   Use the following procedures to reproduce the benchmark results on an
   MI300X series accelerator with the prebuilt PyTorch Docker image.

   .. _pytorch-benchmark-get-started:

   1. Disable NUMA auto-balancing.

      To optimize performance, disable automatic NUMA balancing. Otherwise, the GPU
      might hang until the periodic balancing is finalized. For more information,
      see :ref:`AMD Instinct MI300X system optimization <mi300x-disable-numa>`.

      .. code-block:: shell

         # disable automatic NUMA balancing
         sh -c 'echo 0 > /proc/sys/kernel/numa_balancing'
         # check if NUMA balancing is disabled (returns 0 if disabled)
         cat /proc/sys/kernel/numa_balancing
         0

   .. container:: model-doc pyt_chai1_inference

      2. Use the following command to pull the `ROCm PyTorch Docker image <https://hub.docker.com/layers/rocm/pytorch/rocm6.2.3_ubuntu22.04_py3.10_pytorch_release_2.3.0_triton_llvm_reg_issue/images/sha256-b736a4239ab38a9d0e448af6d4adca83b117debed00bfbe33846f99c4540f79b>`_ from Docker Hub.

         .. code-block:: shell

            docker pull rocm/pytorch:rocm6.2.3_ubuntu22.04_py3.10_pytorch_release_2.3.0_triton_llvm_reg_issue

         .. note::

            The Chai-1 benchmark uses a specifically selected Docker image using ROCm 6.2.3 and PyTorch 2.3.0 to address an accuracy issue.

   .. container:: model-doc pyt_clip_inference

      2. Use the following command to pull the `ROCm PyTorch Docker image <https://hub.docker.com/layers/rocm/pytorch/latest/images/sha256-05b55983e5154f46e7441897d0908d79877370adca4d1fff4899d9539d6c4969>`_ from Docker Hub.

         .. code-block:: shell

            docker pull rocm/pytorch:latest

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
         python3 tools/run_models.py --tags {{model.mad_tag}} --keep-model-dir --live-output --timeout 28800

      MAD launches a Docker container with the name
      ``container_ci-{{model.mad_tag}}``. The latency and throughput reports of the
      model are collected in ``perf.csv``.

      .. note::

         For improved performance, consider enabling TunableOp. By default,
         ``{{model.mad_tag}}`` runs with TunableOp disabled (see
         `<https://github.com/ROCm/MAD/blob/develop/models.json>`__). To enable
         it, edit the default run behavior in the ``tools/run_models.py``-- update the model's
         run ``args`` by changing ``--tunableop off`` to ``--tunableop on``.

         Enabling TunableOp triggers a two-pass run -- a warm-up followed by the performance-collection run.
         Although this might increase the initial training time, it can result in a performance gain.

      {% endfor %}
   {% endfor %}

Further reading
===============

- To learn more about system settings and management practices to configure your system for
  MI300X accelerators, see `AMD Instinct MI300X system optimization <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/system-optimization/mi300x.html>`_.

- To learn how to run LLM models from Hugging Face or your model, see
  :doc:`Running models from Hugging Face <hugging-face-models>`.

- To learn how to optimize inference on LLMs, see
  :doc:`Inference optimization <../inference-optimization/index>`.

- To learn how to fine-tune LLMs, see
  :doc:`Fine-tuning LLMs <../fine-tuning/index>`.
