.. meta::
   :description: Learn how to validate LLM inference performance on MI300X GPUs using AMD MAD and the ROCm vLLM Docker image.
   :keywords: model, MAD, automation, dashboarding, validate

**************
vLLM inference
**************

`vLLM <https://docs.vllm.ai/en/v0.16.0/>`__ is an open-source library for fast,
memory-efficient LLM inference and serving. This page describes how to set up
and run vLLM on AMD GPUs and APUs using either a prebuilt Docker image or pip.
It applies to :ref:`supported AMD GPUs and platforms <release-ai-ecosystem>`.

.. =========================================================== GPU/APU FAMILY ==

.. selector:: AMD device family
   :key: fam

   .. selector-option:: Instinct
      :value: instinct
      :width: 3
      :toc-label: AMD Instinct

   .. selector-option:: Radeon PRO
      :value: radeon-pro
      :width: 3
      :toc-label: AMD Radeon PRO

   .. selector-option:: Radeon
      :value: radeon
      :width: 3
      :toc-label: AMD Radeon

   .. selector-option:: Ryzen
      :value: ryzen
      :width: 3
      :toc-label: AMD Ryzen


.. ================================================================ GPU / APU ==

.. selector:: Instinct GPU
   :key: gpu
   :show-when: fam=instinct

   .. selector-info:: https://www.amd.com/en/products/accelerators/instinct.html

   .. selector-option:: MI355X
      :width: 20%
      :toc-label: AMD Instinct MI355X

   .. selector-option:: MI350X
      :width: 20%
      :toc-label: AMD Instinct MI350X

   .. selector-option:: MI325X
      :width: 20%
      :toc-label: AMD Instinct MI325X

   .. selector-option:: MI300X
      :width: 20%
      :toc-label: AMD Instinct MI300X

   .. selector-option:: MI300A
      :width: 20%
      :toc-label: AMD Instinct MI300A

.. selector:: Radeon PRO GPU
   :key: gpu
   :show-when: fam=radeon-pro

   .. selector-info:: https://www.amd.com/en/products/graphics/workstations.html

   .. selector-option:: AI PRO R9700
      :value: ai-r9700
      :width: 6
      :toc-label: AMD Radeon AI PRO R9700

   .. selector-option:: AI PRO R9600D
      :value: ai-r9600d
      :width: 6
      :toc-label: AMD Radeon AI PRO R9600D

.. selector:: Radeon GPU
   :key: gpu
   :show-when: fam=radeon

   .. selector-info:: https://www.amd.com/en/products/graphics/desktops/radeon.html

   .. selector-option:: RX 9070 XT
      :value: rx-9070-xt
      :width: 4
      :toc-label: AMD Radeon RX 9070 XT

   .. selector-option:: RX 9070 GRE
      :value: rx-9070-gre
      :width: 4
      :toc-label: AMD Radeon RX 9070 GRE

   .. selector-option:: RX 9070
      :value: rx-9070
      :width: 4
      :toc-label: AMD Radeon RX 9070

   .. selector-option:: RX 9060 XT LP
      :value: rx-9060-xt-lp
      :width: 4
      :toc-label: AMD Radeon RX 9060 XT LP

   .. selector-option:: RX 9060 XT
      :value: rx-9060-xt
      :width: 4
      :toc-label: AMD Radeon RX 9060 XT

   .. selector-option:: RX 9060
      :value: rx-9060
      :width: 4
      :toc-label: AMD Radeon RX 9060

.. selector:: Ryzen APU
   :key: gpu
   :show-when: fam=ryzen

   .. selector-info:: https://www.amd.com/en/products/processors/workstations/mobile.html

   .. selector-option:: AI Max+ PRO 395
      :value: max-pro-395
      :width: 4
      :toc-label: AMD Ryzen AI Max+ PRO 395

   .. selector-option:: AI Max PRO 390
      :value: max-pro-390
      :width: 4
      :toc-label: AMD Ryzen AI Max PRO 390

   .. selector-option:: AI Max PRO 385
      :value: max-pro-385
      :width: 4
      :toc-label: AMD Ryzen AI Max PRO 385

   .. selector-option:: AI Max PRO 380
      :value: max-pro-380
      :width: 3
      :toc-label: AMD Ryzen AI Max PRO 380

   .. selector-option:: AI Max+ 395
      :value: max-395
      :width: 3
      :toc-label: AMD Ryzen AI Max+ 395

   .. selector-option:: AI Max 390
      :value: max-390
      :width: 3
      :toc-label: AMD Ryzen AI Max 390

   .. selector-option:: AI Max 385
      :value: max-385
      :width: 3
      :toc-label: AMD Ryzen AI Max 385

.. selector:: Installation method
   :key: i

   .. selector-option:: Docker
      :value: docker
      :width: 6

   .. selector-option:: pip
      :value: pip
      :width: 6

Prerequisites
=============

Ensure your system has :ref:`Python 3.12 <rocm-compat-python>` installed and
accessible. Review the :doc:`/compatibility/compatibility-matrix` for more support
details.

Get started
===========

.. selected:: i=docker

   .. selected:: gpu=mi355x gpu=mi350x

      1. Pull the ROCm vLLM Docker image.

         .. code-block:: bash

            docker pull rocm/vllm:rocm7.12.0_gfx950-dcgpu_ubuntu24.04_py3.12_pytorch_2.9.1_vllm_0.16.0

      2. Start the Docker container.

         .. code-block:: bash

            docker run -it --rm \
               --network=host \
               --group-add=video \
               --ipc=host \
               --cap-add=SYS_PTRACE \
               --security-opt seccomp=unconfined \
               --device /dev/kfd \
               --device /dev/dri \
               -v <path/to/your/models>:/app/models \
               -e HF_HOME="/app/models" \
               rocm/vllm:rocm7.12.0_gfx950-dcgpu_ubuntu24.04_py3.12_pytorch_2.9.1_vllm_0.16.0 \
               bash

   .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

      1. Pull the ROCm vLLM Docker image.

         .. code-block:: bash

            docker pull rocm/vllm:rocm7.12.0_gfx94X-dcgpu_ubuntu24.04_py3.12_pytorch_2.9.1_vllm_0.16.0

      2. Start the Docker container.

         .. code-block:: bash

            docker run -it --rm \
               --network=host \
               --group-add=video \
               --ipc=host \
               --cap-add=SYS_PTRACE \
               --security-opt seccomp=unconfined \
               --device /dev/kfd \
               --device /dev/dri \
               -v <path/to/your/models>:/app/models \
               -e HF_HOME="/app/models" \
               rocm/vllm:rocm7.12.0_gfx94X-dcgpu_ubuntu24.04_py3.12_pytorch_2.9.1_vllm_0.16.0 \
               bash

   .. selected:: fam=radeon-pro fam=radeon

      1. Pull the ROCm vLLM Docker image.

         .. code-block:: bash

            docker pull rocm/vllm:rocm7.12.0_gfx120X-all_ubuntu24.04_py3.12_pytorch_2.9.1_vllm_0.16.0

      2. Start the Docker container.

         .. code-block:: bash

            docker run -it --rm \
               --network=host \
               --group-add=video \
               --ipc=host \
               --cap-add=SYS_PTRACE \
               --security-opt seccomp=unconfined \
               --device /dev/kfd \
               --device /dev/dri \
               -v <path/to/your/models>:/app/models \
               -e HF_HOME="/app/models" \
               rocm/vllm:rocm7.12.0_gfx120X-all_ubuntu24.04_py3.12_pytorch_2.9.1_vllm_0.16.0 \
               bash

   .. selected:: fam=ryzen

      1. Pull the ROCm vLLM Docker image.

         .. code-block:: bash

            docker pull rocm/vllm:rocm7.12.0_gfx1151_ubuntu24.04_py3.12_pytorch_2.9.1_vllm_0.16.0

      2. Start the Docker container.

         .. code-block:: bash

            docker run -it --rm \
               --network=host \
               --group-add=video \
               --ipc=host \
               --cap-add=SYS_PTRACE \
               --security-opt seccomp=unconfined \
               --device /dev/kfd \
               --device /dev/dri \
               -v <path/to/your/models>:/app/models \
               -e HF_HOME="/app/models" \
               rocm/vllm:rocm7.12.0_gfx1151_ubuntu24.04_py3.12_pytorch_2.9.1_vllm_0.16.0 \
               bash

   .. seealso::

      `Set up using Docker (vLLM docs) <https://docs.vllm.ai/en/v0.16.0/getting_started/installation/gpu/#amd-rocm_5>`__

.. selected:: i=pip

   1. Set up your Python virtual environment. If you already have a successful
      ROCm |ROCM_VERSION| :doc:`installation using pip </install/rocm>`, skip
      this step.

      For example, run the following command to create a virtual environment:

      .. code-block:: shell

         python3.12 -m venv .venv

   2. Activate your Python virtual environment. For example:

      .. code-block:: shell

         source .venv/bin/activate

   3. Install ROCm |ROCM_VERSION| and PyTorch 2.9.1 in your virtual environment using pip.

      .. selected:: gpu=mi355x gpu=mi350x

         .. code-block:: bash

            python -m pip install \
              --index-url https://repo.amd.com/rocm/whl/gfx950-dcgpu/ \
              "torch==2.9.1+rocm7.12.0" \
              "torchvision==2.9.0+rocm7.12.0" \
              "torchaudio==0.24.0+rocm7.12.0"

      .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

         .. code-block:: bash

            python -m pip install \
              --index-url https://repo.amd.com/rocm/whl/gfx94X-dcgpu/ \
              "torch==2.9.1+rocm7.12.0" \
              "torchvision==2.9.0+rocm7.12.0" \
              "torchaudio==0.24.0+rocm7.12.0"

      .. selected:: fam=radeon-pro fam=radeon

         .. code-block:: bash

            python -m pip install \
              --index-url https://repo.amd.com/rocm/whl/gfx120X-all/ \
              "torch==2.9.1+rocm7.12.0" \
              "torchvision==2.9.0+rocm7.12.0" \
              "torchaudio==0.24.0+rocm7.12.0"

      .. selected:: fam=ryzen

         .. code-block:: bash

            python -m pip install \
              --index-url https://repo.amd.com/rocm/whl/gfx1151/ \
              "torch==2.9.1+rocm7.12.0" \
              "torchvision==2.9.0+rocm7.12.0" \
              "torchaudio==0.24.0+rocm7.12.0"

   4. Install the appropriate vLLM 0.16.0 build for your GFX architecture from the ROCm package repository.

      .. selected:: gpu=mi355x gpu=mi350x

         .. code-block:: bash

            python -m pip install \
              --extra-index-url https://rocm.frameworks.amd.com/whl/gfx950-dcgpu/ \
              "vllm==0.16.1.dev10+g11515110f.d20260324.rocm712"

      .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

         .. code-block:: bash

            python -m pip install \
              --extra-index-url https://rocm.frameworks.amd.com/whl/gfx94X-dcgpu/ \
              "vllm==0.16.1.dev10+g11515110f.d20260324.rocm712"

      .. selected:: fam=radeon-pro fam=radeon

         .. code-block:: bash

            python -m pip install \
              --extra-index-url https://rocm.frameworks.amd.com/whl/gfx120X-all/ \
              "vllm==0.16.1.dev10+g11515110f.d20260323.rocm712"

      .. selected:: fam=ryzen

         .. code-block:: bash

            python -m pip install \
              --extra-index-url https://rocm.frameworks.amd.com/whl/gfx1151/ \
              "vllm==0.16.1.dev10+g11515110f.d20260323.rocm712"

   5. Set the following environment variables to prevent errors related ROCm platform and Flash Attention availability when running vLLM.

      .. code-block:: bash

         export PYTHONPATH=.venv/lib/python3.12/site-packages/_rocm_sdk_core/share/amd_smi
         export FLASH_ATTENTION_TRITON_AMD_ENABLE=TRUE

   6. Check your installation.

      .. code-block:: bash

         echo "=== vLLM ===" && python -c "import vllm; print('vLLM version:', vllm.__version__)"
         echo "=== PyTorch ===" && python -c "import torch; print('PyTorch:', torch.__version__); print('HIP available:', torch.cuda.is_available()); print('HIP built:', torch.backends.hip.is_built() if hasattr(torch.backends, 'hip') else 'N/A')"
         echo "=== flash-attn ===" && python -c "import flash_attn; print('flash-attn:', flash_attn.__version__)"

   .. seealso::

      `Set up using Python (vLLM docs) <https://docs.vllm.ai/en/v0.16.0/getting_started/installation/gpu/#amd-rocm_3>`__

After setting up your environment, follow the vLLM 0.16.0 usage documentation to get started: `Using
vLLM <https://docs.vllm.ai/en/v0.16.0/usage/>`__.

Known issues
============

- vLLM server startup in Docker containers might fail due to a path resolution issue. See
  :ref:`release-vllm-path-known-issue`.

  As a workaround, before starting the vLLM server inside the ROCm 7.12 vLLM
  Docker container, set ``LD_LIBRARY_PATH`` to include the ROCm SDK core library
  path; for example:

  .. code-block:: bash

     export LD_LIBRARY_PATH=/opt/python/lib/python3.12/site-packages/_rocm_sdk_core/lib:$LD_LIBRARY_PATH

- vLLM server might fail to launch for models with ``tp=8`` resulting in
  ``custom_all_reduce_hip.cuh: invalid device pointer``. See :ref:`release-vllm-tp-known-issue`.
