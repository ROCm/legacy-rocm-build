***********************************************
Install the Instinct Driver via package manager
***********************************************

This page describes how to install the Instinct Driver using
your Linux distribution's package manager. Before installing, see the
:ref:`supported hardware and distros <rc1-system-requirements>` to make sure
your system is compatible.

.. important::

   Upgrades and downgrades are not supported. You must uninstall any existing
   ROCm installation before installing the preview build.

Prerequisites
=============

Before installing, complete the following prerequisites.

.. tab-set::

   .. tab-item:: Ubuntu 22.04
      :sync: ubuntu-22

      Install kernel headers.

      .. code-block:: shell

         sudo apt install "linux-headers-$(uname -r)" "linux-modules-extra-$(uname -r)" 

   .. tab-item:: Ubuntu 24.04
      :sync: ubuntu-24

      Install kernel headers.

      .. code-block:: shell

         sudo apt install "linux-headers-$(uname -r)" "linux-modules-extra-$(uname -r)" 

   .. tab-item:: Debian 12
      :sync: debian-12

      Install kernel headers.

      .. code-block:: shell

         sudo apt install "linux-headers-$(uname -r)" "linux-modules-extra-$(uname -r)" 

   .. tab-item:: RHEL 8.10
      :sync: rhel-810

      1. Register your Enterprise Linux.

         .. code-block:: shell

            subscription-manager register --username <username> --password <password>
            subscription-manager attach --auto

      2. Update your Enterprise Linux.

         .. code-block:: shell

            sudo dnf update --releasever=8.10 --exclude=\*release\*

      3. Install kernel headers.

         .. code-block:: shell

            sudo dnf install "kernel-headers-$(uname -r)" "kernel-devel-$(uname -r)"

   .. tab-item:: RHEL 9.4
      :sync: rhel-96

      1. Register your Enterprise Linux.

         .. code-block:: shell

            subscription-manager register --username <username> --password <password>
            subscription-manager attach --auto

      2. Update your Enterprise Linux.

         .. code-block:: shell

            sudo dnf update --releasever=9.4 --exclude=\*release\*

      3. Install kernel headers.

         .. code-block:: shell

            sudo dnf install "kernel-headers-$(uname -r)" "kernel-devel-$(uname -r)" "kernel-devel-matched-$(uname -r)"

   .. tab-item:: RHEL 9.6
      :sync: rhel-96

      1. Register your Enterprise Linux.

         .. code-block:: shell

            subscription-manager register --username <username> --password <password>
            subscription-manager attach --auto

      2. Update your Enterprise Linux.

         .. code-block:: shell

            sudo dnf update --releasever=9.6 --exclude=\*release\*

      3. Install kernel headers.

         .. code-block:: shell

            sudo dnf install "kernel-headers-$(uname -r)" "kernel-devel-$(uname -r)" "kernel-devel-matched-$(uname -r)"

   .. tab-item:: Oracle Linux 8.10
      :sync: ol-810

      1. Update your Enterprise Linux.

         .. code-block:: shell

            sudo dnf update --releasever=8.10 --exclude=\*release\*

      2. Install kernel headers.

         .. code-block:: shell

            sudo dnf install "kernel-uek-devel-$(uname -r)"

   .. tab-item:: Oracle Linux 9.6
      :sync: ol-96

      1. Update your Enterprise Linux.

         .. code-block:: shell

            sudo dnf update --releasever=9.6 --exclude=\*release\*

      2. Install kernel headers.

         .. code-block:: shell

            sudo dnf install "kernel-uek-devel-$(uname -r)"

   .. tab-item:: SLES 15 SP6
      :sync: sles-156

      1. Register your Enterprise Linux.

         .. code-block:: shell

            sudo SUSEConnect -r <REGCODE>

      2. Update your Enterprise Linux.

         .. code-block:: shell

            sudo zypper update

      3. Install kernel headers.

         .. code-block:: shell

            sudo zypper install kernel-default-devel

   .. tab-item:: SLES 15 SP7
      :sync: sles-157

      1. Register your Enterprise Linux.

         .. code-block:: shell

            sudo SUSEConnect -r <REGCODE>

      2. Update your Enterprise Linux.

         .. code-block:: shell

            sudo zypper update

      3. Install kernel headers.

         .. code-block:: shell

            sudo zypper install kernel-default-devel

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

      2. Register the kernel mode driver.

         .. code-block:: shell

            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/amdgpu/30.10_rc1/ubuntu jammy main" \
              | sudo tee /etc/apt/sources.list.d/amdgpu.list
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

      2. Register the kernel mode driver.

         .. code-block:: shell

            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/amdgpu/30.10_rc1/ubuntu noble main" \
              | sudo tee /etc/apt/sources.list.d/amdgpu.list
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

      2. Register the kernel mode driver.

         .. code-block:: shell

            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/amdgpu/30.10_rc1/ubuntu jammy main" \
              | sudo tee /etc/apt/sources.list.d/amdgpu.list
            sudo apt update 

   .. tab-item:: RHEL 8.10
      :sync: rhel-810

      .. code-block:: shell

         sudo tee /etc/yum.repos.d/amdgpu.repo <<EOF
         [amdgpu]
         name=amdgpu
         baseurl=https://repo.radeon.com/amdgpu/30.10_rc1/rhel/8.10/main/x86_64/
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF
         sudo dnf clean all

   .. tab-item:: RHEL 9.4
      :sync: rhel-94

      .. code-block:: shell

         sudo tee /etc/yum.repos.d/amdgpu.repo <<EOF
         [amdgpu]
         name=amdgpu
         baseurl=https://repo.radeon.com/amdgpu/30.10_rc1/rhel/9.4/main/x86_64/
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF
         sudo dnf clean all

   .. tab-item:: RHEL 9.6
      :sync: rhel-96

      .. code-block:: shell

         sudo tee /etc/yum.repos.d/amdgpu.repo <<EOF
         [amdgpu]
         name=amdgpu
         baseurl=https://repo.radeon.com/amdgpu/30.10_rc1/rhel/9.6/main/x86_64/
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF
         sudo dnf clean all

   .. tab-item:: Oracle Linux 8.10
      :sync: ol-810

      .. code-block:: shell

         sudo tee /etc/yum.repos.d/amdgpu.repo <<EOF
         [amdgpu]
         name=amdgpu
         baseurl=https://repo.radeon.com/amdgpu/30.10_rc1/rhel/8.10/main/x86_64/
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF
         sudo dnf clean all

   .. tab-item:: Oracle Linux 9.6
      :sync: ol-96

      .. code-block:: shell

         sudo tee /etc/yum.repos.d/amdgpu.repo <<EOF
         [amdgpu]
         name=amdgpu
         baseurl=https://repo.radeon.com/amdgpu/30.10_rc1/el/9.6/main/x86_64/
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF
         sudo dnf clean all

   .. tab-item:: SLES 15 SP6
      :sync: sles-156

      .. code-block:: shell

         sudo tee /etc/yum.repos.d/amdgpu.repo <<EOF
         [amdgpu]
         name=amdgpu
         baseurl=https://repo.radeon.com/amdgpu/30.10_rc1/sle/15.6/main/x86_64/
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF
         sudo zypper refresh

   .. tab-item:: SLES 15 SP7
      :sync: sles-157

      .. code-block:: shell

         sudo tee /etc/yum.repos.d/amdgpu.repo <<EOF
         [amdgpu]
         name=amdgpu
         baseurl=https://repo.radeon.com/amdgpu/30.10_rc1/sle/15.7/main/x86_64/
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF
         sudo zypper refresh

Install the kernel driver
=========================

.. tab-set::

   .. tab-item:: Ubuntu 22.04
      :sync: ubuntu-22

      .. code-block:: shell

         sudo apt install amdgpu-dkms
         sudo reboot

   .. tab-item:: Ubuntu 24.04
      :sync: ubuntu-24

      .. code-block:: shell

         sudo apt install amdgpu-dkms
         sudo reboot

   .. tab-item:: Debian 12
      :sync: debian-12

      .. code-block:: shell

         sudo apt install amdgpu-dkms
         sudo reboot

   .. tab-item:: RHEL 8.10
      :sync: rhel-810

      .. code-block:: shell

         sudo dnf install amdgpu-dkms
         sudo reboot

   .. tab-item:: RHEL 9.4
      :sync: rhel-94

      .. code-block:: shell

         sudo dnf install amdgpu-dkms
         sudo reboot

   .. tab-item:: RHEL 9.6
      :sync: rhel-96

      .. code-block:: shell

         sudo dnf install amdgpu-dkms
         sudo reboot

   .. tab-item:: Oracle Linux 8.10
      :sync: ol-810

      .. code-block:: shell

         sudo dnf install amdgpu-dkms
         sudo reboot

   .. tab-item:: Oracle Linux 9.6
      :sync: ol-96

      .. code-block:: shell

         sudo dnf install amdgpu-dkms
         sudo reboot

   .. tab-item:: SLES 15 SP6
      :sync: sles-156

      .. code-block:: shell

         sudo zypper --gpg-auto-import-keys install amdgpu-dkms
         sudo reboot

   .. tab-item:: SLES 15 SP7
      :sync: sles-157

      .. code-block:: shell

         sudo zypper --gpg-auto-import-keys install amdgpu-dkms
         sudo reboot

Uninstalling
============

.. tab-set::

   .. tab-item:: Ubuntu 22.04
      :sync: ubuntu-22

      1. Uninstall the kernel mode driver.

         .. code-block:: shell

            sudo apt autoremove amdgpu-dkms

      2. Remove AMDGPU repositories.

         .. code-block:: shell

            sudo rm /etc/apt/sources.list.d/amdgpu.list
            # Clear the cache and clean the system
            sudo rm -rf /var/cache/apt/*
            sudo apt clean all
            sudo apt update
            # Restart the system
            sudo reboot

   .. tab-item:: Ubuntu 24.04
      :sync: ubuntu-24

      1. Uninstall the kernel mode driver.

         .. code-block:: shell

            sudo apt autoremove amdgpu-dkms

      2. Remove AMDGPU repositories.

         .. code-block:: shell

            sudo rm /etc/apt/sources.list.d/amdgpu.list
            # Clear the cache and clean the system
            sudo rm -rf /var/cache/apt/*
            sudo apt clean all
            sudo apt update
            # Restart the system
            sudo reboot

   .. tab-item:: Debian 12
      :sync: debian-12

      1. Uninstall the kernel mode driver.

         .. code-block:: shell

            sudo apt autoremove amdgpu-dkms

      2. Remove AMDGPU repositories.

         .. code-block:: shell

            sudo rm /etc/apt/sources.list.d/amdgpu.list
            # Clear the cache and clean the system
            sudo rm -rf /var/cache/apt/*
            sudo apt clean all
            sudo apt update
            # Restart the system
            sudo reboot

   .. tab-item:: RHEL 8.10
      :sync: rhel-810

      1. Uninstall the kernel mode driver.

         .. code-block:: shell

            sudo dnf remove amdgpu-dkms

      2. Remove AMDGPU repositories.

         .. code-block:: shell

            sudo rm /etc/yum.repos.d/amdgpu.repo
            # Clear the cache and clean the system
            sudo rm -rf /var/cache/dnf
            sudo dnf clean all
            # Restart the system
            sudo reboot

   .. tab-item:: RHEL 9.4
      :sync: rhel-94

      1. Uninstall the kernel mode driver.

         .. code-block:: shell

            sudo dnf remove amdgpu-dkms

      2. Remove AMDGPU repositories.

         .. code-block:: shell

            sudo rm /etc/yum.repos.d/amdgpu.repo
            # Clear the cache and clean the system
            sudo rm -rf /var/cache/dnf
            sudo dnf clean all
            # Restart the system
            sudo reboot

   .. tab-item:: RHEL 9.6
      :sync: rhel-96

      1. Uninstall the kernel mode driver.

         .. code-block:: shell

            sudo dnf remove amdgpu-dkms

      2. Remove AMDGPU repositories.

         .. code-block:: shell

            sudo rm /etc/yum.repos.d/amdgpu.repo
            # Clear the cache and clean the system
            sudo rm -rf /var/cache/dnf
            sudo dnf clean all
            # Restart the system
            sudo reboot

   .. tab-item:: Oracle Linux 8.10
      :sync: ol-810

      1. Uninstall the kernel mode driver.

         .. code-block:: shell

            sudo dnf remove amdgpu-dkms

      2. Remove AMDGPU repositories.

         .. code-block:: shell

            sudo rm /etc/yum.repos.d/amdgpu.repo
            # Clear the cache and clean the system
            sudo rm -rf /var/cache/dnf
            sudo dnf clean all
            # Restart the system
            sudo reboot

   .. tab-item:: Oracle Linux 9.6
      :sync: ol-96

      1. Uninstall the kernel mode driver.

         .. code-block:: shell

            sudo dnf remove amdgpu-dkms

      2. Remove AMDGPU repositories.

         .. code-block:: shell

            sudo rm /etc/yum.repos.d/amdgpu.repo
            # Clear the cache and clean the system
            sudo rm -rf /var/cache/dnf
            sudo dnf clean all
            # Restart the system
            sudo reboot

   .. tab-item:: SLES 15 SP6
      :sync: sles-156

      1. Uninstall the kernel mode driver.

         .. code-block:: shell

            sudo zypper remove amdgpu-dkms amdgpu-dkms-firmware

      2. Remove AMDGPU repositories.

         .. code-block:: shell

            sudo zypper removerepo "amdgpu"
            # Clear the cache and clean the system
            sudo zypper clean --all
            sudo zypper refresh
            # Restart the system
            sudo reboot

   .. tab-item:: SLES 15 SP7
      :sync: sles-157

      1. Uninstall the kernel mode driver.

         .. code-block:: shell

            sudo zypper remove amdgpu-dkms amdgpu-dkms-firmware

      2. Remove AMDGPU repositories.

         .. code-block:: shell

            sudo zypper removerepo "amdgpu"
            # Clear the cache and clean the system
            sudo zypper clean --all
            sudo zypper refresh
            # Restart the system
            sudo reboot
