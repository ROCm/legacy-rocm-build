:selector-toc2: Installation environment
:selector-toc2-icon: fa-solid fa-computer

.. _pytorch-install:

**************************************
Install PyTorch on ROCm |ROCM_VERSION|
**************************************

This topic guides you through installing PyTorch with ROCm support on AMD
hardware. It applies to :ref:`supported AMD GPUs and platforms
<release-ai-ecosystem>`.

.. selector:: Device family
   :key: fam

   .. selector-option:: AMD Instinct™
      :value: instinct w=compute
      :width: 4
      :toc-label: AMD Instinct

   .. selector-option:: AMD Radeon™
      :value: radeon w=compute
      :width: 4
      :toc-label: AMD Radeon

   .. selector-option:: AMD Ryzen™
      :value: ryzen w=compute
      :width: 4
      :toc-label: AMD Ryzen

.. include:: /install/include/gpu-selector.rst

.. selector:: Operating system
   :key: os
   :show-cond: fam=instinct

   .. selector-option:: Linux
      :value: linux
      :width: 12

.. selector:: Operating system
   :key: os
   :show-cond: fam=radeon fam=ryzen

   .. selector-option:: Linux
      :value: linux
      :width: 6

   .. selector-option:: Windows
      :value: windows
      :width: 6

.. selector:: PyTorch version
   :key: pytorch-ver
   :show-cond: os=linux

   .. selector-option:: 2.11.0
      :value: 2.11.0
      :width: 4

   .. selector-option:: 2.10.0
      :value: 2.10.0
      :width: 4

   .. selector-option:: 2.9.1
      :value: 2.9.1
      :width: 4

.. selector:: PyTorch version
   :key: pytorch-ver
   :show-cond: os=windows

   .. selector-option:: 2.11.0
      :value: 2.11.0
      :width: 12

Prerequisites
=============

.. selected:: fam=instinct fam=radeon

   - Ensure your system has the AMD GPU Driver (amdgpu) installed. See the
     :ref:`compat-matrix` for driver support information. For installation
     instructions, see the `AMD GPU Driver documentation
     <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.30.0-preview/index.html>`__.

- Ensure your system has a :ref:`supported Python version
  <rocm-compat-python>` installed and accessible: 3.11, 3.12, 3.13, or 3.14.

- Complete the ROCm Core SDK installation prerequisites. See
  :ref:`rocm-prerequisites` for instructions.

.. _pip-install-pytorch:

Install PyTorch using pip
=========================

.. _pip-install-pytorch-venv:

1. Set up your Python virtual environment. For example, run the following
   command to create one with Python 3.13:

   .. selected:: os=linux

      .. code-block:: bash

         python3.13 -m venv .venv

   .. selected:: os=windows

      .. code-block:: bat

         py -3.13 -m venv .venv

2. Activate your Python virtual environment. For example:

   .. selected:: os=linux

      .. code-block:: bash

         source .venv/bin/activate

   .. selected:: os=windows

      .. code-block:: bat

         .venv\Scripts\activate

3. Install the appropriate ROCm-enabled PyTorch libraries for your operating
   system and AMD hardware architecture.

   .. selected:: gfx=gfx950

      .. selected:: pytorch-ver=2.11.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx950-dcgpu/ \
                "torch==2.11.0+rocm7.13.0" \
                "torchvision==0.26.0+rocm7.13.0" \
                "torchaudio==2.11.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.10.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx950-dcgpu/ \
                "torch==2.10.0+rocm7.13.0" \
                "torchvision==0.25.0+rocm7.13.0" \
                "torchaudio==2.10.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.9.1

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx950-dcgpu/ \
                "torch==2.9.1+rocm7.13.0" \
                "torchvision==0.24.0+rocm7.13.0" \
                "torchaudio==2.9.0+rocm7.13.0"

   .. selected:: gfx=gfx942

      .. selected:: pytorch-ver=2.11.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx94X-dcgpu/ \
                "torch==2.11.0+rocm7.13.0" \
                "torchvision==0.26.0+rocm7.13.0" \
                "torchaudio==2.11.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.10.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx94X-dcgpu/ \
                "torch==2.10.0+rocm7.13.0" \
                "torchvision==0.25.0+rocm7.13.0" \
                "torchaudio==2.10.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.9.1

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx94X-dcgpu/ \
                "torch==2.9.1+rocm7.13.0" \
                "torchvision==0.24.0+rocm7.13.0" \
                "torchaudio==2.9.0+rocm7.13.0"

   .. selected:: gfx=gfx90a

      .. selected:: pytorch-ver=2.11.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx90a/ \
                "torch==2.11.0+rocm7.13.0" \
                "torchvision==0.26.0+rocm7.13.0" \
                "torchaudio==2.11.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.10.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx90a/ \
                "torch==2.10.0+rocm7.13.0" \
                "torchvision==0.25.0+rocm7.13.0" \
                "torchaudio==2.10.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.9.1

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx90a/ \
                "torch==2.9.1+rocm7.13.0" \
                "torchvision==0.24.0+rocm7.13.0" \
                "torchaudio==2.9.0+rocm7.13.0"

   .. selected:: gfx=gfx908

      .. selected:: pytorch-ver=2.11.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx908/ \
                "torch==2.11.0+rocm7.13.0" \
                "torchvision==0.26.0+rocm7.13.0" \
                "torchaudio==2.11.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.10.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx908/ \
                "torch==2.10.0+rocm7.13.0" \
                "torchvision==0.25.0+rocm7.13.0" \
                "torchaudio==2.10.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.9.1

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx908/ \
                "torch==2.9.1+rocm7.13.0" \
                "torchvision==0.24.0+rocm7.13.0" \
                "torchaudio==2.9.0+rocm7.13.0"

   .. selected:: gfx=gfx1201 gfx=gfx1200

      .. selected:: pytorch-ver=2.11.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx120X-all/ \
                "torch==2.11.0+rocm7.13.0" \
                "torchvision==0.26.0+rocm7.13.0" \
                "torchaudio==2.11.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.10.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx120X-all/ \
                "torch==2.10.0+rocm7.13.0" \
                "torchvision==0.25.0+rocm7.13.0" \
                "torchaudio==2.10.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.9.1

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx120X-all/ \
                "torch==2.9.1+rocm7.13.0" \
                "torchvision==0.24.0+rocm7.13.0" \
                "torchaudio==2.9.0+rocm7.13.0"

   .. selected:: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

      .. selected:: pytorch-ver=2.11.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx110X-all/ \
                "torch==2.11.0+rocm7.13.0" \
                "torchvision==0.26.0+rocm7.13.0" \
                "torchaudio==2.11.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.10.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx110X-all/ \
                "torch==2.10.0+rocm7.13.0" \
                "torchvision==0.25.0+rocm7.13.0" \
                "torchaudio==2.10.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.9.1

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx110X-all/ \
                "torch==2.9.1+rocm7.13.0" \
                "torchvision==0.24.0+rocm7.13.0" \
                "torchaudio==2.9.0+rocm7.13.0"

   .. selected:: gfx=gfx1030

      .. selected:: pytorch-ver=2.11.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx103X-all/ \
                "torch==2.11.0+rocm7.13.0" \
                "torchvision==0.26.0+rocm7.13.0" \
                "torchaudio==2.11.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.10.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx103X-all/ \
                "torch==2.10.0+rocm7.13.0" \
                "torchvision==0.25.0+rocm7.13.0" \
                "torchaudio==2.10.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.9.1

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx103X-all/ \
                "torch==2.9.1+rocm7.13.0" \
                "torchvision==0.24.0+rocm7.13.0" \
                "torchaudio==2.9.0+rocm7.13.0"

   .. selected:: gfx=gfx1151

      .. selected:: pytorch-ver=2.11.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1151/ \
                "torch==2.11.0+rocm7.13.0" \
                "torchvision==0.26.0+rocm7.13.0" \
                "torchaudio==2.11.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.10.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1151/ \
                "torch==2.10.0+rocm7.13.0" \
                "torchvision==0.25.0+rocm7.13.0" \
                "torchaudio==2.10.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.9.1

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1151/ \
                "torch==2.9.1+rocm7.13.0" \
                "torchvision==0.24.0+rocm7.13.0" \
                "torchaudio==2.9.0+rocm7.13.0"

   .. selected:: gfx=gfx1150

      .. selected:: pytorch-ver=2.11.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1150/ \
                "torch==2.11.0+rocm7.13.0" \
                "torchvision==0.26.0+rocm7.13.0" \
                "torchaudio==2.11.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.10.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1150/ \
                "torch==2.10.0+rocm7.13.0" \
                "torchvision==0.25.0+rocm7.13.0" \
                "torchaudio==2.10.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.9.1

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1150/ \
                "torch==2.9.1+rocm7.13.0" \
                "torchvision==0.24.0+rocm7.13.0" \
                "torchaudio==2.9.0+rocm7.13.0"

   .. selected:: gfx=gfx1152

      .. selected:: pytorch-ver=2.11.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1152/ \
                "torch==2.11.0+rocm7.13.0" \
                "torchvision==0.26.0+rocm7.13.0" \
                "torchaudio==2.11.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.10.0

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1152/ \
                "torch==2.10.0+rocm7.13.0" \
                "torchvision==0.25.0+rocm7.13.0" \
                "torchaudio==2.10.0+rocm7.13.0"

      .. selected:: pytorch-ver=2.9.1

         .. code-block:: bash

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1152/ \
                "torch==2.9.1+rocm7.13.0" \
                "torchvision==0.24.0+rocm7.13.0" \
                "torchaudio==2.9.0+rocm7.13.0"

4. Verify your PyTorch installation.

   .. code-block:: shell

      python -c "import torch; print(torch.cuda.is_available())"

   This prints ``True`` if PyTorch and ROCm are installed properly.
