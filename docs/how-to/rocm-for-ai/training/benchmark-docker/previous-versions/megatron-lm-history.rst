:orphan:

********************************************************
Megatron-LM training performance testing version history
********************************************************

This table lists previous versions of the ROCm Megatron-LM training Docker image for
inference performance testing. For detailed information about available models
for benchmarking, see the version-specific documentation. You can find tagged
previous releases of the ``ROCm/megatron-lm`` Docker image on `Docker Hub <https://hub.docker.com/r/rocm/megatron-lm/tags>`__.

.. list-table::
   :header-rows: 1

   * - Image version
     - Components
     - Resources

   * - v25.10 (latest)
     -
       * ROCm 7.1.0
       * PyTorch 2.10.0.dev20251112+rocm7.1
     -
       * :doc:`Primus Megatron documentation <../primus-megatron>`
       * :doc:`Megatron-LM (legacy) documentation <../megatron-lm>`
       * `Docker Hub <https://hub.docker.com/layers/rocm/primus/v25.9_gfx950/images/sha256-1a198be32f49efd66d0ff82066b44bd99b3e6b04c8e0e9b36b2c481e13bff7b6>`__

   * - v25.9
     -
       * ROCm 7.0.0
       * Primus 0.3.0
       * PyTorch 2.9.0.dev20250821+rocm7.0.0.lw.git125803b7
     -
       * :doc:`Primus Megatron documentation <primus-megatron-v25.9>`
       * :doc:`Megatron-LM (legacy) documentation <megatron-lm-v25.9>`
       * `Docker Hub (gfx950) <https://hub.docker.com/layers/rocm/primus/v25.9_gfx950/images/sha256-1a198be32f49efd66d0ff82066b44bd99b3e6b04c8e0e9b36b2c481e13bff7b6>`__
       * `Docker Hub (gfx942) <https://hub.docker.com/layers/rocm/primus/v25.9_gfx942/images/sha256-df6ab8f45b4b9ceb100fb24e19b2019a364e351ee3b324dbe54466a1d67f8357>`__

   * - v25.8
     -
       * ROCm 6.4.3
       * PyTorch 2.8.0a0+gitd06a406
     -
       * :doc:`Primus Megatron documentation <primus-megatron-v25.8>`
       * :doc:`Megatron-LM (legacy) documentation <megatron-lm-v25.8>`
       * `Docker Hub (py310) <https://hub.docker.com/layers/rocm/megatron-lm/v25.8_py310/images/sha256-0030c4a3dcb233c66dd5f61135821f9f5c4e321cbe0a2cdc74f110752f28c869>`__

   * - v25.7
     -
       * ROCm 6.4.2
       * PyTorch 2.8.0a0+gitd06a406
     -
       * :doc:`Primus Megatron documentation <primus-megatron-v25.7>`
       * :doc:`Megatron-LM (legacy) documentation <megatron-lm-v25.7>`
       * `Docker Hub (py310) <https://hub.docker.com/layers/rocm/megatron-lm/v25.7_py310/images/sha256-6189df849feeeee3ae31bb1e97aef5006d69d2b90c134e97708c19632e20ab5a>`__

   * - v25.6
     -
       * ROCm 6.4.1
       * PyTorch 2.8.0a0+git7d205b2
     -
       * :doc:`Documentation <megatron-lm-v25.6>`
       * `Docker Hub (py312) <https://hub.docker.com/layers/rocm/megatron-lm/v25.6_py312/images/sha256-482ff906532285bceabdf2bda629bd32cb6174d2d07f4243a736378001b28df0>`__
       * `Docker Hub (py310) <https://hub.docker.com/layers/rocm/megatron-lm/v25.6_py310/images/sha256-9627bd9378684fe26cb1a10c7dd817868f553b33402e49b058355b0f095568d6>`__

   * - v25.5
     -
       * ROCm 6.3.4
       * PyTorch 2.8.0a0+gite2f9759
     -
       * :doc:`Documentation <megatron-lm-v25.5>`
       * `Docker Hub (py312) <https://hub.docker.com/layers/rocm/megatron-lm/v25.5_py312/images/sha256-4506f18ba188d24189c6b1f95130b425f52c528a543bb3f420351824edceadc2>`__
       * `Docker Hub (py310) <https://hub.docker.com/layers/rocm/megatron-lm/v25.5_py310/images/sha256-743fbf1ceff7a44c4452f938d783a7abf143737d1c15b2b95f6f8a62e0fd048b>`__

   * - v25.4
     -
       * ROCm 6.3.0
       * PyTorch 2.7.0a0+git637433
     -
       * :doc:`Documentation <megatron-lm-v25.4>`
       * `Docker Hub <https://hub.docker.com/layers/rocm/megatron-lm/v25.4/images/sha256-941aa5387918ea91c376c13083aa1e6c9cab40bb1875abbbb73bbb65d8736b3f>`__

   * - v25.3
     -
       * ROCm 6.3.0
       * PyTorch 2.7.0a0+git637433
     -
       * :doc:`Documentation <megatron-lm-v25.3>`
       * `Docker Hub <https://hub.docker.com/layers/rocm/megatron-lm/v25.3/images/sha256-1e6ed9bdc3f4ca397300d5a9907e084ab5e8ad1519815ee1f868faf2af1e04e2>`__

   * - v24.12-dev
     -
       * ROCm 6.1.0
       * PyTorch 2.4.0
     -
       * :doc:`Documentation <megatron-lm-v24.12-dev>`
       * `Docker Hub <https://hub.docker.com/layers/rocm/megatron-lm/24.12-dev/images/sha256-5818c50334ce3d69deeeb8f589d83ec29003817da34158ebc9e2d112b929bf2e>`__
