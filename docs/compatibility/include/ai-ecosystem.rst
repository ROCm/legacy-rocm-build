.. matrix::

   .. matrix-head::

      .. matrix-row::
         :header:

         .. matrix-cell:: Framework

         .. matrix-cell:: Supported versions

         .. matrix-cell:: Python versions

   .. matrix-row::
      :show-cond: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      .. matrix-cell:: PyTorch

      .. matrix-cell:: 2.12.0, 2.11.0, 2.10.0
         :show-cond: gfx=gfx950 gfx=gfx942 gfx=gfx90a gfx=gfx908

      .. matrix-cell:: 2.12.0, 2.11.0
         :show-cond: fam=radeon fam=ryzen

      .. matrix-cell:: 3.14, 3.13, 3.12, 3.11

   .. matrix-row::
      :show-cond: os=windows os=wsl

      .. matrix-cell:: PyTorch

      .. matrix-cell:: 2.12.0
         :show-cond: os=windows os=wsl

      .. matrix-cell:: 3.14, 3.13, 3.12, 3.11

   .. matrix-row::
      :show-cond: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      .. matrix-cell:: JAX
         :show-cond: gfx=gfx950 gfx=gfx942 gfx=gfx1200 gfx=gfx1201 gfx=gfx1100 gfx=gfx1102 gfx=gfx1103

      .. matrix-cell:: 0.10.0, 0.9.1
         :show-cond: gfx=gfx950 gfx=gfx942 gfx=gfx1200 gfx=gfx1201 gfx=gfx1100 gfx=gfx1102 gfx=gfx1103

      .. matrix-cell:: 3.14, 3.13, 3.12, 3.11
         :show-cond: gfx=gfx950 gfx=gfx942 gfx=gfx1200 gfx=gfx1201 gfx=gfx1100 gfx=gfx1102 gfx=gfx1103

   .. matrix-row::
      :show-cond: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      .. matrix-cell:: vLLM
         :show-cond: gfx=gfx950 gfx=gfx942 gfx=gfx1201 gfx=gfx1200 gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1152 gfx=gfx1151 gfx=gfx1150

      .. matrix-cell:: 0.23
         :show-cond: gfx=gfx950 gfx=gfx942 gfx=gfx1201 gfx=gfx1200 gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1152 gfx=gfx1151 gfx=gfx1150

      .. matrix-cell:: 3.14 (requires PyTorch 2.11.0)
         :show-cond: gfx=gfx950 gfx=gfx942 gfx=gfx1201 gfx=gfx1200 gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1152 gfx=gfx1151 gfx=gfx1150

   .. matrix-row::
      :show-cond: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      .. matrix-cell:: SGLang
         :show-cond: gfx=gfx950 gfx=gfx942 gfx=gfx1201 gfx=gfx1200 gfx=gfx1100 gfx=gfx1101 gfx=gfx1102

      .. matrix-cell:: 0.5.13
         :show-cond: gfx=gfx950 gfx=gfx942 gfx=gfx1201 gfx=gfx1200 gfx=gfx1100 gfx=gfx1101 gfx=gfx1102

      .. matrix-cell:: 3.14 (requires PyTorch 2.11.0)
         :show-cond: gfx=gfx950 gfx=gfx942 gfx=gfx1201 gfx=gfx1200 gfx=gfx1100 gfx=gfx1101 gfx=gfx1102

   .. matrix-row::
      :show-cond: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      .. matrix-cell:: MIGraphX
         :show-cond: gfx=gfx950 gfx=gfx942

      .. matrix-cell:: 2.16
         :show-cond: gfx=gfx950 gfx=gfx942

      .. matrix-cell:: 3.12
         :show-cond: gfx=gfx950 gfx=gfx942

   .. matrix-row::
      :show-cond: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      .. matrix-cell:: ONNX Runtime
         :show-cond: gfx=gfx950 gfx=gfx942

      .. matrix-cell:: 1.23.2
         :show-cond: gfx=gfx950 gfx=gfx942

      .. matrix-cell:: 3.12
         :show-cond: gfx=gfx950 gfx=gfx942
