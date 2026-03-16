.. matrix::
   :show-when: fam=radeon

   .. matrix-head::

      .. raw:: html

         <colgroup style="width: 50%;">

   .. matrix-row::

      .. matrix-cell:: AMD GPU series
         :header:

      .. matrix-cell::
         :show-when: gpu=rx-9070 gpu=rx-9070-gre gpu=rx-9070-xt gpu=rx-9060 gpu=rx-9060-xt gpu=rx-9060-xt-lp

         `AMD Radeon RX 9000 Series <https://www.amd.com/en/products/graphics/desktops/radeon.html#tabs-ff9c5c3863-item-37fb38a236-tab>`__

      .. matrix-cell::
         :show-when: gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600

         `AMD Radeon RX 7000 Series <https://www.amd.com/en/products/graphics/desktops/radeon/7000-series.html>`__

   .. matrix-row::

      .. matrix-cell:: Architecture
         :header:

      .. matrix-cell:: RDNA 4
         :show-when: gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

      .. matrix-cell:: RDNA 3
         :show-when: gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600

   .. matrix-row::

      .. matrix-cell:: LLVM target
         :header:

      .. matrix-cell:: gfx1201
         :show-when: gpu=rx-9070 gpu=rx-9070-gre gpu=rx-9070-xt

      .. matrix-cell:: gfx1200
         :show-when: gpu=rx-9060 gpu=rx-9060-xt gpu=rx-9060-xt-lp

      .. matrix-cell:: gfx1100
         :show-when: gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre

      .. matrix-cell:: gfx1101
         :show-when: gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700

      .. matrix-cell:: gfx1102
         :show-when: gpu=rx-7600

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

      .. matrix-cell::

         10.1 (kernel: 6.12.0-124)

         9.7 (kernel: 5.14.0-427)

   .. matrix-row::
      :show-when: os=windows

      .. matrix-cell:: Supported Windows version
         :header:

      .. matrix-cell:: Windows 11 25H2

   .. matrix-row::
      :show-when: os=ubuntu os=rhel

      .. matrix-cell:: Supported AMD GPU Driver (amdgpu) versions
         :header:

      .. matrix-cell::

         `31.20.0 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.20.0-preview/documentation/release-notes.html>`__

         `31.10.0 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.10.0-preview/documentation/release-notes.html>`__

         `30.20.1 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.20.1/documentation/release-notes.html>`__

         `30.20.0 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.20.0/documentation/release-notes.html>`__

         `30.10.2 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.2/documentation/release-notes.html>`__

         `30.10.1 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.1/documentation/release-notes.html>`__

         `30.10.0 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10/documentation/release-notes.html>`__

   .. matrix-row::
      :show-when: os=windows

      .. matrix-cell:: Supported Adrenalin Driver version
         :header:

      .. matrix-cell::

         `26.3.1 <https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-26-3-1.html>`__
