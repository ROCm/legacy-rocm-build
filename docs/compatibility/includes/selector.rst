.. =========================================================== GPU/APU FAMILY ==

.. selector:: AMD device family
   :key: fam

   .. selector-option:: Instinct
      :value: instinct
      :width: 3

   .. selector-option:: Radeon PRO
      :value: radeon-pro
      :width: 3

   .. selector-option:: Radeon
      :value: radeon
      :width: 3

   .. selector-option:: Ryzen AI
      :value: ryzen
      :width: 3


.. ================================================================ GPU / APU ==

.. selector:: Instinct GPU
   :key: gpu
   :show-when: fam=instinct

   .. selector-info:: https://www.amd.com/en/products/accelerators/instinct.html

   .. selector-option:: MI355X
      :width: 3

   .. selector-option:: MI350X
      :width: 3

   .. selector-option:: MI325X
      :width: 3

   .. selector-option:: MI300X
      :width: 3

   .. selector-option:: MI300A
      :width: 20%

   .. selector-option:: MI250X
      :width: 20%

   .. selector-option:: MI250
      :width: 20%

   .. selector-option:: MI210
      :width: 20%

   .. selector-option:: MI100
      :width: 20%

.. selector:: Radeon PRO GPU
   :key: gpu
   :show-when: fam=radeon-pro

   .. selector-info:: https://www.amd.com/en/products/graphics/workstations.html

   .. selector-option:: AI PRO R9700
      :value: ai-r9700
      :width: 3

   .. selector-option:: AI PRO R9600D
      :value: ai-r9600d
      :width: 3

   .. selector-option:: W7900 Dual Slot
      :value: w7900-dual-slot
      :width: 3

   .. selector-option:: W7900
      :value: w7900
      :width: 3

   .. selector-option:: W7800 48GB
      :value: w7800-48gb
      :width: 3

   .. selector-option:: W7800
      :value: w7800
      :width: 3

   .. selector-option:: W7700
      :value: w7700
      :width: 3

   .. selector-option:: V710
      :value: v710
      :width: 3

.. selector:: Radeon GPU
   :key: gpu
   :show-when: fam=radeon

   .. selector-info:: https://www.amd.com/en/products/graphics/desktops/radeon.html

   .. selector-option:: RX 9070 XT
      :value: rx-9070-xt
      :width: 3

   .. selector-option:: RX 9070 GRE
      :value: rx-9070-gre
      :width: 3

   .. selector-option:: RX 9070
      :value: rx-9070
      :width: 3

   .. selector-option:: RX 9060 XT LP
      :value: rx-9060-xt-lp
      :width: 3

   .. selector-option:: RX 9060 XT
      :value: rx-9060-xt
      :width: 3

   .. selector-option:: RX 9060
      :value: rx-9060
      :width: 3

   .. selector-option:: RX 7900 XTX
      :value: rx-7900-xtx
      :width: 3

   .. selector-option:: RX 7900 XT
      :value: rx-7900-xt
      :width: 3

   .. selector-option:: RX 7900 GRE
      :value: rx-7900-gre
      :width: 3

   .. selector-option:: RX 7800 XT
      :value: rx-7800-xt
      :width: 3

   .. selector-option:: RX 7700 XT
      :value: rx-7700-xt
      :width: 3

   .. selector-option:: RX 7700 XE
      :value: rx-7700-xe
      :width: 3

   .. selector-option:: RX 7700
      :value: rx-7700
      :width: 3

   .. selector-option:: RX 7600
      :value: rx-7600
      :width: 3

.. selector:: Ryzen AI APU
   :key: gpu
   :show-when: fam=ryzen

   .. selector-info:: https://www.amd.com/en/products/processors/workstations/mobile.html

   .. selector-option:: Max+ PRO 395
      :value: max-pro-395
      :width: 3

   .. selector-option:: Max PRO 390
      :value: max-pro-390
      :width: 3

   .. selector-option:: Max PRO 385
      :value: max-pro-385
      :width: 3

   .. selector-option:: Max PRO 380
      :value: max-pro-380
      :width: 3

   .. selector-option:: Max+ 395
      :value: max-395
      :width: 20%

   .. selector-option:: Max 390
      :value: max-390
      :width: 20%

   .. selector-option:: Max 385
      :value: max-385
      :width: 20%

   .. selector-option:: 9 HX 375
      :value: 9-hx-375
      :width: 20%

   .. selector-option:: 9 HX 370
      :value: 9-hx-370
      :width: 20%

   .. selector-option:: 9 365
      :value: 9-365
      :width: 20%

   .. selector-option:: 9 270
      :value: 9-365
      :width: 20%

   .. selector-option:: 7 450
      :value: 7-450
      :width: 20%

   .. selector-option:: 7 260
      :value: 7-260
      :width: 20%

   .. selector-option:: 7 250
      :value: 7-250
      :width: 20%

   .. selector-option:: 5 240
      :value: 5-240
      :width: 3

   .. selector-option:: 5 230
      :value: 5-230
      :width: 3

   .. selector-option:: 5 220
      :value: 5-220
      :width: 3

   .. selector-option:: 3 210
      :value: 3-210
      :width: 3

.. ========================================================= OPERATING SYSTEM ==

.. selected:: fam=instinct

   .. selector:: Linux distribution
      :key: os
      :show-when: gpu=mi355x gpu=mi350x gpu=mi325x

      .. selector-option:: Ubuntu
         :value: ubuntu
         :width: 20%

      .. selector-option:: Debian
         :value: debian
         :width: 20%
         :show-when: gpu=mi355x gpu=mi350x gpu=mi325x

      .. selector-option:: RHEL
         :value: rhel
         :width: 20%

      .. selector-option:: Oracle Linux
         :value: oracle-linux
         :width: 20%

      .. selector-option:: SLES
         :value: sles
         :width: 20%

   .. selector:: Linux distribution
      :key: os
      :show-when: gpu=mi300x

      .. selector-option:: Ubuntu
         :value: ubuntu
         :width: 4

      .. selector-option:: Debian
         :value: debian
         :width: 4

      .. selector-option:: RHEL
         :value: rhel
         :width: 4

      .. selector-option:: Oracle Linux
         :value: oracle-linux
         :width: 4

      .. selector-option:: Rocky Linux
         :value: rocky-linux
         :width: 4

      .. selector-option:: SLES
         :value: sles
         :width: 4

   .. selector:: Linux distribution
      :key: os
      :show-when: gpu=mi300a

      .. selector-option:: Ubuntu
         :value: ubuntu
         :width: 3

      .. selector-option:: RHEL
         :value: rhel
         :width: 3

      .. selector-option:: Rocky Linux
         :value: rocky-linux
         :width: 3

      .. selector-option:: SLES
         :value: sles
         :width: 3

   .. selector:: Linux distribution
      :key: os
      :show-when: gpu=mi250x gpu=mi250 gpu=mi210

      .. selector-option:: Ubuntu
         :value: ubuntu
         :width: 4

      .. selector-option:: RHEL
         :value: rhel
         :width: 4

      .. selector-option:: SLES
         :value: sles
         :width: 4

.. selected:: fam=radeon-pro

   .. selector:: Operating system
      :key: os
      :show-when: gpu=ai-r9700 gpu=w7900-dual-slot gpu=w7900 gpu=w7800-48gb gpu=w7800 gpu=w7700 gpu=w6800

      .. selector-option:: Ubuntu
         :value: ubuntu
         :width: 4

      .. selector-option:: RHEL
         :value: rhel
         :width: 4

      .. selector-option:: Windows
         :value: windows
         :width: 4

   .. selector:: Linux distribution
      :key: os
      :show-when: gpu=v710 gpu=ai-r9600d

      .. selector-option:: Ubuntu
         :value: ubuntu
         :width: 6

      .. selector-option:: RHEL
         :value: rhel
         :width: 6

.. selected:: fam=radeon

   .. selector:: Linux distribution
      :key: os
      :show-when: gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060

      .. selector-option:: Ubuntu
         :value: ubuntu
         :width: 6

      .. selector-option:: RHEL
         :value: rhel
         :width: 6

   .. selector:: Operating system
      :key: os
      :show-when: gpu=rx-7900-xtx gpu=rx-7900-xt gpu=rx-7900-gre gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700

      .. selector-option:: Ubuntu
         :value: ubuntu
         :width: 4

      .. selector-option:: RHEL
         :value: rhel
         :width: 4

      .. selector-option:: Windows
         :value: windows
         :width: 4

.. selector:: Operating system
   :key: os
   :show-when: fam=ryzen

   .. selector-option:: Ubuntu
      :value: ubuntu
      :width: 6

   .. selector-option:: Windows
      :value: windows
      :width: 6
