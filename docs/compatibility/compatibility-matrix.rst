.. meta::
    :description: ROCm compatibility matrix
    :keywords: GPU, architecture, hardware, compatibility, system, requirements, components, libraries

**************************************************************************************
Compatibility matrix
**************************************************************************************

Use this matrix to view the ROCm compatibility and system requirements across successive major and minor releases.

You can also refer to the :ref:`past versions of ROCm compatibility matrix<past-rocm-compatibility-matrix>`.

Accelerators and GPUs listed in the following table support compute workloads (no display
information or graphics). If you’re using ROCm with AMD Radeon or Radeon Pro GPUs for graphics
workloads, see the `Use ROCm on Radeon GPU documentation
<https://rocm.docs.amd.com/projects/radeon/en/latest/docs/compatibility.html>`_ to verify
compatibility and system requirements.

.. |br| raw:: html

   <br/>

.. container:: format-big-table

  .. csv-table::
      :header: "ROCm Version", "6.4.3", "6.4.2", "6.3.0"
      :stub-columns: 1

      :ref:`Operating systems & kernels <OS-kernel-versions>`,Ubuntu 24.04.2,Ubuntu 24.04.2,Ubuntu 24.04.2
      ,Ubuntu 22.04.5,Ubuntu 22.04.5,Ubuntu 22.04.5
      ,"RHEL 9.6, 9.4","RHEL 9.6, 9.4","RHEL 9.5, 9.4"
      ,RHEL 8.10,RHEL 8.10,RHEL 8.10
      ,"SLES 15 SP7, SP6","SLES 15 SP7, SP6","SLES 15 SP6, SP5"
      ,"Oracle Linux 9, 8 [#mi300x]_","Oracle Linux 9, 8 [#mi300x]_",Oracle Linux 8.10 [#mi300x]_
      ,Debian 12 [#single-node]_,Debian 12 [#single-node]_,
      ,Azure Linux 3.0 [#mi300x]_,Azure Linux 3.0 [#mi300x]_,
      ,.. _architecture-support-compatibility-matrix:,,
      :doc:`Architecture <rocm-install-on-linux:reference/system-requirements>`,CDNA3,CDNA3,CDNA3
      ,CDNA2,CDNA2,CDNA2
      ,CDNA,CDNA,CDNA
      ,RDNA4,RDNA4,
      ,RDNA3,RDNA3,RDNA3
      ,RDNA2,RDNA2,RDNA2
      ,.. _gpu-support-compatibility-matrix:,,
      :doc:`GPU / LLVM target <rocm-install-on-linux:reference/system-requirements>`,gfx1201 [#RDNA-OS]_,gfx1201 [#RDNA-OS]_,
      ,gfx1200 [#RDNA-OS]_,gfx1200 [#RDNA-OS]_,
      ,gfx1101 [#RDNA-OS]_ [#7700XT-OS]_,gfx1101 [#RDNA-OS]_ [#7700XT-OS]_,
      ,gfx1100,gfx1100,gfx1100
      ,gfx1030,gfx1030,gfx1030
      ,gfx942,gfx942,gfx942
      ,gfx90a,gfx90a,gfx90a
      ,gfx908,gfx908,gfx908
      ,,,
      FRAMEWORK SUPPORT,.. _framework-support-compatibility-matrix:,,
      :doc:`PyTorch <../compatibility/ml-compatibility/pytorch-compatibility>`,"2.6, 2.5, 2.4, 2.3","2.6, 2.5, 2.4, 2.3","2.4, 2.3, 2.2, 2.1, 2.0, 1.13"
      :doc:`TensorFlow <../compatibility/ml-compatibility/tensorflow-compatibility>`,"2.18.1, 2.17.1, 2.16.2","2.18.1, 2.17.1, 2.16.2","2.17.0, 2.16.2, 2.15.1"
      :doc:`JAX <../compatibility/ml-compatibility/jax-compatibility>`,0.4.35,0.4.35,0.4.31
      :doc:`Stanford Megatron-LM <../compatibility/ml-compatibility/stanford-megatron-lm-compatibility>`,N/A,N/A,85f95ae
      :doc:`Megablocks <../compatibility/ml-compatibility/megablocks-compatibility>`,N/A,N/A,0.7.0
      `ONNX Runtime <https://onnxruntime.ai/docs/build/eps.html#amd-migraphx>`_,1.2,1.2,1.17.3
      ,,,
      THIRD PARTY COMMS,.. _thirdpartycomms-support-compatibility-matrix:,,
      `UCC <https://github.com/ROCm/ucc>`_,>=1.3.0,>=1.3.0,>=1.3.0
      `UCX <https://github.com/ROCm/ucx>`_,>=1.15.0,>=1.15.0,>=1.15.0
      ,,,
      THIRD PARTY ALGORITHM,.. _thirdpartyalgorithm-support-compatibility-matrix:,,
      Thrust,2.5.0,2.5.0,2.3.2
      CUB,2.5.0,2.5.0,2.3.2
      ,,,
      KMD & USER SPACE [#kfd_support]_,.. _kfd-userspace-support-compatibility-matrix:,,
      :doc:`KMD versions <rocm-install-on-linux:reference/user-kernel-space-compat-matrix>`,"6.4.x, 6.3.x, 6.2.x, 6.1.x","6.4.x, 6.3.x, 6.2.x, 6.1.x","6.4.x, 6.3.x, 6.2.x, 6.1.x"
      ,,,
      ML & COMPUTER VISION,.. _mllibs-support-compatibility-matrix:,,
      :doc:`Composable Kernel <composable_kernel:index>`,1.1.0,1.1.0,1.1.0
      :doc:`MIGraphX <amdmigraphx:index>`,2.12.0,2.12.0,2.11.0
      :doc:`MIOpen <miopen:index>`,3.4.0,3.4.0,3.3.0
      :doc:`MIVisionX <mivisionx:index>`,3.2.0,3.2.0,3.1.0
      :doc:`rocAL <rocal:index>`,2.2.0,2.2.0,2.1.0
      :doc:`rocDecode <rocdecode:index>`,0.10.0,0.10.0,0.8.0
      :doc:`rocJPEG <rocjpeg:index>`,0.8.0,0.8.0,0.6.0
      :doc:`rocPyDecode <rocpydecode:index>`,0.3.1,0.3.1,0.2.0
      :doc:`RPP <rpp:index>`,1.9.10,1.9.10,1.9.1
      ,,,
      COMMUNICATION,.. _commlibs-support-compatibility-matrix:,,
      :doc:`RCCL <rccl:index>`,2.22.3,2.22.3,2.21.5
      :doc:`rocSHMEM <rocshmem:index>`,2.0.1,2.0.1,N/A
      ,,,
      MATH LIBS,.. _mathlibs-support-compatibility-matrix:,,
      `half <https://github.com/ROCm/half>`_ ,1.12.0,1.12.0,1.12.0
      :doc:`hipBLAS <hipblas:index>`,2.4.0,2.4.0,2.3.0
      :doc:`hipBLASLt <hipblaslt:index>`,0.12.1,0.12.1,0.10.0
      :doc:`hipFFT <hipfft:index>`,1.0.18,1.0.18,1.0.17
      :doc:`hipfort <hipfort:index>`,0.6.0,0.6.0,0.5.0
      :doc:`hipRAND <hiprand:index>`,2.12.0,2.12.0,2.11.0
      :doc:`hipSOLVER <hipsolver:index>`,2.4.0,2.4.0,2.3.0
      :doc:`hipSPARSE <hipsparse:index>`,3.2.0,3.2.0,3.1.2
      :doc:`hipSPARSELt <hipsparselt:index>`,0.2.3,0.2.3,0.2.2
      :doc:`rocALUTION <rocalution:index>`,3.2.3,3.2.3,3.2.1
      :doc:`rocBLAS <rocblas:index>`,4.4.1,4.4.1,4.3.0
      :doc:`rocFFT <rocfft:index>`,1.0.32,1.0.32,1.0.31
      :doc:`rocRAND <rocrand:index>`,3.3.0,3.3.0,3.2.0
      :doc:`rocSOLVER <rocsolver:index>`,3.28.2,3.28.2,3.27.0
      :doc:`rocSPARSE <rocsparse:index>`,3.4.0,3.4.0,3.3.0
      :doc:`rocWMMA <rocwmma:index>`,1.7.0,1.7.0,1.6.0
      :doc:`Tensile <tensile:src/index>`,4.43.0,4.43.0,4.42.0
      ,,,
      PRIMITIVES,.. _primitivelibs-support-compatibility-matrix:,,
      :doc:`hipCUB <hipcub:index>`,3.4.0,3.4.0,3.3.0
      :doc:`hipTensor <hiptensor:index>`,1.5.0,1.5.0,1.4.0
      :doc:`rocPRIM <rocprim:index>`,3.4.1,3.4.1,3.3.0
      :doc:`rocThrust <rocthrust:index>`,3.3.0,3.3.0,3.3.0
      ,,,
      SUPPORT LIBS,,,
      `hipother <https://github.com/ROCm/hipother>`_,6.4.43483,6.4.43483,6.3.42131
      `rocm-core <https://github.com/ROCm/rocm-core>`_,6.4.3,6.4.2,6.3.0
      `ROCT-Thunk-Interface <https://github.com/ROCm/ROCT-Thunk-Interface>`_,N/A [#ROCT-rocr]_,N/A [#ROCT-rocr]_,N/A [#ROCT-rocr]_
      ,,,
      SYSTEM MGMT TOOLS,.. _tools-support-compatibility-matrix:,,
      :doc:`AMD SMI <amdsmi:index>`,25.5.1,25.5.1,24.7.1
      :doc:`ROCm Data Center Tool <rdc:index>`,0.3.0,0.3.0,0.3.0
      :doc:`rocminfo <rocminfo:index>`,1.0.0,1.0.0,1.0.0
      :doc:`ROCm SMI <rocm_smi_lib:index>`,7.7.0,7.5.0,7.4.0
      :doc:`ROCm Validation Suite <rocmvalidationsuite:index>`,1.1.0,1.1.0,1.1.0
      ,,,
      PERFORMANCE TOOLS,,,
      :doc:`ROCm Bandwidth Test <rocm_bandwidth_test:index>`,1.4.0,1.4.0,1.4.0
      :doc:`ROCm Compute Profiler <rocprofiler-compute:index>`,3.1.1,3.1.1,3.0.0
      :doc:`ROCm Systems Profiler <rocprofiler-systems:index>`,1.0.2,1.0.2,0.1.0
      :doc:`ROCProfiler <rocprofiler:index>`,2.0.60403,2.0.60402,2.0.60300
      :doc:`ROCprofiler-SDK <rocprofiler-sdk:index>`,0.6.0,0.6.0,0.5.0
      :doc:`ROCTracer <roctracer:index>`,4.1.60403,4.1.60402,4.1.60300
      ,,,
      DEVELOPMENT TOOLS,,,
      :doc:`HIPIFY <hipify:index>`,19.0.0,19.0.0,18.0.0.24455
      :doc:`ROCm CMake <rocmcmakebuildtools:index>`,0.14.0,0.14.0,0.14.0
      :doc:`ROCdbgapi <rocdbgapi:index>`,0.77.2,0.77.2,0.77.0
      :doc:`ROCm Debugger (ROCgdb) <rocgdb:index>`,15.2.0,15.2.0,15.2.0
      `rocprofiler-register <https://github.com/ROCm/rocprofiler-register>`_,0.4.0,0.4.0,0.4.0
      :doc:`ROCr Debug Agent <rocr_debug_agent:index>`,2.0.4,2.0.4,2.0.3
      ,,,
      COMPILERS,.. _compilers-support-compatibility-matrix:,,
      `clang-ocl <https://github.com/ROCm/clang-ocl>`_,N/A,N/A,N/A
      :doc:`hipCC <hipcc:index>`,1.1.1,1.1.1,1.1.1
      `Flang <https://github.com/ROCm/flang>`_,19.0.0.25224,19.0.0.25224,18.0.0.24455
      :doc:`llvm-project <llvm-project:index>`,19.0.0.25224,19.0.0.25224,18.0.0.24491
      `OpenMP <https://github.com/ROCm/llvm-project/tree/amd-staging/openmp>`_,19.0.0.25224,19.0.0.25224,18.0.0.24491
      ,,,
      RUNTIMES,.. _runtime-support-compatibility-matrix:,,
      :doc:`AMD CLR <hip:understand/amd_clr>`,6.4.43484,6.4.43484,6.3.42131
      :doc:`HIP <hip:index>`,6.4.43484,6.4.43484,6.3.42131
      `OpenCL Runtime <https://github.com/ROCm/clr/tree/develop/opencl>`_,2.0.0,2.0.0,2.0.0
      :doc:`ROCr Runtime <rocr-runtime:index>`,1.15.0,1.15.0,1.14.0


.. rubric:: Footnotes

.. [#mi300x] Oracle Linux and Azure Linux are supported only on AMD Instinct MI300X.
.. [#single-node] Debian 12 is supported only on AMD Instinct MI300X for single-node functionality.
.. [#RDNA-OS] Radeon AI PRO R9700, Radeon RX 9070 XT (gfx1201), Radeon RX 9060 XT (gfx1200), Radeon PRO W7700 (gfx1101), and Radeon RX 7800 XT (gfx1101) are supported only on Ubuntu 24.04.2, Ubuntu 22.04.5, RHEL 9.6, and RHEL 9.4.
.. [#7700XT-OS] Radeon RX 7700 XT (gfx1101) is supported only on Ubuntu 24.04.2 and RHEL 9.6.
.. [#kfd_support] As of ROCm 6.4.0, forward and backward compatibility between the AMD Kernel-mode GPU Driver (KMD) and its user space software is provided up to a year apart. For earlier ROCm releases, the compatibility is provided for +/- 2 releases. The tested user space versions on this page were accurate as of the time of initial ROCm release. For the most up-to-date information, see the latest version of this information at `User and kernel-space support matrix <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/user-kernel-space-compat-matrix.html>`_.
.. [#ROCT-rocr] Starting from ROCm 6.3.0, the ROCT Thunk Interface is included as part of the ROCr runtime package.


.. _OS-kernel-versions:

Operating systems, kernel and Glibc versions
*********************************************

Use this lookup table to confirm which operating system and kernel versions are supported with ROCm.

.. csv-table::
   :header: "OS", "Version", "Kernel", "Glibc"
   :widths: 40, 20, 30, 20
   :stub-columns: 1

   `Ubuntu <https://ubuntu.com/about/release-cycle#ubuntu-kernel-release-cycle>`_, 24.04.2, "6.8 GA, 6.11 HWE", 2.39
   ,,
   `Ubuntu <https://ubuntu.com/about/release-cycle#ubuntu-kernel-release-cycle>`_, 22.04.5, "5.15 GA, 6.8 HWE", 2.35
   ,,
   `Red Hat Enterprise Linux (RHEL 9) <https://access.redhat.com/articles/3078#RHEL9>`_, 9.6, 5.14+, 2.34
   ,9.5, 5.14+, 2.34
   ,9.4, 5.14+, 2.34
   ,9.3, 5.14+, 2.34
   ,,
   `Red Hat Enterprise Linux (RHEL 8) <https://access.redhat.com/articles/3078#RHEL8>`_, 8.10, 4.18.0+, 2.28
   ,8.9, 4.18.0, 2.28
   ,,
   `SUSE Linux Enterprise Server (SLES) <https://www.suse.com/support/kb/doc/?id=000019587#SLE15SP4>`_, 15 SP7, 6.11.0+, 2.38
   ,15 SP6, "6.5.0+, 6.4.0", 2.38
   ,15 SP5, 5.14.21, 2.31
   ,,
   `Oracle Linux <https://blogs.oracle.com/scoter/post/oracle-linux-and-unbreakable-enterprise-kernel-uek-releases>`_, 9, 5.15.0 (UEK), 2.35
   ,8, 5.15.0 (UEK), 2.28
   ,,
   `Debian <https://www.debian.org/download>`_,12, 6.1, 2.36
   ,,
   `Azure Linux <https://techcommunity.microsoft.com/blog/linuxandopensourceblog/azure-linux-3-0-now-in-preview-on-azure-kubernetes-service-v1-31/4287229>`_,3.0, 6.6.60, 2.38
   ,,

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

   .. [#mi300x-past-60] Oracle Linux and Azure Linux are supported only on AMD Instinct MI300X.
   .. [#single-node-past-60] Debian 12 is supported only on AMD Instinct MI300X for single-node functionality.
   .. [#RDNA-OS-past-60] Radeon AI PRO R9700, Radeon RX 9070 XT (gfx1201), Radeon RX 9060 XT (gfx1200), Radeon PRO W7700 (gfx1101), and Radeon RX 7800 XT (gfx1101) are supported only on Ubuntu 24.04.2, Ubuntu 22.04.5, RHEL 9.6, and RHEL 9.4.
   .. [#7700XT-OS-past-60] Radeon RX 7700 XT (gfx1101) is supported only on Ubuntu 24.04.2 and RHEL 9.6.
   .. [#mi300_624-past-60] **For ROCm 6.2.4** - MI300X (gfx942) is supported on listed operating systems *except* Ubuntu 22.04.5 [6.8 HWE] and Ubuntu 22.04.4 [6.5 HWE].
   .. [#mi300_622-past-60] **For ROCm 6.2.2** - MI300X (gfx942) is supported on listed operating systems *except* Ubuntu 22.04.5 [6.8 HWE] and Ubuntu 22.04.4 [6.5 HWE].
   .. [#mi300_621-past-60] **For ROCm 6.2.1** - MI300X (gfx942) is supported on listed operating systems *except* Ubuntu 22.04.5 [6.8 HWE] and Ubuntu 22.04.4 [6.5 HWE].
   .. [#mi300_620-past-60] **For ROCm 6.2.0** - MI300X (gfx942) is supported on listed operating systems *except* Ubuntu 22.04.5 [6.8 HWE] and Ubuntu 22.04.4 [6.5 HWE].
   .. [#mi300_612-past-60] **For ROCm 6.1.2** - MI300A (gfx942) is supported on Ubuntu 22.04.4, RHEL 9.4, RHEL 9.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is only supported on Ubuntu 22.04.4 and Oracle Linux.
   .. [#mi300_611-past-60] **For ROCm 6.1.1** - MI300A (gfx942) is supported on Ubuntu 22.04.4, RHEL 9.4, RHEL 9.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is only supported on Ubuntu 22.04.4 and Oracle Linux.
   .. [#mi300_610-past-60] **For ROCm 6.1.0** - MI300A (gfx942) is supported on Ubuntu 22.04.4, RHEL 9.4, RHEL 9.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is only supported on Ubuntu 22.04.4.
   .. [#mi300_602-past-60] **For ROCm 6.0.2** - MI300A (gfx942) is supported on Ubuntu 22.04.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is only supported on Ubuntu 22.04.3.
   .. [#mi300_600-past-60] **For ROCm 6.0.0** - MI300A (gfx942) is supported on Ubuntu 22.04.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is only supported on Ubuntu 22.04.3.
   .. [#verl_compat] verl is only supported on ROCm 6.2.0.
   .. [#stanford-megatron-lm_compat] Stanford Megatron-LM is only supported on ROCm 6.3.0.
   .. [#dgl_compat] DGL is only supported on ROCm 6.4.0.
   .. [#megablocks_compat] Megablocks is only supported on ROCm 6.3.0.
   .. [#taichi_compat] Taichi is only supported on ROCm 6.3.2.
   .. [#kfd_support-past-60] As of ROCm 6.4.0, forward and backward compatibility between the AMD Kernel-mode GPU Driver (KMD) and its user space software is provided up to a year apart. For earlier ROCm releases, the compatibility is provided for +/- 2 releases. The tested user space versions on this page were accurate as of the time of initial ROCm release. For the most up-to-date information, see the latest version of this information at `User and kernel-space support matrix <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/user-kernel-space-compat-matrix.html>`_.
   .. [#ROCT-rocr-past-60] Starting from ROCm 6.3.0, the ROCT Thunk Interface is included as part of the ROCr runtime package.
   
