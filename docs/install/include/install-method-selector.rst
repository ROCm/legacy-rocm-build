.. selected:: w=compute

   .. selected:: fam=all

      .. selector:: Installation method
         :show-cond: os=ubuntu os=debian
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
         :show-cond: os=rhel os=oracle-linux os=rocky-linux
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
         :show-cond: os=sles
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

   .. selected:: fam=instinct fam=radeon fam=ryzen

      .. selector:: Installation method
         :show-cond: os=ubuntu os=debian
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
         :show-cond: os=rhel os=oracle-linux os=rocky-linux
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
         :show-cond: os=sles
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
   :show-cond: os=windows
   :key: i

   .. selector-option:: pip
      :value: pip
      :width: 6

   .. selector-option:: Tarball
      :value: tar
      :width: 6
