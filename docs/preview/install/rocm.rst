************************************************
Install the ROCm 7.0 RC1 via package manager
************************************************

This page describes how to install the AMD ROCm 7.0 RC1 build using
your Linux distribution's package manager. Before installing, see the
:ref:`supported hardware and distros <rc1-system-requirements>` to make sure
your system is compatible.

.. _rc1-system-requirements:

.. important::

   Upgrades and downgrades are not supported. You must uninstall any existing
   ROCm installation before installing the preview build.

Prerequisites
=============

Before installing, complete the following prerequisites.

.. tab-set::

   .. tab-item:: Ubuntu 22.04
      :sync: ubuntu-22

      1. Install development packages.

         .. code-block:: shell

            sudo apt install python3-setuptools python3-wheel

      2. Configure user permissions for GPU access.

         .. code-block:: shell

            sudo usermod -a -G render,video $LOGNAME

   .. tab-item:: Ubuntu 24.04
      :sync: ubuntu-24

      1. Install development packages.

         .. code-block:: shell

            sudo apt install python3-setuptools python3-wheel

      2. Configure user permissions for GPU access.

         .. code-block:: shell

            sudo usermod -a -G render,video $LOGNAME

   .. tab-item:: Debian 12
      :sync: debian-12

      1. Install development packages.

         .. code-block:: shell

            sudo apt install python3-setuptools python3-wheel

      2. Configure user permissions for GPU access.

         .. code-block:: shell

            sudo usermod -a -G render,video $LOGNAME

   .. tab-item:: RHEL 8.10
      :sync: rhel-810

      1. Register your Enterprise Linux.

         .. code-block:: shell

            subscription-manager register --username <username> --password <password>
            subscription-manager attach --auto

      2. Update your Enterprise Linux.

         .. code-block:: shell

            sudo dnf update --releasever=8.10 --exclude=\*release\*

      3. Install additional package repositories.

         Add the EPEL repository:

         .. code-block:: shell

            wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
            sudo rpm -ivh epel-release-latest-8.noarch.rpm

         Enable the CodeReady Linux Build (CRB) repository.

         .. code-block:: shell

            sudo dnf install dnf-plugin-config-manager
            sudo crb enable

      4. Install development packages.

         .. code-block:: shell

            sudo dnf install python3-setuptools python3-wheel

      5. Configure user permissions for GPU access.

         .. code-block:: shell

            sudo usermod -a -G render,video $LOGNAME

   .. tab-item:: RHEL 9.4
      :sync: rhel-94

      1. Register your Enterprise Linux.

         .. code-block:: shell

            subscription-manager register --username <username> --password <password>
            subscription-manager attach --auto

      2. Update your Enterprise Linux.

         .. code-block:: shell

            sudo dnf update --releasever=9.4 --exclude=\*release\*

      3. Install additional package repositories.

         Add the EPEL repository:

         .. code-block:: shell

            wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
            sudo rpm -ivh epel-release-latest-9.noarch.rpm

         Enable the CodeReady Linux Build (CRB) repository.

         .. code-block:: shell

            sudo dnf install dnf-plugin-config-manager
            sudo crb enable

      4. Install development packages.

         .. code-block:: shell

            sudo dnf install python3-setuptools python3-wheel

      5. Configure user permissions for GPU access.

         .. code-block:: shell

            sudo usermod -a -G render,video $LOGNAME

   .. tab-item:: RHEL 9.6
      :sync: rhel-96

      1. Register your Enterprise Linux.

         .. code-block:: shell

            subscription-manager register --username <username> --password <password>
            subscription-manager attach --auto

      2. Update your Enterprise Linux.

         .. code-block:: shell

            sudo dnf update --releasever=9.6 --exclude=\*release\*

      3. Install additional package repositories.

         Add the EPEL repository:

         .. code-block:: shell

            wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
            sudo rpm -ivh epel-release-latest-9.noarch.rpm

         Enable the CodeReady Linux Build (CRB) repository.

         .. code-block:: shell

            sudo dnf install dnf-plugin-config-manager
            sudo crb enable

      4. Install development packages.

         .. code-block:: shell

            sudo dnf install python3-setuptools python3-wheel

      5. Configure user permissions for GPU access.

         .. code-block:: shell

            sudo usermod -a -G render,video $LOGNAME

   .. tab-item:: Oracle Linux 8.10
      :sync: ol-810

      1. Update your Enterprise Linux.

         .. code-block:: shell

            sudo dnf update --releasever=8.10 --exclude=\*release\*

      2. Install additional package repositories.

         Add the EPEL repository:

         .. code-block:: shell

            wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
            sudo rpm -ivh epel-release-latest-8.noarch.rpm

         Enable the CodeReady Linux Build (CRB) repository.

         .. code-block:: shell

            sudo dnf install dnf-plugin-config-manager
            sudo crb enable

      3. Install development packages.

         .. code-block:: shell

            sudo dnf install python3-setuptools python3-wheel

      4. Configure user permissions for GPU access.

         .. code-block:: shell

            sudo usermod -a -G render,video $LOGNAME

   .. tab-item:: Oracle Linux 9.6
      :sync: ol-96

      1. Update your Enterprise Linux.

         .. code-block:: shell

            sudo dnf update --releasever=9.6 --exclude=\*release\*

      2. Install additional package repositories.

         Add the EPEL repository:

         .. code-block:: shell

            wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
            sudo rpm -ivh epel-release-latest-9.noarch.rpm

         Enable the CodeReady Linux Build (CRB) repository.

         .. code-block:: shell

            sudo dnf install dnf-plugin-config-manager
            sudo crb enable

      3. Install development packages.

         .. code-block:: shell

            sudo dnf install python3-setuptools python3-wheel

      4. Configure user permissions for GPU access.

         .. code-block:: shell

            sudo usermod -a -G render,video $LOGNAME

   .. tab-item:: SLES 15 SP6
      :sync: sles-156

      1. Register your Enterprise Linux.

         .. code-block:: shell

            sudo SUSEConnect -r <REGCODE>

      2. Update your Enterprise Linux.

         .. code-block:: shell

            sudo zypper update

      3. Install additional package repositories.

         Add a few modules with SUSEConnect and the science repository.

         .. code-block:: shell

            sudo SUSEConnect -p sle-module-desktop-applications/15.6/x86_64
            sudo SUSEConnect -p sle-module-development-tools/15.6/x86_64
            sudo SUSEConnect -p PackageHub/15.6/x86_64
            sudo zypper install zypper
            sudo zypper addrepo https://download.opensuse.org/repositories/science/SLE_15_SP5/science.repo 

      4. Install development packages.

         .. code-block:: shell

            sudo dnf install python3-setuptools python3-wheel

      5. Configure user permissions for GPU access.

         .. code-block:: shell

            sudo usermod -a -G render,video $LOGNAME

   .. tab-item:: SLES 15 SP7
      :sync: sles-157

      1. Register your Enterprise Linux.

         .. code-block:: shell

            sudo SUSEConnect -r <REGCODE>

      2. Update your Enterprise Linux.

         .. code-block:: shell

            sudo zypper update

      3. Install additional package repositories.

         Add a few modules with SUSEConnect and the science repository.

         .. code-block:: shell

            sudo SUSEConnect -p sle-module-desktop-applications/15.7/x86_64
            sudo SUSEConnect -p sle-module-development-tools/15.7/x86_64
            sudo SUSEConnect -p PackageHub/15.7/x86_64
            sudo zypper install zypper
            sudo zypper addrepo https://download.opensuse.org/repositories/science/SLE_15_SP5/science.repo 

      4. Install development packages.

         .. code-block:: shell

            sudo dnf install python3-setuptools python3-wheel

      5. Configure user permissions for GPU access.

         .. code-block:: shell

            sudo usermod -a -G render,video $LOGNAME

Register ROCm repositories
==========================

.. tab-set::

   .. tab-item:: Ubuntu 22.04
      :sync: ubuntu-22

      1. Add the package signing key.

         .. code-block:: shell

            # Make the directory if it doesn't exist yet.
            # This location is recommended by the distribution maintainers.
            sudo mkdir --parents --mode=0755 /etc/apt/keyrings 
            # Download the key, convert the signing-key to a full
            # keyring required by apt and store in the keyring directory.
            wget https://repo.radeon.com/rocm/rocm.gpg.key -O - | \
              gpg --dearmor | sudo tee /etc/apt/keyrings/rocm.gpg > /dev/null 

      2. Register ROCm packages.

         .. code-block:: shell

            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/7.0_rc1 jammy main" \
              | sudo tee /etc/apt/sources.list.d/rocm.list

            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/graphics/7.0_rc1/ubuntu jammy main" \ 
              | sudo tee /etc/apt/sources.list.d/rocm-graphics.list

            echo -e 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' \
              | sudo tee /etc/apt/preferences.d/rocm-pin-600
            sudo apt update

   .. tab-item:: Ubuntu 24.04
      :sync: ubuntu-24

      1. Add the package signing key.

         .. code-block:: shell

            # Make the directory if it doesn't exist yet.
            # This location is recommended by the distribution maintainers.
            sudo mkdir --parents --mode=0755 /etc/apt/keyrings 
            # Download the key, convert the signing-key to a full
            # keyring required by apt and store in the keyring directory.
            wget https://repo.radeon.com/rocm/rocm.gpg.key -O - | \
              gpg --dearmor | sudo tee /etc/apt/keyrings/rocm.gpg > /dev/null 

      2. Register ROCm packages.

         .. code-block:: shell

            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/7.0_rc1 noble main" \
              | sudo tee /etc/apt/sources.list.d/rocm.list

            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/graphics/7.0_rc1/ubuntu noble main" \
              | sudo tee /etc/apt/sources.list.d/rocm-graphics.list

            echo -e 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' \
              | sudo tee /etc/apt/preferences.d/rocm-pin-600
            sudo apt update

   .. tab-item:: Debian 12
      :sync: debian-12

      1. Add the package signing key.

         .. code-block:: shell

            # Make the directory if it doesn't exist yet.
            # This location is recommended by the distribution maintainers.
            sudo mkdir --parents --mode=0755 /etc/apt/keyrings 
            # Download the key, convert the signing-key to a full
            # keyring required by apt and store in the keyring directory.
            wget https://repo.radeon.com/rocm/rocm.gpg.key -O - | \
              gpg --dearmor | sudo tee /etc/apt/keyrings/rocm.gpg > /dev/null 

      2. Register ROCm packages.

         .. code-block:: shell

            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/7.0_rc1 jammy main" \
              | sudo tee /etc/apt/sources.list.d/rocm.list

            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/graphics/7.0_rc1/ubuntu jammy main" \ 
              | sudo tee /etc/apt/sources.list.d/rocm-graphics.list

            echo -e 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' \
              | sudo tee /etc/apt/preferences.d/rocm-pin-600
            sudo apt update

   .. tab-item:: RHEL 8.10
      :sync: rhel-810

      .. code-block:: shell

         sudo tee /etc/yum.repos.d/rocm.repo <<EOF
         [ROCm-7.0.0]
         name=ROCm7.0.0
         baseurl=https://repo.radeon.com/rocm/el8/7.0_rc1/main
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF

         sudo tee /etc/yum.repos.d/rocm-graphics.repo <<EOF
         [ROCm-7.0.0-Graphics]
         name=ROCm7.0.0-Graphics
         baseurl=https://repo.radeon.com/graphics/7.0_rc1/rhel/8.10/main/x86_64/
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF
         sudo dnf clean all

   .. tab-item:: RHEL 9.4
      :sync: rhel-94

      .. code-block:: shell

         sudo tee /etc/yum.repos.d/rocm.repo <<EOF
         [ROCm-7.0.0]
         name=ROCm7.0.0
         baseurl=https://repo.radeon.com/rocm/el9/7.0_rc1/main
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF

         sudo tee /etc/yum.repos.d/rocm-graphics.repo <<EOF
         [ROCm-7.0.0-Graphics]
         name=ROCm7.0.0-Graphics
         baseurl=https://repo.radeon.com/graphics/7.0_rc1/rhel/9.4/main/x86_64/
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF
         sudo dnf clean all

   .. tab-item:: RHEL 9.6
      :sync: rhel-96

      .. code-block:: shell

         sudo tee /etc/yum.repos.d/rocm.repo <<EOF
         [ROCm-7.0.0]
         name=ROCm7.0.0
         baseurl=https://repo.radeon.com/rocm/el9/7.0_rc1/main
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF

         sudo tee /etc/yum.repos.d/rocm-graphics.repo <<EOF
         [ROCm-7.0.0-Graphics]
         name=ROCm7.0.0-Graphics
         baseurl=https://repo.radeon.com/graphics/7.0_rc1/rhel/9.6/main/x86_64/
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF
         sudo dnf clean all

   .. tab-item:: Oracle Linux 8.10
      :sync: ol-810

      .. code-block:: shell

         sudo tee /etc/yum.repos.d/rocm.repo <<EOF
         [ROCm-7.0.0]
         name=ROCm7.0.0
         baseurl=https://repo.radeon.com/rocm/el8/7.0_rc1/main
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF

         sudo tee /etc/yum.repos.d/rocm-graphics.repo <<EOF
         [ROCm-7.0.0-Graphics]
         name=ROCm7.0.0-Graphics
         baseurl=https://repo.radeon.com/graphics/7.0_rc1/el/8.10/main/x86_64/
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF
         sudo dnf clean all

   .. tab-item:: Oracle Linux 9.6
      :sync: ol-96

      .. code-block:: shell

         sudo tee /etc/yum.repos.d/rocm.repo <<EOF
         [ROCm-7.0.0]
         name=ROCm7.0.0
         baseurl=https://repo.radeon.com/rocm/el9/7.0_rc1/main
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF

         sudo tee /etc/yum.repos.d/rocm-graphics.repo <<EOF
         [ROCm-7.0.0-Graphics]
         name=ROCm7.0.0-Graphics
         baseurl=https://repo.radeon.com/graphics/7.0_rc1/el/9.6/main/x86_64/
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF
         sudo dnf clean all

   .. tab-item:: SLES 15 SP6
      :sync: sles-156

      .. code-block:: shell

         sudo tee /etc/zypp/repos.d/rocm.repo <<EOF
         [ROCm-7.0.0]
         name=ROCm7.0.0
         baseurl=https://repo.radeon.com/rocm/zyp/7.0_rc1/main
         enabled=1
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF

         sudo tee /etc/zypp/repos.d/rocm-graphics.repo <<EOF
         [ROCm-7.0.0-Graphics]
         name=ROCm7.0.0-Graphics
         baseurl=https://repo.radeon.com/graphics/7.0_rc1/sle/15.6/main/x86_64
         enabled=1
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF

         sudo zypper refresh

   .. tab-item:: SLES 15 SP7
      :sync: sles-157

      .. code-block:: shell

         sudo tee /etc/zypp/repos.d/rocm.repo <<EOF
         [ROCm-7.0.0]
         name=ROCm7.0.0
         baseurl=https://repo.radeon.com/rocm/zyp/7.0_rc1/main
         enabled=1
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF

         sudo tee /etc/zypp/repos.d/rocm-graphics.repo <<EOF
         [ROCm-7.0.0-Graphics]
         name=ROCm7.0.0-Graphics
         baseurl=https://repo.radeon.com/graphics/7.0_rc1/sle/15.7/main/x86_64
         enabled=1
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF

         sudo zypper refresh

Install ROCm
============

.. tab-set::

   .. tab-item:: Ubuntu 22.04
      :sync: ubuntu-22

      .. code-block:: shell

         sudo apt install rocm

   .. tab-item:: Ubuntu 24.04
      :sync: ubuntu-24

      .. code-block:: shell

         sudo apt install rocm

   .. tab-item:: Debian 12
      :sync: debian-12

      .. code-block:: shell

         sudo apt install rocm

   .. tab-item:: RHEL 8.10
      :sync: rhel-810

      .. code-block:: shell

         sudo dnf install rocm

   .. tab-item:: RHEL 9.4
      :sync: rhel-94

      .. code-block:: shell

         sudo dnf install rocm

   .. tab-item:: RHEL 9.6
      :sync: rhel-96

      .. code-block:: shell

         sudo dnf install rocm

   .. tab-item:: Oracle Linux 8.10
      :sync: ol-810

      .. code-block:: shell

         sudo dnf install rocm

   .. tab-item:: Oracle Linux 9.6
      :sync: ol-96

      .. code-block:: shell

         sudo dnf install rocm

   .. tab-item:: SLES 15 SP6
      :sync: sles-156

      .. code-block:: shell

         sudo zypper --gpg-auto-import-keys install rocm

   .. tab-item:: SLES 15 SP7
      :sync: sles-157

      .. code-block:: shell

         sudo zypper --gpg-auto-import-keys install rocm

.. _uninstall-rocm:

Uninstalling
============

.. tab-set::

   .. tab-item:: Ubuntu 22.04
      :sync: ubuntu-22

      1. Uninstall specific meta packages.

         .. code-block:: shell

            sudo apt autoremove rocm

      2. Uninstall ROCm packages.

         .. code-block:: shell

            sudo apt autoremove rocm-core

      3. Remove ROCm repositories.

         .. code-block:: shell

            sudo rm /etc/apt/sources.list.d/rocm*.list
            # Clear the cache and clean the system
            sudo rm -rf /var/cache/apt/*
            sudo apt clean all
            sudo apt update
            # Restart the system
            sudo reboot

   .. tab-item:: Ubuntu 24.04
      :sync: ubuntu-24

      1. Uninstall specific meta packages.

         .. code-block:: shell

            sudo apt autoremove rocm

      2. Uninstall ROCm packages.

         .. code-block:: shell

            sudo apt autoremove rocm-core

      3. Remove ROCm repositories.

         .. code-block:: shell

            sudo rm /etc/apt/sources.list.d/rocm*.list
            # Clear the cache and clean the system
            sudo rm -rf /var/cache/apt/*
            sudo apt clean all
            sudo apt update
            # Restart the system
            sudo reboot

   .. tab-item:: Debian 12
      :sync: debian-12

      1. Uninstall specific meta packages.

         .. code-block:: shell

            sudo apt autoremove rocm

      2. Uninstall ROCm packages.

         .. code-block:: shell

            sudo apt autoremove rocm-core

      3. Remove ROCm repositories.

         .. code-block:: shell

            sudo rm /etc/apt/sources.list.d/rocm*.list
            # Clear the cache and clean the system
            sudo rm -rf /var/cache/apt/*
            sudo apt clean all
            sudo apt update
            # Restart the system
            sudo reboot

   .. tab-item:: RHEL 8.10
      :sync: rhel-810

      1. Uninstall specific meta packages.

         .. code-block:: shell

            sudo dnf remove rocm

      2. Uninstall ROCm packages.

         .. code-block:: shell

            sudo dnf remove rocm-core amdgpu-core

      3. Remove ROCm repositories.

         .. code-block:: shell

            sudo rm /etc/yum.repos.d/rocm*.repo*
            # Clear the cache and clean the system
            sudo rm -rf /var/cache/dnf
            sudo dnf clean all
            # Restart the system
            sudo reboot

   .. tab-item:: RHEL 9.4
      :sync: rhel-94

      1. Uninstall specific meta packages.

         .. code-block:: shell

            sudo dnf remove rocm

      2. Uninstall ROCm packages.

         .. code-block:: shell

            sudo dnf remove rocm-core amdgpu-core

      3. Remove ROCm repositories.

         .. code-block:: shell

            sudo rm /etc/yum.repos.d/rocm*.repo*
            # Clear the cache and clean the system
            sudo rm -rf /var/cache/dnf
            sudo dnf clean all
            # Restart the system
            sudo reboot

   .. tab-item:: RHEL 9.6
      :sync: rhel-96

      1. Uninstall specific meta packages.

         .. code-block:: shell

            sudo dnf remove rocm

      2. Uninstall ROCm packages.

         .. code-block:: shell

            sudo dnf remove rocm-core amdgpu-core

      3. Remove ROCm repositories.

         .. code-block:: shell

            sudo rm /etc/yum.repos.d/rocm*.repo*
            # Clear the cache and clean the system
            sudo rm -rf /var/cache/dnf
            sudo dnf clean all
            # Restart the system
            sudo reboot

   .. tab-item:: Oracle Linux 8.10
      :sync: ol-810

      1. Uninstall specific meta packages.

         .. code-block:: shell

            sudo dnf remove rocm

      2. Uninstall ROCm packages.

         .. code-block:: shell

            sudo dnf remove rocm-core amdgpu-core

      3. Remove ROCm repositories.

         .. code-block:: shell

            sudo rm /etc/yum.repos.d/rocm*.repo*
            # Clear the cache and clean the system
            sudo rm -rf /var/cache/dnf
            sudo dnf clean all
            # Restart the system
            sudo reboot

   .. tab-item:: Oracle Linux 9.6
      :sync: ol-96

      1. Uninstall specific meta packages.

         .. code-block:: shell

            sudo dnf remove rocm

      2. Uninstall ROCm packages.

         .. code-block:: shell

            sudo dnf remove rocm-core amdgpu-core

      3. Remove ROCm repositories.

         .. code-block:: shell

            sudo rm /etc/yum.repos.d/rocm*.repo*
            # Clear the cache and clean the system
            sudo rm -rf /var/cache/dnf
            sudo dnf clean all
            # Restart the system
            sudo reboot

   .. tab-item:: SLES 15 SP6
      :sync: sles-156

      1. Uninstall specific meta packages.

         .. code-block:: shell

            sudo zypper remove rocm

      2. Uninstall ROCm packages.

         .. code-block:: shell

            sudo zypper remove rocm-core amdgpu-core

      3. Remove ROCm repositories.

         .. code-block:: shell

            sudo zypper removerepo "ROCm-7.0.0"
            sudo zypper removerepo "ROCm-7.0.0-Graphics"
            # Clear the cache and clean the system
            sudo zypper clean --all
            sudo zypper refresh
            # Restart the system
            sudo reboot

   .. tab-item:: SLES 15 SP7
      :sync: sles-157

      1. Uninstall specific meta packages.

         .. code-block:: shell

            sudo zypper remove rocm

      2. Uninstall ROCm packages.

         .. code-block:: shell

            sudo zypper remove rocm-core amdgpu-core

      3. Remove ROCm repositories.

         .. code-block:: shell

            sudo zypper removerepo "ROCm-7.0.0"
            sudo zypper removerepo "ROCm-7.0.0-Graphics"
            # Clear the cache and clean the system
            sudo zypper clean --all
            sudo zypper refresh
            # Restart the system
            sudo reboot
