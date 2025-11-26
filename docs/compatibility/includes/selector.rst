.. selector:: AMD device family
   :key: fam

   .. selector-option:: Instinct
      :value: instinct
      :width: 3

   .. selector-option:: Radeon PRO
      :value: radeon-pro
      :width: 3

   .. selector-option:: Radeon RX
      :value: radeon
      :width: 3

   .. selector-option:: Ryzen AI
      :value: ryzen
      :width: 3

.. selector:: Instinct GPU
   :key: gfx
   :show-when: fam=instinct

   .. selector-info:: https://www.amd.com/en/products/accelerators/instinct.html

   .. selector-option:: Instinct MI355X<br>Instinct MI350X
      :value: 950
      :width: 4

   .. selector-option:: Instinct MI325X<br>Instinct MI300X<br>Instinct MI300A
      :value: 942
      :width: 4

   .. selector-option:: Instinct MI250X<br>Instinct MI250<br>Instinct MI210
      :value: 90a
      :width: 4

.. selector:: Radeon PRO GPU
   :key: gfx
   :show-when: fam=radeon-pro

   .. selector-info:: https://www.amd.com/en/products/graphics/workstations.html

   .. selector-option:: Radeon PRO W7900D<br>Radeon PRO W7900<br>Radeon PRO W7800 48GB<br>Radeon PRO W7800
      :value: 1100
      :width: 6

   .. selector-option:: Radeon PRO W7700
      :value: 1101
      :width: 6

.. selector:: Radeon RX GPU
   :key: gfx
   :show-when: fam=radeon

   .. selector-info:: https://www.amd.com/en/products/graphics/desktops/radeon.html

   .. selector-option:: Radeon RX 7900 XTX<br>Radeon RX 7900 XT<br>Radeon RX 7900 GRE
      :value: 1100

   .. selector-option:: Radeon RX 7800 XT<br>Radeon RX 7700 XT
      :value: 1101

.. selector:: Ryzen AI APU
   :key: gfx
   :show-when: fam=ryzen

   .. selector-info:: https://www.amd.com/en/products/processors/workstations/mobile.html

   .. selector-option:: Ryzen AI Max+ PRO 395<br>Ryzen AI Max PRO 390, 385, 380<br>Ryzen AI Max+ 395<br>Ryzen AI Max 390, 385
      :value: 1151
      :width: 6

   .. selector-option:: Ryzen AI 9 HX 375<br>Ryzen AI 9 HX 370<br>Ryzen AI 9 365
      :value: 1150
      :width: 6

.. selector:: Operating system
   :key: os
   :show-when: fam=instinct

   .. selector-option:: Ubuntu
      :value: ubuntu
      :icon: fab fa-ubuntu fa-lg
      :width: 4

   .. selector-option:: RHEL
      :value: rhel
      :icon: fab fa-redhat fa-lg
      :width: 4

   .. selector-option:: SLES
      :value: sles
      :icon: fab fa-suse fa-lg
      :width: 4

.. selector:: Operating system
   :key: os
   :show-when: fam=radeon-pro fam=radeon

   .. selector-option:: Ubuntu
      :value: ubuntu
      :icon: fab fa-ubuntu fa-lg
      :width: 4

   .. selector-option:: RHEL
      :value: rhel
      :icon: fab fa-redhat fa-lg
      :width: 4

   .. selector-option:: Windows
      :value: windows
      :icon: fab fa-windows fa-lg
      :width: 4

.. selector:: Operating system
   :key: os
   :show-when: fam=ryzen

   .. selector-option:: Ubuntu
      :value: ubuntu
      :icon: fab fa-ubuntu fa-lg
      :width: 6

   .. selector-option:: Windows
      :value: windows
      :icon: fab fa-windows fa-lg
      :width: 6
