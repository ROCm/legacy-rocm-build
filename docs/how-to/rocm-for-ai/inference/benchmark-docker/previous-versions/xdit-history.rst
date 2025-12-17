:orphan:

************************************************************
xDiT diffusion inference performance testing version history
************************************************************

This table lists previous versions of the ROCm xDiT diffusion inference performance
testing environment. For detailed information about available models for
benchmarking, see the version-specific documentation.

.. list-table::
   :header-rows: 1

   * - Docker image tag
     - Components
     - Resources

   * - ``rocm/pytorch-xdit:v25.11`` (latest)
     - 
       * `ROCm 7.10.0 preview <https://rocm.docs.amd.com/en/7.10.0-preview/about/release-notes.html>`__
       * TheRock 3e3f834
       * rccl d23d18f
       * composable_kernel 2570462
       * rocm-libraries 0588f07
       * rocm-systems 473025a
       * torch 73adac
       * torchvision f5c6c2e
       * triton 7416ffc
       * accelerate 34c1779
       * aiter de14bec
       * diffusers 40528e9
       * xfuser 83978b5
       * yunchang 2c9b712
     - 
       * :doc:`Documentation <../../xdit-diffusion-inference>`
       * `Docker Hub <https://hub.docker.com/r/rocm/pytorch-xdit>`__

   * - ``rocm/pytorch-xdit:v25.10``
     - 
       * `ROCm 7.9.0 preview <https://rocm.docs.amd.com/en/7.9.0-preview/about/release-notes.html>`__
       * TheRock 7afbe45
       * rccl 9b04b2a
       * composable_kernel b7a806f
       * rocm-libraries f104555
       * rocm-systems 25922d0
       * torch 2.10.0a0+gite9c9017
       * torchvision 0.22.0a0+966da7e
       * triton 3.5.0+git52e49c12
       * accelerate 1.11.0.dev0
       * aiter 0.1.5.post4.dev20+ga25e55e79
       * diffusers 0.36.0.dev0
       * xfuser 0.4.4
       * yunchang 0.6.3.post1
     - 
       * :doc:`Documentation <xdit-25.10>`
       * `Docker Hub <https://hub.docker.com/r/rocm/pytorch-xdit>`__
