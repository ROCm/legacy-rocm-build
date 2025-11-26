Uninstalling
============

.. dropdown:: Installation environment
   :animate: fade-in-slide-down
   :icon: desktop-download
   :chevron: down-up

   .. include:: ./includes/selector.rst

.. selected:: i=pip
   :heading: Remove your Python virtual environment
   :heading-level: 3

   1. Clear the pip cache.

      .. selected:: os=ubuntu os=rhel os=sles

         .. code-block:: bash

            sudo rm -rf ~/.cache/pip

      .. selected:: os=windows

         .. code-block:: bat

            pip cache purge

   2. Remove your local Python virtual environment.

      .. selected:: os=ubuntu os=rhel os=sles

         .. code-block:: bash

            sudo rm -rf .venv

      .. selected:: os=windows

         .. code-block:: bat

            rmdir /s /q .venv

   .. selected:: os=windows

.. selected:: i=tar
   :heading: Remove your installation directory
   :heading-level: 3

   .. selected:: os=ubuntu os=rhel os=sles

      1. To uninstall ROCm, remove your installation directory.

         .. important::

            The following command assumes you’re working with the
            ``therock-tarball`` directory. If you chose a different directory
            name when :ref:`installing ROCm <rocm-install>`, adjust the command
            accordingly.

         .. code-block:: bash

            sudo rm -rf therock-tarball

      2. If you opted for a :ref:`system-wide setup
         <rocm-post-install-system-wide>` during the installation process,
         remove the ROCm environment variables.

         .. code-block:: bash

            sudo rm -f /etc/profile.d/set-rocm-env.sh

   .. selected:: os=windows

      1. Delete your ``C:\TheRock\build`` installation directory and its
         contents.

         .. important::

            This step assumes you’re working with the ``C:\TheRock\build``
            directory. If you chose a different directory name when
            :ref:`installing ROCm <rocm-install>`, adjust this step
            accordingly.

      2. Delete the environment variables. For example, using PowerShell as an administrator:

         .. code-block:: powershell

            [Environment]::SetEnvironmentVariable("HIP_PATH", $null, "Machine")
            [Environment]::SetEnvironmentVariable("HIP_DEVICE_LIB_PATH", $null, "Machine")
            [Environment]::SetEnvironmentVariable("HIP_PLATFORM", $null, "Machine")
            [Environment]::SetEnvironmentVariable("LLVM_PATH", $null, "Machine")

         Remove the following paths from your PATH environment variable using your system settings GUI.

         * ``C:\TheRock\build\bin``

         * ``C:\TheRock\build\lib\llvm\bin``

      3. If you want to uninstall the Adrenalin driver, see `Uninstall AMD
         Software
         <https://www.amd.com/en/resources/support-articles/faqs/RSX2-UNINSTALL.html>`__.

