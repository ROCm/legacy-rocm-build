************************
ComfyUI image generation
************************

`ComfyUI <https://github.com/comfyanonymous/ComfyUI>`__ is an open-source,
node-based interface for building and running image generation workflows with
diffusion models such as Stable Diffusion. Its modular graph-based design lets
you construct, customize, and share complex pipelines without writing code. This
page walks through installing and running ComfyUI on AMD GPUs.

Prerequisites
=============

Ensure your working environment is running ROCm-enabled PyTorch on a supported
system. See :doc:`pytorch` for instructions.

Install and run ComfyUI
=======================

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

3. Run ComfyUI.

   a. Start the ComfyUI server from the command line.

      .. tab-set::

         .. tab-item:: Linux
            :sync: linux

            .. code-block:: bash

               python ComfyUI/main.py

         .. tab-item:: Windows
            :sync: windows

            .. code-block:: bat

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

