Uninstalling
============

.. ========================================================== PACKAGE MANAGER ==

.. selected:: i=pkgman

   1. Use your package manager to remove :ref:`ROCm meta packages <rocm-install-meta-packages>` installed on your system.

      .. selected:: os=ubuntu os=debian

         .. selected:: gpu=mi355x gpu=mi350x

            .. code-block:: bash

               sudo apt autoremove amdrocm7.12-gfx950

         .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

            .. code-block:: bash

               sudo apt autoremove amdrocm7.12-gfx94x

         .. selected:: gpu=mi250x gpu=mi250 gpu=mi210

            .. code-block:: bash

               sudo apt autoremove amdrocm7.12-gfx90a

         .. selected:: gpu=mi100

            .. code-block:: bash

               sudo apt autoremove amdrocm7.12-gfx908

         .. selected:: gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

            .. code-block:: bash

               sudo apt autoremove amdrocm7.12-gfx120x

         .. selected:: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600 gpu=9-270 gpu=7-260 gpu=7-250 gpu=5-240 gpu=5-230 gpu=5-220 gpu=3-210

            .. code-block:: bash

               sudo apt autoremove amdrocm7.12-gfx110x

         .. selected:: gpu=w6800 gpu=v620

            .. code-block:: bash

               sudo apt autoremove amdrocm7.12-gfx103x

         .. selected:: gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385

            .. code-block:: bash

               sudo apt autoremove amdrocm7.12-gfx1151

         .. selected:: gpu=9-hx-pro-475 gpu=9-hx-pro-470 gpu=9-pro-465 gpu=7-pro-450 gpu=5-pro-440 gpu=5-pro-435 gpu=9-hx-375 gpu=9-hx-370 gpu=9-365

            .. code-block:: bash

               sudo apt autoremove amdrocm7.12-gfx1150

      .. selected:: os=rhel os=oracle-linux os=rocky-linux

         .. selected:: gpu=mi355x gpu=mi350x

            .. code-block:: bash

               sudo dnf remove amdrocm7.12-gfx950

         .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

            .. code-block:: bash

               sudo dnf remove amdrocm7.12-gfx94x

         .. selected:: gpu=mi250x gpu=mi250 gpu=mi210

            .. code-block:: bash

               sudo dnf remove amdrocm7.12-gfx90a

         .. selected:: gpu=mi100

            .. code-block:: bash

               sudo dnf remove amdrocm7.12-gfx908

         .. selected:: gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

            .. code-block:: bash

               sudo dnf remove amdrocm7.12-gfx120x

         .. selected:: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600

            .. code-block:: bash

               sudo dnf remove amdrocm7.12-gfx110x

         .. selected:: gpu=w6800 gpu=v620

            .. code-block:: bash

               sudo dnf remove amdrocm7.12-gfx103x

      .. selected:: os=sles

         .. code-block:: bash

            sudo zypper remove amdrocm*

   2. Remove ROCm repositories.

      .. selected:: os=ubuntu os=debian

         .. code-block:: bash

            # Remove ROCm repositories
            sudo rm /etc/apt/sources.list.d/rocm.list

            # Clear the cache and clean the system
            sudo rm -rf /var/cache/apt/*
            sudo apt clean all
            sudo apt update

      .. selected:: os=rhel os=oracle-linux os=rocky-linux

         .. code-block:: bash

            # Remove ROCm repositories
            sudo rm /etc/yum.repos.d/rocm.repo*

            # Clear the cache and clean the system
            sudo rm -rf /var/cache/dnf
            sudo dnf clean all

      .. selected:: os=sles

         .. code-block:: bash

            # Remove ROCm repositories
            sudo zypper removerepo "rocm"

            # Clear the cache and clean the system
            sudo zypper clean --all
            sudo zypper refresh

.. ====================================================================== PIP ==

.. selected:: i=pip

   1. Clear the pip cache.

      .. selected:: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

         .. code-block:: bash

            sudo rm -rf ~/.cache/pip

      .. selected:: os=windows

         .. code-block:: bat

            pip cache purge

   2. Remove your local Python virtual environment.

      .. selected:: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

         .. code-block:: bash

            sudo rm -rf .venv

      .. selected:: os=windows

         .. code-block:: bat

            rmdir /s /q .venv

.. ================================================================== TARBALL ==

.. selected:: i=tar

   .. selected:: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      1. To uninstall ROCm, remove your installation directory.

         .. important::

            The following command assumes you’re working with the
            ``therock-tarball`` directory. If you chose a different directory
            name when :ref:`installing ROCm <rocm-install>`, adjust the command
            accordingly.

         .. code-block:: bash

            sudo rm -rf therock-tarball

      2. Remove your ROCm environment configuration from your system.

         .. tab-set::

            .. tab-item:: System-wide 
               :sync: tarball-system-setup

               If you opted for a :ref:`system-wide setup
               <rocm-post-install-system-wide>` during the installation
               process, remove the ROCm environment variables.

               .. code-block:: bash

                  sudo rm -f /etc/profile.d/set-rocm-env.sh

            .. tab-item:: User
               :sync: tarball-user-setup

               If you opted for a :ref:`user-specific setup
               <rocm-post-install-system-wide>` during the installation
               process, remove the ROCm environment configuration block from
               your shell configuration file (``~/.bashrc`` or ``~/.profile``).

   .. selected:: os=windows

      1. To uninstall ROCm, remove your installation directory.

         .. code-block:: bat

            rmdir /s /q C:\TheRock

         .. important::

            This step assumes you’re working with the ``C:\TheRock\build``
            directory. If you chose a different directory name when
            :ref:`installing ROCm <rocm-install>`, adjust this step
            accordingly.

      2. **Run command prompt as an administrator** and delete the following environment variables.

         .. code-block:: bat

            setx HIP_DEVICE_LIB_PATH "" /M
            setx HIP_PATH "" /M
            setx HIP_PLATFORM "" /M
            setx LLVM_PATH "" /M

         Remove the following paths from your PATH environment variable using your system settings GUI.
         Navigate to the following screen:

         * Control Panel > System and Security > Edit environment variables

         Edit the PATH variable and delete the following paths:

         * ``C:\TheRock\build\bin``

         * ``C:\TheRock\build\lib\llvm\bin``

      3. To uninstall the Adrenalin Driver, see `Uninstall AMD Software
         <https://www.amd.com/en/resources/support-articles/faqs/RSX2-UNINSTALL.html>`__.


.. ================================================================== RUNFILE ==

.. selected:: i=runfile

   1. Use the following command to uninstall ROCm.

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run uninstall-rocm

   2. Use the following command to uninstall the AMD GPU Driver (amdgpu).

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run uninstall-amdgpu
