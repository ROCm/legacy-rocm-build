**************************************
Install PyTorch on ROCm |ROCM_VERSION|
**************************************

This topic guides you through installing PyTorch with ROCm support on AMD
hardware. It applies to :ref:`supported AMD GPUs and platforms
<release-ai-ecosystem>`.

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
      :width: 3
      :toc-label: AMD Instinct MI355X

   .. selector-option:: MI350X
      :width: 3
      :toc-label: AMD Instinct MI350X

   .. selector-option:: MI325X
      :width: 3
      :toc-label: AMD Instinct MI325X

   .. selector-option:: MI300X
      :width: 3
      :toc-label: AMD Instinct MI300X

   .. selector-option:: MI300A
      :width: 20%
      :toc-label: AMD Instinct MI300A

   .. selector-option:: MI250X
      :width: 20%
      :toc-label: AMD Instinct MI250X

   .. selector-option:: MI250
      :width: 20%
      :toc-label: AMD Instinct MI250

   .. selector-option:: MI210
      :width: 20%
      :toc-label: AMD Instinct MI210

   .. selector-option:: MI100
      :width: 20%
      :toc-label: AMD Instinct MI100


.. selector:: Radeon PRO GPU
   :key: gpu
   :show-when: fam=radeon-pro

   .. selector-info:: https://www.amd.com/en/products/graphics/workstations.html

   .. selector-option:: AI PRO R9700
      :value: ai-r9700
      :width: 3
      :toc-label: AMD Radeon AI PRO R9700

   .. selector-option:: AI PRO R9600D
      :value: ai-r9600d
      :width: 3
      :toc-label: AMD Radeon AI PRO R9600D

   .. selector-option:: W7900 Dual Slot
      :value: w7900-dual-slot
      :width: 3
      :toc-label: AMD Radeon PRO W7900 Dual Slot

   .. selector-option:: W7900
      :value: w7900
      :width: 3
      :toc-label: AMD Radeon PRO W7900

   .. selector-option:: W7800 48GB
      :value: w7800-48gb
      :width: 3
      :toc-label: AMD Radeon PRO W7800 48GB

   .. selector-option:: W7800
      :value: w7800
      :width: 3
      :toc-label: AMD Radeon PRO W7800

   .. selector-option:: W7700
      :value: w7700
      :width: 3
      :toc-label: AMD Radeon PRO W7700

   .. selector-option:: V710
      :value: v710
      :width: 3
      :toc-label: AMD Radeon PRO V710

.. selector:: Radeon GPU
   :key: gpu
   :show-when: fam=radeon

   .. selector-info:: https://www.amd.com/en/products/graphics/desktops/radeon.html

   .. selector-option:: RX 9070 XT
      :value: rx-9070-xt
      :width: 3
      :toc-label: AMD Radeon RX 9070 XT

   .. selector-option:: RX 9070 GRE
      :value: rx-9070-gre
      :width: 3
      :toc-label: AMD Radeon RX 9070 GRE

   .. selector-option:: RX 9070
      :value: rx-9070
      :width: 3
      :toc-label: AMD Radeon RX 9070

   .. selector-option:: RX 9060 XT LP
      :value: rx-9060-xt-lp
      :width: 3
      :toc-label: AMD Radeon RX 9060 XT LP

   .. selector-option:: RX 9060 XT
      :value: rx-9060-xt
      :width: 3
      :toc-label: AMD Radeon RX 9060 XT

   .. selector-option:: RX 9060
      :value: rx-9060
      :width: 3
      :toc-label: AMD Radeon RX 9060

   .. selector-option:: RX 7900 XTX
      :value: rx-7900-xtx
      :width: 3
      :toc-label: AMD Radeon RX 7900 XTX

   .. selector-option:: RX 7900 XT
      :value: rx-7900-xt
      :width: 3
      :toc-label: AMD Radeon RX 7900 XT

   .. selector-option:: RX 7900 GRE
      :value: rx-7900-gre
      :width: 3
      :toc-label: AMD Radeon RX 7900 GRE

   .. selector-option:: RX 7800 XT
      :value: rx-7800-xt
      :width: 3
      :toc-label: AMD Radeon RX 7800 XT

   .. selector-option:: RX 7700 XT
      :value: rx-7700-xt
      :width: 3
      :toc-label: AMD Radeon RX 7700 XT

   .. selector-option:: RX 7700 XE
      :value: rx-7700-xe
      :width: 3
      :toc-label: AMD Radeon RX 7700 XE

   .. selector-option:: RX 7700
      :value: rx-7700
      :width: 3
      :toc-label: AMD Radeon RX 7700

   .. selector-option:: RX 7600
      :value: rx-7600
      :width: 3
      :toc-label: AMD Radeon RX 7600

.. selector:: Ryzen APU
   :key: gpu
   :show-when: fam=ryzen

   .. selector-info:: https://www.amd.com/en/products/processors/workstations/mobile.html

   .. selector-option:: AI Max+ PRO 395
      :value: max-pro-395
      :width: 3
      :toc-label: AMD Ryzen AI Max+ PRO 395

   .. selector-option:: AI Max PRO 390
      :value: max-pro-390
      :width: 3
      :toc-label: AMD Ryzen AI Max PRO 390

   .. selector-option:: AI Max PRO 385
      :value: max-pro-385
      :width: 3
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

   .. selector-option:: AI 9 HX PRO 475
      :value: 9-hx-pro-475
      :width: 3
      :toc-label: AMD Ryzen AI 9 HX PRO 475

   .. selector-option:: AI 9 HX PRO 470
      :value: 9-hx-pro-470
      :width: 3
      :toc-label: AMD Ryzen AI 9 HX PRO 470

   .. selector-option:: AI 9 PRO 465
      :value: 9-pro-465
      :width: 3
      :toc-label: AMD Ryzen AI 9 PRO 465

   .. selector-option:: AI 7 PRO 450
      :value: 7-pro-450
      :width: 3
      :toc-label: AMD Ryzen AI 7 PRO 450

   .. selector-option:: AI 5 PRO 440
      :value: 5-pro-440
      :width: 3
      :toc-label: AMD Ryzen AI 5 PRO 440

   .. selector-option:: AI 5 PRO 435
      :value: 5-pro-435
      :width: 20%
      :toc-label: AMD Ryzen AI 5 PRO 435

   .. selector-option:: AI 9 HX 375
      :value: 9-hx-375
      :width: 20%
      :toc-label: AMD Ryzen AI 9 HX 375

   .. selector-option:: AI 9 HX 370
      :value: 9-hx-370
      :width: 20%
      :toc-label: AMD Ryzen AI 9 HX 370

   .. selector-option:: AI 9 365
      :value: 9-365
      :width: 20%
      :toc-label: AMD Ryzen AI 9 365

   .. selector-option:: 9 270
      :value: 9-270
      :width: 20%
      :toc-label: AMD Ryzen 9 270

   .. selector-option:: 7 260
      :value: 7-260
      :width: 2
      :toc-label: AMD Ryzen 7 260

   .. selector-option:: 7 250
      :value: 7-250
      :width: 2
      :toc-label: AMD Ryzen 7 250

   .. selector-option:: 5 240
      :value: 5-240
      :width: 2
      :toc-label: AMD Ryzen 5 240

   .. selector-option:: 5 230
      :value: 5-230
      :width: 2
      :toc-label: AMD Ryzen 5 230

   .. selector-option:: 5 220
      :value: 5-220
      :width: 2
      :toc-label: AMD Ryzen 5 220

   .. selector-option:: 3 210
      :value: 3-210
      :width: 2
      :toc-label: AMD Ryzen 3 210

.. selector:: Operating system
   :key: os
   :show-when: fam=instinct

   .. selector-option:: Linux
      :value: linux
      :width: 12

.. selector:: Operating system
   :key: os
   :show-when: gpu=v710 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060 gpu=rx-7700 gpu=rx-7600

   .. selector-option:: Linux
      :value: linux
      :width: 12

.. selector:: Operating system
   :key: os
   :show-when: gpu=ai-r9700 gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=w6800 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe

   .. selector-option:: Linux
      :value: linux
      :width: 6

   .. selector-option:: Windows
      :value: windows
      :width: 6

.. selector:: Operating system
   :key: os
   :show-when: fam=ryzen

   .. selector-option:: Linux
      :value: linux
      :width: 6

   .. selector-option:: Windows
      :value: windows
      :width: 6

Prerequisites
=============

Ensure your system has a :ref:`supported Python version
<rocm-compat-python>` installed and accessible: 3.11, 3.12, or 3.13.

Review the :doc:`/compatibility/compatibility-matrix` for more details.

.. _pip-install-pytorch:

Install PyTorch
===============

For prerequisite steps and post-installation recommendations, see the
:doc:`ROCm installation instructions </install/rocm>`.

1. Set up your Python virtual environment. If you already have a successful
   ROCm |ROCM_VERSION| :doc:`installation using pip </install/rocm>`, skip this
   step.

   For example, run the following command to create a virtual environment:

   .. selected:: os=linux

      .. code-block:: bash

         python3.12 -m venv .venv

   .. selected:: os=windows

      .. code-block:: bat

         py -3.12 -m venv .venv

2. Activate your Python virtual environment. For example:

   .. selected:: os=linux

      .. code-block:: bash

         source .venv/bin/activate

   .. selected:: os=windows

      .. code-block:: bat

         .venv\Scripts\activate

3. Install the appropriate ROCm-enabled PyTorch build for your operating system
   and AMD hardware architecture.

   .. selected:: gpu=mi355x gpu=mi350x

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx950-dcgpu/ torch torchvision torchaudio

   .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx94X-dcgpu/ torch torchvision torchaudio

   .. selected:: gpu=mi250x gpu=mi250 gpu=mi210

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx90a/ torch torchvision torchaudio

   .. selected:: gpu=mi100

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx908/ torch torchvision torchaudio

   .. selected:: gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx120X-all/ torch torchvision torchaudio

   .. selected:: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600 gpu=9-270 gpu=7-260 gpu=7-250 gpu=5-240 gpu=5-230 gpu=5-220 gpu=3-210

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx110X-dgpu/ torch torchvision torchaudio

   .. selected:: gpu=w6800 gpu=v620

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx103X-dgpu/ torch torchvision torchaudio

   .. selected:: gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1151/ torch torchvision torchaudio

   .. selected:: gpu=9-hx-pro-475 gpu=9-hx-pro-470 gpu=9-pro-465 gpu=7-pro-450 gpu=5-pro-440 gpu=5-pro-435 gpu=9-hx-375 gpu=9-hx-370 gpu=9-365

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1150/ torch torchvision torchaudio

4. Check your PyTorch installation.

   .. code-block:: shell

      python -c "import torch; print(torch.cuda.is_available())"

   This prints ``True`` if PyTorch and ROCm are installed properly.

Optionally, for a demonstration of ROCm-powered image generation, try
:doc:`ComfyUI <comfyui>`.
