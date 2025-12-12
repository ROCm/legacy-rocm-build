.. matrix::
   :show-when: fam=radeon

   .. matrix-row::
      :show-when: gfx=1100

      .. matrix-cell:: AMD Radeon RX 7000 Series
         :header:

      .. matrix-cell::

         `Radeon RX 7900 XTX <https://www.amd.com/en/products/graphics/desktops/radeon/7000-series/amd-radeon-rx-7900xtx.html>`__

         `Radeon RX 7900 XT <https://www.amd.com/en/products/graphics/desktops/radeon/7000-series/amd-radeon-rx-7900xt.html>`__

         `Radeon RX 7900 GRE <https://www.amd.com/en/products/graphics/desktops/radeon/7000-series/amd-radeon-rx-7900-gre.html>`__

   .. matrix-row::
      :show-when: gfx=1101

      .. matrix-cell:: AMD Radeon RX 7000 Series
         :header:

      .. matrix-cell::

         `Radeon RX 7800 XT <https://www.amd.com/en/products/graphics/desktops/radeon/7000-series/amd-radeon-rx-7800-xt.html>`__

         `Radeon RX 7700 XT <https://www.amd.com/en/products/graphics/desktops/radeon/7000-series/amd-radeon-rx-7700-xt.html>`__

   .. matrix-row::

      .. matrix-cell:: Architecture
         :header:

      .. matrix-cell:: RDNA 3
         :show-when: gfx=1101 gfx=1100

   .. matrix-row::

      .. matrix-cell:: LLVM target
         :header:

      .. matrix-cell:: gfx1100
         :show-when: gfx=1100

      .. matrix-cell:: gfx1101
         :show-when: gfx=1101

   .. matrix-row::
      :show-when: os=ubuntu

      .. matrix-cell:: Supported Ubuntu versions
         :header:

      .. matrix-cell::

         24.04.3 (GA kernel: 6.8)

         22.04.5 (GA kernel: 5.15)

   .. matrix-row::
      :show-when: os=rhel

      .. matrix-cell:: Supported RHEL versions
         :header:

      .. matrix-cell:: 10.1, 10.0

   .. matrix-row::
      :show-when: os=windows

      .. matrix-cell:: Supported Windows version
         :header:

      .. matrix-cell:: Windows 11 25H2

   .. matrix-row::

      .. matrix-cell:: Supported AMD GPU Driver (amdgpu) versions
         :header:

      .. matrix-cell:: 

         `30.20.0 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.20.0/>`__,
         `30.10.2 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.2/>`__,
         `30.10.1 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.1/>`__,
         `30.10.0 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10/>`__

   .. matrix-row::
      :show-when: os=ubuntu os=rhel os=sles

      .. matrix-cell:: Supported Radeon Software for Linux version
         :header:

      .. matrix-cell::

         `25.30.1 <https://www.amd.com/en/support/download/linux-drivers.html#linux-for-radeon-pro>`__

   .. matrix-row::
      :show-when: os=windows

      .. matrix-cell:: Supported Adrenalin Driver version
         :header:

      .. matrix-cell::

         `25.11.1 <https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-25-11-1.html>`__
         (generally recommended)

         `25.20.01.17 <https://www.amd.com/en/resources/support-articles/release-notes/RN-AMDGPU-WINDOWS-PYTORCH-7-1-1.html>`__
         (recommended for ComfyUI)

