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

         `Composable Kernel 1.3.0 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/composablekernel>`__

   .. matrix-row::

      .. matrix-cell::

         `hipBLAS 3.4.0 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/hipblas>`__

   .. matrix-row::

      .. matrix-cell::

         `hipBLASLt 1.3.0 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/hipblaslt>`__

   .. matrix-row::

      .. matrix-cell::

         `hipCUB 4.4.0 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/hipcub>`__

   .. matrix-row::

      .. matrix-cell::

         `hipFFT 1.0.23 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/hipfft>`__

   .. matrix-row::

      .. matrix-cell::

         `hipRAND 3.3.0 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/hiprand>`__

   .. matrix-row::

      .. matrix-cell::

         `hipSOLVER 3.4.0 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/hipsolver>`__

   .. matrix-row::

      .. matrix-cell::

         `hipSPARSE 4.5.0 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/hipsparse>`__

   .. matrix-row::

      .. matrix-cell::

         `hipSPARSELt 0.2.8 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/hipsparselt>`__

   .. matrix-row::

      .. matrix-cell::

         `MIOpen 3.5.1 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/miopen>`__

   .. matrix-row::

      .. matrix-cell::

         `rocBLAS 5.4.0 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/rocblas>`__

   .. matrix-row::

      .. matrix-cell::

         `rocFFT 1.0.37 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/rocfft>`__

   .. matrix-row::

      .. matrix-cell::

         `rocPRIM 4.4.0 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/rocprim>`__

   .. matrix-row::

      .. matrix-cell::

         `rocRAND 4.4.0 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/rocrand>`__

   .. matrix-row::

      .. matrix-cell::

         `rocSOLVER 3.34.0 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/rocsolver>`__

   .. matrix-row::

      .. matrix-cell::

         `rocSPARSE 4.6.0 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/rocsparse>`__

   .. matrix-row::

      .. matrix-cell::

         `rocThrust 4.4.0 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/rocthrust>`__

   .. matrix-row::

      .. matrix-cell::

         `rocWMMA 2.2.1 <https://github.com/ROCm/rocm-libraries/tree/therock-7.13/projects/rocwmma>`__

   .. matrix-row::

      .. matrix-cell:: Communication libraries
         :rowspan: 2
         :show-cond: fam=instinct fam=radeon

      .. matrix-cell:: Communication libraries
         :rowspan: 1
         :show-cond: fam=ryzen

      .. matrix-cell::

         `RCCL 2.28.3 <https://github.com/ROCm/rocm-systems/tree/therock-7.13/projects/rccl>`__

   .. matrix-row::
      :show-cond: fam=instinct fam=radeon

      .. matrix-cell::

         `rocSHMEM 3.4.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.13/projects/rocshmem>`__

   .. matrix-row::

      .. matrix-cell:: Media libraries
         :rowspan: 2

      .. matrix-cell::

         `rocDecode 1.8.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.13/projects/rocdecode>`__

   .. matrix-row::

      .. matrix-cell::

         `rocJPEG 1.5.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.13/projects/rocjpeg>`__

   .. matrix-row::

      .. matrix-cell:: Runtimes and compilers
         :rowspan: 5
         :show-cond: fam=instinct fam=radeon

      .. matrix-cell:: Runtimes and compilers
         :rowspan: 4
         :show-cond: fam=ryzen

      .. matrix-cell::

         `HIP 7.13 <https://github.com/ROCm/rocm-systems/tree/therock-7.13/projects/hip>`__

   .. matrix-row::

      .. matrix-cell::

         `HIPIFY 7.13 <https://github.com/ROCm/HIPIFY/tree/therock-7.13>`__

   .. matrix-row::

      .. matrix-cell::

         `LLVM 23.0.0 <https://github.com/ROCm/llvm-project/tree/therock-7.13>`__

   .. matrix-row::
      :show-cond: fam=instinct fam=radeon

      .. matrix-cell::

         `ROCr Runtime 1.21.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.13/projects/rocr-runtime>`__

   .. matrix-row::

      .. matrix-cell::

         `SPIRV-LLVM-Translator 23.0.0 <https://github.com/ROCm/SPIRV-LLVM-Translator/tree/therock-7.13>`__

   .. matrix-row::

      .. matrix-cell:: Profiling and debugging tools
         :rowspan: 6
         :show-cond: fam=instinct

      .. matrix-cell:: Profiling and debugging tools
         :rowspan: 4
         :show-cond: fam=radeon

      .. matrix-cell::
         :show-cond: fam=instinct

         `ROCm Compute Profiler (rocprofiler-compute) 3.6.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.13/projects/rocprofiler-compute>`__

      .. matrix-cell::
         :show-cond: fam=radeon

         `ROCprofiler-SDK 1.3.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.13/projects/rocprofiler-sdk>`__

   .. matrix-row::
      :show-cond: fam=instinct

      .. matrix-cell::

         `ROCm Systems Profiler (rocprofiler-systems) 1.6.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.13/projects/rocprofiler-systems>`__

   .. matrix-row::
      :show-cond: fam=instinct

      .. matrix-cell::

         `ROCprofiler-SDK 1.3.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.13/projects/rocprofiler-sdk>`__

   .. matrix-row::
      :show-cond: fam=instinct fam=radeon

      .. matrix-cell::

         `ROCdbgapi 0.80.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.13/projects/rocdbgapi>`__

   .. matrix-row::
      :show-cond: fam=instinct fam=radeon

      .. matrix-cell::

         `ROCm Debugger (ROCgdb) 16.3 <https://github.com/ROCm/ROCgdb/tree/therock-7.13>`__

   .. matrix-row::
      :show-cond: fam=instinct fam=radeon

      .. matrix-cell::

         `ROCr Debug Agent 2.1.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.13/projects/rocr-debug-agent>`__

   .. matrix-row::

      .. matrix-cell:: Control and monitoring tools
         :rowspan: 3

      .. matrix-cell::
         :show-cond: fam=instinct fam=radeon

         `AMD SMI 26.4.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.13/projects/amdsmi>`__

   .. matrix-row::

      .. matrix-cell::

         `rocminfo 1.0.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.13/projects/rocminfo>`__

   .. matrix-row::
      :show-cond: fam=instinct

      .. matrix-cell::

         `ROCm Data Center Tool (RDC) 1.3.0 <https://github.com/ROCm/rocm-systems/tree/therock-7.13/projects/rdc>`__
