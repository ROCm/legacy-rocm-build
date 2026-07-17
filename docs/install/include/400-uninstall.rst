Uninstalling
============

.. ========================================================== PACKAGE MANAGER ==

.. selected:: i=pkgman

   1. Use your package manager to remove the :ref:`installed packages <rocm-install-rocm>`.

      .. selected:: os=ubuntu os=debian os=wsl

         .. selected:: fam=all

            .. code-block:: bash

               sudo apt autoremove amdrocm7.14

         .. selected:: gfx=gfx950

            .. code-block:: bash

               sudo apt autoremove amdrocm7.14-gfx950

         .. selected:: gfx=gfx942

            .. code-block:: bash

               sudo apt autoremove amdrocm7.14-gfx94x

         .. selected:: gfx=gfx90a

            .. code-block:: bash

               sudo apt autoremove amdrocm7.14-gfx90a

         .. selected:: gfx=gfx908

            .. code-block:: bash

               sudo apt autoremove amdrocm7.14-gfx908

         .. selected:: gfx=gfx1201 gfx=gfx1200

            .. code-block:: bash

               sudo apt autoremove amdrocm7.14-gfx120x

         .. selected:: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

            .. code-block:: bash

               sudo apt autoremove amdrocm7.14-gfx110x

         .. selected:: gfx=gfx1030

            .. code-block:: bash

               sudo apt autoremove amdrocm7.14-gfx103x

         .. selected:: gfx=gfx1151

            .. code-block:: bash

               sudo apt autoremove amdrocm7.14-gfx1151

         .. selected:: gfx=gfx1150

            .. code-block:: bash

               sudo apt autoremove amdrocm7.14-gfx1150

         .. selected:: gfx=gfx1152

            .. code-block:: bash

               sudo apt autoremove amdrocm7.14-gfx1152

         .. selected:: gfx=gfx1153

            .. code-block:: bash

               sudo apt autoremove amdrocm7.14-gfx1153

      .. selected:: os=rhel os=oracle-linux os=rocky-linux

         .. selected:: fam=all

            .. code-block:: bash

               sudo dnf remove amdrocm7.14

         .. selected:: gfx=gfx950

            .. code-block:: bash

               sudo dnf remove amdrocm7.14-gfx950

         .. selected:: gfx=gfx942

            .. code-block:: bash

               sudo dnf remove amdrocm7.14-gfx94x

         .. selected:: gfx=gfx90a

            .. code-block:: bash

               sudo dnf remove amdrocm7.14-gfx90a

         .. selected:: gfx=gfx908

            .. code-block:: bash

               sudo dnf remove amdrocm7.14-gfx908

         .. selected:: gfx=gfx1201 gfx=gfx1200

            .. code-block:: bash

               sudo dnf remove amdrocm7.14-gfx120x

         .. selected:: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

            .. code-block:: bash

               sudo dnf remove amdrocm7.14-gfx110x

         .. selected:: gfx=gfx1030

            .. code-block:: bash

               sudo dnf remove amdrocm7.14-gfx103x

         .. selected:: gfx=gfx1151

            .. code-block:: bash

               sudo dnf remove amdrocm7.14-gfx1151

         .. selected:: gfx=gfx1150

            .. code-block:: bash

               sudo dnf remove amdrocm7.14-gfx1150

         .. selected:: gfx=gfx1152

            .. code-block:: bash

               sudo dnf remove amdrocm7.14-gfx1152

         .. selected:: gfx=gfx1153

            .. code-block:: bash

               sudo dnf remove amdrocm7.14-gfx1153

      .. selected:: os=sles

         .. code-block:: bash

            sudo zypper remove amdrocm*

   2. Remove ROCm repositories.

      .. selected:: os=ubuntu os=debian os=wsl

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

            rm -rf ~/.cache/pip

      .. selected:: os=windows

         .. code-block:: bat

            pip cache purge

   2. Remove your local Python virtual environment.

      .. selected:: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

         .. code-block:: bash

            rm -rf .venv

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
               :sync: env-system-setup

               If you opted for a :ref:`system-wide setup
               <rocm-post-install-env>` during the installation
               process, remove the ROCm environment variables.

               .. code-block:: bash

                  sudo rm -f /etc/profile.d/set-rocm-env.sh

            .. tab-item:: User
               :sync: env-user-setup

               If you opted for a :ref:`user-specific setup
               <rocm-post-install-env>` during the installation
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

      .. selected:: fam=all

         .. code-block:: bash

            bash rocm-installer-7.14.0-6.run uninstall-rocm gfx=all

      .. selected:: gfx=gfx950

         .. code-block:: bash

            bash rocm-installer-7.14.0-6.run uninstall-rocm gfx=gfx950

      .. selected:: gfx=gfx942

         .. code-block:: bash

            bash rocm-installer-7.14.0-6.run uninstall-rocm gfx=gfx942

      .. selected:: gfx=gfx90a

         .. code-block:: bash

            bash rocm-installer-7.14.0-6.run uninstall-rocm gfx=gfx90a

      .. selected:: gfx=gfx908

         .. code-block:: bash

            bash rocm-installer-7.14.0-6.run uninstall-rocm gfx=gfx908

      .. selected:: gfx=gfx1201

         .. code-block:: bash

            bash rocm-installer-7.14.0-6.run uninstall-rocm gfx=gfx1201

      .. selected:: gfx=gfx1200

         .. code-block:: bash

            bash rocm-installer-7.14.0-6.run uninstall-rocm gfx=gfx1200

      .. selected:: gfx=gfx1100

         .. code-block:: bash

            bash rocm-installer-7.14.0-6.run uninstall-rocm gfx=gfx1100

      .. selected:: gfx=gfx1101

         .. code-block:: bash

            bash rocm-installer-7.14.0-6.run uninstall-rocm gfx=gfx1101

      .. selected:: gfx=gfx1102

         .. code-block:: bash

            bash rocm-installer-7.14.0-6.run uninstall-rocm gfx=gfx1102

      .. selected:: gfx=gfx1103

         .. code-block:: bash

            bash rocm-installer-7.14.0-6.run uninstall-rocm gfx=gfx1103

      .. selected:: gfx=gfx1030

         .. code-block:: bash

            bash rocm-installer-7.14.0-6.run uninstall-rocm gfx=gfx1030

      .. selected:: gfx=gfx1151

         .. code-block:: bash

            bash rocm-installer-7.14.0-6.run uninstall-rocm gfx=gfx1151

      .. selected:: gfx=gfx1150

         .. code-block:: bash

            bash rocm-installer-7.14.0-6.run uninstall-rocm gfx=gfx1150

      .. selected:: gfx=gfx1152

         .. code-block:: bash

            bash rocm-installer-7.14.0-6.run uninstall-rocm gfx=gfx1152

      .. selected:: gfx=gfx1153

         .. code-block:: bash

            bash rocm-installer-7.14.0-6.run uninstall-rocm gfx=gfx1153

   2. Use the following command to uninstall the AMD GPU Driver (amdgpu).

      .. code-block:: bash

         bash rocm-installer-7.14.0-6.run uninstall-amdgpu

.. selected:: w=graphics

   .. selected:: os=ubuntu os=rhel

      .. selected:: fam=radeon

         1. Use ``amdgpu-uninstall`` to remove the :ref:`installed packages
            <rocm-install-rocm>`.

            .. code-block:: bash

               sudo amdgpu-uninstall

      .. selected:: fam=ryzen

         1. Use ``amdgpu-uninstall`` to remove the :ref:`installed packages
            <rocm-install-rocm>`.

            .. code-block:: bash

               sudo amdgpu-uninstall

      .. selected:: fam=all

         1. Use ``amdgpu-uninstall`` to remove the :ref:`installed packages
            <rocm-install-rocm>`.

            .. code-block:: bash

               sudo amdgpu-uninstall

      2. Remove ROCm repositories.

         .. selected:: os=ubuntu

            .. code-block:: bash

               sudo apt purge amdgpu-install
               sudo apt autoremove

               # Clear the cache and clean the system
               sudo rm -rf /var/cache/apt/*
               sudo apt clean all
               sudo apt update

         .. selected:: os=rhel

            .. code-block:: bash

               sudo dnf remove amdgpu-install

               # Clear the cache and clean the system
               sudo rm -rf /var/cache/dnf
               sudo dnf clean all
