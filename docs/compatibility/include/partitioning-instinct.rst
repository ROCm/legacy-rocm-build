.. selected:: gpu=mi355x gpu=mi350x gpu=mi350p gpu=mi325x gpu=mi300x
   :heading: GPU partitioning support

   .. selected:: gpu=mi355x gpu=mi350x gpu=mi350p gpu=mi325x gpu=mi300x

      AMD Instinct GPUs support compute and memory partitioning modes for bare-metal, passthrough, and SR-IOV deployments.

      The following compute partition and NUMA-per-socket (NPS) configurations are available on AMD Instinct GPUs in bare-metal deployments.


      .. matrix::

         .. matrix-row::
            :header:

            .. matrix-cell:: Compute partition mode

            .. matrix-cell:: Memory partition mode

         .. matrix-row::
            :show-cond: gpu=mi355x gpu=mi350x gpu=mi350p gpu=mi325x gpu=mi300x

            .. matrix-cell:: SPX

            .. matrix-cell:: NPS1

         .. matrix-row::
            :show-cond: gpu=mi355x gpu=mi350x gpu=mi300x

            .. matrix-cell:: DPX

            .. matrix-cell:: NPS2

         .. matrix-row::
            :show-cond: gpu=mi355x gpu=mi350x

            .. matrix-cell:: CPX

            .. matrix-cell:: NPS2

         .. matrix-row::
            :show-cond: gpu=mi355x gpu=mi350x

            .. matrix-cell:: QPX

            .. matrix-cell:: NPS2

         .. matrix-row::
            :show-cond: gpu=mi350p

            .. matrix-cell:: DPX

            .. matrix-cell:: NPS1

         .. matrix-row::
            :show-cond: gpu=mi350p

            .. matrix-cell:: CPX

            .. matrix-cell:: NPS1

         .. matrix-row::
            :show-cond: gpu=mi300x

            .. matrix-cell:: CPX

            .. matrix-cell:: NPS4


      The following configurations are available on AMD Instinct GPUs in passthrough deployments.

      .. matrix::

         .. matrix-row::
            :header:

            .. matrix-cell:: Deployment

            .. matrix-cell:: Compute partition mode

            .. matrix-cell:: Memory partition mode

         .. matrix-row::
            :show-cond: gpu=mi355x gpu=mi350x gpu=mi325x gpu=mi300x

            .. matrix-cell:: KVM Passthrough

            .. matrix-cell:: SPX

            .. matrix-cell:: NPS1

         .. matrix-row::
            :show-cond: gpu=mi350p gpu=mi300x

            .. matrix-cell:: ESXi Passthrough

            .. matrix-cell:: SPX

            .. matrix-cell:: NPS1

   .. selected:: gpu=mi355x gpu=mi350x gpu=mi325x gpu=mi300x

      The following configurations are available on AMD Instinct GPUs in SR-IOV deployments. See :ref:`release-virtualization-support` for driver support information.

      .. matrix::

         .. matrix-row::
            :header:

            .. matrix-cell:: Deployment

            .. matrix-cell:: VFs per GPU

            .. matrix-cell:: Compute partition mode

            .. matrix-cell:: Memory partition mode

         .. matrix-row::
            :show-cond: gpu=mi355x gpu=mi350x gpu=mi300x gpu=mi325x

            .. matrix-cell:: KVM SR-IOV

            .. matrix-cell:: 1

            .. matrix-cell:: SPX

            .. matrix-cell:: NPS1

         .. matrix-row::
            :show-cond: gpu=mi355x gpu=mi350x

            .. matrix-cell:: KVM SR-IOV

            .. matrix-cell:: 2[*]

            .. matrix-cell:: DPX

            .. matrix-cell:: NPS2

         .. matrix-row::
            :show-cond: gpu=mi355x gpu=mi350x

            .. matrix-cell:: KVM SR-IOV

            .. matrix-cell:: 8[*]

            .. matrix-cell:: CPX

            .. matrix-cell:: NPS2

         .. matrix-row::
            :show-cond: gpu=mi355x gpu=mi350x

            .. matrix-cell:: ESXi SR-IOV

            .. matrix-cell:: 1

            .. matrix-cell:: SPX

            .. matrix-cell:: NPS1

         .. matrix-row::
            :show-cond: gpu=mi300x

            .. matrix-cell:: KVM SR-IOV

            .. matrix-cell:: 8[*]

            .. matrix-cell:: CPX

            .. matrix-cell:: NPS4


      [*] Multi-VF support requires a compatible firmware. See the :ref:`release notes <release-virtualization-support>` for the list of required firmware versions and supported configurations.
