**************************************************
Install PyTorch and ComfyUI on ROCm |ROCM_VERSION|
**************************************************

This topic guides you through installing PyTorch with ROCm support on AMD
hardware. It applies to :ref:`supported AMD GPUs and platforms
<release-supported-hw>`. It also includes additional setup steps for ComfyUI,
showcasing AI-powered image generation.

.. selector:: AMD device family
   :key: fam

   .. selector-option:: Instinct
      :value: instinct
      :width: 3

   .. selector-option:: Radeon PRO
      :value: radeon-pro
      :width: 3

   .. selector-option:: Radeon RX
      :value: radeon
      :width: 3

   .. selector-option:: Ryzen AI
      :value: ryzen
      :width: 3

.. selector:: Instinct GPU
   :key: gfx
   :show-when: fam=instinct

   .. selector-info:: https://www.amd.com/en/products/accelerators/instinct.html

   .. selector-option:: Instinct MI355X<br>Instinct MI350X
      :value: 950
      :width: 4

   .. selector-option:: Instinct MI325X<br>Instinct MI300X<br>Instinct MI300A
      :value: 942
      :width: 4

   .. selector-option:: Instinct MI250X<br>Instinct MI250<br>Instinct MI210
      :value: 90a
      :width: 4

.. selector:: Radeon PRO GPU
   :key: gfx
   :show-when: fam=radeon-pro

   .. selector-info:: https://www.amd.com/en/products/graphics/workstations.html

   .. selector-option:: Radeon PRO W7900D<br>Radeon PRO W7900<br>Radeon PRO W7800 48GB<br>Radeon PRO W7800
      :value: 1100
      :width: 6

   .. selector-option:: Radeon PRO W7700
      :value: 1101
      :width: 6

.. selector:: Radeon RX GPU
   :key: gfx
   :show-when: fam=radeon

   .. selector-info:: https://www.amd.com/en/products/graphics/desktops/radeon.html

   .. selector-option:: Radeon RX 7900 XTX<br>Radeon RX 7900 XT<br>Radeon RX 7900 GRE
      :value: 1100

   .. selector-option:: Radeon RX 7800 XT<br>Radeon RX 7700 XT
      :value: 1101

.. selector:: Ryzen AI APU
   :key: gfx
   :show-when: fam=ryzen

   .. selector-info:: https://www.amd.com/en/products/processors/workstations/mobile.html

   .. selector-option:: Ryzen AI Max+ PRO 395<br>Ryzen AI Max PRO 390, 385, 380<br>Ryzen AI Max+ 395<br>Ryzen AI Max 390, 385
      :value: 1151
      :width: 7

   .. selector-option:: Ryzen AI 9 HX 375<br>Ryzen AI 9 HX 370<br>Ryzen AI 9 365
      :value: 1150
      :width: 5

.. selector:: Operating system
   :key: os
   :show-when: fam=instinct

   .. selector-option:: Linux
      :value: linux
      :icon: fab fa-linux fa-lg
      :width: 12

.. selector:: Operating system
   :key: os
   :show-when: fam=radeon-pro fam=radeon fam=ryzen

   .. selector-option:: Linux
      :value: linux
      :icon: fab fa-linux fa-lg
      :width: 6

   .. selector-option:: Windows
      :value: windows
      :icon: fab fa-windows fa-lg
      :width: 6
      :disable-when: fam=instinct

Prerequisites
=============

.. selected:: os=windows

   To run ComfyUI workloads on Windows, ensure you have Adrenalin Driver
   version 25.20.01.17. For details and the download link, see `AMD Software:
   PyTorch on Windows Edition 7.1.1
   <https://www.amd.com/en/resources/support-articles/release-notes/RN-AMDGPU-WINDOWS-PYTORCH-7-1-1.html>`__. See the :ref:`related known issue <comfyui-driver-known-issue>`.

Ensure your system has a :ref:`supported Python version
<rocm-compat-python>` installed and accessible: 3.11, 3.12, or 3.13.

Review the :doc:`/compatibility/compatibility-matrix` for more details.

.. _pip-install-pytorch:

Install PyTorch
===============

For prerequisite steps and post-installation recommendations, see the
:doc:`ROCm installation instructions </install/rocm>`.

1. Set up your Python virtual environment. If you already have a successful
   :doc:`ROCm 7.10.0 installation using pip </install/rocm>`, skip this step.

   For example, run the following command to create a virtual environment:

   .. code-block:: shell

      python3.12 -m venv .venv

2. Activate your Python virtual environment. For example:

   .. selected:: os=linux

      .. code-block:: shell

         source .venv/bin/activate

   .. selected:: os=windows

      .. code-block:: shell

         .venv\Scripts\activate

3. Install the appropriate ROCm-enabled PyTorch build for your operating system
   and AMD hardware architecture.

   .. selected:: gfx=950

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx950-dcgpu/ torch torchvision torchaudio

   .. selected:: gfx=942

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx94X-dcgpu/ torch torchvision torchaudio

   .. selected:: gfx=90a

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx90X-dcgpu/ torch torchvision torchaudio

   .. selected:: gfx=1151

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1151/ torch torchvision torchaudio

   .. selected:: gfx=1150

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1150/ torch torchvision torchaudio

   .. selected:: gfx=1100 gfx=1101

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx110X-dgpu/ torch torchvision torchaudio

4. Check your PyTorch installation.

   .. code-block:: shell

      python -c "import torch; print(torch.cuda.is_available())"

   This prints ``True`` if PyTorch and ROCm are installed properly.

Optionally, for a demonstration of ROCm-powered image generation, try
:ref:`ComfyUI on Windows <install-comfyui-windows>`.

.. _install-comfyui-windows:

Install and run ComfyUI
=======================

1. Ensure your working environment is running ROCm-enabled PyTorch on a supported system.
   See :ref:`Install PyTorch <pip-install-pytorch>` for instructions.

2. Clone the ComfyUI repository.

   .. code-block:: shell

      git clone https://github.com/comfyanonymous/ComfyUI.git

3. Install Python dependencies.

   .. selected:: os=linux

      .. code-block:: shell

         pip install -r ComfyUI/requirements.txt

   .. selected:: os=windows

      .. code-block:: shell

         pip install -r ComfyUI\requirements.txt

4. Run ComfyUI.

   a. Start the ComfyUI server from the command line.

      .. selected:: os=linux

         .. code-block:: bash

            python ComfyUI/main.py

      .. selected:: os=windows

         .. code-block:: bash

            python ComfyUI\main.py

      This will start the server and display a prompt like:

      .. code-block:: text

         To see the GUI go to: http://127.0.0.1:8188

   b. Navigate to ``http://127.0.0.1:8188`` in your web browser. You might need to
      replace ``8188`` with the appropriate port number.

      .. image:: /data/comfyui/comfyui-main.png
         :align: center

   c. Search for one of the following templates and download any missing
      models.

      .. tab-set::

         .. tab-item:: SD3.5 Simple

            Select **Template** → **Model Filter** → **SD3.5** → **SD3.5 Simple**

            .. image:: /data/comfyui/sd3_5-simple-card.png
               :align: center

            Download required models, if missing.

            .. image:: /data/comfyui/sd3_5-missing-models.png
               :align: center

         .. tab-item:: Chroma1 Radiance text to image

            Select **Template** → **Model Filter** → **Chroma** → **Chroma1 Radiance text to image**

            .. image:: /data/comfyui/chroma1-radiance-tti-card.png
               :align: center

            Download required models, if missing.

            .. image:: /data/comfyui/chroma1-radiance-tti-missing-models.png
               :align: center

   d. Click the **Run** button.

   The application will use your AMD GPU to convert the prompted text to an image.

.. selected:: os=windows
   :heading: Known limitations
   :heading-level: 3

   ComfyUI might not start if Smart App Control is enabled in your Windows
   security settings.

