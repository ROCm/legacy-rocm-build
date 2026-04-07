.. matrix::

   .. matrix-head::

      .. matrix-row::
         :header:

         .. matrix-cell:: Framework

         .. matrix-cell:: Supported versions

         .. matrix-cell:: Python versions

   .. matrix-row::

      .. matrix-cell:: PyTorch

      .. matrix-cell:: 2.11.0, 2.10.0, 2.9.1
         :show-cond: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      .. matrix-cell:: 2.11.0
         :show-cond: os=windows

      .. matrix-cell:: 3.14, 3.13, 3.12, 3.11

   .. matrix-row::
      :show-cond: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      .. matrix-cell:: JAX

      .. matrix-cell:: 0.9.1, 0.8.2

      .. matrix-cell:: 3.14, 3.13, 3.12, 3.11

   .. matrix-row::
      :show-cond: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      .. matrix-cell:: vLLM
         :show-cond: gfx=gfx950 gfx=gfx942 gfx=gfx1201 gfx=gfx1200 gfx=gfx1151

      .. matrix-cell:: 0.19.0
         :show-cond: gfx=gfx950 gfx=gfx942 gfx=gfx1201 gfx=gfx1200 gfx=gfx1151

      .. matrix-cell:: 3.13 (requires PyTorch 2.10.0)
         :show-cond: gfx=gfx950 gfx=gfx942 gfx=gfx1201 gfx=gfx1200 gfx=gfx1151
