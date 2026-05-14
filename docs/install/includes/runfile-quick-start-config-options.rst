.. selected:: i=runfile
   :heading: Quick start
   :heading-level: 2

   Download and launch the interactive installer to set up ROCm and/or the AMD
   GPU Driver with guided, step-by-step configuration.

   .. code-block:: bash

      curl -fsSLO https://repo.radeon.com/rocm/installer/rocm-runfile-installer/rocm-rel-7.12/rocm-installer-7.12.0-2.run && bash rocm-installer-7.12.0-2.run

.. selected:: i=runfile
   :heading: Configuration options
   :heading-level: 2

   The following command line options are used to customize the runfile
   installer, including dependency handling and GPU access configuration. For
   recommended usage, go to :ref:`rocm-install`.

   .. selected:: i=runfile
      :heading: Dependencies
      :heading-level: 3

      The runfile installer controls dependency installation via the ``deps=``
      argument.

      .. matrix::

         .. matrix-row::
            :header:

            .. matrix-cell:: Command

            .. matrix-cell:: Description

         .. matrix-row::

            .. matrix-cell::

               ``deps=install``

            .. matrix-cell:: Installs all required packages

         .. matrix-row::

            .. matrix-cell::

               ``deps=list``

            .. matrix-cell:: Lists all required packages

         .. matrix-row::

            .. matrix-cell::

               ``deps=validate``

            .. matrix-cell:: Validates which required packages are installed

      Specify the target after the dependency argument; for example: ``deps=install rocm``.

      .. note::

         It is recommended to include ``deps=install`` if you're not sure what
         dependencies are installed on your system.

   .. selected:: i=runfile
      :heading: GPU access
      :heading-level: 3

      There are two primary methods of configuring GPU access for ROCm: group
      membership or udev rules. The choice depends on your specific
      requirements and system management preferences.

      The runfile installer sets GPU access at install time using the ``gpu-access=`` argument.

      .. matrix::

         .. matrix-row::
            :header:

            .. matrix-cell:: Argument

            .. matrix-cell:: Method

         .. matrix-row::

            .. matrix-cell::

               ``gpu-access=user``

            .. matrix-cell:: Group membership (adds the current user to the render and video groups)

         .. matrix-row::

            .. matrix-cell::

               ``gpu-access=all``

            .. matrix-cell:: udev rules (configures system-wide GPU access)
