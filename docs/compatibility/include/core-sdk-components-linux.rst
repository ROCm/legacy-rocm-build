.. matrix::
   :show-cond: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

   .. matrix-head::

      .. matrix-row::
         :header:

         .. matrix-cell:: Component group

         .. matrix-cell:: Component name

   .. matrix-row::

      .. matrix-cell:: Math and compute libraries
         :rowspan: 18

      .. matrix-cell::

         `Composable Kernel 1.2.0 <https://rocm.docs.amd.com/projects/composable_kernel/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `hipBLAS 3.5.0 <https://rocm.docs.amd.com/projects/hipBLAS/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `hipBLASLt 1.4.1 <https://rocm.docs.amd.com/projects/hipBLASLt/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `hipCUB 4.5.0 <https://rocm.docs.amd.com/projects/hipCUB/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `hipFFT 1.0.24 <https://rocm.docs.amd.com/projects/hipFFT/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `hipRAND 3.4.0 <https://rocm.docs.amd.com/projects/hipRAND/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `hipSOLVER 3.5.0 <https://rocm.docs.amd.com/projects/hipSOLVER/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `hipSPARSE 4.6.0 <https://rocm.docs.amd.com/projects/hipSPARSE/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `hipSPARSELt 0.2.9 <https://rocm.docs.amd.com/projects/hipSPARSELt/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `MIOpen 3.5.2 <https://rocm.docs.amd.com/projects/MIOpen/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `rocBLAS 5.5.0 <https://rocm.docs.amd.com/projects/rocBLAS/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `rocFFT 1.0.38 <https://rocm.docs.amd.com/projects/rocFFT/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `rocPRIM 4.5.0 <https://rocm.docs.amd.com/projects/rocPRIM/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `rocRAND 4.5.0 <https://rocm.docs.amd.com/projects/rocRAND/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `rocSOLVER 3.35.0 <https://rocm.docs.amd.com/projects/rocSOLVER/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `rocSPARSE 4.7.0 <https://rocm.docs.amd.com/projects/rocSPARSE/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `rocThrust 4.5.0 <https://rocm.docs.amd.com/projects/rocThrust/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell::

         `rocWMMA 2.2.1 <https://rocm.docs.amd.com/projects/rocWMMA/en/docs-7.14/index.html>`__

   .. matrix-row::

      .. matrix-cell:: Communication libraries
         :rowspan: 2
         :show-cond: fam=instinct fam=radeon

      .. matrix-cell:: Communication libraries
         :rowspan: 1
         :show-cond: fam=ryzen

      .. matrix-cell::

         `RCCL 2.30.4 <https://github.com/ROCm/rocm-systems/tree/therock-7.14/projects/rccl>`__

   .. matrix-row::
      :show-cond: fam=instinct fam=radeon

      .. matrix-cell::

         `rocSHMEM 3.5.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.14/projects/rocshmem>`__

   .. matrix-row::

      .. matrix-cell:: Media libraries
         :rowspan: 2

      .. matrix-cell::

         `rocDecode 1.8.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.14/projects/rocdecode>`__

   .. matrix-row::

      .. matrix-cell::

         `rocJPEG 1.6.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.14/projects/rocjpeg>`__

   .. matrix-row::

      .. matrix-cell:: Runtimes and compilers
         :rowspan: 5
         :show-cond: fam=instinct fam=radeon

      .. matrix-cell:: Runtimes and compilers
         :rowspan: 4
         :show-cond: fam=ryzen

      .. matrix-cell::

         `HIP 7.14 <https://github.com/ROCm/rocm-systems/tree/therock-7.14/projects/hip>`__

   .. matrix-row::

      .. matrix-cell::

         `HIPIFY 7.14 <https://github.com/ROCm/HIPIFY/tree/therock-7.14>`__

   .. matrix-row::

      .. matrix-cell::

         `LLVM 23.0.0 <https://github.com/ROCm/llvm-project/tree/therock-7.14>`__

   .. matrix-row::
      :show-cond: fam=instinct fam=radeon

      .. matrix-cell::

         `ROCr Runtime 1.21.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.14/projects/rocr-runtime>`__

   .. matrix-row::

      .. matrix-cell::

         `SPIRV-LLVM-Translator 23.0.0 <https://github.com/ROCm/SPIRV-LLVM-Translator/tree/therock-7.14>`__

   .. matrix-row::

      .. matrix-cell:: Profiling and debugging tools
         :rowspan: 6
         :show-cond: fam=instinct

      .. matrix-cell:: Profiling and debugging tools
         :rowspan: 4
         :show-cond: fam=radeon

      .. matrix-cell::
         :show-cond: fam=instinct

         `ROCm Compute Profiler (rocprofiler-compute) 3.7.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.14/projects/rocprofiler-compute>`__

      .. matrix-cell::
         :show-cond: fam=radeon

         `ROCprofiler-SDK 1.3.2 <https://github.com/ROCm/rocm-systems/tree/therock-7.14/projects/rocprofiler-sdk>`__

   .. matrix-row::
      :show-cond: fam=instinct

      .. matrix-cell::

         `ROCm Systems Profiler (rocprofiler-systems) 1.7.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.14/projects/rocprofiler-systems>`__

   .. matrix-row::
      :show-cond: fam=instinct

      .. matrix-cell::

         `ROCprofiler-SDK 1.3.2 <https://github.com/ROCm/rocm-systems/tree/therock-7.14/projects/rocprofiler-sdk>`__

   .. matrix-row::
      :show-cond: fam=instinct fam=radeon

      .. matrix-cell::

         `ROCdbgapi 0.80.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.14/projects/rocdbgapi>`__

   .. matrix-row::
      :show-cond: fam=instinct fam=radeon

      .. matrix-cell::

         `ROCm Debugger (ROCgdb) 16.3 <https://github.com/ROCm/ROCgdb/tree/therock-7.14>`__

   .. matrix-row::
      :show-cond: fam=instinct fam=radeon

      .. matrix-cell::

         `ROCr Debug Agent 2.1.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.14/projects/rocr-debug-agent>`__

   .. matrix-row::

      .. matrix-cell:: Control and monitoring tools
         :rowspan: 3

      .. matrix-cell::
         :show-cond: fam=instinct fam=radeon

         `AMD SMI 26.5.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.14/projects/amdsmi>`__

   .. matrix-row::

      .. matrix-cell::

         `rocminfo 1.0.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.14/projects/rocminfo>`__

   .. matrix-row::
      :show-cond: fam=instinct

      .. matrix-cell::

         `ROCm Data Center Tool (RDC) 1.3.1 <https://github.com/ROCm/rocm-systems/tree/therock-7.14/projects/rdc>`__
