.. selected:: gpu=mi355x gpu=mi350x gpu=mi325x gpu=mi300x
   :heading: GPU virtualization support

   .. selected:: gpu=mi355x

      AMD Instinct MI355X GPUs support the following virtualization
      configurations.
      Supported SR-IOV configurations require the GPU-IOV Module (GIM) driver
      8.7.0K -- see the `AMD Instinct Virtualization Driver documentation
      <https://instinct.docs.amd.com/projects/virt-drv/en/mainline-8.7.0.k/>`__ to
      get started.

   .. selected:: gpu=mi350x

      AMD Instinct MI350X GPUs support the following virtualization
      configurations.
      Supported SR-IOV configurations require the GPU-IOV Module (GIM) driver
      8.7.0K -- see the `AMD Instinct Virtualization Driver documentation
      <https://instinct.docs.amd.com/projects/virt-drv/en/mainline-8.7.0.k/>`__ to
      get started.

   .. selected:: gpu=mi325x

      AMD Instinct MI325X GPUs support the following virtualization
      configurations.
      Supported SR-IOV configurations require the GPU-IOV Module (GIM) driver
      8.7.0K -- see the `AMD Instinct Virtualization Driver documentation
      <https://instinct.docs.amd.com/projects/virt-drv/en/mainline-8.7.0.k/>`__ to
      get started.

   .. selected:: gpu=mi300x

      AMD Instinct MI300X GPUs support the following virtualization
      configurations.
      Supported SR-IOV configurations require the GPU-IOV Module (GIM) driver
      8.7.0K -- see the `AMD Instinct Virtualization Driver documentation
      <https://instinct.docs.amd.com/projects/virt-drv/en/mainline-8.7.0.k/>`__ to
      get started.

   .. matrix::

      .. matrix-row::
         :header:

         .. matrix-cell:: Hypervisor

         .. matrix-cell:: Virtualization technology

         .. matrix-cell:: Virtualization driver

         .. matrix-cell:: Host OS

         .. matrix-cell:: Guest OS

      .. matrix-row::
         :show-when: gpu=mi355x gpu=mi350x

         .. matrix-cell:: KVM
            :rowspan: 2

         .. matrix-cell:: Passthrough

         .. matrix-cell:: —

         .. matrix-cell:: Ubuntu 24.04
            :rowspan: 2

         .. matrix-cell:: Ubuntu 24.04
            :rowspan: 2

      .. matrix-row::
         :show-when: gpu=mi325x

         .. matrix-cell:: KVM

         .. matrix-cell:: SR-IOV

         .. matrix-cell::

            `GIM 8.7.0K <https://github.com/amd/MxGPU-Virtualization/releases/tag/8.7.0.K>`__

         .. matrix-cell:: Ubuntu 22.04

         .. matrix-cell:: Ubuntu 22.04

      .. matrix-row::
         :show-when: gpu=mi300x

         .. matrix-cell:: KVM
            :rowspan: 2

         .. matrix-cell:: Passthrough

         .. matrix-cell:: —

         .. matrix-cell:: Ubuntu 22.04
            :rowspan: 2

         .. matrix-cell:: Ubuntu 22.04
            :rowspan: 2

      .. matrix-row::
         :show-when: gpu=mi355x gpu=mi350x gpu=mi300x

         .. matrix-cell:: SR-IOV

         .. matrix-cell::

            `GIM 8.7.0K <https://github.com/amd/MxGPU-Virtualization/releases/tag/8.7.0.K>`__

   See the :ref:`release notes <release-virtualization-support>`
   for the full list of supported configurations.

