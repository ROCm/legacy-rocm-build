.. selected:: gpu=ai-r9700s gpu=v710
   :heading: GPU virtualization support

   .. selected:: gpu=ai-r9700s gpu=v710

      Supported SR-IOV configurations require the GPU-IOV Module (GIM) driver
      9.1.0.K -- see the `AMD Instinct Virtualization Driver documentation
      <https://instinct.docs.amd.com/projects/virt-drv/en/mainline-9.1.0.k/>`__ to
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
         :show-cond: gpu=ai-r9700s

         .. matrix-cell:: KVM

         .. matrix-cell:: Passthrough

         .. matrix-cell:: —

         .. matrix-cell:: Ubuntu 24.04

         .. matrix-cell:: Ubuntu 24.04

      .. matrix-row::
         :show-cond: gpu=v710

         .. matrix-cell:: KVM

         .. matrix-cell:: SR-IOV

         .. matrix-cell::

            `GIM 9.1.0.K <https://github.com/amd/MxGPU-Virtualization/releases/tag/9.1.0.K>`__

         .. matrix-cell:: Ubuntu 24.04

         .. matrix-cell:: Ubuntu 24.04

   See the :ref:`release notes <release-virtualization-support>`
   for the full list of supported configurations.

