.. selected:: os=ubuntu

   .. selected:: fam=instinct

      .. selector:: Ubuntu version
         :key: ubuntu-ver
         :show-cond: gpu=mi355x gpu=mi350x gpu=mi325x gpu=mi300x gpu=mi300a gpu=mi250x gpu=mi250 gpu=mi210 gpu=mi100

         .. selector-option:: 26.04
            :value: 26.04
            :width: 4

         .. selector-option:: 24.04.4
            :show-cond: fam=instinct fam=radeon fam=all
            :value: 24.04
            :width: 4

         .. selector-option:: 22.04.5
            :show-cond: fam=instinct fam=radeon fam=all
            :value: 22.04
            :width: 4

      .. selector:: Ubuntu version
         :key: ubuntu-ver
         :show-cond: gpu=mi350p

         .. selector-option:: 26.04
            :value: 26.04
            :width: 6

         .. selector-option:: 24.04.4
            :show-cond: fam=instinct fam=radeon fam=all
            :value: 24.04
            :width: 6

   .. selected:: fam=radeon fam=all

      .. selector:: Ubuntu version
         :key: ubuntu-ver

         .. selector-option:: 26.04
            :value: 26.04
            :width: 4

         .. selector-option:: 24.04.4
            :show-cond: fam=instinct fam=radeon fam=all
            :value: 24.04
            :width: 4

         .. selector-option:: 22.04.5
            :show-cond: fam=instinct fam=radeon fam=all
            :value: 22.04
            :width: 4

   .. selected:: fam=ryzen

      .. selector:: Ubuntu version
         :key: ubuntu-ver

         .. selector-option:: 26.04
            :value: 26.04
            :width: 50%

         .. selector-option:: 24.04.4
            :value: 24.04
            :width: 50%

.. selected:: os=wsl

   .. selector:: WSL Linux distro
      :key: ubuntu-ver

      .. selector-option:: Ubuntu 26.04
         :show-cond: fam=radeon
         :value: 26.04
         :width: 4

      .. selector-option:: Ubuntu 24.04
         :show-cond: fam=radeon
         :value: 24.04
         :width: 4

      .. selector-option:: Ubuntu 22.04
         :show-cond: fam=radeon
         :value: 22.04
         :width: 4

      .. selector-option:: Ubuntu 26.04
         :show-cond: fam=ryzen
         :value: 26.04
         :width: 6

      .. selector-option:: Ubuntu 24.04
         :show-cond: fam=ryzen
         :value: 24.04
         :width: 6
