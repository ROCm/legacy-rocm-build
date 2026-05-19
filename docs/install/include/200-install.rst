Installation
============

Before getting started, make sure you've completed the :ref:`rocm-prerequisites`.
For information about supported operating systems and compatible AMD devices,
see the :doc:`Compatibility matrix </compatibility/compatibility-matrix>`.

.. selected:: os=windows

   .. caution::

      Do not replace or copy the ROCm compiler and runtime DLLs to System32 as
      this can cause conflicts.

.. selected:: i=runfile
   :heading: Download the runfile installer
   :heading-level: 3

   Use the following command to download the ROCm Runfile Installer.

   .. code-block:: bash

      wget https://repo.radeon.com/rocm/installer/rocm-runfile-installer/rocm-rel-7.13/rocm-installer-7.13.0-2.run

.. selected:: w=graphics

   .. selected:: os=ubuntu os=rhel
      :heading: Install the amdgpu-install script
      :heading-level: 3

      Use the following commands to download and install the ``amdgpu-install`` script.

      .. selected:: os=ubuntu

         .. selected:: ubuntu-ver=26.04

            .. code-block:: bash

               sudo apt update
               wget https://repo.radeon.com/amdgpu-install/31.30/ubuntu/resolute/amdgpu-install_26.12.261200-1_all.deb
               sudo apt install ./amdgpu-install_26.12.261200-1_all.deb

         .. selected:: ubuntu-ver=24.04

            .. code-block:: bash

               sudo apt update
               wget https://repo.radeon.com/amdgpu-install/31.30/ubuntu/noble/amdgpu-install_26.12.261200-1_all.deb
               sudo apt install ./amdgpu-install_26.12.261200-1_all.deb

         .. selected:: ubuntu-ver=22.04

            .. code-block:: bash

               sudo apt update
               wget https://repo.radeon.com/amdgpu-install/31.30/ubuntu/jammy/amdgpu-install_26.12.261200-1_all.deb
               sudo apt install ./amdgpu-install_26.12.261200-1_all.deb

      .. selected:: os=rhel

         .. selected:: rhel-ver=10.1

            .. code-block:: bash

               wget https://repo.radeon.com/amdgpu-install/31.30/rhel/10.1/amdgpu-install-26.12.261200-1.el10.noarch.rpm
               sudo dnf install ./amdgpu-install-26.12.261200-1.el10.noarch.rpm

         .. selected:: rhel-ver=9.7

            .. code-block:: bash

               wget https://repo.radeon.com/amdgpu-install/31.30/rhel/9.7/amdgpu-install-26.12.261200-1.el9.noarch.rpm
               sudo dnf install ./amdgpu-install-26.12.261200-1.el9.noarch.rpm

.. ==================================================== INSTALL KERNEL DRIVER ==

.. selected:: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

   .. selected:: i=pkgman i=pip i=tar

      .. selected:: fam=all
         :heading: Install the kernel driver
         :heading-level: 3

         For information about AMD GPU Driver (amdgpu) compatibility, see the
         :doc:`Compatibility matrix </compatibility/compatibility-matrix>`.

         .. selected:: os=ubuntu

            For Instinct and Radeon devices, install the AMD GPU Driver (amdgpu).
            See `Ubuntu native installation
            <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.30.0-preview/install/detailed-install/package-manager/package-manager-ubuntu.html>`__
            in the AMD Instinct Data Center GPU Documentation.

            .. selected:: ubuntu-ver=26.04

               Supported Ryzen APUs require the inbox kernel driver included with
               Ubuntu 26.04.

            .. selected:: ubuntu-ver=24.04

               Supported Ryzen APUs require the inbox kernel driver included with
               Ubuntu 24.04.4.

         .. selected:: os=debian

            For Instinct and Radeon devices, install the AMD GPU Driver (amdgpu).
            See `Debian native installation
            <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.30.0-preview/install/detailed-install/package-manager/package-manager-debian.html>`__
            in the AMD Instinct Data Center GPU Documentation.

         .. selected:: os=rhel

            For Instinct and Radeon devices, install the AMD GPU Driver (amdgpu).
            See `RHEL native installation
            <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.30.0-preview/install/detailed-install/package-manager/package-manager-rhel.html>`__
            in the AMD Instinct Data Center GPU Documentation.

         .. selected:: os=oracle-linux

            For Instinct and Radeon devices, install the AMD GPU Driver (amdgpu).
            See `Oracle Linux native installation
            <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.30.0-preview/install/detailed-install/package-manager/package-manager-ol.html>`__
            in the AMD Instinct Data Center GPU Documentation.

         .. selected:: os=rocky-linux

            For Instinct and Radeon devices, install the AMD GPU Driver (amdgpu).
            See `Rocky Linux native installation
            <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.30.0-preview/install/detailed-install/package-manager/package-manager-rl.html>`__
            in the AMD Instinct Data Center GPU Documentation.

         .. selected:: os=sles

            For Instinct and Radeon devices, install the AMD GPU Driver (amdgpu).
            See `SLES native installation
            <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.30.0-preview/install/detailed-install/package-manager/package-manager-sles.html>`__
            in the AMD Instinct Data Center GPU Documentation.

      .. selected:: fam=instinct fam=radeon
         :heading: Install the kernel driver
         :heading-level: 3

         For information about AMD GPU Driver (amdgpu) compatibility, see the
         :doc:`Compatibility matrix </compatibility/compatibility-matrix>`.

         .. selected:: os=ubuntu

            For instructions on installing the AMD GPU Driver (amdgpu), see `Ubuntu native
            installation
            <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.30.0-preview/install/detailed-install/package-manager/package-manager-ubuntu.html>`__
            in the AMD Instinct Data Center GPU Documentation.

         .. selected:: os=debian

            For instructions on installing the AMD GPU Driver (amdgpu), see `Debian native
            installation
            <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.30.0-preview/install/detailed-install/package-manager/package-manager-debian.html>`__
            in the AMD Instinct Data Center GPU Documentation.

         .. selected:: os=rhel

            For instructions on installing the AMD GPU Driver (amdgpu), see `RHEL native
            installation
            <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.30.0-preview/install/detailed-install/package-manager/package-manager-rhel.html>`__
            in the AMD Instinct Data Center GPU Documentation.

         .. selected:: os=oracle-linux

            For instructions on installing the AMD GPU Driver (amdgpu), see `Oracle Linux native
            installation
            <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.30.0-preview/install/detailed-install/package-manager/package-manager-ol.html>`__
            in the AMD Instinct Data Center GPU Documentation.

         .. selected:: os=rocky-linux

            For instructions on installing the AMD GPU Driver (amdgpu), see `Rocky Linux native
            installation
            <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.30.0-preview/install/detailed-install/package-manager/package-manager-rl.html>`__
            in the AMD Instinct Data Center GPU Documentation.

         .. selected:: os=sles

            For instructions on installing the AMD GPU Driver (amdgpu), see `SLES
            native installation
            <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.30.0-preview/install/detailed-install/package-manager/package-manager-sles.html>`__
            in the AMD Instinct Data Center GPU Documentation.

      .. selected:: fam=ryzen

         .. selected:: os=ubuntu
            :heading: About the kernel driver
            :heading-level: 3

            .. selected:: ubuntu-ver=26.04

                  Supported Ryzen APUs require the inbox kernel driver included with
                  Ubuntu 26.04.

            .. selected:: ubuntu-ver=24.04

                  Supported Ryzen APUs require the inbox kernel driver included with
                  Ubuntu 24.04.4.

   .. selected:: i=runfile
      :heading: Install the kernel driver
      :heading-level: 3

      For information about AMD GPU Driver (amdgpu) compatibility, see the
      :doc:`Compatibility matrix </compatibility/compatibility-matrix>`.

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install amdgpu

      .. note::

         Reboot your system after installing the AMD GPU Driver.


.. _rocm-install-rocm:

Install ROCm
------------

Use the following instructions to install the ROCm Core SDK on your system.

.. ========================================================== PACKAGE MANAGER ==

.. selected:: i=pkgman
   :heading: Register ROCm repositories
   :heading-level: 4

   .. selected:: os=ubuntu

      Register the ROCm repository with your system's package manager. This lets you install and update
      ROCm packages using ``apt``.

      .. selected:: ubuntu-ver=26.04

         .. selected:: fam=all

            .. code-block:: bash

               # Download and install GPG key
               sudo mkdir --parents --mode=0755 /etc/apt/keyrings
               wget https://repo.amd.com/rocm/packages/gpg/rocm.gpg -O - | \
                   gpg --dearmor | sudo tee /etc/apt/keyrings/amdrocm.gpg > /dev/null

               sudo tee /etc/apt/sources.list.d/rocm.list << EOF
               deb [arch=amd64 signed-by=/etc/apt/keyrings/amdrocm.gpg] https://repo.amd.com/rocm/packages-multi-arch/ubuntu2604 stable main
               EOF

               sudo apt update

         .. selected:: fam=instinct fam=radeon fam=ryzen

            .. code-block:: bash

               # Download and install GPG key
               sudo mkdir --parents --mode=0755 /etc/apt/keyrings

               # ROCm release signing key
               wget https://repo.amd.com/rocm/packages/gpg/rocm.gpg -O - | \
                   gpg --dearmor | sudo tee /etc/apt/keyrings/amdrocm.gpg > /dev/null

               sudo tee /etc/apt/sources.list.d/rocm.list << EOF
               deb [arch=amd64 signed-by=/etc/apt/keyrings/amdrocm.gpg] https://repo.amd.com/rocm/packages/ubuntu2604 stable main
               EOF

               sudo apt update

      .. selected:: ubuntu-ver=24.04

         .. selected:: fam=all

            .. code-block:: bash

               # Download and install GPG key
               sudo mkdir --parents --mode=0755 /etc/apt/keyrings
               wget https://repo.amd.com/rocm/packages/gpg/rocm.gpg -O - | \
                   gpg --dearmor | sudo tee /etc/apt/keyrings/amdrocm.gpg > /dev/null

               sudo tee /etc/apt/sources.list.d/rocm.list << EOF
               deb [arch=amd64 signed-by=/etc/apt/keyrings/amdrocm.gpg] https://repo.amd.com/rocm/packages-multi-arch/ubuntu2404 stable main
               EOF

               sudo apt update

         .. selected:: fam=instinct fam=radeon fam=ryzen

            .. code-block:: bash

               # Download and install GPG key
               sudo mkdir --parents --mode=0755 /etc/apt/keyrings

               # ROCm release signing key
               wget https://repo.amd.com/rocm/packages/gpg/rocm.gpg -O - | \
                   gpg --dearmor | sudo tee /etc/apt/keyrings/amdrocm.gpg > /dev/null

               sudo tee /etc/apt/sources.list.d/rocm.list << EOF
               deb [arch=amd64 signed-by=/etc/apt/keyrings/amdrocm.gpg] https://repo.amd.com/rocm/packages/ubuntu2404 stable main
               EOF

               sudo apt update

      .. selected:: ubuntu-ver=22.04

         .. selected:: fam=all

            .. code-block:: bash

               # Download and install GPG key
               sudo mkdir --parents --mode=0755 /etc/apt/keyrings
               wget https://repo.amd.com/rocm/packages/gpg/rocm.gpg -O - | \
                   gpg --dearmor | sudo tee /etc/apt/keyrings/amdrocm.gpg > /dev/null

               sudo tee /etc/apt/sources.list.d/rocm.list << EOF
               deb [arch=amd64 signed-by=/etc/apt/keyrings/amdrocm.gpg] https://repo.amd.com/rocm/packages-multi-arch/ubuntu2204 stable main
               EOF

               sudo apt update

         .. selected:: fam=instinct fam=radeon fam=ryzen

            .. code-block:: bash

               # Download and install GPG key
               sudo mkdir --parents --mode=0755 /etc/apt/keyrings

               # ROCm release signing key
               wget https://repo.amd.com/rocm/packages/gpg/rocm.gpg -O - | \
                   gpg --dearmor | sudo tee /etc/apt/keyrings/amdrocm.gpg > /dev/null

               sudo tee /etc/apt/sources.list.d/rocm.list << EOF
               deb [arch=amd64 signed-by=/etc/apt/keyrings/amdrocm.gpg] https://repo.amd.com/rocm/packages/ubuntu2204 stable main
               EOF

               sudo apt update

   .. selected:: os=debian

      Register the ROCm repository with your system's package manager. This enables
      you to install and update ROCm packages using ``apt``.

      .. selected:: debian-ver=13

         .. selected:: fam=all

            .. code-block:: bash

               # Download and install GPG key
               sudo mkdir --parents --mode=0755 /etc/apt/keyrings
               wget https://repo.amd.com/rocm/packages/gpg/rocm.gpg -O - | \
                   gpg --dearmor | sudo tee /etc/apt/keyrings/amdrocm.gpg > /dev/null

               sudo tee /etc/apt/sources.list.d/rocm.list << EOF
               deb [arch=amd64 signed-by=/etc/apt/keyrings/amdrocm.gpg] https://repo.amd.com/rocm/packages-multi-arch/debian13 stable main
               EOF

               sudo apt update

         .. selected:: fam=instinct fam=radeon fam=ryzen

            .. code-block:: bash

               # Download and install GPG key
               sudo mkdir --parents --mode=0755 /etc/apt/keyrings
               wget https://repo.amd.com/rocm/packages/gpg/rocm.gpg -O - | \
                   gpg --dearmor | sudo tee /etc/apt/keyrings/amdrocm.gpg > /dev/null

               sudo tee /etc/apt/sources.list.d/rocm.list << EOF
               deb [arch=amd64 signed-by=/etc/apt/keyrings/amdrocm.gpg] https://repo.amd.com/rocm/packages/debian13 stable main
               EOF

               sudo apt update

      .. selected:: debian-ver=12

         .. selected:: fam=all

            .. code-block:: bash

               # Download and install GPG key
               sudo mkdir --parents --mode=0755 /etc/apt/keyrings
               wget https://repo.amd.com/rocm/packages/gpg/rocm.gpg -O - | \
                   gpg --dearmor | sudo tee /etc/apt/keyrings/amdrocm.gpg > /dev/null

               sudo tee /etc/apt/sources.list.d/rocm.list << EOF
               deb [arch=amd64 signed-by=/etc/apt/keyrings/amdrocm.gpg] https://repo.amd.com/rocm/packages-multi-arch/debian12 stable main
               EOF

               sudo apt update

         .. selected:: fam=instinct fam=radeon fam=ryzen

            .. code-block:: bash

               # Download and install GPG key
               sudo mkdir --parents --mode=0755 /etc/apt/keyrings
               wget https://repo.amd.com/rocm/packages/gpg/rocm.gpg -O - | \
                   gpg --dearmor | sudo tee /etc/apt/keyrings/amdrocm.gpg > /dev/null

               sudo tee /etc/apt/sources.list.d/rocm.list << EOF
               deb [arch=amd64 signed-by=/etc/apt/keyrings/amdrocm.gpg] https://repo.amd.com/rocm/packages/debian12 stable main
               EOF

               sudo apt update

   .. selected:: os=rhel

      Register the ROCm repository with your system's package manager. This enables
      you to install and update ROCm packages using ``dnf``.

      .. selected:: rhel-ver=10.1 rhel-ver=10.0

         .. selected:: fam=all

            .. code-block:: bash

               sudo tee /etc/yum.repos.d/rocm.repo <<EOF
               [rocm]
               name=ROCm 7.13.0
               baseurl=https://repo.amd.com/rocm/packages-multi-arch/rhel10/x86_64
               enabled=1
               gpgcheck=1
               gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
               priority=50
               EOF

               sudo dnf clean all

         .. selected:: fam=instinct fam=radeon fam=ryzen

            .. code-block:: bash

               sudo tee /etc/yum.repos.d/rocm.repo <<EOF
               [rocm]
               name=ROCm 7.13.0
               baseurl=https://repo.amd.com/rocm/packages/rhel10/x86_64
               enabled=1
               gpgcheck=1
               gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
               priority=50
               EOF

               sudo dnf clean all

      .. selected:: rhel-ver=9.7 rhel-ver=9.6 rhel-ver=9.4

         .. selected:: fam=all

            .. code-block:: bash

               sudo tee /etc/yum.repos.d/rocm.repo <<EOF
               [rocm]
               name=ROCm 7.13.0
               baseurl=https://repo.amd.com/rocm/packages-multi-arch/rhel9/x86_64
               enabled=1
               gpgcheck=1
               gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
               priority=50
               EOF

               sudo dnf clean all

         .. selected:: fam=instinct fam=radeon fam=ryzen

            .. code-block:: bash

               sudo tee /etc/yum.repos.d/rocm.repo <<EOF
               [rocm]
               name=ROCm 7.13.0
               baseurl=https://repo.amd.com/rocm/packages/rhel9/x86_64
               enabled=1
               gpgcheck=1
               gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
               priority=50
               EOF

               sudo dnf clean all

      .. selected:: rhel-ver=8.10

         .. selected:: fam=all

            .. code-block:: bash

               sudo tee /etc/yum.repos.d/rocm.repo <<EOF
               [rocm]
               name=ROCm 7.13.0
               baseurl=https://repo.amd.com/rocm/packages-multi-arch/rhel8/x86_64
               enabled=1
               gpgcheck=1
               gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
               priority=50
               EOF

               sudo dnf clean all

         .. selected:: fam=instinct fam=radeon fam=ryzen

            .. code-block:: bash

               sudo tee /etc/yum.repos.d/rocm.repo <<EOF
               [rocm]
               name=ROCm 7.13.0
               baseurl=https://repo.amd.com/rocm/packages/rhel8/x86_64
               enabled=1
               gpgcheck=1
               gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
               priority=50
               EOF

               sudo dnf clean all

   .. selected:: os=oracle-linux

      Register the ROCm repository with your system's package manager. This enables
      you to install and update ROCm packages using ``dnf``.

      .. selected:: oracle-linux-ver=10

         .. selected:: fam=all

            .. code-block:: bash

               sudo tee /etc/yum.repos.d/rocm.repo <<EOF
               [rocm]
               name=ROCm 7.13.0
               baseurl=https://repo.amd.com/rocm/packages-multi-arch/rhel10/x86_64
               enabled=1
               gpgcheck=1
               gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
               priority=50
               EOF

               sudo dnf clean all

         .. selected:: fam=instinct fam=radeon fam=ryzen

            .. code-block:: bash

               sudo tee /etc/yum.repos.d/rocm.repo <<EOF
               [rocm]
               name=ROCm 7.13.0
               baseurl=https://repo.amd.com/rocm/packages/rhel10/x86_64
               enabled=1
               gpgcheck=1
               gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
               priority=50
               EOF

               sudo dnf clean all

      .. selected:: oracle-linux-ver=9

         .. selected:: fam=all

            .. code-block:: bash

               sudo tee /etc/yum.repos.d/rocm.repo <<EOF
               [rocm]
               name=ROCm 7.13.0
               baseurl=https://repo.amd.com/rocm/packages-multi-arch/rhel9/x86_64
               enabled=1
               gpgcheck=1
               gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
               priority=50
               EOF

               sudo dnf clean all

         .. selected:: fam=instinct fam=radeon fam=ryzen

            .. code-block:: bash

               sudo tee /etc/yum.repos.d/rocm.repo <<EOF
               [rocm]
               name=ROCm 7.13.0
               baseurl=https://repo.amd.com/rocm/packages/rhel9/x86_64
               enabled=1
               gpgcheck=1
               gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
               priority=50
               EOF

               sudo dnf clean all

      .. selected:: oracle-linux-ver=8

         .. selected:: fam=all

            .. code-block:: bash

               sudo tee /etc/yum.repos.d/rocm.repo <<EOF
               [rocm]
               name=ROCm 7.13.0
               baseurl=https://repo.amd.com/rocm/packages-multi-arch/rhel8/x86_64
               enabled=1
               gpgcheck=1
               gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
               priority=50
               EOF

               sudo dnf clean all

         .. selected:: fam=instinct fam=radeon fam=ryzen

            .. code-block:: bash

               sudo tee /etc/yum.repos.d/rocm.repo <<EOF
               [rocm]
               name=ROCm 7.13.0
               baseurl=https://repo.amd.com/rocm/packages/rhel8/x86_64
               enabled=1
               gpgcheck=1
               gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
               priority=50
               EOF

               sudo dnf clean all

   .. selected:: os=rocky-linux

      Register the ROCm repository with your system's package manager. This enables
      you to install and update ROCm packages using ``dnf``.

      .. selected:: fam=all

         .. code-block:: bash

            sudo tee /etc/yum.repos.d/rocm.repo <<EOF
            [rocm]
            name=ROCm 7.13.0
            baseurl=https://repo.amd.com/rocm/packages-multi-arch/rhel9/x86_64
            enabled=1
            gpgcheck=1
            gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
            priority=50
            EOF

            sudo dnf clean all

      .. selected:: fam=instinct fam=radeon fam=ryzen

         .. code-block:: bash

            sudo tee /etc/yum.repos.d/rocm.repo <<EOF
            [rocm]
            name=ROCm 7.13.0
            baseurl=https://repo.amd.com/rocm/packages/rhel9/x86_64
            enabled=1
            gpgcheck=1
            gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
            priority=50
            EOF

            sudo dnf clean all

   .. selected:: os=sles

      Register the ROCm repository with your system's package manager. This enables
      you to install and update ROCm packages using ``zypper``.

      .. selected:: sles-ver=16.0

         .. selected:: fam=all

            .. code-block:: bash

               sudo tee /etc/zypp/repos.d/rocm.repo <<EOF
               [rocm]
               name=ROCm 7.13.0
               baseurl=https://repo.amd.com/rocm/packages-multi-arch/sles16/x86_64
               enabled=1
               gpgcheck=1
               gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
               priority=50
               EOF

               sudo zypper --gpg-auto-import-keys refresh

         .. selected:: fam=instinct fam=radeon fam=ryzen

            .. code-block:: bash

               sudo tee /etc/zypp/repos.d/rocm.repo <<EOF
               [rocm]
               name=ROCm 7.13.0
               baseurl=https://repo.amd.com/rocm/packages/sles16/x86_64
               enabled=1
               gpgcheck=1
               gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
               priority=50
               EOF

               sudo zypper --gpg-auto-import-keys refresh

      .. selected:: sles-ver=15.7

         .. selected:: fam=all

            .. code-block:: bash

               sudo tee /etc/zypp/repos.d/rocm.repo <<EOF
               [rocm]
               name=ROCm 7.13.0
               baseurl=https://repo.amd.com/rocm/packages-multi-arch/sles15/x86_64
               enabled=1
               gpgcheck=1
               gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
               priority=50
               EOF

               sudo zypper --gpg-auto-import-keys refresh

         .. selected:: fam=instinct fam=radeon fam=ryzen

            .. code-block:: bash

               sudo tee /etc/zypp/repos.d/rocm.repo <<EOF
               [rocm]
               name=ROCm 7.13.0
               baseurl=https://repo.amd.com/rocm/packages/sles15/x86_64
               enabled=1
               gpgcheck=1
               gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
               priority=50
               EOF

               sudo zypper --gpg-auto-import-keys refresh

.. selected:: i=pkgman
   :heading: Install ROCm packages
   :heading-level: 4

   .. selected:: os=ubuntu os=debian

      Use ``apt`` to install the core ROCm packages. See :ref:`ROCm meta
      packages <rocm-install-meta-packages>` for additional installation
      options.

      .. selected:: fam=all

         .. code-block:: bash

            sudo apt install amdrocm7.13

      .. selected:: gfx=gfx950

         .. code-block:: bash

            sudo apt install amdrocm7.13-gfx950

      .. selected:: gfx=gfx942

         .. code-block:: bash

            sudo apt install amdrocm7.13-gfx94x

      .. selected:: gfx=gfx90a

         .. code-block:: bash

            sudo apt install amdrocm7.13-gfx90a

      .. selected:: gfx=gfx908

         .. code-block:: bash

            sudo apt install amdrocm7.13-gfx908

      .. selected:: gfx=gfx1200 gfx=gfx1201

         .. code-block:: bash

            sudo apt install amdrocm7.13-gfx120x

      .. selected:: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

         .. code-block:: bash

            sudo apt install amdrocm7.13-gfx110x

      .. selected:: gfx=gfx1030

         .. code-block:: bash

            sudo apt install amdrocm7.13-gfx103x

      .. selected:: gfx=gfx1151

         .. code-block:: bash

            sudo apt install amdrocm7.13-gfx1151

      .. selected:: gfx=gfx1150

         .. code-block:: bash

            sudo apt install amdrocm7.13-gfx1150

      .. selected:: gfx=gfx1152

         .. code-block:: bash

            sudo apt install amdrocm7.13-gfx1152

   .. selected:: os=rhel os=oracle-linux os=rocky-linux

      Use ``dnf`` to install the core ROCm packages. See :ref:`ROCm meta
      packages <rocm-install-meta-packages>` for additional installation
      options.

      .. selected:: fam=all

         .. code-block:: bash

            sudo dnf install amdrocm7.13

      .. selected:: gfx=gfx950

         .. code-block:: bash

            sudo dnf install amdrocm7.13-gfx950

      .. selected:: gfx=gfx942

         .. code-block:: bash

            sudo dnf install amdrocm7.13-gfx94x

      .. selected:: gfx=gfx90a

         .. code-block:: bash

            sudo dnf install amdrocm7.13-gfx90a

      .. selected:: gfx=gfx908

         .. code-block:: bash

            sudo dnf install amdrocm7.13-gfx908

      .. selected:: gfx=gfx1201 gfx=gfx1200

         .. code-block:: bash

            sudo dnf install amdrocm7.13-gfx120x

      .. selected:: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

         .. code-block:: bash

            sudo dnf install amdrocm7.13-gfx110x

      .. selected:: gfx=gfx1030

         .. code-block:: bash

            sudo dnf install amdrocm7.13-gfx103x

      .. selected:: gfx=gfx1151

         .. code-block:: bash

            sudo dnf install amdrocm7.13-gfx1151

      .. selected:: gfx=gfx1150

         .. code-block:: bash

            sudo dnf install amdrocm7.13-gfx1150

      .. selected:: gfx=gfx1152

         .. code-block:: bash

            sudo dnf install amdrocm7.13-gfx1152

   .. selected:: os=sles

      Use ``zypper`` to install the core ROCm packages. See :ref:`ROCm meta
      packages <rocm-install-meta-packages>` for additional installation
      options.

      .. selected:: fam=all

         .. code-block:: bash

            sudo zypper install amdrocm7.13

      .. selected:: gfx=gfx950

         .. code-block:: bash

            sudo zypper install amdrocm7.13-gfx950

      .. selected:: gfx=gfx942

         .. code-block:: bash

            sudo zypper install amdrocm7.13-gfx94x

      .. selected:: gfx=gfx90a

         .. code-block:: bash

            sudo zypper install amdrocm7.13-gfx90a

      .. selected:: gfx=gfx908

         .. code-block:: bash

            sudo zypper install amdrocm7.13-gfx908

.. ============================================================ META PACKAGES ==

.. selected:: i=pkgman
   :heading: ROCm meta packages
   :heading-level: 5

   .. _rocm-install-meta-packages:

   Meta packages group related components and dependencies together, allowing
   you to install only what is necessary for your use case. The following table
   describes available ROCm meta packages:

   .. matrix::

      .. matrix-row::
         :header:

         .. matrix-cell:: Meta package name

         .. matrix-cell:: Contents

         .. matrix-cell:: Use case

      .. matrix-row::

         .. matrix-cell::
            :show-cond: gfx=gfx950

            ``amdrocm7.13-gfx950``

         .. matrix-cell::
            :show-cond: gfx=gfx942

            ``amdrocm7.13-gfx94x``

         .. matrix-cell::
            :show-cond: gfx=gfx90a

            ``amdrocm7.13-gfx90a``

         .. matrix-cell::
            :show-cond: gfx=gfx908

            ``amdrocm7.13-gfx908``

         .. matrix-cell::
            :show-cond: gfx=gfx1201 gfx=gfx1200

            ``amdrocm7.13-gfx120x``

         .. matrix-cell::
            :show-cond: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

            ``amdrocm7.13-gfx110x``

         .. matrix-cell::
            :show-cond: gfx=gfx1030

            ``amdrocm7.13-gfx103x``

         .. matrix-cell::
            :show-cond: gfx=gfx1151

            ``amdrocm7.13-gfx1151``

         .. matrix-cell::
            :show-cond: gfx=gfx1150

            ``amdrocm7.13-gfx1150``

         .. matrix-cell::
            :show-cond: gfx=gfx1152

            ``amdrocm7.13-gfx1152``

         .. matrix-cell::
            :show-cond: fam=all

            ``amdrocm7.13``

         .. matrix-cell:: Runtimes, libraries, system control and monitoring tools, and other essential components.

         .. matrix-cell::

            Core runtime environment.
            Install this to run ROCm applications.

      .. matrix-row::

         .. matrix-cell::
            :show-cond: os=ubuntu os=debian

            .. selected:: gfx=gfx950

               ``amdrocm-core-dev7.13-gfx950``

            .. selected:: gfx=gfx942

               ``amdrocm-core-dev7.13-gfx94x``

            .. selected:: gfx=gfx90a

               ``amdrocm-core-dev7.13-gfx90a``

            .. selected:: gfx=gfx908

               ``amdrocm-core-dev7.13-gfx908``

            .. selected:: gfx=gfx1201 gfx=gfx1200

               ``amdrocm-core-dev7.13-gfx120x``

            .. selected:: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

               ``amdrocm-core-dev7.13-gfx110x``

            .. selected:: gfx=gfx1030

               ``amdrocm-core-dev7.13-gfx103x``

            .. selected:: gfx=gfx1151

               ``amdrocm-core-dev7.13-gfx1151``

            .. selected:: gfx=gfx1150

               ``amdrocm-core-dev7.13-gfx1150``

            .. selected:: gfx=gfx1152

               ``amdrocm-core-dev7.13-gfx1152``

            .. selected:: fam=all

               ``amdrocm-core-dev7.13``

         .. matrix-cell::
            :show-cond: os=rhel os=oracle-linux os=rocky-linux os=sles

            .. selected:: gfx=gfx950

               ``amdrocm-core-devel7.13-gfx950``

            .. selected:: gfx=gfx942

               ``amdrocm-core-devel7.13-gfx94x``

            .. selected:: gfx=gfx90a

               ``amdrocm-core-devel7.13-gfx90a``

            .. selected:: gfx=gfx908

               ``amdrocm-core-devel7.13-gfx908``

            .. selected:: gfx=gfx1201 gfx=gfx1200

               ``amdrocm-core-devel7.13-gfx120x``

            .. selected:: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

               ``amdrocm-core-devel7.13-gfx110x``

            .. selected:: gfx=gfx1030

               ``amdrocm-core-devel7.13-gfx103x``

            .. selected:: gfx=gfx1151

               ``amdrocm-core-devel7.13-gfx1151``

            .. selected:: gfx=gfx1150

               ``amdrocm-core-devel7.13-gfx1150``

            .. selected:: gfx=gfx1152

               ``amdrocm-core-devel7.13-gfx1152``

            .. selected:: fam=all

               ``amdrocm-core-devel7.13``

         .. matrix-cell::
            :show-cond: gfx=gfx950

            ``amdrocm7.13-gfx950`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-cond: gfx=gfx942

            ``amdrocm7.13-gfx94x`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-cond: gfx=gfx90a

            ``amdrocm7.13-gfx90a`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-cond: gfx=gfx908

            ``amdrocm7.13-gfx908`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-cond: gfx=gfx1201 gfx=gfx1200

            ``amdrocm7.13-gfx120x`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-cond: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

            ``amdrocm7.13-gfx110x`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-cond: gfx=gfx1030

            ``amdrocm7.13-gfx103x`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-cond: gfx=gfx1151

            ``amdrocm7.13-gfx1151`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-cond: gfx=gfx1150

            ``amdrocm7.13-gfx1150`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-cond: gfx=gfx1152

            ``amdrocm7.13-gfx1152`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-cond: fam=all

            ``amdrocm7.13`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::

            Development environment.
            Install this to build ROCm applications.

      .. matrix-row::

         .. matrix-cell::

            ``amdrocm-developer-tools7.13``

         .. matrix-cell:: Profilers, debuggers, and related tools.

         .. matrix-cell:: Install this to profile, debug, and optimize ROCm applications.

      .. matrix-row::

         .. matrix-cell::

            ``amdrocm-opencl7.13``

         .. matrix-cell:: Components needed to run OpenCL.

         .. matrix-cell:: Install this to run OpenCL applications on ROCm.

      .. matrix-row::

         .. matrix-cell::
            :show-cond: gfx=gfx950

            ``amdrocm-core-sdk7.13-gfx950``

         .. matrix-cell::
            :show-cond: gfx=gfx942

            ``amdrocm-core-sdk7.13-gfx94x``

         .. matrix-cell::
            :show-cond: gfx=gfx90a

            ``amdrocm-core-sdk7.13-gfx90a``

         .. matrix-cell::
            :show-cond: gfx=gfx908

            ``amdrocm-core-sdk7.13-gfx908``

         .. matrix-cell::
            :show-cond: gfx=gfx1201 gfx=gfx1200

            ``amdrocm-core-sdk7.13-gfx120x``

         .. matrix-cell::
            :show-cond: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

            ``amdrocm-core-sdk7.13-gfx110x``

         .. matrix-cell::
            :show-cond: gfx=gfx1030

            ``amdrocm-core-sdk7.13-gfx103x``

         .. matrix-cell::
            :show-cond: gfx=gfx1151

            ``amdrocm-core-sdk7.13-gfx1151``

         .. matrix-cell::
            :show-cond: gfx=gfx1150

            ``amdrocm-core-sdk7.13-gfx1150``

         .. matrix-cell::
            :show-cond: gfx=gfx1152

            ``amdrocm-core-sdk7.13-gfx1152``

         .. matrix-cell::
            :show-cond: fam=all

            ``amdrocm-core-sdk7.13``

         .. matrix-cell:: The complete ROCm Core SDK including runtimes, compilers, development tools, and dependencies.

         .. matrix-cell:: Install this if you need everything.


.. selected:: w=graphics

   .. selected:: os=ubuntu os=rhel

      .. selected:: fam=radeon

         Run the ``amdgpu-install`` script with the following ``--usecase`` arguments
         to install ROCm and graphics packages.

         .. code-block:: bash

            sudo amdgpu-install --usecase=rocm,graphics

      .. selected:: fam=ryzen

         Run the ``amdgpu-install`` script with the following ``--usecase``
         arguments to install ROCm packages. Ryzen APUs require the inbox
         kernel driver included with Ubuntu -- to skip installing the AMD GPU
         driver, add ``--no-dkms``.

         .. code-block:: bash

            sudo amdgpu-install --usecase=rocm --no-dkms

      Reboot your system after installing.

.. ====================================================================== PIP ==

.. selected:: i=pip
   :heading: Set up your Python virtual environment
   :heading-level: 4

   Create and activate the Python virtual environment where you'll install
   ROCm packages.

   .. selected:: os=ubuntu

      .. selected:: ubuntu-ver=26.04

         For example, to create and activate a Python 3.14 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.14 -m venv .venv
            source .venv/bin/activate

      .. selected:: ubuntu-ver=24.04

         For example, to create and activate a Python 3.12 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.12 -m venv .venv
            source .venv/bin/activate

      .. selected:: ubuntu-ver=22.04

         For example, to create and activate a Python 3.11 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.11 -m venv .venv
            source .venv/bin/activate

   .. selected:: os=debian

      .. selected:: debian-ver=13

         For example, to create and activate a Python 3.13 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.13 -m venv .venv
            source .venv/bin/activate

      .. selected:: debian-ver=12

         For example, to create and activate a Python 3.11 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.11 -m venv .venv
            source .venv/bin/activate

   .. selected:: os=rhel

      .. selected:: rhel-ver=10.1 rhel-ver=10.0

         For example, to create and activate a Python 3.12 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.12 -m venv .venv
            source .venv/bin/activate

      .. selected:: rhel-ver=9.7 rhel-ver=9.6 rhel-ver=9.4 rhel-ver=8.10

         For example, to create and activate a Python 3.11 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.11 -m venv .venv
            source .venv/bin/activate

   .. selected:: os=oracle-linux

      .. selected:: oracle-linux-ver=10

         For example, to create and activate a Python 3.12 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.12 -m venv .venv
            source .venv/bin/activate

      .. selected:: oracle-linux-ver=9

         For example, to create and activate a Python 3.11 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.11 -m venv .venv
            source .venv/bin/activate

      .. selected:: oracle-linux-ver=8

         For example, to create and activate a Python 3.11 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.11 -m venv .venv
            source .venv/bin/activate

   .. selected:: os=rocky-linux

      For example, to create and activate a Python 3.11 virtual environment,
      run the following command:

      .. code-block:: bash

         python3.11 -m venv .venv
         source .venv/bin/activate

   .. selected:: os=sles

      .. selected:: sles-ver=16.0

         For example, to create and activate a Python 3.13 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.13 -m venv .venv
            source .venv/bin/activate

      .. selected:: sles-ver=15.7

         For example, to create and activate a Python 3.11 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.11 -m venv .venv
            source .venv/bin/activate

   .. selected:: os=windows

      For example, to create and activate a Python 3.12 virtual environment,
      run the following command:

      .. code-block:: bat

         py -3.12 -m venv .venv
         .venv\Scripts\activate

.. selected:: i=pip
   :heading: Install ROCm wheel packages
   :heading-level: 4

   .. selected:: fam=all

      Use pip to install the ROCm Core SDK libraries and development tools.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl-multi-arch/ "rocm[libraries,devel,device-all]"

   .. selected:: gfx=gfx950

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx950`` GPU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx950-dcgpu/ "rocm[libraries,devel]"

   .. selected:: gfx=gfx942

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx942`` device.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx94X-dcgpu/ "rocm[libraries,devel]"

   .. selected:: gfx=gfx90a

      Use pip to install the ROCm Core SDK libraries and development tools.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx90a/ "rocm[libraries,devel]"

   .. selected:: gfx=gfx908

      Use pip to install the ROCm Core SDK libraries and development tools.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx908/ "rocm[libraries,devel]"

   .. selected:: gfx=gfx1201

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx1201`` GPU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx120X-all/ "rocm[libraries,devel]"

   .. selected:: gfx=gfx1200

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx1200`` GPU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx120X-all/ "rocm[libraries,devel]"

   .. selected:: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

      Use pip to install the ROCm Core SDK libraries and development tools.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx110X-all/ "rocm[libraries,devel]"

   .. selected:: gfx=gfx1030

      Use pip to install the ROCm Core SDK libraries and development tools.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx103X-all/ "rocm[libraries,devel]"

   .. selected:: gfx=gfx1151

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx1151`` Ryzen APU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1151/ "rocm[libraries,devel]"

   .. selected:: gfx=gfx1150

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx1150`` Ryzen APU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1150/ "rocm[libraries,devel]"

   .. selected:: gfx=gfx1152

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx1152`` Ryzen APU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1152/ "rocm[libraries,devel]"

.. ================================================================== TARBALL ==

.. selected:: i=tar
   :heading: Create the installation directory
   :heading-level: 4

   .. selected:: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      Run the following command in your desired location to create your
      installation directory:

      .. code-block:: bash

         mkdir therock-tarball && cd therock-tarball

      .. important::

         Subsequent commands assume you're working with the ``therock-tarball``
         directory. If you choose a different directory name, adjust the
         commands accordingly.


   .. selected:: os=windows

      Create the installation directory in ``C:\TheRock\build``. For example,
      use the following command in your command prompt:

      .. code-block:: bat

         mkdir C:\TheRock\build

      .. important::

         Subsequent commands assume you're working with the
         ``C:\TheRock\build`` directory. If you choose a different directory
         name, adjust the commands accordingly.

.. selected:: i=tar
   :heading: Download and unpack the tarball
   :heading-level: 4

   .. selected:: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      .. selected:: fam=all

         Use the following commands to download and untar the ROCm tarball.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball-multi-arch/therock-dist-linux-multiarch-7.13.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gfx=gfx950

         Use the following commands to download and untar the ROCm tarball for
         your ``gfx950`` GPU.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx950-dcgpu-7.13.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gfx=gfx942

         Use the following commands to download and untar the ROCm tarball for
         your ``gfx942`` GPU.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx94X-dcgpu-7.13.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gfx=gfx90a

         Use the following commands to download and untar the ROCm tarball.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx90a-7.13.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gfx=gfx908

         Use the following commands to download and untar the ROCm tarball.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx908-7.13.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gfx=gfx1201 gfx=gfx1200

         Use the following commands to download and untar the ROCm tarball.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx120X-all-7.13.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

         Use the following commands to download and untar the ROCm tarball.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx110X-all-7.13.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gfx=gfx1030

         Use the following commands to download and untar the ROCm tarball.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx103X-all-7.13.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gfx=gfx1151

         Use the following commands to download and untar the ROCm tarball for
         your ``gfx1151`` GPU.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx1151-7.13.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gfx=gfx1150

         Use the following commands to download and untar the ROCm tarball for
         your ``gfx1150`` GPU.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx1150-7.13.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gfx=gfx1152

         Use the following commands to download and untar the ROCm tarball for
         your ``gfx1152`` GPU.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx1152-7.13.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

   .. selected:: os=windows

      Download the tarball and extract the contents to ``C:\TheRock\build``.
      Run the following commands in your command prompt:

      .. selected:: gfx=gfx1201 gfx=gfx1200

         .. code-block:: bat

            cd C:\TheRock
            curl -o therock-dist-windows-gfx120X-all-7.13.0.tar.gz https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx120X-all-7.13.0.tar.gz
            tar -xzf therock-dist-windows-gfx120X-all-7.13.0.tar.gz -C build --strip-components=1

         - Download link: `therock-dist-windows-gfx120X-all-7.13.0.tar.gz
           <https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx120X-all-7.13.0.tar.gz>`__

      .. selected:: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

         .. code-block:: bat

            cd C:\TheRock
            curl -o therock-dist-windows-gfx110X-all-7.13.0.tar.gz https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx110X-all-7.13.0.tar.gz
            tar -xzf therock-dist-windows-gfx110X-all-7.13.0.tar.gz -C build --strip-components=1

         - Download link: `therock-dist-windows-gfx110X-all-7.13.0.tar.gz
           <https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx110X-all-7.13.0.tar.gz>`__

      .. selected:: gfx=gfx1030

         .. code-block:: bat

            cd C:\TheRock
            curl -o therock-dist-windows-gfx103X-all-7.13.0.tar.gz https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx103X-all-7.13.0.tar.gz
            tar -xzf therock-dist-windows-gfx103X-all-7.13.0.tar.gz -C build --strip-components=1

         - Download link: `therock-dist-windows-gfx103X-all-7.13.0.tar.gz
           <https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx103X-all-7.13.0.tar.gz>`__

      .. selected:: gfx=gfx1151

         .. code-block:: bat

            cd C:\TheRock
            curl -o therock-dist-windows-gfx1151-7.13.0.tar.gz https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx1151-7.13.0.tar.gz
            tar -xzf therock-dist-windows-gfx1151-7.13.0.tar.gz -C build --strip-components=1

         - Download link: `therock-dist-windows-gfx1151-7.13.0.tar.gz
           <https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx1151-7.13.0.tar.gz>`__

      .. selected:: gfx=gfx1150

         .. code-block:: bat

            cd C:\TheRock
            curl -o therock-dist-windows-gfx1150-7.13.0.tar.gz https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx1150-7.13.0.tar.gz
            tar -xzf therock-dist-windows-gfx1150-7.13.0.tar.gz -C build --strip-components=1

         - Download link: `therock-dist-windows-gfx1150-7.13.0.tar.gz
           <https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx1150-7.13.0.tar.gz>`__

      .. selected:: gfx=gfx1152

         .. code-block:: bat

            cd C:\TheRock
            curl -o therock-dist-windows-gfx1152-7.13.0.tar.gz https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx1152-7.13.0.tar.gz
            tar -xzf therock-dist-windows-gfx1152-7.13.0.tar.gz -C build --strip-components=1

         - Download link: `therock-dist-windows-gfx1152-7.13.0.tar.gz
           <https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx1152-7.13.0.tar.gz>`__

.. ================================================================== RUNFILE ==

.. selected:: i=runfile

   Install the ``core`` ROCm components. See :ref:`ROCm meta components
   <rocm-install-runfile-meta-components>` for additional installation options.

   .. selected:: gfx=gfx950

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx950 gpu-access=user

   .. selected:: gfx=gfx942

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx94x gpu-access=user

   .. selected:: gfx=gfx90a

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx90a gpu-access=user

   .. selected:: gfx=gfx908

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx908 gpu-access=user

   .. selected:: gfx=gfx1201 gfx=gfx1200

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx120x gpu-access=user

   .. selected:: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx110x gpu-access=user

   .. selected:: gfx=gfx1030

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx103x gpu-access=user

   .. selected:: gfx=gfx1151

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx1151 gpu-access=user

   .. selected:: gfx=gfx1150

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx1150 gpu-access=user

   .. selected:: gfx=gfx1152

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx1152 gpu-access=user

.. selected:: i=runfile
   :heading: ROCm meta components
   :heading-level: 4

   .. _rocm-install-runfile-meta-components:

   Meta components are similar to the meta packages used in the package manager
   installation method. They group related components and dependencies
   together, allowing you to install only what is necessary for your use case.
   The following table describes available ROCm meta components:

   .. matrix::

      .. matrix-row::
         :header:

         .. matrix-cell:: Meta component name

         .. matrix-cell:: Contents

         .. matrix-cell:: Use case

      .. matrix-row::

         .. matrix-cell::

            ``core``

         .. matrix-cell::

            Runtimes, libraries, system control and monitoring tools, and other essential components.

         .. matrix-cell::

            Core runtime environment. Install this to run ROCm applications.

      .. matrix-row::

         .. matrix-cell::

            ``core-dev``

         .. matrix-cell::

            ``core`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::

            Development environment. Install this to build ROCm applications.

      .. matrix-row::

         .. matrix-cell::

            ``dev-tools``

         .. matrix-cell::

            Profilers, debuggers, and related tools.

         .. matrix-cell::

            Install this to profile, debug, and optimize ROCm applications.

      .. matrix-row::

         .. matrix-cell::

            ``opencl``

         .. matrix-cell::

            Components needed to run OpenCL.

         .. matrix-cell::

            Install this to run OpenCL applications on ROCm.

      .. matrix-row::

         .. matrix-cell::

            ``core-sdk``

         .. matrix-cell::

            The complete ROCm Core SDK including runtimes, compilers, development tools, and dependencies.

         .. matrix-cell::

            Install this if you need everything.

   The default installation uses the core meta component. To select other
   components, add the ``compo=`` argument. For example, to install both ``core`` and
   ``core-dev``:

   .. selected:: gfx=gfx950

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx950 compo=core,core-dev gpu-access=user

   .. selected:: gfx=gfx942

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx94x compo=core,core-dev gpu-access=user

   .. selected:: gfx=gfx90a

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx90a compo=core,core-dev gpu-access=user

   .. selected:: gfx=gfx908

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx908 compo=core,core-dev gpu-access=user

   .. selected:: gfx=gfx1201 gfx=gfx1200

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx120x compo=core,core-dev gpu-access=user

   .. selected:: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx110x compo=core,core-dev gpu-access=user

   .. selected:: gfx=gfx1030

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx103x compo=core,core-dev gpu-access=user

   .. selected:: gfx=gfx1151

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx1151 compo=core,core-dev gpu-access=user

   .. selected:: gfx=gfx1150

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx1150 compo=core,core-dev gpu-access=user

   .. selected:: gfx=gfx1152

      .. code-block:: bash

         bash rocm-installer-7.13.0-2.run deps=install rocm gfx=gfx1152 compo=core,core-dev gpu-access=user
