.. meta::
    :description: ROCm compatibility matrix
    :keywords: GPU, architecture, hardware, compatibility, system, requirements, components, libraries

**************************************************************************************
Compatibility matrix
**************************************************************************************

Use this matrix to view the ROCm compatibility and system requirements across successive major and minor releases.

You can also refer to the :ref:`past versions of ROCm compatibility matrix<past-rocm-compatibility-matrix>`.

GPUs listed in the following table support compute workloads (no display
information or graphics). If you’re using ROCm with AMD Radeon GPUs or Ryzen APUs for graphics
workloads, see the :doc:`Use ROCm on Radeon and Ryzen <radeon:index>` to verify
compatibility and system requirements.

.. |br| raw:: html

   <br/>

.. container:: format-big-table

  .. csv-table::
      :header: "ROCm Version", "7.2.4/7.2.3", "7.2.2/7.2.1", "7.1.0"
      :stub-columns: 1

      :ref:`Operating systems & kernels <OS-kernel-versions>` [#os-compatibility]_,Ubuntu 24.04.4,Ubuntu 24.04.4,Ubuntu 24.04.3
      ,Ubuntu 22.04.5,Ubuntu 22.04.5,Ubuntu 22.04.5
      ,"RHEL 10.1, 10.0, |br| 9.7, 9.6, 9.4","RHEL 10.1, 10.0, |br| 9.7, 9.6, 9.4","RHEL 10.0, 9.6, 9.4"
      ,RHEL 8.10,RHEL 8.10,RHEL 8.10
      ,SLES 15 SP7,SLES 15 SP7,SLES 15 SP7
      ,"Oracle Linux 10, 9, 8","Oracle Linux 10, 9, 8","Oracle Linux 10, 9, 8"
      ,"Debian 13, 12","Debian 13, 12","Debian 13, 12"
      ,Rocky Linux 9,Rocky Linux 9,Rocky Linux 9
      ,.. _architecture-support-compatibility-matrix:,,
      :doc:`Architecture <rocm-install-on-linux:reference/system-requirements>`,CDNA4,CDNA4,CDNA4
      ,CDNA3,CDNA3,CDNA3
      ,CDNA2,CDNA2,CDNA2
      ,CDNA,CDNA,CDNA
      ,RDNA4,RDNA4,RDNA4
      ,RDNA3,RDNA3,RDNA3
      ,RDNA2,RDNA2,RDNA2
      ,.. _gpu-support-compatibility-matrix:,,
      :doc:`GPU / LLVM target <rocm-install-on-linux:reference/system-requirements>`  [#gpu-compatibility]_,gfx950,gfx950,gfx950
      ,gfx1201,gfx1201,gfx1201
      ,gfx1200,gfx1200,gfx1200
      ,gfx1101,gfx1101,gfx1101
      ,gfx1100,gfx1100,gfx1100
      ,gfx1030,gfx1030,gfx1030
      ,gfx942,gfx942,gfx942
      ,gfx90a,gfx90a,gfx90a
      ,gfx908,gfx908,gfx908
      ,,,
      FRAMEWORK SUPPORT,.. _framework-support-compatibility-matrix:,,
      :doc:`PyTorch <../compatibility/ml-compatibility/pytorch-compatibility>`,"2.9.1, 2.8.0, 2.7.1","2.9.1, 2.8.0, 2.7.1","2.8, 2.7, 2.6"
      :doc:`TensorFlow <../compatibility/ml-compatibility/tensorflow-compatibility>`,"2.20.0, 2.19.1, 2.18.1","2.20.0, 2.19.1, 2.18.1","2.20.0, 2.19.1, 2.18.1"
      :doc:`JAX <../compatibility/ml-compatibility/jax-compatibility>`,0.8.2,0.8.2,0.7.1
      `ONNX Runtime <https://onnxruntime.ai/docs/build/eps.html#amd-migraphx>`_,1.23.2,1.23.2,1.22.0
      ,,,
      THIRD PARTY COMMS,.. _thirdpartycomms-support-compatibility-matrix:,,
      `UCC <https://github.com/ROCm/ucc>`_,>=1.6.0,>=1.6.0,>=1.4.0
      `UCX <https://github.com/ROCm/ucx>`_,>=1.17.0,>=1.17.0,>=1.17.0
      ,,,
      THIRD PARTY ALGORITHM,.. _thirdpartyalgorithm-support-compatibility-matrix:,,
      Thrust,2.8.5,2.8.5,2.8.5
      CUB,2.8.5,2.8.5,2.8.5
      ,,,
      DRIVER & USER SPACE [#kfd_support]_,.. _kfd-userspace-support-compatibility-matrix:,,
      :doc:`AMD GPU Driver <rocm-install-on-linux:reference/user-kernel-space-compat-matrix>`,"30.30.x, 30.20.x [#mi325x_KVM]_, |br| 30.10.x [#driver_patch]_, 6.4.x","30.30.x, 30.20.x [#mi325x_KVM]_, |br| 30.10.x [#driver_patch]_, 6.4.x","30.20.0 [#mi325x_KVM]_, 30.10.x [#driver_patch]_, 6.4.x"
      ,,,
      ML & COMPUTER VISION,.. _mllibs-support-compatibility-matrix:,,
      :doc:`Composable Kernel <composable_kernel:index>`,1.2.0,1.2.0,1.1.0
      :doc:`MIGraphX <amdmigraphx:index>`,2.15.0,2.15.0,2.14.0
      :doc:`MIOpen <miopen:index>`,3.5.1,3.5.1,3.5.1
      :doc:`MIVisionX <mivisionx:index>`,3.5.0,3.5.0,3.4.0
      :doc:`rocAL <rocal:index>`,2.5.0,2.5.0,2.4.0
      :doc:`rocDecode <rocdecode:index>`,1.7.0,1.7.0,1.4.0
      :doc:`rocJPEG <rocjpeg:index>`,1.4.0,1.4.0,1.2.0
      :doc:`rocPyDecode <rocpydecode:index>`,0.8.0,0.8.0,0.7.0
      :doc:`RPP <rpp:index>`,2.2.1,2.2.1,2.1.0
      ,,,
      COMMUNICATION,.. _commlibs-support-compatibility-matrix:,,
      :doc:`RCCL <rccl:index>`,2.27.7,2.27.7,2.27.7
      :doc:`rocSHMEM <rocshmem:index>`,3.2.0,3.2.0,3.0.0
      ,,,
      MATH LIBS,.. _mathlibs-support-compatibility-matrix:,,
      `half <https://github.com/ROCm/half>`_ ,1.12.0,1.12.0,1.12.0
      :doc:`hipBLAS <hipblas:index>`,3.2.0,3.2.0,3.1.0
      :doc:`hipBLASLt <hipblaslt:index>`,1.2.2,1.2.2,1.1.0
      :doc:`hipFFT <hipfft:index>`,1.0.22,1.0.22,1.0.21
      :doc:`hipfort <hipfort:index>`,0.7.1,0.7.1,0.7.1
      :doc:`hipRAND <hiprand:index>`,3.1.0,3.1.0,3.1.0
      :doc:`hipSOLVER <hipsolver:index>`,3.2.0,3.2.0,3.1.0
      :doc:`hipSPARSE <hipsparse:index>`,4.2.0,4.2.0,4.1.0
      :doc:`hipSPARSELt <hipsparselt:index>`,0.2.6,0.2.6,0.2.5
      :doc:`rocALUTION <rocalution:index>`,4.1.0,4.1.0,4.0.1
      :doc:`rocBLAS <rocblas:index>`,5.2.0,5.2.0,5.1.0
      :doc:`rocFFT <rocfft:index>`,1.0.36,1.0.36,1.0.35
      :doc:`rocRAND <rocrand:index>`,4.2.0,4.2.0,4.1.0
      :doc:`rocSOLVER <rocsolver:index>`,3.32.0,3.32.0,3.31.0
      :doc:`rocSPARSE <rocsparse:index>`,4.2.0,4.2.0,4.1.0
      :doc:`rocWMMA <rocwmma:index>`,2.2.0,2.2.0,2.0.0
      :doc:`Tensile <tensile:src/index>`,4.45.0,4.45.0,4.44.0
      ,,,
      PRIMITIVES,.. _primitivelibs-support-compatibility-matrix:,,
      :doc:`hipCUB <hipcub:index>`,4.2.0,4.2.0,4.1.0
      :doc:`hipTensor <hiptensor:index>`,2.2.0,2.2.0,2.0.0
      :doc:`rocPRIM <rocprim:index>`,4.2.0,4.2.0,4.1.0
      :doc:`rocThrust <rocthrust:index>`,4.2.0,4.2.0,4.1.0
      ,,,
      SUPPORT LIBS,,,
      `hipother <https://github.com/ROCm/hipother>`_,7.2.53211,7.2.53211,7.1.25424
      `rocm-core <https://github.com/ROCm/rocm-systems/tree/develop/projects/rocm-core>`_,7.2.4/7.2.3,7.2.2/7.2.1,7.1.0
      `ROCT-Thunk-Interface <https://github.com/ROCm/ROCT-Thunk-Interface>`_,N/A [#ROCT-rocr]_,N/A [#ROCT-rocr]_,N/A [#ROCT-rocr]_
      ,,,
      SYSTEM MGMT TOOLS,.. _tools-support-compatibility-matrix:,,
      :doc:`AMD SMI <amdsmi:index>`,26.2.2,26.2.2,26.1.0
      :doc:`ROCm Data Center Tool <rdc:index>`,1.2.0,1.2.0,1.2.0
      :doc:`rocminfo <rocminfo:index>`,1.0.0,1.0.0,1.0.0
      :doc:`ROCm SMI <rocm_smi_lib:index>`,7.8.0,7.8.0,7.8.0
      :doc:`ROCm Validation Suite <rocmvalidationsuite:index>`,1.3.0,1.3.0,1.2.0
      ,,,
      PERFORMANCE TOOLS,,,
      :doc:`ROCm Bandwidth Test <rocm_bandwidth_test:index>`,2.6.0,2.6.0,2.6.0
      :doc:`ROCm Compute Profiler <rocprofiler-compute:index>`,3.4.0,3.4.0,3.3.0
      :doc:`ROCm Systems Profiler <rocprofiler-systems:index>`,1.3.0,1.3.0,1.2.0
      :doc:`ROCProfiler <rocprofiler:index>`,2.0.70204/2.0.70203,2.0.70202/2.0.70201,2.0.70100
      :doc:`ROCprofiler-SDK <rocprofiler-sdk:index>`,1.1.0,1.1.0,1.0.0
      :doc:`ROCTracer <roctracer:index>`,4.1.70204/4.1.70203,4.1.70202/4.1.70201,4.1.70100
      ,,,
      DEVELOPMENT TOOLS,,,
      :doc:`HIPIFY <hipify:index>`,22.0.0,22.0.0,20.0.0
      :doc:`ROCm CMake <rocmcmakebuildtools:index>`,0.14.0,0.14.0,0.14.0
      :doc:`ROCdbgapi <rocdbgapi:index>`,0.77.4,0.77.4,0.77.4
      :doc:`ROCm Debugger (ROCgdb) <rocgdb:index>`,16.3.0,16.3.0,16.3.0
      `rocprofiler-register <https://github.com/ROCm/rocprofiler-register>`_,0.5.0,0.5.0,0.5.0
      :doc:`ROCr Debug Agent <rocr_debug_agent:index>`,2.1.0,2.1.0,2.1.0
      ,,,
      COMPILERS,.. _compilers-support-compatibility-matrix:,,
      :doc:`hipCC <hipcc:index>`,1.1.1,1.1.1,1.1.1
      `Flang <https://github.com/ROCm/flang>`_,22.0.0.26084,22.0.0.26084,20.0.025425
      :doc:`llvm-project <llvm-project:index>`,22.0.0.26084,22.0.0.26084,20.0.025425
      `OpenMP <https://github.com/ROCm/llvm-project/tree/amd-staging/openmp>`_,22.0.0.26084,22.0.0.26084,20.0.025425
      ,,,
      RUNTIMES,.. _runtime-support-compatibility-matrix:,,
      :doc:`AMD CLR <hip:understand/amd_clr>`,7.2.53211,7.2.53211,7.1.25424
      :doc:`HIP <hip:index>`,7.2.53211,7.2.53211,7.1.25424
      `OpenCL Runtime <https://github.com/ROCm/clr/tree/develop/opencl>`_,2.0.0,2.0.0,2.0.0
      :doc:`ROCr Runtime <rocr-runtime:index>`,1.18.0,1.18.0,1.18.0


.. rubric:: Footnotes

.. [#os-compatibility] Some operating systems are supported on specific GPUs. For detailed information about operating systems supported on ROCm 7.2.4/7.2.3, see the latest :ref:`supported_distributions`. For version specific information, see `ROCm 7.2.2/7.2.1 <https://rocm.docs.amd.com/projects/install-on-linux/en/docs-7.2.2/reference/system-requirements.html#supported-operating-systems>`__, and `ROCm 7.1.0 <https://rocm.docs.amd.com/projects/install-on-linux/en/docs-7.1.0/reference/system-requirements.html#supported-operating-systems>`__.
.. [#gpu-compatibility] Some GPUs have limited operating system support. For detailed information about GPUs supporting ROCm 7.2.4/7.2.3, see the latest :ref:`supported_GPUs`. For version specific information, see `ROCm 7.2.2/7.2.1 <https://rocm.docs.amd.com/projects/install-on-linux/en/docs-7.2.2/reference/system-requirements.html#supported-gpus>`__, and `ROCm 7.1.0 <https://rocm.docs.amd.com/projects/install-on-linux/en/docs-7.1.0/reference/system-requirements.html#supported-gpus>`__.
.. [#mi325x_KVM] For AMD Instinct MI325X KVM SR-IOV users, do not use AMD GPU Driver (amdgpu) 30.20.0.
.. [#driver_patch] AMD GPU Driver (amdgpu) 30.10.1 is a quality release that resolves an issue identified in the 30.10 release. There are no other significant changes or feature additions in ROCm 7.0.1 from ROCm 7.0.0. AMD GPU Driver (amdgpu) 30.10.1 is compatible with ROCm 7.0.1 and ROCm 7.0.0.
.. [#kfd_support] As of ROCm 6.4.0, forward and backward compatibility between the AMD GPU Driver (amdgpu) and its user space software is provided up to a year apart. For earlier ROCm releases, the compatibility is provided for +/- 2 releases. The supported user space versions on this page were accurate as of the time of initial ROCm release. For the most up-to-date information, see the latest version of this information at `User and AMD GPU Driver support matrix <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/user-kernel-space-compat-matrix.html>`_.
.. [#ROCT-rocr] Starting from ROCm 6.3.0, the ROCT Thunk Interface is included as part of the ROCr runtime package.

.. _OS-kernel-versions:

Operating systems, kernel and Glibc versions
*********************************************

For detailed information on operating system supported on ROCm 7.2.4/7.2.3 and associated Kernel and Glibc version, see the latest :ref:`supported_distributions`. For version specific information, see `ROCm 7.2.2/7.2.1 <https://rocm.docs.amd.com/projects/install-on-linux/en/docs-7.2.2/reference/system-requirements.html#supported-operating-systems>`__, and `ROCm 7.1.0 <https://rocm.docs.amd.com/projects/install-on-linux/en/docs-7.1.0/reference/system-requirements.html#supported-operating-systems>`__.

.. note::

  * See `Red Hat Enterprise Linux Release Dates <https://access.redhat.com/articles/3078>`_ to learn about the specific kernel versions supported on Red Hat Enterprise Linux (RHEL).
  * See `List of SUSE Linux Enterprise Server kernel <https://www.suse.com/support/kb/doc/?id=000019587>`_ to learn about the specific kernel version supported on SUSE Linux Enterprise Server (SLES).

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
      :file: compatibility-matrix-historical-6.0.csv
      :header-rows: 1
      :stub-columns: 1

   .. rubric:: Footnotes

   .. [#os-compatibility-past-60] Some operating systems are supported on specific GPUs. For detailed information, see :ref:`supported_distributions` and select the required ROCm version for version specific support.
   .. [#gpu-compatibility-past-60] Some GPUs have limited operating system support. For detailed information, see :ref:`supported_GPUs` and select the required ROCm version for version specific support.
   .. [#tf-mi350-past-60] TensorFlow 2.17.1 is not supported on AMD Instinct MI350 Series GPUs. Use TensorFlow 2.19.1 or 2.18.1 with MI350 Series GPUs instead.
   .. [#dgl_compat-past-60] DGL is supported only on ROCm 7.0.0, ROCm 6.4.3, and ROCm 6.4.0.
   .. [#mi325x_KVM-past-60] For AMD Instinct MI325X KVM SR-IOV users, do not use AMD GPU Driver (amdgpu) 30.20.0.
   .. [#driver_patch-past-60] AMD GPU Driver (amdgpu) 30.10.1 is a quality release that resolves an issue identified in the 30.10 release. There are no other significant changes or feature additions in ROCm 7.0.1 from ROCm 7.0.0. AMD GPU Driver (amdgpu) 30.10.1 is compatible with ROCm 7.0.1 and ROCm 7.0.0.
   .. [#kfd_support-past-60] As of ROCm 6.4.0, forward and backward compatibility between the AMD GPU Driver (amdgpu) and its user space software is provided up to a year apart. For earlier ROCm releases, the compatibility is provided for +/- 2 releases. The supported user space versions on this page were accurate as of the time of initial ROCm release. For the most up-to-date information, see the latest version of this information at `User and AMD GPU Driver support matrix <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/user-kernel-space-compat-matrix.html>`_.
   .. [#ROCT-rocr-past-60] Starting from ROCm 6.3.0, the ROCT Thunk Interface is included as part of the ROCr runtime package.
   
