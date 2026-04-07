:selector-toc2: Installation environment
:selector-toc2-icon: fa-solid fa-computer

.. meta::
   :description: Learn how to set up and run SGLang on AMD GPUs using a prebuilt Docker image.
   :keywords: SGLang, inference, serving, LLM, AMD, ROCm, Docker

.. |SGLANG_VERSION| replace:: 0.5.9

.. |SGLANG_DOCKER_TAG_GFX950| replace:: rocm/utd-private:sglang-v0.5.9-therock-gfx950-dcgpu-py3.12-20260409_063920
.. |SGLANG_DOCKER_TAG_GFX94X| replace:: rocm/utd-private:sglang-v0.5.9-therock-gfx942-dcgpu-py3.12-20260409_063920

************************************
SGLang inference and serving on ROCm
************************************

`SGLang <https://docs.sglang.io/>`__ is an open-source framework for serving
LLMs and multimodal models with high throughput and low latency. It supports
efficient inference in deployments ranging from standalone GPUs to large-scale
distributed clusters. This page describes how to set up and run SGLang on AMD
GPUs and APUs using a prebuilt Docker image. It applies to :ref:`supported AMD
GPUs and platforms <release-ai-ecosystem>`.

.. selector:: AMD device family
   :key: fam

   .. selector-option:: Instinct
      :value: instinct
      :width: 100%
      :toc-label: AMD Instinct

.. selector:: AMD Instinct GPU
   :key: gpu
   :show-cond: fam=instinct

   .. selector-option:: MI355X
      :value: mi355x gfx=gfx950
      :width: 20%
      :toc-label: AMD Instinct MI355X (gfx950)

   .. selector-option:: MI350X
      :value: mi350x gfx=gfx950
      :width: 20%
      :toc-label: AMD Instinct MI350X (gfx950)

   .. selector-option:: MI325X
      :value: mi325x gfx=gfx942
      :width: 20%
      :toc-label: AMD Instinct MI325X (gfx942)

   .. selector-option:: MI300X
      :value: mi300x gfx=gfx942
      :width: 20%
      :toc-label: AMD Instinct MI300X (gfx942)

   .. selector-option:: MI300A
      :value: mi300a gfx=gfx942
      :width: 20%
      :toc-label: AMD Instinct MI300A (gfx942)

.. selector:: Installation method
   :key: i

   .. selector-option:: Docker
      :value: docker
      :width: 12

Prerequisites
=============

Ensure the host system has `Docker Engine
<https://docs.docker.com/engine/install/>`__ and the AMD GPU Driver (amdgpu)
installed. See :ref:`docker-prerequisites` for more information.

Get started
===========

.. selected:: i=docker

   .. selected:: gpu=mi355x gpu=mi350x

      1. Pull the ROCm SGLang |SGLANG_VERSION| Docker image.

         .. code-block:: bash
            :substitutions:

            docker pull |SGLANG_DOCKER_TAG_GFX950|

      2. Start the Docker container.

         .. code-block:: bash
            :substitutions:

            docker run -it --rm \
               --device=/dev/kfd \
               --device=/dev/dri \
               --network=host \
               --ipc=host \
               --group-add video \
               --cap-add=SYS_PTRACE \
               --security-opt seccomp=unconfined \
               --privileged \
               --shm-size 16G \
               -v $HOME/dockerx:/dockerx \
               -v /data:/data
               |SGLANG_DOCKER_TAG_GFX950| \
               bash

   .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

      1. Pull the ROCm SGLang |SGLANG_VERSION| Docker image.

         .. code-block:: bash
            :substitutions:

            docker pull |SGLANG_DOCKER_TAG_GFX94X|

      2. Start the Docker container.

         .. code-block:: bash
            :substitutions:

            docker run -it --rm \
               --device=/dev/kfd \
               --device=/dev/dri \
               --network=host \
               --ipc=host \
               --group-add video \
               --cap-add=SYS_PTRACE \
               --security-opt seccomp=unconfined \
               --privileged \
               --shm-size 16G \
               -v $HOME/dockerx:/dockerx \
               -v /data:/data
               |SGLANG_DOCKER_TAG_GFX94X| \
               bash

   3. To enable AMD `AITER <https://github.com/ROCm/aiter>`__ optimizations,
      export the following environment variable within the container. See
      `Quantization on AMD GPUs (SGLang docs)
      <https://docs.sglang.io/docs/hardware-platforms/amd_gpu#quantization-on-amd-gpus>`__
      for more information.

      .. code-block:: bash

         export SGLANG_USE_AITER=1

      .. seealso::

         `Install using Docker for AMD GPUs (SGLang docs) <https://docs.sglang.io/docs/hardware-platforms/amd_gpu#install-using-docker-recommended>`__

   4. After setting up your environment, follow the SGLang |SGLANG_VERSION| usage
      documentation to get started: `Basic usage (SGLang docs)
      <https://docs.sglang.io/docs/basic_usage/overview>`__.

