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

   .. selector-option:: Radeon
      :value: radeon
      :width: 3

   .. selector-option:: Ryzen AI
      :value: ryzen
      :width: 3

.. selector:: Instinct GPU
   :key: gpu
   :show-when: fam=instinct

   .. selector-info:: https://www.amd.com/en/products/accelerators/instinct.html

   .. selector-option:: MI355X
      :width: 3

   .. selector-option:: MI350X
      :width: 3

   .. selector-option:: MI325X
      :width: 3

   .. selector-option:: MI300X
      :width: 3

   .. selector-option:: MI300A
      :width: 3

   .. selector-option:: MI250X
      :width: 3

   .. selector-option:: MI250
      :width: 3

   .. selector-option:: MI210
      :width: 3

.. selector:: Radeon PRO GPU
   :key: gpu
   :show-when: fam=radeon-pro

   .. selector-info:: https://www.amd.com/en/products/graphics/workstations.html

   .. selector-option:: AI PRO R9700
      :value: ai-r9700
      :width: 3

   .. selector-option:: AI PRO R9600D
      :value: ai-r9600d
      :width: 3

   .. selector-option:: W7900 Dual Slot
      :value: w7900-dual-slot
      :width: 3

   .. selector-option:: W7900
      :value: w7900
      :width: 3

   .. selector-option:: W7800 48GB
      :value: w7800-48gb
      :width: 3

   .. selector-option:: W7800
      :value: w7800
      :width: 3

   .. selector-option:: W7700
      :value: w7700
      :width: 3

   .. selector-option:: V710
      :value: v710
      :width: 3

.. selector:: Radeon GPU
   :key: gpu
   :show-when: fam=radeon

   .. selector-info:: https://www.amd.com/en/products/graphics/desktops/radeon.html

   .. selector-option:: RX 9070 XT
      :value: rx-9070-xt
      :width: 3

   .. selector-option:: RX 9070 GRE
      :value: rx-9070-gre
      :width: 3

   .. selector-option:: RX 9070
      :value: rx-9070
      :width: 3

   .. selector-option:: RX 9060 XT LP
      :value: rx-9060-xt-lp
      :width: 3

   .. selector-option:: RX 9060 XT
      :value: rx-9060-xt
      :width: 3

   .. selector-option:: RX 9060
      :value: rx-9060
      :width: 3

   .. selector-option:: RX 7900 XTX
      :value: rx-7900-xtx
      :width: 3

   .. selector-option:: RX 7900 XT
      :value: rx-7900-xt
      :width: 3

   .. selector-option:: RX 7900 GRE
      :value: rx-7900-gre
      :width: 3

   .. selector-option:: RX 7800 XT
      :value: rx-7800-xt
      :width: 3

   .. selector-option:: RX 7700 XT
      :value: rx-7700-xt
      :width: 3

   .. selector-option:: RX 7700
      :value: rx-7700
      :width: 3

.. selector:: Ryzen AI APU
   :key: gpu
   :show-when: fam=ryzen

   .. selector-info:: https://www.amd.com/en/products/processors/workstations/mobile.html

   .. selector-option:: Max+ PRO 395
      :value: max-pro-395
      :width: 3

   .. selector-option:: Max PRO 390
      :value: max-pro-390
      :width: 3

   .. selector-option:: Max PRO 385
      :value: max-pro-385
      :width: 3

   .. selector-option:: Max PRO 380
      :value: max-pro-380
      :width: 3

   .. selector-option:: Max+ 395
      :value: max-395
      :width: 2

   .. selector-option:: Max 390
      :value: max-390
      :width: 2

   .. selector-option:: Max 385
      :value: max-385
      :width: 2

   .. selector-option:: 9 HX 375
      :value: 9-hx-375
      :width: 2

   .. selector-option:: 9 HX 370
      :value: 9-hx-370
      :width: 2

   .. selector-option:: 9 365
      :value: 9-365
      :width: 2

.. selector:: Operating system
   :key: os
   :show-when: fam=instinct

   .. selector-option:: Linux
      :value: linux
      :width: 12

.. selector:: Operating system
   :key: os
   :show-when: gpu=v710 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

   .. selector-option:: Linux
      :value: linux
      :width: 12

.. selector:: Operating system
   :key: os
   :show-when: fam=ryzen

   .. selector-option:: Linux
      :value: linux
      :width: 6

   .. selector-option:: Windows
      :value: windows
      :width: 6

.. selector:: Operating system
   :key: os
   :show-when: gpu=ai-r9700 gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=w6800 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700

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
   :doc:`ROCm 7.11.0 installation using pip </install/rocm>`, skip this step.

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

   .. selected:: gpu=mi355x gpu=mi350x

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx950-dcgpu/ torch torchvision torchaudio

   .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx94X-dcgpu/ torch torchvision torchaudio

   .. selected:: gpu=mi250x gpu=mi250 gpu=mi210

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx90X-dcgpu/ torch torchvision torchaudio

   .. selected:: gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx120X-all/ torch torchvision torchaudio

   .. selected:: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx110X-dgpu/ torch torchvision torchaudio

   .. selected:: gpu=w6800 gpu=v620

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx103X-dgpu/ torch torchvision torchaudio

   .. selected:: gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1151/ torch torchvision torchaudio

   .. selected:: gpu=9-hx-375 gpu=9-hx-370 gpu=9-365

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1150/ torch torchvision torchaudio

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

