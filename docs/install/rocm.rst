.. meta::
   :description: Learn how to install AMD ROCm 7.12.0 for supported Instinct GPUs and Ryzen AI APUs on Ubuntu, RHEL, and Windows. This step-by-step guide covers prerequisites, driver setup, installation methods (pip and tarball), and troubleshooting.
   :keywords: AMD ROCm 7.12.0, install ROCm, Instinct GPU, Ryzen APU, Ubuntu, RHEL, Windows, pip install ROCm, ROCm wheel, ROCm tarball, ROCm GPU driver, ROCm setup, ROCm uninstall, ROCm troubleshooting

*******************************
Install AMD ROCm |ROCM_VERSION|
*******************************

.. _rocm-install-selector:

Use the following selector to choose your installation method for your
supported AMD GPU or APU and operating system. For system requirements and
support information, see the :doc:`Compatibility matrix
</compatibility/compatibility-matrix>`. To learn more about changes introduced
in ROCm |ROCM_VERSION|, see the :doc:`Release notes </about/release-notes>`.

.. note::

   If your GPU is not listed, it might be community-enabled through TheRock
   nightly builds. This enablement is not part of the official ROCm release. For
   more information, see `TheRock supported GPUs
   <https://github.com/ROCm/TheRock/blob/main/SUPPORTED_GPUS.md>`__. For
   installation guidance, see `TheRock releases
   <https://github.com/ROCm/TheRock/blob/main/RELEASES.md>`__.

.. include:: /compatibility/includes/selector.rst

.. =========================================================== UBUNTU VERSION ==

.. selected:: os=ubuntu

   .. selector:: Ubuntu version
      :key: os-version

      .. selector-option:: 24.04.3
         :show-when: fam=instinct fam=radeon-pro fam=radeon
         :value: 24.04
         :width: 6

      .. selector-option:: 22.04.5
         :show-when: fam=instinct fam=radeon-pro fam=radeon
         :value: 22.04
         :width: 6

      .. selector-option:: 24.04.3
         :show-when: fam=ryzen
         :value: 24.04
         :width: 12


.. =========================================================== DEBIAN VERSION ==

.. selected:: os=debian

   .. selector:: Debian version
      :show-when: gpu=mi355x gpu=mi325x gpu=mi350x gpu=mi300x
      :key: os-version

      .. selector-option:: 13
         :width: 6

      .. selector-option:: 12
         :width: 6

   .. selector:: Debian version
      :show-when: gpu=mi300a gpu=mi250x gpu=mi250
      :key: os-version

      .. selector-option:: 12
         :width: 12


.. ============================================================= RHEL VERSION ==

.. selected:: os=rhel

   .. selector:: RHEL version
      :key: os-version
      :show-when: fam=instinct fam=radeon-pro fam=radeon

      .. selector-option:: 10.1
         :show-when: gpu=mi355x gpu=mi350x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210 gpu=mi100
         :width: 2

      .. selector-option:: 10.0
         :show-when: gpu=mi355x gpu=mi350x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210 gpu=mi100
         :width: 2

      .. selector-option:: 9.7
         :show-when: gpu=mi355x gpu=mi350x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210 gpu=mi100
         :width: 2

      .. selector-option:: 9.6
         :show-when: gpu=mi355x gpu=mi350x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210 gpu=mi100
         :width: 2

      .. selector-option:: 9.4
         :show-when: gpu=mi355x gpu=mi350x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210 gpu=mi100
         :width: 2

      .. selector-option:: 8.10
         :show-when: gpu=mi355x gpu=mi350x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210 gpu=mi100
         :width: 2

      .. selector-option:: 10.1
         :show-when: gpu=mi325x
         :width: 20%

      .. selector-option:: 10.0
         :show-when: gpu=mi325x
         :width: 20%

      .. selector-option:: 9.7
         :show-when: gpu=mi325x
         :width: 20%

      .. selector-option:: 9.6
         :show-when: gpu=mi325x
         :width: 20%

      .. selector-option:: 9.4
         :show-when: gpu=mi325x
         :width: 20%

      .. selector-option:: 10.1
         :show-when: fam=radeon-pro fam=radeon
         :width: 6

      .. selector-option:: 9.7
         :show-when: fam=radeon-pro fam=radeon
         :width: 6


.. ===================================================== ORACLE LINUX VERSION ==

.. selected:: os=oracle-linux

   .. selector:: Oracle Linux version
      :show-when: gpu=mi355x gpu=mi350x gpu=mi325x gpu=mi300x
      :key: os-version

      .. selector-option:: 10
         :show-when: gpu=mi355x gpu=mi350x gpu=mi325x
         :width: 6
         :value: 10.1

      .. selector-option:: 9
         :show-when: gpu=mi355x gpu=mi350x gpu=mi325x
         :width: 6
         :value: 9.6

      .. selector-option:: 10
         :show-when: gpu=mi300x
         :width: 4
         :value: 10.1

      .. selector-option:: 9
         :show-when: gpu=mi300x
         :width: 4
         :value: 9.6

      .. selector-option:: 8
         :show-when: gpu=mi300x
         :width: 4
         :value: 8.10


.. ====================================================== ROCKY LINUX VERSION ==

.. selected:: os=rocky-linux

   .. selector:: Rocky Linux version
      :show-when: gpu=mi300x gpu=mi300a
      :key: os-version

      .. selector-option:: 9
         :width: 12
         :value: 9.7


.. ============================================================= SLES VERSION ==

.. selected:: os=sles

   .. selector:: SLES version
      :show-when: gpu=mi355x gpu=mi350x gpu=mi325x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210
      :key: os-version

      .. selector-option:: 16.0
         :width: 6

      .. selector-option:: 15.7
         :width: 6

   .. selector:: SLES version
      :show-when: gpu=mi100
      :key: os-version

      .. selector-option:: 15.7
         :width: 12


.. ========================================================== WINDOWS VERSION ==

.. selected:: os=windows

   .. selector:: Windows version
      :key: os-version

      .. selector-option:: 11 25H2
         :width: 12

.. ====================================================== INSTALLATION METHOD ==

.. selector:: Installation method
   :show-when: os=ubuntu os=debian
   :key: i

   .. selector-option:: apt
      :value: pkgman
      :width: 3

   .. selector-option:: pip
      :value: pip
      :width: 3

   .. selector-option:: Tarball
      :value: tar
      :width: 3

   .. selector-option:: Runfile
      :value: runfile
      :width: 3

.. selector:: Installation method
   :show-when: os=rhel os=oracle-linux os=rocky-linux
   :key: i

   .. selector-option:: dnf
      :value: pkgman
      :width: 3

   .. selector-option:: pip
      :value: pip
      :width: 3

   .. selector-option:: Tarball
      :value: tar
      :width: 3

   .. selector-option:: Runfile
      :value: runfile
      :width: 3

.. selector:: Installation method
   :show-when: os=sles
   :key: i

   .. selector-option:: zypper
      :value: pkgman
      :width: 3

   .. selector-option:: pip
      :value: pip
      :width: 3

   .. selector-option:: Tarball
      :value: tar
      :width: 3

   .. selector-option:: Runfile
      :value: runfile
      :width: 3

.. selector:: Installation method
   :show-when: os=windows
   :key: i

   .. selector-option:: pip
      :value: pip
      :width: 6

   .. selector-option:: Tarball
      :value: tar
      :width: 6

----

.. selected:: i=runfile

   The ROCm Runfile Installer can install ROCm and/or the AMD GPU Driver (amdgpu)
   without using a native Linux package management system, making it ideal for
   systems with policy constraints or restricted environments. Network access is
   not needed for install as long as dependencies for ROCm and/or AMD GPU driver
   (amdgpu) are met. A single installer supports all GFX architectures, automates
   post-installation configuration, and offers an interactive command-line GUI for
   guided setup.

.. _rocm-prerequisites:

.. include:: ./includes/prerequisites.rst

----

.. include:: ./includes/runfile-quick-start-config-options.rst

----

.. _rocm-install:

.. include:: ./includes/install.rst

----

.. _rocm-post-install:

.. include:: ./includes/post-install.rst

----

.. _rocm-uninstall:

.. include:: ./includes/uninstall.rst

|
|
|
|
|
|
|
|
|

.. raw:: html

   <script>
     document.addEventListener("DOMContentLoaded", () => {
       const nextLink = document.querySelector("footer.prev-next-footer a.right-next");
       const nextTitle = nextLink.querySelector(".prev-next-title");
       nextTitle.textContent = "Build the ROCm Core SDK from source";
       nextLink.href = "./build-from-source.html";
     });
   </script>
