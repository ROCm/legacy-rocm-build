.. selector:: Device family
   :key: fam

   .. selector-option:: All
      :value: all
      :width: 25%

   .. selector-option:: AMD Instinct™
      :value: instinct w=compute
      :width: 25%
      :toc-label: AMD Instinct

   .. selector-option:: AMD Radeon™
      :value: radeon
      :width: 25%
      :toc-label: AMD Radeon

   .. selector-option:: AMD Ryzen™
      :value: ryzen
      :width: 25%
      :toc-label: AMD Ryzen

.. selected:: fam=radeon fam=ryzen

   .. selector:: Use case
      :key: w

      .. selector-option:: Mixed graphics and compute
         :value: graphics
         :width: 50%

      .. selector-option:: Compute
         :value: compute
         :width: 50%

.. selected:: fam=all

   .. selector:: Use case
      :key: w

      .. selector-option:: Mixed graphics and compute
         :value: graphics
         :width: 50%

      .. selector-option:: Compute
         :value: compute
         :width: 50%
