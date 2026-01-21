.. matrix::
   :show-when: fam=radeon-pro

   .. matrix-head::

      .. raw:: html

         <colgroup style="width: 50%;">

   .. matrix-row::

      .. matrix-cell:: AMD GPU series
         :header:

      .. matrix-cell::
         :show-when: gpu=ai-r9700 gpu=ai-r9600d

         `AMD Radeon AI PRO R9000 Series <https://www.amd.com/en/products/graphics/workstations/radeon-ai-pro.html#tabs-95fa144b96-item-b95ec9e1ca-tab>`__

      .. matrix-cell::
         :show-when: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700

         `AMD Radeon PRO W7000 Series <https://www.amd.com/en/products/graphics/workstations/radeon-pro.html#tabs-990fdead92-item-20daa37284-tab>`__

      .. matrix-cell::
         :show-when: gpu=w6800

         `AMD Radeon PRO W6000 Series <https://www.amd.com/en/products/graphics/workstations/radeon-pro/w6800.html>`__

      .. matrix-cell::
         :show-when: gpu=v710 gpu=v620

         `AMD Radeon PRO V Series <https://www.amd.com/en/products/accelerators/radeon-pro.html>`__

   .. matrix-row::

      .. matrix-cell:: Architecture
         :header:

      .. matrix-cell:: RDNA 4
         :show-when: gpu=ai-r9700 gpu=ai-r9600d

      .. matrix-cell:: RDNA 3
         :show-when: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=w6800 gpu=v620

   .. matrix-row::

      .. matrix-cell:: LLVM target
         :header:

      .. matrix-cell:: gfx1201
         :show-when: gpu=ai-r9700 gpu=ai-r9600d

      .. matrix-cell:: gfx1100
         :show-when: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800

      .. matrix-cell:: gfx1101
         :show-when: gpu=w7700 gpu=v710

      .. matrix-cell:: gfx1030
         :show-when: gpu=w6800 gpu=v620

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

         `31.10.0 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-31.10.0/documentation/release-notes.html>`__

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

         `26.1.1 <https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-26-1-1.html>`__
