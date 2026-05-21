.. matrix::
   :show-cond: fam=radeon

   .. matrix-row::

      .. matrix-cell:: AMD GPU series
         :header:

      .. matrix-cell::
         :show-cond: gpu=ai-r9700s gpu=ai-r9700 gpu=ai-r9600d

         `AMD Radeon AI PRO R9000 Series <https://www.amd.com/en/products/graphics/workstations/radeon-ai-pro.html#tabs-95fa144b96-item-b95ec9e1ca-tab>`__

      .. matrix-cell::
         :show-cond: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700

         `AMD Radeon PRO W7000 Series <https://www.amd.com/en/products/graphics/workstations/radeon-pro.html#tabs-990fdead92-item-20daa37284-tab>`__

      .. matrix-cell::
         :show-cond: gpu=w6800

         `AMD Radeon PRO W6000 Series <https://www.amd.com/en/products/graphics/workstations/radeon-pro/w6800.html>`__

      .. matrix-cell::
         :show-cond: gpu=v710 gpu=v620

         `AMD Radeon PRO V Series <https://www.amd.com/en/products/accelerators/radeon-pro.html>`__

      .. matrix-cell::
         :show-cond: gpu=rx-9070 gpu=rx-9070-gre gpu=rx-9070-xt gpu=rx-9060 gpu=rx-9060-xt gpu=rx-9060-xt-lp

         `AMD Radeon RX 9000 Series <https://www.amd.com/en/products/graphics/desktops/radeon.html#tabs-ff9c5c3863-item-37fb38a236-tab>`__

      .. matrix-cell::
         :show-cond: gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600

         `AMD Radeon RX 7000 Series <https://www.amd.com/en/products/graphics/desktops/radeon/7000-series.html>`__

   .. matrix-row::

      .. matrix-cell:: Architecture
         :header:

      .. matrix-cell:: RDNA 4
         :show-cond: gpu=ai-r9700s gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

      .. matrix-cell:: RDNA 3
         :show-cond: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600

      .. matrix-cell:: RDNA 2
         :show-cond: gpu=w6800 gpu=v620

   .. matrix-row::

      .. matrix-cell:: LLVM target
         :header:

      .. matrix-cell:: gfx1201
         :show-cond: gpu=ai-r9700s gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070 gpu=rx-9070-gre gpu=rx-9070-xt

      .. matrix-cell:: gfx1200
         :show-cond: gpu=rx-9060 gpu=rx-9060-xt gpu=rx-9060-xt-lp

      .. matrix-cell:: gfx1100
         :show-cond: gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800

      .. matrix-cell:: gfx1101
         :show-cond: gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=w7700 gpu=v710

      .. matrix-cell:: gfx1102
         :show-cond: gpu=rx-7600

      .. matrix-cell:: gfx1030
         :show-cond: gpu=w6800 gpu=v620

   .. matrix-row::
      :show-cond: os=ubuntu

      .. matrix-cell:: Supported Ubuntu versions
         :header:

      .. matrix-cell::

         26.04 (GA kernel: 7.0)

         24.04.4 (GA kernel: 6.8)

         22.04.5 (GA kernel: 5.15)

   .. matrix-row::
      :show-cond: os=rhel

      .. matrix-cell:: Supported RHEL versions
         :header:

      .. matrix-cell::

         10.1 (kernel: 6.12.0-124)

         9.7 (kernel: 5.14.0-611)

   .. matrix-row::
      :show-cond: os=windows

      .. matrix-cell:: Supported Windows version
         :header:

      .. matrix-cell:: Windows 11 25H2

   .. matrix-row::
      :show-cond: os=ubuntu os=rhel

      .. matrix-cell:: Supported AMD GPU Driver (amdgpu) versions
         :header:

      .. matrix-cell::

         `31.30.0 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.30.0-preview/documentation/release-notes.html>`__

         `31.20.0 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.20.0-preview/documentation/release-notes.html>`__

         `31.10.0 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.10.0-preview/documentation/release-notes.html>`__

         `30.30.3 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.30.3/documentation/release-notes.html>`__

         `30.30.2 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.30.2/documentation/release-notes.html>`__

         `30.30.1 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.30.1/documentation/release-notes.html>`__

         `30.30.0 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.30.0/documentation/release-notes.html>`__

         `30.20.1 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.20.1/documentation/release-notes.html>`__

         `30.20.0 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.20.0/documentation/release-notes.html>`__

         `30.10.2 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.2/documentation/release-notes.html>`__

         `30.10.1 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.1/documentation/release-notes.html>`__

         `30.10.0 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10/documentation/release-notes.html>`__

   .. matrix-row::
      :show-cond: os=windows

      .. matrix-cell:: Supported Adrenalin Driver version
         :header:

      .. matrix-cell::

         `26.5.1 <https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-26-5-1.html>`__
