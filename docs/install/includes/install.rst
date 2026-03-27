Installation
============

Before getting started, make sure you've completed the :ref:`rocm-prerequisites`.
For information about supported operating systems and compatible AMD devices,
see the :doc:`Compatibility matrix </compatibility/compatibility-matrix>`.

.. selected:: os=windows

   .. caution::

      Do not copy/replace the ROCm compiler and runtime DLLs to System32 as
      this can cause conflicts.

.. selected:: i=runfile
   :heading: Download the runfile installer
   :heading-level: 3

   Use the following command to download the ROCm Runfile Installer.

   .. code-block:: bash

      wget https://repo.radeon.com/rocm/installer/rocm-runfile-installer/rocm-rel-7.12/rocm-installer-7.12.0-1.run

.. ==================================================== INSTALL KERNEL DRIVER ==

.. selected:: i=pkgman i=pip i=tar

   .. selected:: fam=instinct fam=radeon-pro fam=radeon
      :heading: Install the kernel driver
      :heading-level: 3

      For information about AMD GPU Driver (amdgpu) compatibility, see the
      :doc:`Compatibility matrix </compatibility/compatibility-matrix>`.

      .. selected:: os=ubuntu

         For instructions on installing the AMD GPU Driver (amdgpu), see `Ubuntu native
         installation
         <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.20.0-preview/install/detailed-install/package-manager/package-manager-ubuntu.html>`__
         in the AMD Instinct Data Center GPU Documentation.

      .. selected:: os=debian

         For instructions on installing the AMD GPU Driver (amdgpu), see `Debian native
         installation
         <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.20.0-preview/install/detailed-install/package-manager/package-manager-debian.html>`__
         in the AMD Instinct Data Center GPU Documentation.

      .. selected:: os=rhel

         For instructions on installing the AMD GPU Driver (amdgpu), see `RHEL native
         installation
         <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.20.0-preview/install/detailed-install/package-manager/package-manager-rhel.html>`__
         in the AMD Instinct Data Center GPU Documentation.

      .. selected:: os=oracle-linux

         For instructions on installing the AMD GPU Driver (amdgpu), see `Oracle Linux native
         installation
         <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.20.0-preview/install/detailed-install/package-manager/package-manager-ol.html>`__
         in the AMD Instinct Data Center GPU Documentation.

      .. selected:: os=rocky-linux

         For instructions on installing the AMD GPU Driver (amdgpu), see `Rocky Linux native
         installation
         <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.20.0-preview/install/detailed-install/package-manager/package-manager-rl.html>`__
         in the AMD Instinct Data Center GPU Documentation.

      .. selected:: os=sles

         For instructions on installing the AMD GPU Driver (amdgpu), see `SLES
         native installation
         <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.20.0-preview/install/detailed-install/package-manager/package-manager-sles.html>`__
         in the AMD Instinct Data Center GPU Documentation.

   .. selected:: fam=ryzen

      .. selected:: os=ubuntu
         :heading: About the kernel driver
         :heading-level: 3

         Supported Ryzen AI APUs require the inbox kernel driver included with
         Ubuntu 24.04.3.

.. selected:: i=runfile
   :heading: Install the kernel driver
   :heading-level: 3

   For information about AMD GPU Driver (amdgpu) compatibility, see the
   :doc:`Compatibility matrix </compatibility/compatibility-matrix>`.

   .. code-block:: bash

      bash rocm-installer-7.12.0-1.run deps=install amdgpu

   .. note::

      Reboot your system after installing the AMD GPU Driver.


Install ROCm
------------

Use the following instructions to install the ROCm on your system.

.. ========================================================== PACKAGE MANAGER ==

.. selected:: i=pkgman
   :heading: Register ROCm repositories
   :heading-level: 4

   .. selected:: os=ubuntu

      Register the ROCm repository with your system's package manager. This lets you install and update
      ROCm packages using ``apt``.

      .. selected:: os-version=24.04

         .. code-block:: bash

            # Download and install GPG key
            sudo mkdir --parents --mode=0755 /etc/apt/keyrings
            wget https://repo.amd.com/rocm/packages/gpg/rocm.gpg -O - | \
                gpg --dearmor | sudo tee /etc/apt/keyrings/amdrocm.gpg > /dev/null

            sudo tee /etc/apt/sources.list.d/rocm.list << EOF
            deb [arch=amd64 signed-by=/etc/apt/keyrings/amdrocm.gpg] https://repo.amd.com/rocm/packages/ubuntu2404 stable main
            EOF

            sudo apt update

      .. selected:: os-version=22.04

         .. code-block:: bash

            # Download and install GPG key
            sudo mkdir --parents --mode=0755 /etc/apt/keyrings
            wget https://repo.amd.com/rocm/packages/gpg/rocm.gpg -O - | \
                gpg --dearmor | sudo tee /etc/apt/keyrings/amdrocm.gpg > /dev/null

            sudo tee /etc/apt/sources.list.d/rocm.list << EOF
            deb [arch=amd64 signed-by=/etc/apt/keyrings/amdrocm.gpg] https://repo.amd.com/rocm/packages/ubuntu2204 stable main
            EOF

            sudo apt update

   .. selected:: os=debian

      Register the ROCm repository with your system's package manager. This enables
      you to install and update ROCm packages using ``apt``.

      .. selected:: os-version=13

         .. code-block:: bash

            # Download and install GPG key
            sudo mkdir --parents --mode=0755 /etc/apt/keyrings
            wget https://repo.amd.com/rocm/packages/gpg/rocm.gpg -O - | \
                gpg --dearmor | sudo tee /etc/apt/keyrings/amdrocm.gpg > /dev/null

            sudo tee /etc/apt/sources.list.d/rocm.list << EOF
            deb [arch=amd64 signed-by=/etc/apt/keyrings/amdrocm.gpg] https://repo.amd.com/rocm/packages/debian13 stable main
            EOF

            sudo apt update

      .. selected:: os-version=12

         .. code-block:: bash

            # Download and install GPG key
            sudo mkdir --parents --mode=0755 /etc/apt/keyrings
            wget https://repo.amd.com/rocm/packages/gpg/rocm.gpg -O - | \
                gpg --dearmor | sudo tee /etc/apt/keyrings/amdrocm.gpg > /dev/null

            sudo tee /etc/apt/sources.list.d/rocm.list << EOF
            deb [arch=amd64 signed-by=/etc/apt/keyrings/amdrocm.gpg] https://repo.amd.com/rocm/packages/debian12 stable main
            EOF

            sudo apt update

   .. selected:: os=rhel os=oracle-linux os=rocky-linux

      .. selected:: os-version=10.1 os-version=10.0

         Register the ROCm repository with your system's package manager. This enables
         you to install and update ROCm packages using ``dnf``.

         .. code-block:: bash

            sudo tee /etc/yum.repos.d/rocm.repo <<EOF
            [rocm]
            name=ROCm 7.12.0
            baseurl=https://repo.amd.com/rocm/packages/rhel10/x86_64
            enabled=1
            gpgcheck=1
            gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
            priority=50
            EOF

            sudo dnf clean all

      .. selected:: os-version=9.7 os-version=9.6 os-version=9.4

         Register the ROCm repository with your system's package manager. This enables
         you to install and update ROCm packages using ``dnf``.

         .. code-block:: bash

            sudo tee /etc/yum.repos.d/rocm.repo <<EOF
            [rocm]
            name=ROCm 7.12.0
            baseurl=https://repo.amd.com/rocm/packages/rhel9/x86_64
            enabled=1
            gpgcheck=1
            gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
            priority=50
            EOF

            sudo dnf clean all


      .. selected:: os-version=8.10

         Register the ROCm repository with your system's package manager. This enables
         you to install and update ROCm packages using ``dnf``.

         .. code-block:: bash

            sudo tee /etc/yum.repos.d/rocm.repo <<EOF
            [rocm]
            name=ROCm 7.12.0
            baseurl=https://repo.amd.com/rocm/packages/rhel8/x86_64
            enabled=1
            gpgcheck=1
            gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
            priority=50
            EOF

            sudo dnf clean all

   .. selected:: os=sles

      Register the ROCm repository with your system's package manager. This enables
      you to install and update ROCm packages using ``zypper``.

      .. selected:: os-version=16.0

         .. code-block:: bash

            sudo tee /etc/zypp/repos.d/rocm.repo <<EOF
            [rocm]
            name=ROCm 7.12.0
            baseurl=https://repo.amd.com/rocm/packages/sles16/x86_64
            enabled=1
            gpgcheck=1
            gpgkey=https://repo.amd.com/rocm/packages/gpg/rocm.gpg
            priority=50
            EOF

            sudo zypper --gpg-auto-import-keys refresh

      .. selected:: os-version=15.7

         .. code-block:: bash

            sudo tee /etc/zypp/repos.d/rocm.repo <<EOF
            [rocm]
            name=ROCm 7.12.0
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

      .. selected:: gpu=mi355x gpu=mi350x

         .. code-block:: bash

            sudo apt install amdrocm7.12-gfx950

      .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

         .. code-block:: bash

            sudo apt install amdrocm7.12-gfx94x

      .. selected:: gpu=mi250x gpu=mi250 gpu=mi210

         .. code-block:: bash

            sudo apt install amdrocm7.12-gfx90a

      .. selected:: gpu=mi100

         .. code-block:: bash

            sudo apt install amdrocm7.12-gfx908

      .. selected:: gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

         .. code-block:: bash

            sudo apt install amdrocm7.12-gfx120x

      .. selected:: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600 gpu=9-270 gpu=7-260 gpu=7-250 gpu=5-240 gpu=5-230 gpu=5-220 gpu=3-210

         .. code-block:: bash

            sudo apt install amdrocm7.12-gfx110x

      .. selected:: gpu=w6800 gpu=v620

         .. code-block:: bash

            sudo apt install amdrocm7.12-gfx103x

      .. selected:: gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385

         .. code-block:: bash

            sudo apt install amdrocm7.12-gfx1151

      .. selected:: gpu=9-hx-pro-475 gpu=9-hx-pro-470 gpu=9-pro-465 gpu=7-pro-450 gpu=5-pro-440 gpu=5-pro-435 gpu=9-hx-375 gpu=9-hx-370 gpu=9-365

         .. code-block:: bash

            sudo apt install amdrocm7.12-gfx1150

   .. selected:: os=rhel os=oracle-linux os=rocky-linux

      Use ``dnf`` to install the core ROCm packages. See :ref:`ROCm meta
      packages <rocm-install-meta-packages>` for additional installation
      options.

      .. selected:: gpu=mi355x gpu=mi350x

         .. code-block:: bash

            sudo dnf install amdrocm7.12-gfx950

      .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

         .. code-block:: bash

            sudo dnf install amdrocm7.12-gfx94x

      .. selected:: gpu=mi250x gpu=mi250 gpu=mi210

         .. code-block:: bash

            sudo dnf install amdrocm7.12-gfx90a

      .. selected:: gpu=mi100

         .. code-block:: bash

            sudo dnf install amdrocm7.12-gfx908

      .. selected:: gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

         .. code-block:: bash

            sudo dnf install amdrocm7.12-gfx120x

      .. selected:: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600

         .. code-block:: bash

            sudo dnf install amdrocm7.12-gfx110x

      .. selected:: gpu=w6800 gpu=v620

         .. code-block:: bash

            sudo dnf install amdrocm7.12-gfx103x

   .. selected:: os=sles

      Use ``zypper`` to install the core ROCm packages. See :ref:`ROCm meta
      packages <rocm-install-meta-packages>` for additional installation
      options.

      .. selected:: gpu=mi355x gpu=mi350x

         .. code-block:: bash

            sudo zypper install amdrocm7.12-gfx950

      .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

         .. code-block:: bash

            sudo zypper install amdrocm7.12-gfx94x

      .. selected:: gpu=mi250x gpu=mi250 gpu=mi210

         .. code-block:: bash

            sudo zypper install amdrocm7.12-gfx90a

      .. selected:: gpu=mi100

         .. code-block:: bash

            sudo zypper install amdrocm7.12-gfx908

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
            :show-when: gpu=mi355x gpu=mi350x

            ``amdrocm7.12-gfx950``

         .. matrix-cell::
            :show-when: gpu=mi325x gpu=mi300x gpu=mi300a

            ``amdrocm7.12-gfx94x``

         .. matrix-cell::
            :show-when: gpu=mi250x gpu=mi250 gpu=mi210

            ``amdrocm7.12-gfx90a``

         .. matrix-cell::
            :show-when: gpu=mi100

            ``amdrocm7.12-gfx908``

         .. matrix-cell::
            :show-when: gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

            ``amdrocm7.12-gfx120x``

         .. matrix-cell::
            :show-when: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600 gpu=9-270 gpu=7-260 gpu=7-250 gpu=5-240 gpu=5-230 gpu=5-220 gpu=3-210

            ``amdrocm7.12-gfx110x``

         .. matrix-cell::
            :show-when: gpu=w6800 gpu=v620

            ``amdrocm7.12-gfx103x``

         .. matrix-cell::
            :show-when: gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385

            ``amdrocm7.12-gfx1151``

         .. matrix-cell::
            :show-when: gpu=9-hx-pro-475 gpu=9-hx-pro-470 gpu=9-pro-465 gpu=7-pro-450 gpu=5-pro-440 gpu=5-pro-435 gpu=9-hx-375 gpu=9-hx-370 gpu=9-365

            ``amdrocm7.12-gfx1150``

         .. matrix-cell:: Runtimes, libraries, system control and monitoring tools, and other essential components.

         .. matrix-cell::

            Core runtime environment.
            Install this to run ROCm applications.

      .. matrix-row::

         .. matrix-cell::
            :show-when: os=ubuntu os=debian

            .. selected:: gpu=mi355x gpu=mi350x

               ``amdrocm-core-dev7.12-gfx950``

            .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

               ``amdrocm-core-dev7.12-gfx94x``

            .. selected:: gpu=mi250x gpu=mi250 gpu=mi210

               ``amdrocm-core-dev7.12-gfx90a``

            .. selected:: gpu=mi100

               ``amdrocm-core-dev7.12-gfx908``

            .. selected:: gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

               ``amdrocm-core-dev7.12-gfx120x``

            .. selected:: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600 gpu=9-270 gpu=7-260 gpu=7-250 gpu=5-240 gpu=5-230 gpu=5-220 gpu=3-210

               ``amdrocm-core-dev7.12-gfx110x``

            .. selected:: gpu=w6800 gpu=v620

               ``amdrocm-core-dev7.12-gfx103x``

            .. selected:: gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385

               ``amdrocm-core-dev7.12-gfx1151``

            .. selected:: gpu=9-hx-pro-475 gpu=9-hx-pro-470 gpu=9-pro-465 gpu=7-pro-450 gpu=5-pro-440 gpu=5-pro-435 gpu=9-hx-375 gpu=9-hx-370 gpu=9-365

               ``amdrocm-core-dev7.12-gfx1150``

         .. matrix-cell::
            :show-when: os=rhel os=oracle-linux os=rocky-linux os=sles

            .. selected:: gpu=mi355x gpu=mi350x

               ``amdrocm-core-devel7.12-gfx950``

            .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

               ``amdrocm-core-devel7.12-gfx94x``

            .. selected:: gpu=mi250x gpu=mi250 gpu=mi210

               ``amdrocm-core-devel7.12-gfx90a``

            .. selected:: gpu=mi100

               ``amdrocm-core-devel7.12-gfx908``

            .. selected:: gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

               ``amdrocm-core-devel7.12-gfx120x``

            .. selected:: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600 gpu=9-270 gpu=7-260 gpu=7-250 gpu=5-240 gpu=5-230 gpu=5-220 gpu=3-210

               ``amdrocm-core-devel7.12-gfx110x``

            .. selected:: gpu=w6800 gpu=v620

               ``amdrocm-core-devel7.12-gfx103x``

            .. selected:: gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385

               ``amdrocm-core-devel7.12-gfx1151``

            .. selected:: gpu=9-hx-pro-475 gpu=9-hx-pro-470 gpu=9-pro-465 gpu=7-pro-450 gpu=5-pro-440 gpu=5-pro-435 gpu=9-hx-375 gpu=9-hx-370 gpu=9-365

               ``amdrocm-core-devel7.12-gfx1150``

         .. matrix-cell::
            :show-when: gpu=mi355x gpu=mi350x

            ``amdrocm7.12-gfx950`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-when: gpu=mi325x gpu=mi300x gpu=mi300a

            ``amdrocm7.12-gfx94x`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-when: gpu=mi250x gpu=mi250 gpu=mi210

            ``amdrocm7.12-gfx90a`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-when: gpu=mi100

            ``amdrocm7.12-gfx908`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-when: gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

            ``amdrocm7.12-gfx120x`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-when: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600 gpu=9-270 gpu=7-260 gpu=7-250 gpu=5-240 gpu=5-230 gpu=5-220 gpu=3-210

            ``amdrocm7.12-gfx110x`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-when: gpu=w6800 gpu=v620

            ``amdrocm7.12-gfx103x`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-when: gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385

            ``amdrocm7.12-gfx1151`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::
            :show-when: gpu=9-hx-pro-475 gpu=9-hx-pro-470 gpu=9-pro-465 gpu=7-pro-450 gpu=5-pro-440 gpu=5-pro-435 gpu=9-hx-375 gpu=9-hx-370 gpu=9-365

            ``amdrocm7.12-gfx1150`` plus compilers, CMake configurations, static library files, and headers.

         .. matrix-cell::

            Development environment.
            Install this to build ROCm applications.

      .. matrix-row::

         .. matrix-cell::

            ``amdrocm-developer-tools7.12``

         .. matrix-cell:: Profilers, debuggers, and related tools.

         .. matrix-cell:: Install this to profile, debug, and optimize ROCm applications.

      .. matrix-row::

         .. matrix-cell::

            ``amdrocm-opencl7.12``

         .. matrix-cell:: Components needed to run OpenCL.

         .. matrix-cell:: Install this to run OpenCL applications on ROCm.

      .. matrix-row::

         .. matrix-cell::
            :show-when: gpu=mi355x gpu=mi350x

            ``amdrocm-core-sdk-gfx950``

         .. matrix-cell::
            :show-when: gpu=mi325x gpu=mi300x gpu=mi300a

            ``amdrocm-core-sdk-gfx94x``

         .. matrix-cell::
            :show-when: gpu=mi250x gpu=mi250 gpu=mi210

            ``amdrocm-core-sdk-gfx90a``

         .. matrix-cell::
            :show-when: gpu=mi100

            ``amdrocm-core-sdk-gfx908``

         .. matrix-cell::
            :show-when: gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

            ``amdrocm-core-sdk-gfx120x``

         .. matrix-cell::
            :show-when: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600 gpu=9-270 gpu=7-260 gpu=7-250 gpu=5-240 gpu=5-230 gpu=5-220 gpu=3-210

            ``amdrocm-core-sdk-gfx110x``

         .. matrix-cell::
            :show-when: gpu=w6800 gpu=v620

            ``amdrocm-core-sdk-gfx103x``

         .. matrix-cell::
            :show-when: gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385

            ``amdrocm-core-sdk-gfx1151``

         .. matrix-cell::
            :show-when: gpu=9-hx-pro-475 gpu=9-hx-pro-470 gpu=9-pro-465 gpu=7-pro-450 gpu=5-pro-440 gpu=5-pro-435 gpu=9-hx-375 gpu=9-hx-370 gpu=9-365

            ``amdrocm-core-sdk-gfx1150``

         .. matrix-cell:: The complete ROCm Core SDK including runtimes, compilers, development tools, and dependencies.

         .. matrix-cell:: Install this if you need everything.

.. ====================================================================== PIP ==

.. selected:: i=pip
   :heading: Set up your Python virtual environment
   :heading-level: 4

   Create and activate the Python virtual environment where you'll install
   ROCm packages.

   .. selected:: os=ubuntu

      .. selected:: os-version=24.04

         For example, to create and activate a Python 3.12 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.12 -m venv .venv
            source .venv/bin/activate

      .. selected:: os-version=22.04

         For example, to create and activate a Python 3.11 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.11 -m venv .venv
            source .venv/bin/activate

   .. selected:: os=debian

      .. selected:: os-version=13

         For example, to create and activate a Python 3.13 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.13 -m venv .venv
            source .venv/bin/activate

      .. selected:: os-version=12

         For example, to create and activate a Python 3.11 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.11 -m venv .venv
            source .venv/bin/activate

   .. selected:: os=rhel os=oracle-linux os=rocky-linux

      .. selected:: os-version=10.1 os-version=10.0

         For example, to create and activate a Python 3.12 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.12 -m venv .venv
            source .venv/bin/activate

      .. selected:: os-version=9.7 os-version=9.6 os-version=9.4 os-version=9 os-version=8.10 os-version=8

         For example, to create and activate a Python 3.11 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.11 -m venv .venv
            source .venv/bin/activate

   .. selected:: os=sles

      .. selected:: os-version=16.0

         For example, to create and activate a Python 3.13 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.13 -m venv .venv
            source .venv/bin/activate

      .. selected:: os-version=15.7

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

   .. selected:: gpu=mi355x gpu=mi350x

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx950`` GPU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx950-dcgpu/ "rocm[libraries,devel]"

   .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx942`` device.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx94X-dcgpu/ "rocm[libraries,devel]"

   .. selected:: gpu=mi250x gpu=mi250 gpu=mi210

      Use pip to install the ROCm Core SDK libraries and development tools.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx90a/ "rocm[libraries,devel]"

   .. selected:: gpu=mi100

      Use pip to install the ROCm Core SDK libraries and development tools.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx908/ "rocm[libraries,devel]"

   .. selected:: gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx1201`` GPU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx120x-all/ "rocm[libraries,devel]"

   .. selected:: gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx1200`` GPU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx120x-all/ "rocm[libraries,devel]"

   .. selected:: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600 gpu=9-270 gpu=7-260 gpu=7-250 gpu=5-240 gpu=5-230 gpu=5-220 gpu=3-210

      Use pip to install the ROCm Core SDK libraries and development tools.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx110X-all/ "rocm[libraries,devel]"

   .. selected:: gpu=w6800 gpu=v620

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx1030`` GPU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx103X-dgpu/ "rocm[libraries,devel]"

   .. selected:: gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx1151`` Ryzen APU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1151/ "rocm[libraries,devel]"

   .. selected:: gpu=9-hx-pro-475 gpu=9-hx-pro-470 gpu=9-pro-465 gpu=7-pro-450 gpu=5-pro-440 gpu=5-pro-435 gpu=9-hx-375 gpu=9-hx-370 gpu=9-365

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx1150`` Ryzen APU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1150/ "rocm[libraries,devel]"

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

      .. selected:: gpu=mi355x gpu=mi350x

         Use the following commands to download and untar the ROCm tarball for
         your ``gfx950`` GPU.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx950-dcgpu-7.12.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

         Use the following commands to download and untar the ROCm tarball for
         your ``gfx942`` GPU.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx94X-dcgpu-7.12.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gpu=mi250x gpu=mi250 gpu=mi210

         Use the following commands to download and untar the ROCm tarball.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx90a-7.12.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gpu=mi100

         Use the following commands to download and untar the ROCm tarball.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx908-7.12.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

         Use the following commands to download and untar the ROCm tarball.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx120X-all-7.12.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600 gpu=9-270 gpu=7-260 gpu=7-250 gpu=5-240 gpu=5-230 gpu=5-220 gpu=3-210

         Use the following commands to download and untar the ROCm tarball.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx110X-all-7.12.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gpu=w6800 gpu=v620

         Use the following commands to download and untar the ROCm tarball.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx103X-dgpu-7.12.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385

         Use the following commands to download and untar the ROCm tarball for
         your ``gfx1151`` GPU.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx1151-7.12.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gpu=9-hx-pro-475 gpu=9-hx-pro-470 gpu=9-pro-465 gpu=7-pro-450 gpu=5-pro-440 gpu=5-pro-435 gpu=9-hx-375 gpu=9-hx-370 gpu=9-365

         Use the following commands to download and untar the ROCm tarball for
         your ``gfx1150`` GPU.

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx1150-7.12.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

   .. selected:: os=windows

      Download the tarball and extract the contents to ``C:\TheRock\build``.
      Run the following commands in your command prompt:

      .. selected:: gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

         .. code-block:: bat

            cd C:\TheRock
            curl -o therock-dist-windows-gfx120X-all-7.12.0.tar.gz https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx120X-all-7.12.0.tar.gz
            tar -xzf therock-dist-windows-gfx120X-all-7.12.0.tar.gz -C build --strip-components=1

         - Download link: `therock-dist-windows-gfx120X-all-7.12.0.tar.gz
           <https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx120X-all-7.12.0.tar.gz>`__

      .. selected:: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600 gpu=9-270 gpu=7-260 gpu=7-250 gpu=5-240 gpu=5-230 gpu=5-220 gpu=3-210

         .. code-block:: bat

            cd C:\TheRock
            curl -o therock-dist-windows-gfx110X-all-7.12.0.tar.gz https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx110X-all-7.12.0.tar.gz
            tar -xzf therock-dist-windows-gfx110X-all-7.12.0.tar.gz -C build --strip-components=1

         - Download link: `therock-dist-windows-gfx110X-all-7.12.0.tar.gz
           <https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx110X-all-7.12.0.tar.gz>`__

      .. selected:: gpu=w6800 gpu=v620

         .. code-block:: bat

            cd C:\TheRock
            curl -o therock-dist-windows-gfx103X-dgpu-7.12.0.tar.gz https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx103X-dgpu-7.12.0.tar.gz
            tar -xzf therock-dist-windows-gfx103X-dgpu-7.12.0.tar.gz -C build --strip-components=1

         - Download link: `therock-dist-windows-gfx103X-dgpu-7.12.0.tar.gz
           <https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx103X-dgpu-7.12.0.tar.gz>`__

      .. selected:: gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385

         .. code-block:: bat

            cd C:\TheRock
            curl -o therock-dist-windows-gfx1151-7.12.0.tar.gz https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx1151-7.12.0.tar.gz
            tar -xzf therock-dist-windows-gfx1151-7.12.0.tar.gz -C build --strip-components=1

         - Download link: `therock-dist-windows-gfx1151-7.12.0.tar.gz
           <https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx1151-7.12.0.tar.gz>`__

      .. selected:: gpu=9-hx-pro-475 gpu=9-hx-pro-470 gpu=9-pro-465 gpu=7-pro-450 gpu=5-pro-440 gpu=5-pro-435 gpu=9-hx-375 gpu=9-hx-370 gpu=9-365

         .. code-block:: bat

            cd C:\TheRock
            curl -o therock-dist-windows-gfx1150-7.12.0.tar.gz https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx1150-7.12.0.tar.gz
            tar -xzf therock-dist-windows-gfx1150-7.12.0.tar.gz -C build --strip-components=1

         - Download link: `therock-dist-windows-gfx1150-7.12.0.tar.gz
           <https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx1150-7.12.0.tar.gz>`__

.. ================================================================== RUNFILE ==

.. selected:: i=runfile

   Install the ``core`` ROCm components. See :ref:`ROCm meta components
   <rocm-install-runfile-meta-components>` for additional installation options.

   .. selected:: gpu=mi355x gpu=mi350x

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx950 gpu-access=user

   .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx94x gpu-access=user

   .. selected:: gpu=mi250x gpu=mi250 gpu=mi210

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx90a gpu-access=user

   .. selected:: gpu=mi100

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx908 gpu-access=user

   .. selected:: gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx120x gpu-access=user

   .. selected:: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600 gpu=9-270 gpu=7-260 gpu=7-250 gpu=5-240 gpu=5-230 gpu=5-220 gpu=3-210

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx110x gpu-access=user

   .. selected:: gpu=w6800 gpu=v620

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx103x gpu-access=user

   .. selected:: gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx1151 gpu-access=user

   .. selected:: gpu=9-hx-pro-475 gpu=9-hx-pro-470 gpu=9-pro-465 gpu=7-pro-450 gpu=5-pro-440 gpu=5-pro-435 gpu=9-hx-375 gpu=9-hx-370 gpu=9-365

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx1150 gpu-access=user

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

   .. selected:: gpu=mi355x gpu=mi350x

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx950 compo=core,core-dev gpu-access=user

   .. selected:: gpu=mi325x gpu=mi300x gpu=mi300a

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx94x compo=core,core-dev gpu-access=user

   .. selected:: gpu=mi250x gpu=mi250 gpu=mi210

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx90a compo=core,core-dev gpu-access=user

   .. selected:: gpu=mi100

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx908 compo=core,core-dev gpu-access=user

   .. selected:: gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx120x compo=core,core-dev gpu-access=user

   .. selected:: gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=v710 gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700 gpu=rx-7600 gpu=9-270 gpu=7-260 gpu=7-250 gpu=5-240 gpu=5-230 gpu=5-220 gpu=3-210

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx110x compo=core,core-dev gpu-access=user

   .. selected:: gpu=w6800 gpu=v620

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx103x compo=core,core-dev gpu-access=user

   .. selected:: gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx1151 compo=core,core-dev gpu-access=user

   .. selected:: gpu=9-hx-pro-475 gpu=9-hx-pro-470 gpu=9-pro-465 gpu=7-pro-450 gpu=5-pro-440 gpu=5-pro-435 gpu=9-hx-375 gpu=9-hx-370 gpu=9-365

      .. code-block:: bash

         bash rocm-installer-7.12.0-1.run deps=install rocm gfx=gfx1150 compo=core,core-dev gpu-access=user
