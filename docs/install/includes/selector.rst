.. include:: /compatibility/includes/selector.rst

.. selected:: fam=instinct fam=radeon-pro fam=radeon

   .. selector:: Ubuntu version
      :key: os-version
      :show-when: os=ubuntu

      .. selector-option:: 24.04.3
         :value: 24

      .. selector-option:: 22.04.5
         :value: 22

.. selected:: fam=ryzen

   .. selector:: Ubuntu version
      :key: os-version
      :show-when: os=ubuntu

      .. selector-option:: 24.04.3
         :value: 24
         :width: 12

.. selector:: RHEL version
   :key: os-version
   :show-when: os=rhel

   .. selector-option:: 10.1
      :value: 10.1
      :width: 3

   .. selector-option:: 10.0
      :value: 10.0
      :width: 3

   .. selector-option:: 9.7
      :value: 9.7
      :width: 2

   .. selector-option:: 9.6
      :value: 9.6
      :width: 2

   .. selector-option:: 8.10
      :value: 8
      :width: 2

.. selector:: SLES version
   :key: os-version
   :show-when: os=sles

   .. selector-option:: 15.7
      :value: 15
      :width: 12

.. selector:: Windows version
   :key: os-version
   :show-when: os=windows

   .. selector-option:: 11 25H2
      :value: 11-25h2
      :width: 12

.. selector:: Installation method
   :key: i

   .. selector-option:: pip
      :value: pip

   .. selector-option:: Tarball
      :value: tar

