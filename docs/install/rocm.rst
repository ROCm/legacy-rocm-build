.. meta::
   :description: Learn how to install AMD ROCm 7.9.0 for supported Instinct GPUs and Ryzen AI APUs on Ubuntu, RHEL, and Windows. This step-by-step guide covers prerequisites, driver setup, installation methods (pip and tarball), and troubleshooting.
   :keywords: AMD ROCm 7.9.0, install ROCm, Instinct GPU, Ryzen APU, Ubuntu, RHEL, Windows, pip install ROCm, ROCm wheel, ROCm tarball, ROCm GPU driver, ROCm setup, ROCm uninstall, ROCm troubleshooting

**********************
Install AMD ROCm 7.9.0
**********************

Use the following selector to choose your installation method for your
supported AMD GPU or APU and operating system. For information about supported
operating systems and compatible AMD devices, see the :doc:`Compatibility matrix
</compatibility/compatibility-matrix>`.

.. selector:: AMD product family
   :key: plat

   .. selector-option:: Instinct GPU
      :value: instinct
      :width: 6

   .. selector-option:: Ryzen APU
      :value: ryzen
      :width: 6

.. selected:: plat=instinct

   .. selector:: Instinct GPU
      :key: instinct-arch

      .. selector-option:: Instinct MI355X, MI350X
         :value: gfx950

      .. selector-option:: Instinct MI325X, MI300X, MI300A
         :value: gfx942

   .. selector:: Operating system
      :key: instinct-os

      .. selector-option:: Ubuntu
         :value: ubuntu
         :icon: fab fa-linux fa-lg

      .. selector-option:: Red Hat Enterprise Linux
         :value: rhel
         :icon: fab fa-linux fa-lg

   .. selector:: Ubuntu version
      :key: instinct-ubuntu-version
      :show-when: instinct-os=ubuntu

      .. selector-option:: 24.04.3
         :value: 24.04
         :icon: fab fa-ubuntu fa-lg

      .. selector-option:: 22.04.5
         :value: 22.04
         :icon: fab fa-ubuntu fa-lg

   .. selector:: RHEL version
      :key: instinct-rhel-version
      :show-when: instinct-os=rhel

      .. selector-option:: 10.0
         :value: 10.0
         :icon: fab fa-redhat fa-lg

      .. selector-option:: 9.6
         :value: 9.6
         :icon: fab fa-redhat fa-lg

.. selected:: plat=ryzen

   .. selector:: Ryzen APU
      :key: ryzen

      .. selector-option:: Ryzen AI Max+ PRO 395<br>Ryzen AI Max PRO 390, 385, 380
         :value: ryzen-ai-max-pro
         :width: 7

      .. selector-option:: Ryzen AI Max+ 395<br>Ryzen AI Max 390, 385
         :value: ryzen-ai-max
         :width: 5

   .. selector:: Operating system
      :key: ryzen-os

      .. selector-option:: Ubuntu
         :value: ubuntu
         :icon: fab fa-linux fa-lg

      .. selector-option:: Windows
         :value: windows
         :icon: fab fa-windows fa-lg

   .. selector:: Ubuntu version
      :key: ryzen-ubuntu-version
      :show-when: ryzen-os=ubuntu

      .. selector-option:: 24.04.3
         :value: 24.04
         :icon: fab fa-ubuntu fa-lg
         :width: 12

   .. selector:: Windows version
      :key: ryzen-windows-version
      :show-when: ryzen-os=windows

      .. selector-option:: 11 24H2
         :value: 11_24h2
         :icon: fab fa-windows fa-lg
         :width: 12

.. selector:: Installation method
   :key: install-method

   .. selector-option:: pip
      :value: wheel

   .. selector-option:: Tarball
      :value: tar

.. selected:: install-method=wheel
   :heading: Prerequisites

   .. selected:: plat=instinct

      .. selected:: instinct-os=ubuntu

         .. selected:: instinct-ubuntu-version=22.04

            .. include:: ./includes/1_ubuntu-22.04-wheel-prerequisites.md
               :parser: myst

         .. selected:: instinct-ubuntu-version=24.04

            .. include:: ./includes/1_ubuntu-24.04-wheel-prerequisites.md
               :parser: myst

      .. selected:: instinct-os=rhel

         .. selected:: instinct-rhel-version=9.6

            .. include:: ./includes/1_rhel-9.6-wheel-prerequisites.md
               :parser: myst

         .. selected:: instinct-rhel-version=10.0

            .. include:: ./includes/1_rhel-10.0-wheel-prerequisites.md
               :parser: myst

   .. selected:: plat=ryzen

      .. selected:: ryzen-os=ubuntu

         .. selected:: ryzen-ubuntu-version=24.04

            .. include:: ./includes/1_ubuntu-24.04-wheel-prerequisites.md
               :parser: myst

      .. selected:: ryzen-os=windows

         .. include:: ./includes/1_windows-wheel-prerequisites.md
            :parser: myst

.. selected:: install-method=tar
   :heading: Prerequisites

   .. selected:: plat=instinct

      .. selected:: instinct-os=ubuntu

         .. include:: ./includes/1_ubuntu-tar-prerequisites.md
            :parser: myst

      .. selected:: instinct-os=rhel

         .. selected:: instinct-rhel-version=9.6

            .. include:: ./includes/1_rhel-9.6-tar-prerequisites.md
               :parser: myst

         .. selected:: instinct-rhel-version=10.0

            .. include:: ./includes/1_rhel-10.0-tar-prerequisites.md
               :parser: myst

   .. selected:: plat=ryzen

      .. selected:: ryzen-os=ubuntu

         .. include:: ./includes/1_ubuntu-tar-prerequisites.md
            :parser: myst

      .. selected:: ryzen-os=windows

         .. include:: ./includes/1_windows-tar-prerequisites.md
            :parser: myst

.. selected:: plat=instinct
   :heading: Installing

   .. selected:: instinct-os=ubuntu
      :heading: Install AMD GPU Driver
      :heading-level: 3

      .. include:: ./includes/2_ubuntu-instinct-install-kmd.md
         :parser: myst

   .. selected:: instinct-os=rhel
      :heading: Install AMD GPU Driver
      :heading-level: 3

      .. include:: ./includes/2_rhel-instinct-install-kmd.md
         :parser: myst

.. selected:: plat=ryzen
   :heading: Installing

   .. selected:: ryzen-os=ubuntu
      :heading: Install kernel driver
      :heading-level: 3

      Supported Ryzen AI APUs require the inbox kernel driver included with
      Ubuntu 24.04.3.

.. selected:: install-method=wheel
   :heading: Install ROCm
   :heading-level: 3

   .. selected:: plat=instinct

      .. selected:: instinct-arch=gfx950

         .. selected:: instinct-os=ubuntu

            .. selected:: instinct-ubuntu-version=22.04

               .. include:: ./includes/3_wheel-gfx950-install-rocm-py311.md
                  :parser: myst

            .. selected:: instinct-ubuntu-version=24.04

               .. include:: ./includes/3_wheel-gfx950-install-rocm.md
                  :parser: myst

         .. selected:: instinct-os=rhel

            .. selected:: instinct-rhel-version=10.0

               .. include:: ./includes/3_wheel-gfx950-install-rocm.md
                  :parser: myst

            .. selected:: instinct-rhel-version=9.6

               .. include:: ./includes/3_wheel-gfx950-install-rocm-py311.md
                  :parser: myst

      .. selected:: instinct-arch=gfx942

         .. selected:: instinct-os=ubuntu

            .. selected:: instinct-ubuntu-version=22.04

               .. include:: ./includes/3_wheel-gfx942-install-rocm-py311.md
                  :parser: myst

            .. selected:: instinct-ubuntu-version=24.04

               .. include:: ./includes/3_wheel-gfx942-install-rocm.md
                  :parser: myst

         .. selected:: instinct-os=rhel

            .. selected:: instinct-rhel-version=10.0

               .. include:: ./includes/3_wheel-gfx942-install-rocm.md
                  :parser: myst

            .. selected:: instinct-rhel-version=9.6

               .. include:: ./includes/3_wheel-gfx942-install-rocm-py311.md
                  :parser: myst

   .. selected:: plat=ryzen

      .. selected:: ryzen-os=ubuntu

         .. include:: ./includes/3_wheel-gfx1151-install-rocm.md
            :parser: myst

      .. selected:: ryzen-os=windows

         .. include:: ./includes/3_windows-wheel-install-rocm.md
            :parser: myst

.. selected:: install-method=tar
   :heading: Install ROCm
   :heading-level: 3

   .. selected:: plat=instinct

      .. selected:: instinct-arch=gfx950

         .. include:: ./includes/3_tar-gfx950-install-rocm.md
            :parser: myst

      .. selected:: instinct-arch=gfx942

         .. include:: ./includes/3_tar-gfx942-install-rocm.md
            :parser: myst

   .. selected:: plat=ryzen

      .. selected:: ryzen-os=ubuntu

         .. include:: ./includes/3_tar-gfx1151-install-rocm.md
            :parser: myst

      .. selected:: ryzen-os=windows

         .. include:: ./includes/3_windows-tar-install-rocm.md
            :parser: myst

.. selected:: install-method=tar
   :heading: Post-installation

   .. selected:: plat=instinct

      .. include:: ./includes/4_linux-tar-post-install.md
         :parser: myst

   .. selected:: plat=ryzen

      .. selected:: ryzen-os=ubuntu

         .. include:: ./includes/4_linux-tar-post-install.md
            :parser: myst

      .. selected:: ryzen-os=windows

         .. include:: ./includes/4_windows-tar-post-install.md
            :parser: myst

.. selected:: install-method=wheel
   :heading: Post-installation

   .. selected:: plat=instinct

      .. selected:: instinct-os=ubuntu

         .. include:: ./includes/4_ubuntu-wheel-post-install.md
            :parser: myst

      .. selected:: instinct-os=rhel

         .. include:: ./includes/4_rhel-wheel-post-install.md
            :parser: myst

   .. selected:: plat=ryzen

      .. selected:: ryzen-os=ubuntu

         .. include:: ./includes/4_ubuntu-wheel-post-install.md
            :parser: myst

      .. selected:: ryzen-os=windows

         .. include:: ./includes/4_windows-wheel-post-install.md
            :parser: myst

.. selected:: install-method=tar
   :heading: Uninstalling

   .. selected:: plat=instinct

      .. include:: ./includes/5_tar-uninstall.md
         :parser: myst

   .. selected:: plat=ryzen

      .. selected:: ryzen-os=ubuntu

         .. include:: ./includes/5_tar-uninstall.md
            :parser: myst

      .. selected:: ryzen-os=windows

         .. include:: ./includes/5_windows-tar-uninstall.md
            :parser: myst

.. selected:: install-method=wheel
   :heading: Uninstalling

   .. selected:: plat=instinct

      .. include:: ./includes/5_wheel-linux-uninstall.md
         :parser: myst

   .. selected:: plat=ryzen

      .. selected:: ryzen-os=ubuntu

         .. include:: ./includes/5_wheel-linux-uninstall.md
            :parser: myst

      .. selected:: ryzen-os=windows

         .. include:: ./includes/5_wheel-windows-uninstall.md
            :parser: myst

.. selected:: plat=instinct
   :heading: Troubleshooting

   .. selected:: instinct-os=ubuntu

      .. selected:: instinct-os=ubuntu
         :heading-level: 3
         :heading: Additional packages for Docker installation

         .. include:: ./includes/6_ubuntu-troubleshooting.md
            :parser: myst

   .. selected:: instinct-os=rhel

      .. selected:: instinct-os=rhel
         :heading-level: 3
         :heading: Additional packages for Docker installation

         .. include:: ./includes/6_rhel-troubleshooting.md
            :parser: myst

.. selected:: plat=ryzen

   .. selected:: ryzen-os=ubuntu
      :heading: Troubleshooting

      .. selected:: ryzen-os=ubuntu
         :heading-level: 3
         :heading: Additional packages for Docker installation

      .. include:: ./includes/6_ubuntu-troubleshooting.md
         :parser: myst
