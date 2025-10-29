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
      :header: "ROCm Version", "7.1.0", "7.0.2", "6.4.0"
      :stub-columns: 1

      :ref:`Operating systems & kernels <OS-kernel-versions>`,Ubuntu 24.04.3,Ubuntu 24.04.3,Ubuntu 24.04.2
      ,Ubuntu 22.04.5,Ubuntu 22.04.5,Ubuntu 22.04.5
      ,"RHEL 10.0 [#rhel-10-702]_, 9.6 [#rhel-10-702]_, 9.4 [#rhel-94-702]_","RHEL 10.0 [#rhel-10-702]_, 9.6 [#rhel-10-702]_, 9.4 [#rhel-94-702]_","RHEL 9.5, 9.4"
      ,RHEL 8.10 [#rhel-700]_,RHEL 8.10 [#rhel-700]_,RHEL 8.10
      ,SLES 15 SP7 [#sles-710]_,SLES 15 SP7 [#sles-db-700]_,SLES 15 SP6
      ,"Oracle Linux 10, 9, 8 [#ol-710-mi300x]_","Oracle Linux 10, 9, 8 [#ol-700-mi300x]_","Oracle Linux 9, 8 [#ol-mi300x]_"
      ,"Debian 13 [#db-710-mi300x]_, 12 [#db12-710]_","Debian 13 [#db-mi300x]_, 12 [#sles-db-700]_",Debian 12 [#single-node]_
      ,Azure Linux 3.0 [#az-mi300x]_,Azure Linux 3.0 [#az-mi300x]_,Azure Linux 3.0 [#az-mi300x]_
      ,Rocky Linux 9 [#rl-700]_,Rocky Linux 9 [#rl-700]_,
      ,.. _architecture-support-compatibility-matrix:,,
      :doc:`Architecture <rocm-install-on-linux:reference/system-requirements>`,CDNA4,CDNA4,
      ,CDNA3,CDNA3,CDNA3
      ,CDNA2,CDNA2,CDNA2
      ,CDNA,CDNA,CDNA
      ,RDNA4,RDNA4,
      ,RDNA3,RDNA3,RDNA3
      ,RDNA2,RDNA2,RDNA2
      ,.. _gpu-support-compatibility-matrix:,,
      :doc:`GPU / LLVM target <rocm-install-on-linux:reference/system-requirements>`,gfx950 [#mi350x-os-710]_,gfx950 [#mi350x-os-700]_,
      ,gfx1201 [#RDNA-OS-700]_,gfx1201 [#RDNA-OS-700]_,
      ,gfx1200 [#RDNA-OS-700]_,gfx1200 [#RDNA-OS-700]_,
      ,gfx1101 [#RDNA-OS-700]_ [#rd-v710]_,gfx1101 [#RDNA-OS-700]_ [#rd-v710]_,
      ,gfx1100 [#RDNA-OS-700]_,gfx1100 [#RDNA-OS-700]_,gfx1100
      ,gfx1030 [#RDNA-OS-700]_ [#rd-v620]_,gfx1030 [#RDNA-OS-700]_ [#rd-v620]_,gfx1030
      ,gfx942 [#mi325x-os-710]_ [#mi300x-os]_ [#mi300A-os]_,gfx942 [#mi325x-os]_ [#mi300x-os]_ [#mi300A-os]_,gfx942
      ,gfx90a [#mi200x-os]_,gfx90a [#mi200x-os]_,gfx90a
      ,gfx908 [#mi100-710-os]_,gfx908 [#mi100-os]_,gfx908
      ,,,
      FRAMEWORK SUPPORT,.. _framework-support-compatibility-matrix:,,
      :doc:`PyTorch <../compatibility/ml-compatibility/pytorch-compatibility>`,"2.8, 2.7, 2.6","2.8, 2.7, 2.6","2.6, 2.5, 2.4, 2.3"
      :doc:`TensorFlow <../compatibility/ml-compatibility/tensorflow-compatibility>`,"2.20.0, 2.19.1, 2.18.1","2.19.1, 2.18.1, 2.17.1 [#tf-mi350]_","2.18.1, 2.17.1, 2.16.2"
      :doc:`JAX <../compatibility/ml-compatibility/jax-compatibility>`,0.6.0,0.6.0,0.4.35
      :doc:`DGL <../compatibility/ml-compatibility/dgl-compatibility>` [#dgl_compat]_,N/A,N/A,2.4.0
      :doc:`llama.cpp <../compatibility/ml-compatibility/llama-cpp-compatibility>` [#llama-cpp_compat]_,N/A,N/A,b5997
      `ONNX Runtime <https://onnxruntime.ai/docs/build/eps.html#amd-migraphx>`_,1.22.0,1.22.0,1.20.0
      ,,,
      THIRD PARTY COMMS,.. _thirdpartycomms-support-compatibility-matrix:,,
      `UCC <https://github.com/ROCm/ucc>`_,>=1.4.0,>=1.4.0,>=1.3.0
      `UCX <https://github.com/ROCm/ucx>`_,>=1.17.0,>=1.17.0,>=1.15.0
      ,,,
      THIRD PARTY ALGORITHM,.. _thirdpartyalgorithm-support-compatibility-matrix:,,
      Thrust,2.6.0,2.6.0,2.5.0
      CUB,2.6.0,2.6.0,2.5.0
      ,,,
      DRIVER & USER SPACE [#kfd_support]_,.. _kfd-userspace-support-compatibility-matrix:,,
      :doc:`AMD GPU Driver <rocm-install-on-linux:reference/user-kernel-space-compat-matrix>`,"30.20.0, 30.10.2, |br| 30.10.1 [#driver_patch]_, 30.10, 6.4.x","30.10.2, 30.10.1 [#driver_patch]_, |br| 30.10, 6.4.x, 6.3.x","6.4.x, 6.3.x, 6.2.x, 6.1.x"
      ,,,
      ML & COMPUTER VISION,.. _mllibs-support-compatibility-matrix:,,
      :doc:`Composable Kernel <composable_kernel:index>`,1.1.0,1.1.0,1.1.0
      :doc:`MIGraphX <amdmigraphx:index>`,2.14.0,2.13.0,2.12.0
      :doc:`MIOpen <miopen:index>`,3.5.1,3.5.0,3.4.0
      :doc:`MIVisionX <mivisionx:index>`,3.4.0,3.3.0,3.2.0
      :doc:`rocAL <rocal:index>`,2.4.0,2.3.0,2.2.0
      :doc:`rocDecode <rocdecode:index>`,1.4.0,1.0.0,0.10.0
      :doc:`rocJPEG <rocjpeg:index>`,1.2.0,1.1.0,0.8.0
      :doc:`rocPyDecode <rocpydecode:index>`,0.7.0,0.6.0,0.3.1
      :doc:`RPP <rpp:index>`,2.1.0,2.0.0,1.9.10
      ,,,
      COMMUNICATION,.. _commlibs-support-compatibility-matrix:,,
      :doc:`RCCL <rccl:index>`,2.27.7,2.26.6,2.22.3
      :doc:`rocSHMEM <rocshmem:index>`,3.0.0,3.0.0,2.0.0
      ,,,
      MATH LIBS,.. _mathlibs-support-compatibility-matrix:,,
      `half <https://github.com/ROCm/half>`_ ,1.12.0,1.12.0,1.12.0
      :doc:`hipBLAS <hipblas:index>`,3.1.0,3.0.2,2.4.0
      :doc:`hipBLASLt <hipblaslt:index>`,1.1.0,1.0.0,0.12.0
      :doc:`hipFFT <hipfft:index>`,1.0.21,1.0.20,1.0.18
      :doc:`hipfort <hipfort:index>`,0.7.1,0.7.0,0.6.0
      :doc:`hipRAND <hiprand:index>`,3.1.0,3.0.0,2.12.0
      :doc:`hipSOLVER <hipsolver:index>`,3.1.0,3.0.0,2.4.0
      :doc:`hipSPARSE <hipsparse:index>`,4.1.0,4.0.1,3.2.0
      :doc:`hipSPARSELt <hipsparselt:index>`,0.2.5,0.2.4,0.2.3
      :doc:`rocALUTION <rocalution:index>`,4.0.1,4.0.0,3.2.2
      :doc:`rocBLAS <rocblas:index>`,5.1.0,5.0.2,4.4.0
      :doc:`rocFFT <rocfft:index>`,1.0.35,1.0.34,1.0.32
      :doc:`rocRAND <rocrand:index>`,4.1.0,4.0.0,3.3.0
      :doc:`rocSOLVER <rocsolver:index>`,3.31.0,3.30.1,3.28.0
      :doc:`rocSPARSE <rocsparse:index>`,4.1.0,4.0.2,3.4.0
      :doc:`rocWMMA <rocwmma:index>`,2.0.0,2.0.0,1.7.0
      :doc:`Tensile <tensile:src/index>`,4.44.0,4.44.0,4.43.0
      ,,,
      PRIMITIVES,.. _primitivelibs-support-compatibility-matrix:,,
      :doc:`hipCUB <hipcub:index>`,4.1.0,4.0.0,3.4.0
      :doc:`hipTensor <hiptensor:index>`,2.0.0,2.0.0,1.5.0
      :doc:`rocPRIM <rocprim:index>`,4.1.0,4.0.1,3.4.0
      :doc:`rocThrust <rocthrust:index>`,4.1.0,4.0.0,3.3.0
      ,,,
      SUPPORT LIBS,,,
      `hipother <https://github.com/ROCm/hipother>`_,7.1.25414,7.0.51831,6.4.43482
      `rocm-core <https://github.com/ROCm/rocm-core>`_,7.1.0,7.0.2,6.4.0
      `ROCT-Thunk-Interface <https://github.com/ROCm/ROCT-Thunk-Interface>`_,N/A [#ROCT-rocr]_,N/A [#ROCT-rocr]_,N/A [#ROCT-rocr]_
      ,,,
      SYSTEM MGMT TOOLS,.. _tools-support-compatibility-matrix:,,
      :doc:`AMD SMI <amdsmi:index>`,26.1.0,26.0.2,25.3.0
      :doc:`ROCm Data Center Tool <rdc:index>`,1.2.0,1.1.0,0.3.0
      :doc:`rocminfo <rocminfo:index>`,1.0.0,1.0.0,1.0.0
      :doc:`ROCm SMI <rocm_smi_lib:index>`,7.8.0,7.8.0,7.5.0
      :doc:`ROCm Validation Suite <rocmvalidationsuite:index>`,1.2.0,1.2.0,1.1.0
      ,,,
      PERFORMANCE TOOLS,,,
      :doc:`ROCm Bandwidth Test <rocm_bandwidth_test:index>`,2.6.0,2.6.0,1.4.0
      :doc:`ROCm Compute Profiler <rocprofiler-compute:index>`,3.3.0,3.2.3,3.1.0
      :doc:`ROCm Systems Profiler <rocprofiler-systems:index>`,1.2.0,1.1.1,1.0.0
      :doc:`ROCProfiler <rocprofiler:index>`,2.0.70100,2.0.70002,2.0.60400
      :doc:`ROCprofiler-SDK <rocprofiler-sdk:index>`,1.0.0,1.0.0,0.6.0
      :doc:`ROCTracer <roctracer:index>`,4.1.70100,4.1.70002,4.1.60400
      ,,,
      DEVELOPMENT TOOLS,,,
      :doc:`HIPIFY <hipify:index>`,20.0.0,20.0.0,19.0.0
      :doc:`ROCm CMake <rocmcmakebuildtools:index>`,0.14.0,0.14.0,0.14.0
      :doc:`ROCdbgapi <rocdbgapi:index>`,0.77.4,0.77.4,0.77.2
      :doc:`ROCm Debugger (ROCgdb) <rocgdb:index>`,16.3.0,16.3.0,15.2.0
      `rocprofiler-register <https://github.com/ROCm/rocprofiler-register>`_,0.5.0,0.5.0,0.4.0
      :doc:`ROCr Debug Agent <rocr_debug_agent:index>`,2.1.0,2.1.0,2.0.4
      ,,,
      COMPILERS,.. _compilers-support-compatibility-matrix:,,
      `clang-ocl <https://github.com/ROCm/clang-ocl>`_,N/A,N/A,N/A
      :doc:`hipCC <hipcc:index>`,1.1.1,1.1.1,1.1.1
      `Flang <https://github.com/ROCm/flang>`_,20.0.025413,20.0.0.25385,19.0.0.25133
      :doc:`llvm-project <llvm-project:index>`,20.0.025413,20.0.0.25385,19.0.0.25133
      `OpenMP <https://github.com/ROCm/llvm-project/tree/amd-staging/openmp>`_,20.0.025413,20.0.0.25385,19.0.0.25133
      ,,,
      RUNTIMES,.. _runtime-support-compatibility-matrix:,,
      :doc:`AMD CLR <hip:understand/amd_clr>`,7.1.25414,7.0.51831,6.4.43482
      :doc:`HIP <hip:index>`,7.1.25414,7.0.51831,6.4.43482
      `OpenCL Runtime <https://github.com/ROCm/clr/tree/develop/opencl>`_,2.0.0,2.0.0,2.0.0
      :doc:`ROCr Runtime <rocr-runtime:index>`,1.18.0,1.18.0,1.15.0


.. rubric:: Footnotes

.. [#rhel-10-702] RHEL 10.0 and RHEL 9.6 are supported on all listed :ref:`supported_GPUs` except AMD Radeon PRO V620 GPU.
.. [#rhel-94-702] RHEL 9.4 is supported on all AMD Instinct GPUs listed under :ref:`supported_GPUs`.
.. [#rhel-700] RHEL 8.10 is supported only on AMD Instinct MI300X, MI300A, MI250X, MI250, MI210, and MI100 GPUs.
.. [#sles-710] **For ROCm 7.1.x** - SLES 15 SP7 is supported only on AMD Instinct MI325X, MI300X, MI300A, MI250X, MI250, MI210, and MI100 GPUs.
.. [#sles-db-700] **For ROCm 7.0.x** - SLES 15 SP7 and Debian 12 are supported only on AMD Instinct MI300X, MI300A, MI250X, MI250, and MI210 GPUs.
.. [#ol-710-mi300x] **For ROCm 7.1.x** - Oracle Linux 10 and 9 are supported only on AMD Instinct MI355X, MI350X, MI325X, and MI300X GPUs. Oracle Linux 8 is supported only on AMD Instinct MI300X GPU.
.. [#ol-700-mi300x] **For ROCm 7.0.x** - Oracle Linux 10 and 9 are supported only on AMD Instinct MI355X, MI350X, and MI300X GPUs. Oracle Linux 8 is supported only on AMD Instinct MI300X GPU.
.. [#ol-mi300x] **Prior ROCm 7.0.0** - Oracle Linux is supported only on AMD Instinct MI300X GPUs.
.. [#db-710-mi300x] **For ROCm 7.1.x** - Debian 13 is supported only on AMD Instinct MI355X, MI350X, MI325X, and MI300X GPUs.
.. [#db12-710] **For ROCm 7.1.x** - Debian 12 is supported only on AMD Instinct MI325X, MI300X, MI300A, MI250X, MI250, and MI210 GPUs.
.. [#db-mi300x] **For ROCm 7.0.2** - Debian 13 is supported only on AMD Instinct MI300X GPUs.
.. [#az-mi300x] Starting ROCm 6.4.0, Azure Linux 3.0 is supported only on AMD Instinct MI300X and AMD Radeon PRO V710 GPUs.
.. [#rl-700] Rocky Linux 9 is supported only on AMD Instinct MI300X and MI300A GPUs.
.. [#single-node] **Prior to ROCm 7.0.0** - Debian 12 is supported only on AMD Instinct MI300X GPUs for single-node functionality.
.. [#mi350x-os-710] AMD Instinct MI355X (gfx950) and MI350X (gfx950) GPUs supports all listed :ref:`supported_distributions` except RHEL 8.10, SLES 15 SP7, Debian 12, Rocky 9, Azure Linux 3.0, and Oracle Linux 8.
.. [#mi350x-os-700] AMD Instinct MI355X (gfx950) and MI350X (gfx950) GPUs only supports Ubuntu 24.04.3, Ubuntu 22.04.5, RHEL 10.0, RHEL 9.6, RHEL 9.4, Oracle Linux 10, and Oracle Linux 9.
.. [#RDNA-OS-700] **For ROCm 7.0.x** - AMD Radeon PRO AI PRO R9700 (gfx1201), AMD Radeon RX 9070 XT (gfx1201), AMD Radeon RX 9070 GRE (gfx1201), AMD Radeon RX 9070 (gfx1201), AMD Radeon RX 9060 XT (gfx1200), AMD Radeon RX 9060 (gfx1200), AMD Radeon RX 7800 XT (gfx1101), AMD Radeon RX 7700 XT (gfx1101), AMD Radeon PRO W7700 (gfx1101), and AMD Radeon PRO W6800 (gfx1030) only supports Ubuntu 24.04.3, Ubuntu 22.04.5, RHEL 10.0, and RHEL 9.6.
.. [#rd-v710] **For ROCm 7.0.x** - AMD Radeon PRO V710 (gfx1101) GPUs only supports Ubuntu 24.04.3, Ubuntu 22.04.5, RHEL 10.0, RHEL 9.6, and Azure Linux 3.0.
.. [#rd-v620] **For ROCm 7.0.x** - AMD Radeon PRO V620 (gfx1030) GPUs only supports Ubuntu 24.04.3 and Ubuntu 22.04.5.
.. [#mi325x-os-710] **For ROCm 7.1.x** - AMD Instinct MI325X GPUs (gfx942) supports all listed :ref:`supported_distributions` except RHEL 8.10, Rocky 9, Azure Linux 3.0, and Oracle Linux 8.
.. [#mi325x-os] **For ROCm 7.0.x** - AMD Instinct MI325X GPUs (gfx942) only supports Ubuntu 24.04.3, Ubuntu 22.04.5, RHEL 9.6, and RHEL 9.4.
.. [#mi300x-os] **Starting ROCm 7.0.x** - AMD Instinct MI300X GPUs (gfx942) supports all listed :ref:`supported_distributions`.
.. [#mi300A-os] **Starting ROCm 7.0.x** - AMD Instinct MI300A GPUs (gfx942) supports all listed :ref:`supported_distributions` except on Debian 13, Azure Linux 3.0, Oracle Linux 10, Oracle Linux 9, and Oracle Linux 8.
.. [#mi200x-os] **For ROCm 7.0.x** - AMD Instinct MI200 Series GPUs (gfx90a) only supports Ubuntu 24.04.3, Ubuntu 22.04.5, RHEL 10.0, RHEL 9.6, RHEL 9.4, RHEL 8.10, SLES 15 SP7, and Debian 12.
.. [#mi100-710-os] **For ROCM 7.1.x** - AMD Instinct MI100 GPUs (gfx908) only supports Ubuntu 24.04.3, Ubuntu 22.04.5, RHEL 10.0, RHEL 9.6, RHEL 9.4, RHEL 8.10, and SLES 15 SP7.
.. [#mi100-os] **For ROCm 7.0.x** - AMD Instinct MI100 GPUs (gfx908) only supports Ubuntu 24.04.3, Ubuntu 22.04.5, RHEL 10.0, RHEL 9.6, RHEL 9.4, and RHEL 8.10.
.. [#tf-mi350] TensorFlow 2.17.1 is not supported on AMD Instinct MI350 Series GPUs. Use TensorFlow 2.19.1 or 2.18.1 with MI350 Series GPUs instead.
.. [#dgl_compat] DGL is supported only on ROCm 6.4.0.
.. [#llama-cpp_compat] llama.cpp is supported only on ROCm 7.0.0 and ROCm 6.4.x.
.. [#driver_patch] AMD GPU Driver (amdgpu) 30.10.1 is a quality release that resolves an issue identified in the 30.10 release. There are no other significant changes or feature additions in ROCm 7.0.1 from ROCm 7.0.0. AMD GPU Driver (amdgpu) 30.10.1 is compatible with ROCm 7.0.1 and ROCm 7.0.0.
.. [#kfd_support] As of ROCm 6.4.0, forward and backward compatibility between the AMD GPU Driver (amdgpu) and its user space software is provided up to a year apart. For earlier ROCm releases, the compatibility is provided for +/- 2 releases. The supported user space versions on this page were accurate as of the time of initial ROCm release. For the most up-to-date information, see the latest version of this information at `User and AMD GPU Driver support matrix <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/user-kernel-space-compat-matrix.html>`_.
.. [#ROCT-rocr] Starting from ROCm 6.3.0, the ROCT Thunk Interface is included as part of the ROCr runtime package.


.. _OS-kernel-versions:

Operating systems, kernel and Glibc versions
*********************************************

Use this lookup table to confirm which operating system and kernel versions are supported with ROCm.

.. csv-table::
   :header: "OS", "Version", "Kernel", "Glibc"
   :widths: 40, 20, 30, 20
   :stub-columns: 1

   `Ubuntu <https://ubuntu.com/about/release-cycle#ubuntu-kernel-release-cycle>`_, 24.04.3, "6.8 [GA], 6.14 [HWE]", 2.39
   ,,
   `Ubuntu <https://ubuntu.com/about/release-cycle#ubuntu-kernel-release-cycle>`_, 24.04.2, "6.8 [GA], 6.11 [HWE]", 2.39
   ,,
   `Ubuntu <https://ubuntu.com/about/release-cycle#ubuntu-kernel-release-cycle>`_, 22.04.5, "5.15 [GA], 6.8 [HWE]", 2.35
   ,,
   `Red Hat Enterprise Linux (RHEL 10) <https://access.redhat.com/articles/3078#RHEL9>`_, 10.0, 6.12.0-55, 2.39
   ,,
   `Red Hat Enterprise Linux (RHEL 9) <https://access.redhat.com/articles/3078#RHEL9>`_, 9.6, 5.14.0-570, 2.34
   ,9.5, 5.14+, 2.34
   ,9.4, 5.14.0-427, 2.34
   ,,
   `Red Hat Enterprise Linux (RHEL 8) <https://access.redhat.com/articles/3078#RHEL8>`_, 8.10, 4.18.0-553, 2.28
   ,,
   `SUSE Linux Enterprise Server (SLES) <https://www.suse.com/support/kb/doc/?id=000019587#SLE15SP4>`_, 15 SP7, 6.40-150700.51, 2.38
   ,15 SP6, "6.5.0+, 6.4.0", 2.38
   ,15 SP5, 5.14.21, 2.31
   ,,
   `Rocky Linux <https://wiki.rockylinux.org/rocky/version/>`_, 9, 5.14.0-570, 2.34
   ,,
   `Oracle Linux <https://blogs.oracle.com/scoter/post/oracle-linux-and-unbreakable-enterprise-kernel-uek-releases>`_, 10, 6.12.0 (UEK), 2.39
   ,9, 6.12.0 (UEK), 2.34
   ,8, 5.15.0 (UEK), 2.28
   ,,
   `Debian <https://www.debian.org/download>`_,13, 6.12, 2.35
   ,12, 6.1.0, 2.36
   ,,
   `Azure Linux <https://techcommunity.microsoft.com/blog/linuxandopensourceblog/azure-linux-3-0-now-in-preview-on-azure-kubernetes-service-v1-31/4287229>`_,3.0, 6.6.92, 2.38
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

   .. [#rhel-10-702-past-60] RHEL 10.0 and RHEL 9.6 are supported on all listed :ref:`supported_GPUs` except AMD Radeon PRO V620 GPU.
   .. [#rhel-94-702-past-60] RHEL 9.4 is supported on all AMD Instinct GPUs listed under :ref:`supported_GPUs`.
   .. [#rhel-700-past-60] **For ROCm 7.0.x** - RHEL 8.10 is supported only on AMD Instinct MI300X, MI300A, MI250X, MI250, MI210, and MI100 GPUs.
   .. [#sles-710-past-60] **For ROCm 7.1.x** - SLES 15 SP7 is supported only on AMD Instinct MI325X, MI300X, MI300A, MI250X, MI250, MI210, and MI100 GPUs.
   .. [#sles-db-700-past-60] **For ROCm 7.0.x** - SLES 15 SP7 and Debian 12 are supported only on AMD Instinct MI300X, MI300A, MI250X, MI250, and MI210 GPUs.
   .. [#ol-710-mi300x-past-60] **For ROCm 7.1.x** - Oracle Linux 10 and 9 are supported only on AMD Instinct MI355X, MI350X, MI325X, and MI300X GPUs. Oracle Linux 8 is supported only on AMD Instinct MI300X GPU.
   .. [#ol-700-mi300x-past-60] **For ROCm 7.0.x** - Oracle Linux 10 and 9 are supported only on AMD Instinct MI355X, MI350X, and MI300X GPUs. Oracle Linux 8 is supported only on AMD Instinct MI300X GPU.
   .. [#mi300x-past-60] **Prior ROCm 7.0.0** - Oracle Linux is supported only on AMD Instinct MI300X GPUs.
   .. [#db-710-mi300x-past-60] **For ROCm 7.1.x** - Debian 13 is supported only on AMD Instinct MI355X, MI350X, MI325X, and MI300X GPUs.
   .. [#db12-710-past-60] **For ROCm 7.1.x** - Debian 12 is supported only on AMD Instinct MI325X, MI300X, MI300A, MI250X, MI250, and MI210 GPUs.
   .. [#db-mi300x-past-60] **For ROCm 7.0.2** - Debian 13 is supported only on AMD Instinct MI300X GPUs.
   .. [#single-node-past-60] **Prior to ROCm 7.0.0** - Debian 12 is supported only on AMD Instinct MI300X GPUs for single-node functionality.
   .. [#az-mi300x-past-60] Starting from ROCm 6.4.0, Azure Linux 3.0 is supported only on AMD Instinct MI300X and AMD Radeon PRO V710 GPUs.
   .. [#az-mi300x-630-past-60] **Prior ROCm 6.4.0**- Azure Linux 3.0 is supported only on AMD Instinct MI300X GPUs.
   .. [#rl-700-past-60] Rocky Linux 9 is supported only on AMD Instinct MI300X and MI300A GPUs.
   .. [#mi350x-os-710-past-60] **For ROCm 7.1.x** - AMD Instinct MI355X (gfx950) and MI350X (gfx950) GPUs supports all listed :ref:`supported_distributions` except RHEL 8.10, SLES 15 SP7, Debian 12, Rocky 9, Azure Linux 3.0, and Oracle Linux 8.
   .. [#mi350x-os-700-past-60] **For ROCm 7.0.x** - AMD Instinct MI355X (gfx950) and MI350X (gfx950) GPUs only supports Ubuntu 24.04.3, Ubuntu 22.04.5, RHEL 9.6, RHEL 9.4, and Oracle Linux 9.
   .. [#RDNA-OS-700-past-60] **Starting ROCm 7.0.x** AMD Radeon PRO AI PRO R9700 (gfx1201), AMD Radeon RX 9070 XT (gfx1201), AMD Radeon RX 9070 GRE (gfx1201), AMD Radeon RX 9070 (gfx1201), AMD Radeon RX 9060 XT (gfx1200), AMD Radeon RX 9060 (gfx1200), AMD Radeon RX 7800 XT (gfx1101), AMD Radeon RX 7700 XT (gfx1101), AMD Radeon PRO W7700 (gfx1101), and AMD Radeon PRO W6800 (gfx1030) only supports Ubuntu 24.04.3, Ubuntu 22.04.5, RHEL 10.0, RHEL 9.6, and RHEL 9.4.
   .. [#RDNA-OS-past-60] **Prior ROCm 7.0.0** - Radeon AI PRO R9700, Radeon RX 9070 XT (gfx1201), Radeon RX 9060 XT (gfx1200), Radeon PRO W7700 (gfx1101), and Radeon RX 7800 XT (gfx1101) only supports Ubuntu 24.04.2, Ubuntu 22.04.5, RHEL 9.6, and RHEL 9.4.
   .. [#rd-v710-past-60] **Starting ROCm 7.0.x** - AMD Radeon PRO V710 (gfx1101) only supports Ubuntu 24.04.3, Ubuntu 22.04.5, RHEL 10.0, RHEL 9.6, and Azure Linux 3.0.
   .. [#rd-v620-past-60] **Starting ROCm 7.0.x** - AMD Radeon PRO V620 (gfx1030) only supports Ubuntu 24.04.3 and Ubuntu 22.04.5.
   .. [#mi325x-os-710past-60] **For ROCm 7.1.x** - AMD Instinct MI325X GPU (gfx942) supports all listed :ref:`supported_distributions` except RHEL 8.10, Rocky 9, Azure Linux 3.0, and Oracle Linux 8.
   .. [#mi325x-os-past-60] **For ROCm 7.0.x** - AMD Instinct MI325X GPU (gfx942) only supports Ubuntu 24.04.3, Ubuntu 22.04.5, RHEL 9.6, and RHEL 9.4.
   .. [#mi300x-os-past-60] **For ROCm 7.0.x** - AMD Instinct MI300X GPU (gfx942) supports all listed :ref:`supported_distributions`.
   .. [#mi300A-os-past-60] **Starting ROCm 7.0.x** - AMD Instinct MI300A GPUs (gfx942) supports all listed :ref:`supported_distributions` except on Debian 13, Azure Linux 3.0, Oracle Linux 10, Oracle Linux 9, and Oracle Linux 8.
   .. [#mi200x-os-past-60] **For ROCm 7.0.x** - AMD Instinct MI200 Series GPUs (gfx90a) only supports Ubuntu 24.04.3, Ubuntu 22.04.5, RHEL 10.0, RHEL 9.6, RHEL 9.4, RHEL 8.10, SLES 15 SP7, and Debian 12.
   .. [#mi100-710-os-past-60] **For ROCM 7.1.x** - AMD Instinct MI100 GPUs (gfx908) only supports Ubuntu 24.04.3, Ubuntu 22.04.5, RHEL 10.0, RHEL 9.6, RHEL 9.4, RHEL 8.10, and SLES 15 SP7.
   .. [#mi100-os-past-60] **For ROCm 7.0.x** - AMD Instinct MI100 GPU (gfx908) only supports Ubuntu 24.04.3, Ubuntu 22.04.5, RHEL 10.0, RHEL 9.6, RHEL 9.4, and RHEL 8.10.
   .. [#7700XT-OS-past-60] **Prior to ROCm 7.0.0** - Radeon RX 7700 XT (gfx1101) only supports Ubuntu 24.04.2 and RHEL 9.6.
   .. [#mi300_624-past-60] **For ROCm 6.2.4** - MI300X (gfx942) is supported on listed operating systems *except* Ubuntu 22.04.5 [6.8 HWE] and Ubuntu 22.04.4 [6.5 HWE].
   .. [#mi300_622-past-60] **For ROCm 6.2.2** - MI300X (gfx942) is supported on listed operating systems *except* Ubuntu 22.04.5 [6.8 HWE] and Ubuntu 22.04.4 [6.5 HWE].
   .. [#mi300_621-past-60] **For ROCm 6.2.1** - MI300X (gfx942) is supported on listed operating systems *except* Ubuntu 22.04.5 [6.8 HWE] and Ubuntu 22.04.4 [6.5 HWE].
   .. [#mi300_620-past-60] **For ROCm 6.2.0** - MI300X (gfx942) is supported on listed operating systems *except* Ubuntu 22.04.5 [6.8 HWE] and Ubuntu 22.04.4 [6.5 HWE].
   .. [#mi300_612-past-60] **For ROCm 6.1.2** - MI300A (gfx942) is supported on Ubuntu 22.04.4, RHEL 9.4, RHEL 9.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is supported only on Ubuntu 22.04.4 and Oracle Linux.
   .. [#mi300_611-past-60] **For ROCm 6.1.1** - MI300A (gfx942) is supported on Ubuntu 22.04.4, RHEL 9.4, RHEL 9.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is supported only on Ubuntu 22.04.4 and Oracle Linux.
   .. [#mi300_610-past-60] **For ROCm 6.1.0** - MI300A (gfx942) is supported on Ubuntu 22.04.4, RHEL 9.4, RHEL 9.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is supported only on Ubuntu 22.04.4.
   .. [#mi300_602-past-60] **For ROCm 6.0.2** - MI300A (gfx942) is supported on Ubuntu 22.04.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is supported only on Ubuntu 22.04.3.
   .. [#mi300_600-past-60] **For ROCm 6.0.0** - MI300A (gfx942) is supported on Ubuntu 22.04.3, RHEL 8.9, and SLES 15 SP5. MI300X (gfx942) is supported only on Ubuntu 22.04.3.
   .. [#tf-mi350-past-60] TensorFlow 2.17.1 is not supported on AMD Instinct MI350 Series GPUs. Use TensorFlow 2.19.1 or 2.18.1 with MI350 Series GPUs instead.
   .. [#verl_compat-past-60] verl is supported only on ROCm 6.2.0.
   .. [#stanford-megatron-lm_compat-past-60] Stanford Megatron-LM is supported only on ROCm 6.3.0.
   .. [#dgl_compat-past-60] DGL is supported only on ROCm 6.4.0.
   .. [#megablocks_compat-past-60] Megablocks is supported only on ROCm 6.3.0.
   .. [#taichi_compat-past-60] Taichi is supported only on ROCm 6.3.2.
   .. [#ray_compat-past-60] Ray is supported only on ROCm 6.4.1.
   .. [#llama-cpp_compat-past-60] llama.cpp is supported only on ROCm 7.0.0 and 6.4.x.
   .. [#flashinfer_compat-past-60] FlashInfer is supported only on ROCm 6.4.1.
   .. [#driver_patch-past-60] AMD GPU Driver (amdgpu) 30.10.1 is a quality release that resolves an issue identified in the 30.10 release. There are no other significant changes or feature additions in ROCm 7.0.1 from ROCm 7.0.0. AMD GPU Driver (amdgpu) 30.10.1 is compatible with ROCm 7.0.1 and ROCm 7.0.0.
   .. [#kfd_support-past-60] As of ROCm 6.4.0, forward and backward compatibility between the AMD GPU Driver (amdgpu) and its user space software is provided up to a year apart. For earlier ROCm releases, the compatibility is provided for +/- 2 releases. The supported user space versions on this page were accurate as of the time of initial ROCm release. For the most up-to-date information, see the latest version of this information at `User and AMD GPU Driver support matrix <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/user-kernel-space-compat-matrix.html>`_.
   .. [#ROCT-rocr-past-60] Starting from ROCm 6.3.0, the ROCT Thunk Interface is included as part of the ROCr runtime package.
   
