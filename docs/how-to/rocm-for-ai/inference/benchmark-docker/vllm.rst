.. meta::
   :description: Learn how to validate LLM inference performance on MI300X GPUs using AMD MAD and the ROCm vLLM Docker image.
   :keywords: model, MAD, automation, dashboarding, validate

**************
vLLM inference
**************

The `ROCm-enabled vLLM Docker image
<https://hub.docker.com/r/vllm/vllm-openai-rocm/tags>`__ offers a prebuilt,
optimized environment for large language model (LLM) inference on AMD Instinct
MI355X, MI350X, MI325X and MI300X GPUs. This ROCm vLLM Docker image integrates
vLLM and PyTorch tailored specifically for AMD Instinct data center GPUs.

This container integrates ROCm, PyTorch, and vLLM with optimizations tailored
for AMD Instinct data center GPUs, enabling consistent and reproducible
inference deployments.

What's new
==========

- For vLLM release notes on model support, hardware and performance improvements,
  and other highlights, see the `vLLM Releases page
  <https://github.com/vllm-project/vllm/releases>`__ on GitHub.

- It's now recommended to use the upstream vLLM documentation at `docs.vllm.ai
  <https://docs.vllm.ai>`__ for the latest inference and deployment guides.

Get started
===========

For a consistent and portable inference environment, it's recommended to use Docker. vLLM
offers a Docker image `vllm/vllm-openai-rocm
<https://hub.docker.com/r/vllm/vllm-openai-rocm/tags>`__ for deployment on AMD
GPUs. Use the following command to pull the latest Docker image from Docker Hub.

.. code-block:: shell

   docker pull vllm/vllm-openai-rocm:latest

After pulling the Docker image, follow the vLLM usage documentation: `Using
vLLM <https://docs.vllm.ai/en/latest/usage/>`__.

Further reading
===============

- See :ref:`fine-tuning-llms-vllm` and :ref:`mi300x-vllm-optimization` for
  a brief introduction to vLLM and optimization strategies.

- For a list of other ready-made Docker images for AI with ROCm, see
  `AMD Infinity Hub <https://www.amd.com/en/developer/resources/infinity-hub.html#f-amd_hub_category=AI%20%26%20ML%20Models>`__.

.. _vllm-inference-previous-versions:

Previous versions
=================

It's now recommended to use the upstream vLLM documentation at `docs.vllm.ai
<https://docs.vllm.ai>`__ for the latest deployment guides.

You can find legacy versions of this documentation at
:doc:`previous-versions/vllm-history` which provide instructions for
inference performance testing for select models. See the `Use AMD's Docker
images
<https://docs.vllm.ai/en/stable/deployment/docker/#use-amds-docker-images>`__
note in the vLLM documentation for more information.
