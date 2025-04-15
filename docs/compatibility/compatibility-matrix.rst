.. meta::
    :description: ROCm compatibility matrix
    :keywords: AMD, GPU, architecture, hardware, compatibility, requirements

**************************************************************************************
Compatibility matrix
**************************************************************************************

Use this matrix to view the ROCm compatibility across successive major and minor releases.

You can also refer to the :ref:`past versions of ROCm compatibility matrix<past-rocm-compatibility-matrix>`.

.. container:: format-big-table

  .. csv-table:: 
      :header: "ROCm Version", "6.2.0", "6.1.2", "6.0.0"
      :stub-columns: 1

      :doc:`Operating Systems <rocm-install-on-linux:reference/system-requirements>`, "Ubuntu 24.04","",""
      ,"Ubuntu 22.04.5 [#Ubuntu220405]_, 22.04.4","Ubuntu 22.04.5 [#Ubuntu220405]_, 22.04.4, 22.04.3","Ubuntu 22.04.4, 22.04.3"
      ,,"Ubuntu 20.04.6, 20.04.5","Ubuntu 20.04.6, 20.04.5"
      ,"RHEL 9.4, 9.3","RHEL 9.4 [#red-hat94]_, 9.3, 9.2","RHEL 9.3, 9.2"
      ,"RHEL 8.10, 8.9","RHEL 8.9, 8.8","RHEL 8.9, 8.8"
      ,"SLES 15 SP6, SP5","SLES 15 SP5, SP4","SLES 15 SP5, SP4"
      ,,CentOS 7.9,CentOS 7.9
      ,"Oracle Linux 8.9 [#oracle89]_","Oracle Linux 8.9 [#oracle89]_",""
      ,".. _architecture-support-compatibility-matrix:",,
      :doc:`Architecture <rocm-install-on-linux:reference/system-requirements>`,CDNA3,CDNA3,CDNA3
      ,CDNA2,CDNA2,CDNA2
      ,CDNA,CDNA,CDNA
      ,RDNA3,RDNA3,RDNA3
      ,RDNA2,RDNA2,RDNA2
      ,".. _gpu-support-compatibility-matrix:",,
      :doc:`GPU / LLVM target <rocm-install-on-linux:reference/system-requirements>`,gfx1100,gfx1100,gfx1100
      ,gfx1030,gfx1030,gfx1030
      ,gfx942 [#mi300_620]_, gfx942 [#mi300_612]_, gfx942 [#mi300_600]_
      ,gfx90a,gfx90a,gfx90a
      ,gfx908,gfx908,gfx908
      ,,,
      FRAMEWORK SUPPORT,".. _framework-support-compatibility-matrix:",,
      :doc:`PyTorch <rocm-install-on-linux:install/3rd-party/pytorch-install>`,"2.3, 2.2, 2.1, 2.0, 1.13","2.1, 2.0, 1.13","2.1, 2.0, 1.13"
      :doc:`TensorFlow <rocm-install-on-linux:install/3rd-party/tensorflow-install>`,"2.16.1, 2.15.1, 2.14.1","2.15.0, 2.14.0, 2.13.1","2.14.0, 2.13.1, 2.12.1"
      :doc:`JAX <rocm-install-on-linux:install/3rd-party/jax-install>`,0.4.26,0.4.26,0.4.26
      `ONNX Runtime <https://onnxruntime.ai/docs/build/eps.html#amd-migraphx>`_,1.17.3,1.17.3,1.14.1
      ,,,
      THIRD PARTY COMMS,".. _thirdpartycomms-support-compatibility-matrix:",,
      `UCC <https://github.com/ROCm/ucc>`_,>=1.3.0,>=1.3.0,>=1.2.0
      `UCX <https://github.com/ROCm/ucx>`_,>=1.15.0,>=1.14.1,>=1.14.1
      ,,,
      THIRD PARTY ALGORITHM,".. _thirdpartyalgorithm-support-compatibility-matrix:",,
      Thrust,2.2.0,2.1.0,2.0.1
      CUB,2.2.0,2.1.0,2.0.1
      ,,,
      ML & COMPUTER VISION,".. _mllibs-support-compatibility-matrix:",,
      :doc:`Composable Kernel <composable_kernel:index>`,1.1.0,1.1.0,1.1.0
      :doc:`MIGraphX <amdmigraphx:index>`,2.10.0,2.9.0,2.8.0
      :doc:`MIOpen <miopen:index>`,3.2.0,3.1.0,3.0.0
      :doc:`MIVisionX <mivisionx:index>`,3.0.0,2.5.0,2.5.0
      :doc:`RPP <rpp:index>`,1.8.0,1.5.0,1.4.0
      :doc:`rocAL <rocal:index>`,1.0.0,1.0.0,1.0.0
      :doc:`rocDecode <rocdecode:index>`,0.6.0,0.6.0,N/A
      :doc:`rocPyDecode <rocpydecode:index>`,0.1.0,N/A,N/A
      ,,,
      COMMUNICATION,".. _commlibs-support-compatibility-matrix:",,
      :doc:`RCCL <rccl:index>`,2.20.5,2.18.6,2.18.3
      ,,,
      MATH LIBS,".. _mathlibs-support-compatibility-matrix:",,
      `half <https://github.com/ROCm/half>`_ ,1.12.0,1.12.0,1.12.0
      :doc:`hipBLAS <hipblas:index>`,2.2.0,2.1.0,2.0.0
      :doc:`hipBLASLt <hipblaslt:index>`,0.8.0,0.7.0,0.6.0
      :doc:`hipFFT <hipfft:index>`,1.0.14,1.0.14,1.0.13
      :doc:`hipFORT <hipfort:index>`,0.4.0,0.4.0,0.4.0
      :doc:`hipRAND <hiprand:index>`,2.11.0,2.10.16,2.10.16
      :doc:`hipSOLVER <hipsolver:index>`,2.2.0,2.1.1,2.0.0
      :doc:`hipSPARSE <hipsparse:index>`,3.1.1,3.0.1,3.0.0
      :doc:`hipSPARSELt <hipsparselt:index>`,0.2.1,0.2.0,0.1.0
      :doc:`rocALUTION <rocalution:index>`,3.2.0,3.1.1,3.0.3
      :doc:`rocBLAS <rocblas:index>`,4.2.0,4.1.2,4.0.0
      :doc:`rocFFT <rocfft:index>`,1.0.28,1.0.27,1.0.23
      :doc:`rocRAND <rocrand:index>`,3.1.0,3.0.1,2.10.17
      :doc:`rocSOLVER <rocsolver:index>`,3.26.0,3.25.0,3.24.0
      :doc:`rocSPARSE <rocsparse:index>`,3.2.0,3.1.2,3.0.2
      :doc:`rocWMMA <rocwmma:index>`,1.5.0,1.4.0,1.3.0
      `Tensile <https://github.com/ROCm/Tensile>`_,4.40.0,4.40.0,4.39.0
      ,,,
      PRIMITIVES,".. _primitivelibs-support-compatibility-matrix:",,
      :doc:`hipCUB <hipcub:index>`,3.2.0,3.1.0,3.0.0
      :doc:`hipTensor <hiptensor:index>`,1.3.0,1.2.0,1.1.0
      :doc:`rocPRIM <rocprim:index>`,3.2.0,3.1.0,3.0.0
      :doc:`rocThrust <rocthrust:index>`,3.0.1,3.0.1,3.0.0
      ,,,
      SUPPORT LIBS,,,
      `hipother <https://github.com/ROCm/hipother>`_,6.2.41133,6.1.40093,6.1.32830
      `rocm-core <https://github.com/ROCm/rocm-core>`_,6.2.0,6.1.2,6.0.0
      `ROCT-Thunk-Interface <https://github.com/ROCm/ROCT-Thunk-Interface>`_,20240607.1.4246,20240125.5.08,20231016.2.245
      ,,,
      SYSTEM MGMT TOOLS,".. _tools-support-compatibility-matrix:",,
      :doc:`AMD SMI <amdsmi:index>`,24.6.2,24.5.1,23.4.2
      :doc:`ROCm Data Center Tool <rdc:index>`,1.0.0,0.3.0,0.3.0
      :doc:`rocminfo <rocminfo:index>`,1.0.0,1.0.0,1.0.0
      :doc:`ROCm SMI <rocm_smi_lib:index>`,7.3.0,7.2.0,6.0.0
      :doc:`ROCm Validation Suite <rocmvalidationsuite:index>`,rocm-6.2.0,rocm-6.1.2,rocm-6.0.0
      ,,,
      PERFORMANCE TOOLS,,,
      :doc:`Omniperf <omniperf:index>`,2.0.1,N/A,N/A
      :doc:`Omnitrace <omnitrace:index>`,1.11.2,N/A,N/A
      :doc:`ROCm Bandwidth Test <rocm_bandwidth_test:index>`,1.4.0,1.4.0,1.4.0
      :doc:`ROCProfiler <rocprofiler:index>`,2.0.60200,2.0.60102,2.0.60000
      :doc:`ROCprofiler-SDK <rocprofiler-sdk:index>`,0.4.0,N/A,N/A
      :doc:`ROCTracer <roctracer:index>`,4.1.60200,4.1.60102,4.1.60000
      ,,,
      DEVELOPMENT TOOLS,,,
      :doc:`HIPIFY <hipify:index>`,18.0.0.24232,17.0.0.24193,17.0.0.23483
      :doc:`ROCm CMake <rocmcmakebuildtools:index>`,0.13.0,0.12.0,0.11.0
      :doc:`ROCdbgapi <rocdbgapi:index>`,0.76.0,0.71.0,0.71.0
      :doc:`ROCm Debugger (ROCgdb) <rocgdb:index>`,14.2.0,14.1.0,13.2.0
      `rocprofiler-register <https://github.com/ROCm/rocprofiler-register>`_,0.4.0,0.3.0,N/A
      :doc:`ROCr Debug Agent <rocr_debug_agent:index>`,2.0.3,2.0.3,2.0.3
      ,,,
      COMPILERS,".. _compilers-support-compatibility-matrix:",,
      `clang-ocl <https://github.com/ROCm/clang-ocl>`_,N/A,0.5.0,0.5.0
      :doc:`hipCC <hipcc:index>`,1.1.1,1.0.0,1.0.0
      `Flang <https://github.com/ROCm/flang>`_,18.0.0.24232,17.0.0.24193,17.0.0.23483
      :doc:`llvm-project <llvm-project:index>`,18.0.0.24232,17.0.0.24193,17.0.0.23483
      `OpenMP <https://github.com/ROCm/llvm-project/tree/amd-staging/openmp>`_,18.0.0.24232,17.0.0.24193,17.0.0.23483
      ,,,
      RUNTIMES,".. _runtime-support-compatibility-matrix:",,
      :doc:`AMD CLR <hip:understand/amd_clr>`,6.2.41133,6.1.40093,6.1.32830
      :doc:`HIP <hip:index>`,6.2.41133,6.1.40093,6.1.32830
      `OpenCL Runtime <https://github.com/ROCm/clr/tree/develop/opencl>`_,2.0.0,2.0.0,2.0.0
      :doc:`ROCR-Runtime <rocr-runtime:index>`,1.13.0,1.13.0,1.12.0


.. rubric:: Footnotes

.. [#Ubuntu220405] Preview support of Ubuntu 22.04.5 only
.. [#red-hat94] **For ROCm 6.1** - RHEL 9.4 is supported only on AMD Instinct MI300A.
.. [#oracle89] Oracle Linux is supported only on AMD Instinct MI300X.
.. [#mi300_620] **For ROCm 6.2.0** - MI300X (gfx942) is supported on listed operating systems *except* Ubuntu 22.04.5 [6.8 HWE] and Ubuntu 22.04.4 [6.5 HWE].
.. [#mi300_612] **For ROCm 6.1.2** - MI300A (gfx942) is supported on Ubuntu 22.04.4, RHEL 9.4, RHEL 9.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is only supported on Ubuntu 22.04.4 and Oracle Linux.
.. [#mi300_600] **For ROCm 6.0.0** - MI300A (gfx942) is supported on Ubuntu 22.04.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is only supported on Ubuntu 22.04.3.

..
   Footnotes and ref anchors in below historical tables should be appended with "-past-60", to differentiate from the 
   footnote references in the above, latest, compatibility matrix.  It also allows to easily find & replace.
   An easy way to work is to download the historical.CSV file, and update open it in excel. Then when content is ready, 
   delete the columns you don't need, to build the current compatibility matrix to use in above table.  Find & replace all
   instances of "-past-60" to make it ready for above table.


.. _past-rocm-compatibility-matrix:

Past versions of ROCm compatibility matrix
***************************************************

Expand for full historical view of:

.. dropdown:: ROCm 6.0 - Present

   You can `download the entire .csv <../downloads/compatibility-matrix-historical-6.0.csv>`_ for offline reference.

   .. csv-table::
      :file: ../data/reference/compatibility-matrix-historical-6.0.csv
      :widths: 20,10,10,10,10,10,10,10
      :header-rows: 1
      :stub-columns: 1
   
   .. rubric:: Footnotes

   .. [#Ubuntu220405-past-60] Preview support of Ubuntu 22.04.5 only
   .. [#red-hat94-past-60] **For ROCm 6.1** - RHEL 9.4 is supported only on AMD Instinct MI300A.
   .. [#oracle89-past-60] Oracle Linux is supported only on AMD Instinct MI300X.
   .. [#mi300_620-past-60] **For ROCm 6.2.0** - MI300X (gfx942) is supported on listed operating systems *except* Ubuntu 22.04.5 [6.8 HWE] and Ubuntu 22.04.4 [6.5 HWE].
   .. [#mi300_612-past-60] **For ROCm 6.1.2** - MI300A (gfx942) is supported on Ubuntu 22.04.4, RHEL 9.4, RHEL 9.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is only supported on Ubuntu 22.04.4 and Oracle Linux.
   .. [#mi300_611-past-60] **For ROCm 6.1.1** - MI300A (gfx942) is supported on Ubuntu 22.04.4, RHEL 9.4, RHEL 9.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is only supported on Ubuntu 22.04.4 and Oracle Linux.
   .. [#mi300_610-past-60] **For ROCm 6.1.0** - MI300A (gfx942) is supported on Ubuntu 22.04.4, RHEL 9.4, RHEL 9.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is only supported on Ubuntu 22.04.4.
   .. [#mi300_602-past-60] **For ROCm 6.0.2** - MI300A (gfx942) is supported on Ubuntu 22.04.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is only supported on Ubuntu 22.04.3.
   .. [#mi300_600-past-60] **For ROCm 6.0.0** - MI300A (gfx942) is supported on Ubuntu 22.04.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is only supported on Ubuntu 22.04.3.

