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
      :width: 6

   .. selector-option:: 10.0
      :value: 10.0
      :width: 6

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

