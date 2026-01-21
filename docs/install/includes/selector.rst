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
         :width: 12


.. ============================================================= RHEL VERSION ==

.. selected:: os=rhel

   .. selector:: RHEL version
      :key: os-version
      :show-when: fam=instinct fam=radeon-pro fam=radeon

      .. selector-option:: 10.1
         :show-when: gpu=mi355x gpu=mi350x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210
         :width: 2

      .. selector-option:: 10.0
         :show-when: gpu=mi355x gpu=mi350x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210
         :width: 2

      .. selector-option:: 9.7
         :show-when: gpu=mi355x gpu=mi350x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210
         :width: 2

      .. selector-option:: 9.6
         :show-when: gpu=mi355x gpu=mi350x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210
         :width: 2

      .. selector-option:: 9.4
         :show-when: gpu=mi355x gpu=mi350x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210
         :width: 2

      .. selector-option:: 8.10
         :show-when: gpu=mi355x gpu=mi350x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210
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
      :show-when: fam=instinct
      :key: os-version

      .. selector-option:: 16.0
         :width: 6

      .. selector-option:: 15.7
         :width: 6


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
      :width: 4

   .. selector-option:: pip
      :value: pip
      :width: 4

   .. selector-option:: Tarball
      :value: tar
      :width: 4

.. selector:: Installation method
   :show-when: os=rhel os=oracle-linux os=rocky-linux
   :key: i

   .. selector-option:: dnf
      :value: pkgman
      :width: 4

   .. selector-option:: pip
      :value: pip
      :width: 4

   .. selector-option:: Tarball
      :value: tar
      :width: 4

.. selector:: Installation method
   :show-when: os=sles
   :key: i

   .. selector-option:: zypper
      :value: pkgman
      :width: 4

   .. selector-option:: pip
      :value: pip
      :width: 4

   .. selector-option:: Tarball
      :value: tar
      :width: 4

.. selector:: Installation method
   :show-when: os=windows
   :key: i

   .. selector-option:: pip
      :value: pip

   .. selector-option:: Tarball
      :value: tar
