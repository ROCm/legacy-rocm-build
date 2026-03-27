Prerequisites
=============

.. selected:: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

   Before installing the ROCm Core SDK |ROCM_VERSION|, ensure your system meets
   all prerequisites. This includes installing the required dependencies and
   configuring permissions for GPU access. To confirm that your system is
   supported, see the :doc:`Compatibility matrix
   </compatibility/compatibility-matrix>`.

.. selected:: os=windows

   Before installing the ROCm Core SDK |ROCM_VERSION|, ensure your system meets
   all prerequisites. To confirm that your system is supported, see the
   :doc:`Compatibility matrix </compatibility/compatibility-matrix>`.

.. ====================================================== DOCKER REQUIREMENTS ==

.. selected:: os=ubuntu os=debian os=rhel os=rocky-linux os=oracle-linux os=sles

   .. dropdown:: Install essential packages for Docker containers
      :animate: fade-in-slide-down
      :color: info
      :icon: tools
      :chevron: down-up

      Docker images often include only a minimal set of installations, so some
      essential packages might be missing. When installing ROCm within a Docker
      container, you might need to install additional packages for a successful
      installation.

      If applicable, run the following command to install essential packages:

      .. selected:: os=ubuntu os=debian

         .. selected:: i=pkgman

            .. code-block:: bash

               apt update
               apt install sudo wget

         .. selected:: i=pip

            .. code-block:: bash

               apt update
               apt install sudo cmake libgfortran5

         .. selected:: i=tar i=runfile

            .. code-block:: bash

               apt update
               apt install sudo wget python3

      .. selected:: os=rhel os=rocky-linux os=oracle-linux

         .. code-block:: bash

            dnf install sudo wget

      .. selected:: os=sles

         .. selected:: i=pkgman

            .. code-block:: bash

               zypper install sudo wget SUSEConnect

         .. selected:: i=pip

            .. code-block:: bash

               zypper install sudo wget cmake libgfortran5

         .. selected:: i=tar i=runfile

            .. code-block:: bash

               zypper install sudo wget


.. selected:: os=windows

    1. Remove any existing HIP SDK for Windows installations and other
       conflicting AMD graphics software. To uninstall the HIP SDK using the
       GUI, navigate to the following screen:

       * Control Panel > Programs > Uninstall a program

    2. Install AMD Software: Adrenalin Edition for Windows. For details and the
       download link, see `AMD Software: Adrenalin Edition 26.3.1
       <https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-26-3-1.html#Downloads>`__.

    3. Disable the following Windows security features as they can interfere
       with ROCm functionality:

       * Turn off WDAG (Windows Defender Application Guard)

         * Control Panel > Programs > Programs and Features > Turn Windows
           features on or off > **Clear** “Microsoft Defender Application
           Guard”

       * Turn off SAC (Smart App Control)

         * Settings > Privacy & security > Windows Security > App & browser
           control > Smart App Control settings > **Off**

.. =============================================================== OEM KERNEL ==

.. selected:: fam=ryzen

   .. selected:: os=ubuntu
      :heading: Install the OEM kernel
      :heading-level: 3

      Ryzen APUs require the OEM kernel 6.14 for Ubuntu 24.04. Use the
      following command to install it using ``apt``.

      .. code-block:: bash

         sudo apt update && sudo apt install linux-image-6.14.0-1018-oem

      .. note::

         Reboot your system after installing the OEM kernel.

.. ================================================ REGISTER ENTERPRISE LINUX ==

.. selected:: os=rhel
   :heading: Register your Red Hat Enterprise Linux system
   :heading-level: 3

   Register your Red Hat Enterprise Linux (RHEL) system to enable access to Red
   Hat repositories and ensure you’re able to download and install packages.

   Run the following command to register your system:

   .. selected:: os-version=10.1 os-version=10.0

      .. code-block:: bash

         subscription-manager register --username <username> --password <password>

   .. selected:: os-version=9.7 os-version=9.6 os-version=9.4 os-version=8.10

      .. code-block:: bash

         subscription-manager register --username <username> --password <password>
         subscription-manager attach --auto

.. selected:: os=sles
   :heading: Register your SUSE Linux Enterprise Server system
   :heading-level: 3

   Register your SUSE Linux Enterprise Server (SLES) system to enable access to
   SUSE repositories and ensure you’re able to download and install packages.

   Run the following command to register your system:

   .. code-block:: bash

      sudo SUSEConnect -r <REGCODE>

.. ========================================== ADDITIONAL PACKAGE REPOSITORIES ==

.. selected:: os=rhel
   :heading: Update your system
   :heading-level: 3

   After registering your system, update RHEL to the latest packages. This is
   particularly important for newer hardware on older versions of RHEL.

   Run the following command to update your system:

   .. selected:: os-version=10.1

      .. code-block:: bash

         sudo dnf update --releasever=10.1 --exclude=\*release\*

   .. selected:: os-version=10.0

      .. code-block:: bash

         sudo dnf update --releasever=10.0 --exclude=\*release\*

   .. selected:: os-version=9.7

      .. code-block:: bash

         sudo dnf update --releasever=9.7 --exclude=\*release\*

   .. selected:: os-version=9.6

      .. code-block:: bash

         sudo dnf update --releasever=9.6 --exclude=\*release\*

   .. selected:: os-version=9.4

      .. code-block:: bash

         sudo dnf update --releasever=9.4 --exclude=\*release\*

   .. selected:: os-version=8.10

      .. code-block:: bash

         sudo dnf update --releasever=8.10 --exclude=\*release\*

.. selected:: os=sles
   :heading: Update your system
   :heading-level: 3

   After registering your system, update SLES to the latest available packages.
   This is particularly important for newer hardware on older versions of SLES.

   Run the following command to update your system:

   .. code-block:: bash

      sudo zypper update

.. selected:: i=pkgman

   .. selected:: os=oracle-linux
      :heading: Update your system
      :heading-level: 3

      Update Oracle Linux to the latest available packages.

      Run the following command to update your system:

      .. code-block:: bash

         sudo dnf update

   .. selected:: os=rhel
      :heading: Add additional package repositories
      :heading-level: 3

      ROCm installation packages depend on packages that aren’t included in
      the default package repositories. Use the following command to add the
      necessary repositories.

      .. selected:: os-version=10.1 os-version=10.0

         .. code-block:: bash

            wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm
            sudo rpm -ivh epel-release-latest-10.noarch.rpm

         .. code-block:: bash

            sudo dnf config-manager --enable codeready-builder-for-rhel-10-x86_64-rpms

      .. selected:: os-version=9.7 os-version=9.6 os-version=9.4

         .. code-block:: bash

            wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
            sudo rpm -ivh epel-release-latest-9.noarch.rpm

         .. code-block:: bash

            sudo dnf config-manager --enable codeready-builder-for-rhel-9-x86_64-rpms

      .. selected:: os-version=8.10

         .. code-block:: bash

            wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
            sudo rpm -ivh epel-release-latest-8.noarch.rpm

         .. code-block:: bash

            sudo dnf config-manager --enable codeready-builder-for-rhel-8-x86_64-rpms

   .. selected:: os=oracle-linux os=rocky-linux
      :heading: Add additional package repositories
      :heading-level: 3

      ROCm installation packages depend on packages that aren’t included in
      the default package repositories. Use the following command to add the
      necessary repositories.

      .. selected:: os-version=10.1 os-version=10.0

         .. code-block:: bash

            wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm
            sudo rpm -ivh epel-release-latest-10.noarch.rpm

      .. selected:: os-version=9.7 os-version=9.6 os-version=9.4

         .. code-block:: bash

            wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
            sudo rpm -ivh epel-release-latest-9.noarch.rpm

      .. selected:: os-version=8.10

         .. code-block:: bash

            wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
            sudo rpm -ivh epel-release-latest-8.noarch.rpm

      .. code-block:: bash

         sudo crb enable

.. selected:: os=sles
   :heading: Add additional package repositories
   :heading-level: 3

   .. selected:: os-version=16.0

      .. code-block:: bash

         sudo SUSEConnect -p sle-module-desktop-applications/16.0/x86_64
         sudo SUSEConnect -p sle-module-development-tools/16.0/x86_64
         sudo SUSEConnect -p PackageHub/16.0/x86_64

   .. selected:: os-version=15.7

      .. code-block:: bash

         sudo SUSEConnect -p sle-module-desktop-applications/15.7/x86_64
         sudo SUSEConnect -p sle-module-development-tools/15.7/x86_64
         sudo SUSEConnect -p PackageHub/15.7/x86_64


.. ============================================== INSTALL ADDITIONAL PACKAGES ==

.. selected:: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

   .. selected:: i=pkgman i=pip i=tar
      :heading: Install additional packages
      :heading-level: 3

      Some ROCm tools require the ``libatomic`` and ``libquadmath`` libraries to run correctly. Install
      them using your distribution's package manager.

      .. selected:: os=ubuntu os=debian

         .. code-block:: bash

            sudo apt install libatomic1 libquadmath0

      .. selected:: os=rhel os=oracle-linux os=rocky-linux

         .. code-block:: bash

            sudo dnf install libatomic libquadmath

      .. selected:: os=sles

         .. code-block:: bash

            sudo zypper install libatomic1 libquadmath0


.. =========================================================== INSTALL PYTHON ==

.. selected:: i=pip

   .. selected:: os=ubuntu

      .. selected:: os-version=24.04
         :heading: Install Python
         :heading-level: 3

         Install a supported Python version. For example, to install Python
         3.12, run the following command:

         .. code-block:: bash

            sudo apt install python3.12 python3.12-venv

      .. selected:: os-version=22.04
         :heading: Install Python
         :heading-level: 3

         Install a supported Python version. For example, to install Python
         3.11, run the following command:

         .. code-block:: bash

            sudo apt install python3.11 python3.11-venv

   .. selected:: os=debian

      .. selected:: os-version=13
         :heading: Install Python
         :heading-level: 3

         Install a supported Python version. For example, to install Python
         3.13, run the following command:

         .. code-block:: bash

            sudo apt install python3.13 python3.13-venv

      .. selected:: os-version=12
         :heading: Install Python
         :heading-level: 3

         Install a supported Python version. For example, to install Python
         3.11, run the following command:

         .. code-block:: bash

            sudo apt install python3.11 python3.11-venv

   .. selected:: os=rhel os=oracle-linux os=rocky-linux

      .. selected:: os-version=10.1 os-version=10.0 os-version=10
         :heading: Install Python
         :heading-level: 3

         Install a supported Python version. For example, to install Python
         3.12, run the following command:

         .. code-block:: bash

            sudo dnf install python3.12 python3.12-pip

      .. selected:: os-version=9.7 os-version=9.6 os-version=9.4 os-version=9 os-version=8.10 os-version=8
         :heading: Install Python
         :heading-level: 3

         Install a supported Python version. For example, to install Python
         3.11, run the following command:

         .. code-block:: bash

            sudo dnf install python3.11 python3.11-pip

   .. selected:: os=sles
      :heading: Install Python
      :heading-level: 3

      .. selected:: os-version=16.0

         Install a supported Python version. For example, to install Python 3.13,
         run the following command:

         .. code-block:: bash

            sudo zypper install -y python313 python313-pip

      .. selected:: os-version=15.7

         Install a supported Python version. For example, to install Python 3.11,
         run the following command:

         .. code-block:: bash

            sudo zypper install -y python311 python311-pip

   .. selected:: os=windows
      :heading: Install Python
      :heading-level: 3

      Install a supported Python version: 3.11, 3.12, or 3.13. See `Python
      Releases for Windows <https://www.python.org/downloads/windows/>`__ for
      installation details.

.. =================================================== GPU ACCESS PERMISSIONS ==

.. selected:: i=pkgman i=pip i=tar

   .. selected:: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles
      :heading: Configure permissions for GPU access
      :heading-level: 3

      There are two primary methods of configuring GPU access for ROCm: group
      membership or udev rules. Each method has its own advantages. The choice
      depends on your specific requirements and system management preferences.

      .. tab-set::

         .. tab-item:: Group membership

            By default, GPU access is controlled by membership in the ``video`` and
            ``render`` Linux system groups. The ``video`` group traditionally handles
            video device access, while the ``render`` group manages GPU rendering
            through DRM render nodes.

            .. code-block:: bash

               # Add the current user to the render and video groups
               sudo usermod -a -G render,video $LOGNAME

         .. tab-item:: udev rules

            udev rules are a flexible, system-wide approach for managing device
            permissions, eliminating the need for user group management while
            allowing granular GPU access. To enable them and grant GPU access to
            all users, run the following command:

            .. code-block:: bash

               sudo tee /etc/udev/rules.d/70-amdgpu.rules << EOF
               KERNEL=="kfd", GROUP="render", MODE="0666"
               SUBSYSTEM=="drm", KERNEL=="renderD*", GROUP="render", MODE="0666"
               EOF

               sudo udevadm control --reload-rules
               sudo udevadm trigger

      .. note::

         To apply all settings, reboot your system.

