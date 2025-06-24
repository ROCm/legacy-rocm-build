**********************************************
Install the ROCm 7.0 Alpha via package manager
**********************************************

This page describes how to install the ROCm 7.0 Alpha build using ``apt`` on
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

            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/7.0_alpha jammy main" \
              | sudo tee /etc/apt/sources.list.d/rocm.list

            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/graphics/7.0_alpha/ubuntu jammy main" \ 
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

            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/7.0_alpha noble main" \
              | sudo tee /etc/apt/sources.list.d/rocm.list

            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/graphics/7.0_alpha/ubuntu noble main" \
              | sudo tee /etc/apt/sources.list.d/rocm-graphics.list

            echo -e 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' \
              | sudo tee /etc/apt/preferences.d/rocm-pin-600
            sudo apt update 

   .. tab-item:: RHEL 9.6
      :sync: rhel-96

      .. code-block:: shell

         sudo tee /etc/yum.repos.d/rocm.repo <<EOF
         [ROCm-7.0.0]
         name=ROCm7.0.0
         baseurl=https://repo.radeon.com/rocm/el9/7.0_alpha/main
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF

         sudo tee /etc/yum.repos.d/rocm-graphics.repo <<EOF
         [ROCm-7.0.0-Graphics]
         name=ROCm7.0.0-Graphics
         baseurl=https://repo.radeon.com/graphics/7.0_alpha/rhel/9/main/x86_64/
         enabled=1
         priority=50
         gpgcheck=1
         gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
         EOF
         sudo dnf clean all

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

   .. tab-item:: RHEL 9.6
      :sync: rhel-96

      .. code-block:: shell

         sudo dnf install rocm

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
