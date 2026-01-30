.. matrix::
   :show-when: fam=instinct

   .. matrix-row::
      :show-when: gfx=950

      .. matrix-cell:: AMD Instinct MI350 Series
         :header:

      .. matrix-cell::

         `Instinct MI355X <https://www.amd.com/en/products/accelerators/instinct/mi350/mi355x.html>`__

         `Instinct MI350X <https://www.amd.com/en/products/accelerators/instinct/mi350/mi350x.html>`__

   .. matrix-row::
      :show-when: gfx=942

      .. matrix-cell:: AMD Instinct MI300 Series
         :header:

      .. matrix-cell::

         `Instinct MI325X <https://www.amd.com/en/products/accelerators/instinct/mi300/mi325x.html>`__

         `Instinct MI300X <https://www.amd.com/en/products/accelerators/instinct/mi300/mi300x.html>`__

         `Instinct MI300A <https://www.amd.com/en/products/accelerators/instinct/mi300/mi300a.html>`__

   .. matrix-row::
      :show-when: gfx=90a

      .. matrix-cell:: AMD Instinct MI200 Series
         :header:

      .. matrix-cell::

         `Instinct MI250X <https://www.amd.com/en/products/accelerators/instinct/mi200/mi250x.html>`__

         `Instinct MI250 <https://www.amd.com/en/products/accelerators/instinct/mi200/mi250.html>`__

         `Instinct MI210 <https://www.amd.com/en/products/accelerators/instinct/mi200/mi210.html>`__

   .. matrix-row::

      .. matrix-cell:: Architecture
         :header:

      .. matrix-cell:: CDNA 4
         :show-when: gfx=950

      .. matrix-cell:: CDNA 3
         :show-when: gfx=942

      .. matrix-cell:: CDNA 2
         :show-when: gfx=90a

   .. matrix-row::

      .. matrix-cell:: LLVM target
         :header:

      .. matrix-cell:: gfx950
         :show-when: gfx=950

      .. matrix-cell:: gfx942
         :show-when: gfx=942

      .. matrix-cell:: gfx90a
         :show-when: gfx=90a

   .. matrix-row::
      :show-when: os=ubuntu

      .. matrix-cell:: Supported Ubuntu versions
         :header:

      .. matrix-cell::

         Ubuntu 24.04.3 (GA kernel: 6.8)

         Ubuntu 22.04.5 (GA kernel: 5.15)

   .. matrix-row::
      :show-when: os=rhel

      .. matrix-cell:: Supported Red Hat Enterprise Linux versions
         :header:

      .. matrix-cell::

         RHEL 10.1 (kernel: 6.12.0-124)

         RHEL 10.0 (kernel: 6.12.0-55)

         RHEL 9.7 (kernel: 5.14.0-611)

         RHEL 9.6 (kernel: 5.14.0-570)

         RHEL 8.10 (kernel: 4.18.0-553)

   .. matrix-row::
      :show-when: os=sles

      .. matrix-cell:: Supported SUSE Linux Enterprise Server version
         :header:

      .. matrix-cell:: SLES 15.7 (kernel: 6.4.0-150700.51)

   .. matrix-row::

      .. matrix-cell:: Supported AMD GPU Driver (amdgpu) versions
         :header:

      .. matrix-cell::

         `30.20.0 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.20.0/>`__,
         `30.10.2 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.2/>`__,
         `30.10.1 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.1/>`__,
         `30.10.0 <https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10/>`__

   .. matrix-row::

      .. matrix-cell:: Supported PLDM bundle (firmware) versions
         :header:

      .. matrix-cell:: 01.25.15.04, 01.25.13.09
         :show-when: gfx=950

      .. matrix-cell::
         :show-when: gfx=942

         **MI325X** 01.25.04.02, 01.25.03.03

         **MI300X** 01.25.05.00 (or later), 01.25.03.12

         **MI300A** BKC 26, 25

      .. matrix-cell::
         :show-when: gfx=90a

         **MI250X** IFWI 47 (or later)

         **MI250** Maintenance update 5 with IFWI 75 (or later)

         **MI210** Maintenance update 5 with IFWI 75 (or later)

