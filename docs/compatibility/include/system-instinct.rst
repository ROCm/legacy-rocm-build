.. matrix::
   :show-cond: fam=instinct

   .. matrix-row::

      .. matrix-cell:: AMD GPU series
         :header:

      .. matrix-cell::
         :show-cond: gpu=mi355x gpu=mi350x gpu=mi350p

         `AMD Instinct MI350 Series <https://www.amd.com/en/products/accelerators/instinct/mi350.html>`__

      .. matrix-cell::
         :show-cond: gpu=mi325x gpu=mi300x gpu=mi300a

         `AMD Instinct MI300 Series <https://www.amd.com/en/products/accelerators/instinct/mi300.html>`__

      .. matrix-cell::
         :show-cond: gpu=mi250x gpu=mi250 gpu=mi210

         `AMD Instinct MI200 Series <https://www.amd.com/en/products/accelerators/instinct/mi200.html>`__

      .. matrix-cell::
         :show-cond: gpu=mi100

         `AMD Instinct MI100 Series <https://www.amd.com/en/products/accelerators/instinct/mi100.html>`__

   .. matrix-row::

      .. matrix-cell:: Architecture
         :header:

      .. matrix-cell:: CDNA 4
         :show-cond: gpu=mi355x gpu=mi350x gpu=mi350p

      .. matrix-cell:: CDNA 3
         :show-cond: gpu=mi325x gpu=mi300x gpu=mi300a

      .. matrix-cell:: CDNA 2
         :show-cond: gpu=mi250x gpu=mi250 gpu=mi210

      .. matrix-cell:: CDNA
         :show-cond: gpu=mi100

   .. matrix-row::

      .. matrix-cell:: LLVM target
         :header:

      .. matrix-cell:: gfx950
         :show-cond: gpu=mi355x gpu=mi350x gpu=mi350p

      .. matrix-cell:: gfx942
         :show-cond: gpu=mi325x gpu=mi300x gpu=mi300a

      .. matrix-cell:: gfx90a
         :show-cond: gpu=mi250x gpu=mi250 gpu=mi210

      .. matrix-cell:: gfx908
         :show-cond: gpu=mi100

   .. matrix-row::
      :show-cond: os=ubuntu

      .. matrix-cell:: Supported Ubuntu versions
         :header:

      .. matrix-cell::
         :show-cond: gpu=mi355x gpu=mi350x gpu=mi325x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210 gpu=mi100

         Ubuntu 26.04 (GA kernel: 7.0)

         Ubuntu 24.04.4 (GA kernel: 6.8)

         Ubuntu 22.04.5 (GA kernel: 5.15)

      .. matrix-cell::
         :show-cond: gpu=mi350p

         Ubuntu 26.04 (GA kernel: 7.0)

         Ubuntu 24.04.4 (GA kernel: 6.8)

   .. matrix-row::
      :show-cond: os=rhel

      .. matrix-cell:: Supported Red Hat Enterprise Linux versions
         :header:

      .. matrix-cell::
         :show-cond: gpu=mi355x gpu=mi350x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210 gpu=mi100

         RHEL 10.1 (kernel: 6.12.0-124)

         RHEL 10.0 (kernel: 6.12.0-55)

         RHEL 9.7 (kernel: 5.14.0-611)

         RHEL 9.6 (kernel: 5.14.0-570)

         RHEL 9.4 (kernel: 5.14.0-427)

         RHEL 8.10 (kernel: 4.18.0-553)

      .. matrix-cell::
         :show-cond: gpu=mi350p

         RHEL 9.6 (kernel: 5.14.0-570)

      .. matrix-cell::
         :show-cond: gpu=mi325x

         RHEL 10.1 (kernel: 6.12.0-124)

         RHEL 10.0 (kernel: 6.12.0-55)

         RHEL 9.7 (kernel: 5.14.0-611)

         RHEL 9.6 (kernel: 5.14.0-570)

         RHEL 9.4 (kernel: 5.14.0-427)

   .. matrix-row::
      :show-cond: os=debian

      .. matrix-cell:: Supported Debian version
         :header:

      .. matrix-cell::
         :show-cond: gpu=mi355x gpu=mi350x gpu=mi325x gpu=mi300x

         Debian 13 (kernel: 6.12)

         Debian 12 (kernel: 6.1.0)

      .. matrix-cell:: Debian 12 (kernel: 6.1.0)
         :show-cond: gpu=mi300a gpu=mi250x gpu=mi250

   .. matrix-row::
      :show-cond: os=oracle-linux

      .. matrix-cell:: Supported Oracle Linux versions
         :header:

      .. matrix-cell::
         :show-cond: gpu=mi355x gpu=mi350x gpu=mi325x

         Oracle Linux 10 (kernel: UEK 8.1)

         Oracle Linux 9 (kernel: UEK 8)

      .. matrix-cell::
         :show-cond: gpu=mi300x

         Oracle Linux 10 (kernel: UEK 8.1)

         Oracle Linux 9 (kernel: UEK 8)

         Oracle Linux 8 (kernel: UEK 7)

   .. matrix-row::
      :show-cond: os=rocky-linux

      .. matrix-cell:: Supported Rocky Linux versions
         :header:

      .. matrix-cell::
         :show-cond: gpu=mi300x gpu=mi300a

         Rocky Linux 9 (kernel: 5.14.0-570)

   .. matrix-row::
      :show-cond: os=sles

      .. matrix-cell:: Supported SUSE Linux Enterprise Server versions
         :header:

      .. matrix-cell::
         :show-cond: gpu=mi355x gpu=mi350x gpu=mi325x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210

         SLES 16.0 (kernel: 6.12)

         SLES 15.7 (kernel: 6.4.0-150700.51)

      .. matrix-cell::
         :show-cond: gpu=mi100

         SLES 15.7 (kernel: 6.4.0-150700.51)

   .. matrix-row::

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

      .. matrix-cell:: Supported PLDM bundle (firmware) versions
         :header:

      .. matrix-cell::
         :show-cond: gpu=mi355x gpu=mi350x gpu=mi300x

         01.26.00.02

      .. matrix-cell::
         :show-cond: gpu=mi350p

         IFWI 00185129

      .. matrix-cell::
         :show-cond: gpu=mi325x

         01.25.04.02

      .. matrix-cell::
         :show-cond: gpu=mi300a

         BKC 26.1

      .. matrix-cell::
         :show-cond: gpu=mi250x

         IFWI 75 (or later)

      .. matrix-cell::
         :show-cond: gpu=mi250 gpu=mi210

         Maintenance update (MU) 5 with IFWI 75 (or later)

      .. matrix-cell::
         :show-cond: gpu=mi100

         VBIOS D3430401-037
