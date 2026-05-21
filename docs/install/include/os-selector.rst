.. selected:: w=compute

   .. selected:: fam=instinct

      .. selector:: Linux distribution
         :key: os
         :show-cond: gpu=mi355x gpu=mi350x gpu=mi325x

         .. selector-option:: Ubuntu
            :value: ubuntu
            :width: 20%

         .. selector-option:: Debian
            :value: debian
            :width: 20%

         .. selector-option:: RHEL
            :value: rhel
            :width: 20%
            :toc-label: Red Hat Enterprise Linux

         .. selector-option:: Oracle Linux
            :value: oracle-linux
            :width: 20%

         .. selector-option:: SLES
            :value: sles
            :width: 20%
            :toc-label: SUSE Linux Enterprise Server

      .. selector:: Linux distribution
         :key: os
         :show-cond: gpu=mi350p

         .. selector-option:: Ubuntu
            :value: ubuntu
            :width: 50%

         .. selector-option:: RHEL
            :value: rhel
            :width: 50%
            :toc-label: Red Hat Enterprise Linux

      .. selector:: Linux distribution
         :key: os
         :show-cond: gpu=mi300x

         .. selector-option:: Ubuntu
            :value: ubuntu
            :width: 4

         .. selector-option:: Debian
            :value: debian
            :width: 4

         .. selector-option:: RHEL
            :value: rhel
            :width: 4
            :toc-label: Red Hat Enterprise Linux

         .. selector-option:: Oracle Linux
            :value: oracle-linux
            :width: 4

         .. selector-option:: Rocky Linux
            :value: rocky-linux
            :width: 4

         .. selector-option:: SLES
            :value: sles
            :width: 4
            :toc-label: SUSE Linux Enterprise Server

      .. selector:: Linux distribution
         :key: os
         :show-cond: gpu=mi300a

         .. selector-option:: Ubuntu
            :value: ubuntu
            :width: 20%

         .. selector-option:: Debian
            :value: debian
            :width: 20%

         .. selector-option:: RHEL
            :value: rhel
            :width: 20%
            :toc-label: Red Hat Enterprise Linux

         .. selector-option:: Rocky Linux
            :value: rocky-linux
            :width: 20%

         .. selector-option:: SLES
            :value: sles
            :width: 20%
            :toc-label: SUSE Linux Enterprise Server

      .. selector:: Linux distribution
         :key: os
         :show-cond: gpu=mi250x gpu=mi250

         .. selector-option:: Ubuntu
            :value: ubuntu
            :width: 25%

         .. selector-option:: Debian
            :value: debian
            :width: 25%

         .. selector-option:: RHEL
            :value: rhel
            :width: 25%
            :toc-label: Red Hat Enterprise Linux

         .. selector-option:: SLES
            :value: sles
            :width: 25%
            :toc-label: SUSE Linux Enterprise Server

      .. selector:: Linux distribution
         :key: os
         :show-cond: gpu=mi210

         .. selector-option:: Ubuntu
            :value: ubuntu
            :width: 4

         .. selector-option:: RHEL
            :value: rhel
            :width: 4
            :toc-label: Red Hat Enterprise Linux

         .. selector-option:: SLES
            :value: sles
            :width: 4
            :toc-label: SUSE Linux Enterprise Server

      .. selector:: Linux distribution
         :key: os
         :show-cond: gpu=mi100

         .. selector-option:: Ubuntu
            :value: ubuntu
            :width: 4

         .. selector-option:: RHEL
            :value: rhel
            :width: 4
            :toc-label: Red Hat Enterprise Linux

         .. selector-option:: SLES
            :value: sles
            :width: 4
            :toc-label: SUSE Linux Enterprise Server

   .. selected:: fam=radeon

      .. selector:: Operating system
         :key: os
         :show-cond: gfx=gfx1201 gfx=gfx1200 gfx=gfx1100 gfx=gfx1102

         .. selector-option:: Ubuntu
            :value: ubuntu
            :width: 3

         .. selector-option:: RHEL
            :value: rhel
            :width: 3
            :toc-label: Red Hat Enterprise Linux

         .. selector-option:: Windows
            :value: windows
            :width: 3

         .. selector-option:: WSL
            :value: wsl i=pkgman
            :width: 3

      .. selected:: gfx=gfx1101

         .. selector:: Operating system
            :key: os
            :show-cond: gpu=v710

            .. selector-option:: Ubuntu
               :value: ubuntu
               :width: 50%

            .. selector-option:: RHEL
               :value: rhel
               :width: 50%
               :toc-label: Red Hat Enterprise Linux

         .. selector:: Operating system
            :key: os
            :show-cond: gpu=w7700 gpu=rx-7800-xt gpu=rx-7700-xt gpu=rx-7700-xe gpu=rx-7700

            .. selector-option:: Ubuntu
               :value: ubuntu
               :width: 3

            .. selector-option:: RHEL
               :value: rhel
               :width: 3
               :toc-label: Red Hat Enterprise Linux

            .. selector-option:: Windows
               :value: windows
               :width: 3

            .. selector-option:: WSL
               :value: wsl i=pkgman
               :width: 3

      .. selector:: Operating system
         :key: os
         :show-cond: gfx=gfx1030

         .. selector-option:: Ubuntu
            :value: ubuntu
            :width: 50%

         .. selector-option:: RHEL
            :value: rhel
            :width: 50%
            :toc-label: Red Hat Enterprise Linux

   .. selector:: Operating system
      :key: os
      :show-cond: fam=ryzen

      .. selector-option:: Ubuntu
         :value: ubuntu
         :width: 4

      .. selector-option:: Windows
         :value: windows
         :width: 4

      .. selector-option:: WSL
         :value: wsl i=pkgman
         :width: 4

   .. selected:: fam=all

      .. selector:: Operating system
         :key: os

         .. selector-option:: Ubuntu
            :value: ubuntu
            :width: 3

         .. selector-option:: Debian
            :value: debian
            :width: 3

         .. selector-option:: RHEL
            :value: rhel
            :width: 3
            :toc-label: Red Hat Enterprise Linux

         .. selector-option:: Oracle Linux
            :value: oracle-linux
            :width: 3

         .. selector-option:: Rocky Linux
            :value: rocky-linux
            :width: 4

         .. selector-option:: SLES
            :value: sles
            :width: 4
            :toc-label: SUSE Linux Enterprise Server

         .. selector-option:: Windows
            :value: windows
            :width: 4

.. selected:: w=graphics

   .. selector:: Operating system
      :key: os
      :show-cond: fam=radeon

      .. selector-option:: Ubuntu
         :value: ubuntu
         :width: 4

      .. selector-option:: RHEL
         :value: rhel
         :width: 4
         :toc-label: Red Hat Enterprise Linux

      .. selector-option:: Windows
         :value: windows
         :width: 4

   .. selector:: Operating system
      :key: os
      :show-cond: fam=ryzen

      .. selector-option:: Ubuntu
         :value: ubuntu
         :width: 6

      .. selector-option:: Windows
         :value: windows
         :width: 6
