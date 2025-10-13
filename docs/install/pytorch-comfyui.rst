.. meta::
   :description: Step-by-step guide to installing PyTorch with AMD ROCm 7.9.0 and setting up ComfyUI for AI image generation on Ryzen AI (gfx1151) APUs. Covers Linux and Windows installation, environment setup, and troubleshooting.
   :keywords: PyTorch ROCm, ComfyUI, ROCm 7.9.0, AMD GPU, Ryzen AI APU, install PyTorch ROCm, ROCm PyTorch Windows, ROCm PyTorch Linux, ROCm AI image generation, ROCm gfx1151, ComfyUI ROCm setup, PyTorch 2.9.0 ROCm

*****************************************
Install PyTorch and ComfyUI on ROCm 7.9.0
*****************************************

This guide walks you through installing PyTorch with ROCm support on AMD
hardware. It applies to :ref:`supported AMD GPUs and platforms
<790-supported-hw>`. It also includes additional setup steps for ComfyUI on
Windows using Ryzen AI (gfx1151) APUs, showcasing AI-powered image generation.

Prerequisites
=============

Before beginning, ensure your system meets these requirements:

- Python version: 3.11, 3.12, or 3.13 installed and accessible

- ROCm 7.9.0: A working ROCm installation (if not already installed via pip, this guide covers the setup)

Review the :doc:`ROCm 7.9.0 compatibility </compatibility/compatibility-matrix>` information.

.. _790-install-pyt:

Install PyTorch
===============

For prerequisite steps and post-installation recommendations, see :doc:`rocm`.

1. Set up your Python virtual environment. If you already have a successful
   :doc:`ROCm 7.9.0 installation via pip <rocm>`, skip this step.

   .. code-block:: shell

      python3.12 -m venv .venv

2. Activate your Python virtual environment.

   .. tab-set::

      .. tab-item:: Linux
         :sync: linux

         .. code-block:: shell

            source .venv/bin/activate

      .. tab-item:: Windows
         :sync: windows

         .. code-block:: shell

            .venv\Scripts\activate

3. Install the appropriate ROCm-enabled PyTorch build for your operating system
   and AMD hardware architecture.

   .. tab-set::

      .. tab-item:: Linux (PyTorch 2.7.1)
         :sync: linux

         .. tab-set::

            .. tab-item:: Instinct MI350 Series
               :sync: gfx950

               .. code-block:: bash

                  python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx950-dcgpu/ torch torchvision torchaudio

            .. tab-item:: Instinct MI300 Series
               :sync: gfx942

               .. code-block:: bash

                  python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx94X-dcgpu/ torch torchvision torchaudio

            .. tab-item:: Ryzen AI Max APU
               :sync: gfx1151

               .. code-block:: bash

                  python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1151/ torch torchvision torchaudio

      .. tab-item:: Windows (PyTorch 2.9.0)
         :sync: windows

         .. tab-set::

            .. tab-item:: Ryzen AI Max APU
               :sync: gfx1151

               .. code-block:: bash

                  python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1151/ torch torchvision torchaudio

4. Check your PyTorch installation.

   .. code-block:: shell

      python -c "import torch; print(torch.cuda.is_available())"

   This prints ``True`` if PyTorch and ROCm are installed properly.

Optionally, if you're running Windows on a supported Ryzen AI APU, try
:ref:`ComfyUI on Windows <790-install-comfyui>`.

.. _790-install-comfyui:

Install ComfyUI on Windows
==========================

ComfyUI is tested for support only on Ryzen AI (gfx1151) APUs on
Windows.

1. Ensure your working environment is running ROCm-enabled PyTorch 2.9.0 on Windows.
   See :ref:`Install PyTorch <790-install-pyt>`.

2. Clone the ComfyUI repository.

   .. code-block:: shell

      git clone https://github.com/comfyanonymous/ComfyUI.git

3. Install Python dependencies.

   .. code-block:: shell

      pip install -r ComfyUI\requirements.txt

4. Run ComfyUI.

   a. Start the ComfyUI server from the command line.

      .. code-block:: bash

         python ComfyUI\main.py

      This will start the server and display a prompt like:

      .. code-block:: text

         To see the GUI go to: http://127.0.0.1:8188

   b. Navigate to ``http://127.0.0.1:8188`` in your web browser. You might need to
      replace `8188` with the appropriate port number.

      .. image:: /data/comfyui/comfyui-main.png
         :align: center

   c. Search for one of the following templates and download any missing
      models.

      .. tab-set::

         .. tab-item:: SD3.5 Simple

            Select **Template** → **Model Filter** → **SD3.5** → **SD3.5 Simple**

            .. image:: /data/comfyui/sd3_5-simple-card.png
               :align: center

            Download any missing required models.

            .. image:: /data/comfyui/sd3_5-missing-models.png
               :align: center

         .. tab-item:: Chroma1 Radiance text to image

            Select **Template** → **Model Filter** → **Chroma** → **Chroma1 Radiance text to image**

            .. image:: /data/comfyui/chroma1-radiance-tti-card.png
               :align: center

            Download any missing required models.

            .. image:: /data/comfyui/chroma1-radiance-tti-missing-models.png
               :align: center

   d. Click the **Run** button.

   The application will use your AMD GPU to convert the prompted text to an image.

Known limitations
-----------------

ComfyUI might not start if Smart App Control is enabled.
