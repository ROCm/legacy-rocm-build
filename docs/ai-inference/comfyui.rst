********************************
ComfyUI image generation on ROCm
********************************

`ComfyUI <https://github.com/comfyanonymous/ComfyUI>`__ is an open-source,
node-based interface for building and running image generation workflows with
diffusion models such as Stable Diffusion. Its modular graph-based design lets
you construct, customize, and share complex pipelines without writing code. This
page walks through installing and running ComfyUI on AMD GPUs.

Prerequisites
=============

Ensure your working environment is running ROCm-enabled PyTorch on
a :ref:`supported system <compat-matrix>`. See :ref:`pytorch-install` for
instructions.

.. important::

   On Windows, ComfyUI might not start if Smart App Control is enabled in your
   Windows security settings.

Installation
============

After installing ROCm and PyTorch in your Python environment, follow these
steps to install ComfyUI.

1. Clone the ComfyUI repository.

   .. code-block:: shell

      git clone https://github.com/comfyanonymous/ComfyUI.git

2. Activate your Python virtual environment and install dependencies.

   .. tab-set::

      .. tab-item:: Linux
         :sync: linux

         .. code-block:: bash

            pip install -r ComfyUI/requirements.txt

      .. tab-item:: Windows
         :sync: windows

         .. code-block:: bat

            pip install -r ComfyUI\requirements.txt

Run ComfyUI
===========

Use the following steps for a simple example of running ComfyUI.

1. Start the ComfyUI server from the command line.

   .. tab-set::

      .. tab-item:: Linux
         :sync: linux

         .. code-block:: bash

            python ComfyUI/main.py

      .. tab-item:: Windows
         :sync: windows

         .. code-block:: bat

            python ComfyUI\main.py

   This starts the server, displaying a prompt like:

   .. code-block:: text

      To see the GUI go to: http://127.0.0.1:8188

2. Go to ``http://127.0.0.1:8188`` in your web browser. You might need to
   replace ``8188`` with the appropriate port.

   .. image:: ./images/comfyui/comfyui-main.png
      :align: center

3. Search for one of the following templates and download any missing
   models.

   .. tab-set::

      .. tab-item:: SD3.5 Simple

         Select **Template** → **Model Filter** → **SD3.5** → **SD3.5 Simple**

         .. image:: ./images/comfyui/sd3_5-simple-card.png
            :align: center

         Download required models, if missing.

         .. image:: ./images/comfyui/sd3_5-missing-models.png
            :align: center

      .. tab-item:: Chroma1 Radiance text to image

         Select **Template** → **Model Filter** → **Chroma** → **Chroma1 Radiance text to image**

         .. image:: ./images/comfyui/chroma1-radiance-tti-card.png
            :align: center

         Download required models, if missing.

         .. image:: ./images/comfyui/chroma1-radiance-tti-missing-models.png
            :align: center

4. Click the **Run** button.

   The application will use your AMD GPU to convert the prompted text to an image.

.. seealso::

   To learn more about the ComfyUI interface and workflows, see the `ComfyUI
   documentation <https://docs.comfy.org/development/core-concepts/workflow>`__.
