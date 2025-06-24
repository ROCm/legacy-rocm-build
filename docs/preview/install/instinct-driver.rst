***********************************************
Install the Instinct Driver via package manager
***********************************************

This section describes how to install the Instinct Driver using ``apt`` on
Ubuntu 22.04 or 24.04, or ``dnf`` on Red Hat Enterprise Linux 9.6.

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

            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/amdgpu/30.10_alpha/ubuntu jammy main" \
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

            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/amdgpu/30.10_alpha/ubuntu noble main" \
              | sudo tee /etc/apt/sources.list.d/amdgpu.list
            sudo apt update 

   .. tab-item:: RHEL 9.6
      :sync: rhel-96

      .. code-block:: shell

         sudo tee /etc/yum.repos.d/amdgpu.repo <<EOF
         [amdgpu]
         name=amdgpu
         baseurl=https://repo.radeon.com/amdgpu/30.10_alpha/rhel/9.6/main/x86_64/
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF
         sudo dnf clean all

Install the kernel driver
=========================

.. tab-set::

   .. tab-item:: Ubuntu 22.04
      :sync: ubuntu-22

      .. code-block:: shell

         sudo apt install amdgpu-dkms

   .. tab-item:: Ubuntu 24.04
      :sync: ubuntu-24

      .. code-block:: shell

         sudo apt install amdgpu-dkms

   .. tab-item:: RHEL 9.6
      :sync: rhel-96

      .. code-block:: shell

         sudo dnf install amdgpu-dkms

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
