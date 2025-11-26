Prerequisites
=============

Before installing the ROCm Core SDK |ROCM_VERSION|, ensure your system meets
all prerequisites. This includes installing the required dependencies and
configuring permissions for GPU access. To confirm that your system is
supported, see the :doc:`Compatibility matrix
</compatibility/compatibility-matrix>`.

.. selected:: os=ubuntu os=rhel os=sles

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

      .. selected:: os=ubuntu

         .. code-block:: bash

            apt update
            apt install sudo wget python3 libatomic1

      .. selected:: os=rhel

         .. selected:: os-version=10.1 os-version=10.0 os-version=9.7 os-version=9.6

            .. code-block:: bash

               dnf install sudo wget libatomic

         .. selected:: os-version=8

            .. code-block:: bash

               dnf install sudo wget libatomic python3

      .. selected:: os=sles

         .. code-block:: bash

            zypper install sudo libatomic1 libgfortran5 wget SUSEConnect python3


.. selected:: os=windows

    1. Remove any existing HIP SDK for Windows installations and other
       conflicting AMD graphics software.

    2. Install the Adrenalin Driver for Windows.

       * For general use cases, use the Adrenalin Driver version 25.11.1. For
         details and the download link, see `AMD Software: Adrenalin
         Edition 25.11.1
         <https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-25-11-1.html>`__.

       * If you intend to run :ref:`ComfyUI workloads
         <install-comfyui-windows>`, use driver version 25.20.01.17. For
         details and the download link, see `AMD Software: PyTorch on Windows
         Edition 7.1.1
         <https://www.amd.com/en/resources/support-articles/release-notes/RN-AMDGPU-WINDOWS-PYTORCH-7-1-1.html>`__.

    3. Disable the following Windows security features as they can interfere
       with ROCm functionality:

       * Turn off WDAG (Windows Defender Application Guard)

         * Control Panel > Programs > Programs and Features > Turn Windows
           features on or off > **Clear** “Microsoft Defender Application
           Guard”

       * Turn off SAC (Smart App Control)

         * Settings > Privacy & security > Windows Security > App & browser
           control > Smart App Control settings > **Off**

.. selected:: os=rhel
   :heading: Register your Red Hat Enterprise Linux system
   :heading-level: 3

   Register your Red Hat Enterprise Linux (RHEL) system to enable access to Red
   Hat repositories and ensure you’re able to download and install packages.

   Run the following command to register your system:

   .. selected:: os-version=10.1 os-version=10.0

      .. code-block:: bash

         subscription-manager register --username <username> --password <password>

   .. selected:: os-version=9.7 os-version=9.6 os-version=8

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

   .. selected:: os-version=8

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

.. selected:: i=pip

   .. selected:: os=ubuntu

      .. selected:: os-version=24
         :heading: Install Python
         :heading-level: 3

         Install a supported Python version. For example, to install Python
         3.12, run the following command:

         .. code-block:: bash

            sudo apt install python3.12 python3.12-venv

      .. selected:: os-version=22
         :heading: Install Python
         :heading-level: 3

         Install a supported Python version. For example, to install Python
         3.11, run the following command:

         .. code-block:: bash

            sudo apt install python3.11 python3.11-venv

   .. selected:: os=rhel

      .. selected:: os-version=10.1 os-version=10.0
         :heading: Install Python
         :heading-level: 3

         Install a supported Python version. For example, to install Python
         3.12, run the following command:

         .. code-block:: bash

            sudo dnf install python3.12 python3.12-pip

      .. selected:: os-version=9.7 os-version=9.6 os-version=8
         :heading: Install Python
         :heading-level: 3

         Install a supported Python version. For example, to install Python
         3.11, run the following command:

         .. code-block:: bash

            sudo dnf install python3.11 python3.11-pip

   .. selected:: os=sles
      :heading: Install Python
      :heading-level: 3

      Install a supported Python version. For example, to install Python 3.11,
      run the following command:

      .. code-block:: bash

         sudo zypper install -y python311 python311-pip

   .. selected:: os=windows
      :heading: Install Python
      :heading-level: 3

      Install a supported Python version: 3.11, 3.12, or 3.13.

.. selected:: os=rhel

   .. selected:: os-version=10.0 os-version=8
      :heading: Install additional development packages
      :heading-level: 3

      .. code-block:: bash

         sudo dnf install libatomic

.. selected:: os=sles

   .. selected:: os-version=15
      :heading: Install additional development packages
      :heading-level: 3

      .. code-block:: bash

         sudo zypper install libatomic1

.. selected:: os=ubuntu os=rhel os=sles
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

