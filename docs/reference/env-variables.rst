.. meta::
    :description: Environment variables reference
    :keywords: AMD, ROCm, environment variables, environment, reference, settings

.. role:: cpp(code)
   :language: cpp

.. _env-variables-reference:

*************************************************************
ROCm environment variables
*************************************************************

ROCm provides a set of environment variables that allow users to configure and optimize their development
and runtime experience. These variables define key settings such as installation paths, platform selection,
and runtime behavior for applications running on AMD accelerators and GPUs.

This page outlines commonly used environment variables across different components of the ROCm software stack,
including HIP and ROCR-Runtime. Understanding these variables can help streamline software development and
execution in ROCm-based environments.

Commonly used environment variables
===================================

The table below provides an overview of key environment variables used in the ROCm software stack.
These variables configure various aspects of ROCm, such as specifying installation paths and
selecting the target platform for applications running on AMD accelerators and GPUs.

.. list-table::
    :header-rows: 1
    :widths: 70,30

    * - Environment variable
      - Value

    * - | ``HIP_DIR``
        | The path of the HIP SDK on Microsoft Windows. This variable is ignored, if ``HIP_PATH`` is set.
      - Default: ``C:/hip``

    * - | ``HIP_PATH``
        | The path of the HIP SDK on Microsoft Windows.
      - Default: ``C:/hip``

    * - | ``HIP_PLATFORM``
        | The platform targeted by HIP. If ``HIP_PLATFORM`` isn't set, then :doc:`HIPCC <hipcc:index>` attempts to auto-detect the platform, if it can find NVCC.
      - ``amd``, ``nvidia``

    * - | ``ROCM_PATH``
        | The path of the installed ROCm software stack on Linux.
      - Default: ``/opt/rocm``

HIP environment variables
=========================

The following tables list the HIP environment variables:

.. remote-content::
   :repo: ROCm/HIP
   :path: docs/data/env_variables_hip.rst
   :default_branch: docs/develop
   :tag_prefix: docs/

ROCR-Runtime environment variables
==================================

The following table lists the ROCR-Runtime environment variables:

.. remote-content::
   :repo: ROCm/ROCR-Runtime
   :path: runtime/docs/data/env_variables.rst
   :default_branch: amd-staging
   :tag_prefix: docs/

HIPCC environment variables
===========================

.. remote-content::
   :repo: ROCm/llvm-project
   :path: amd/hipcc/docs/env.rst
   :default_branch: amd-staging
   :start_line: 10
   :tag_prefix: docs/

Additional component environment variables
==========================================

Many ROCm libraries and tools define environment variables for specific tuning, debugging, or
behavioral control. The table below provides an overview and links to further documentation.

.. list-table::
   :header-rows: 1
   :widths: 40, 60

   * - Component
     - Documentation Link

   * - rocBLAS
     - `Link <https://rocm.docs.amd.com/projects/rocBLAS/en/latest/docs/ENV_VARIABLES.html>`_

   * - rocSPARSE
     - `Link <https://rocm.docs.amd.com/projects/rocSPARSE/en/latest/docs/ENV_VARIABLES.html>`_

   * - MIOpen
     - `Link <https://rocm.docs.amd.com/projects/MIOpen/en/latest/docs/ENV_VARIABLES.html>`_

   * - AMD SMI
     - `Link <#amd-smi-vars-detail>`_

   * - rocFFT
     - `Link <#rocfft-vars-detail>`_

   * - rocRAND
     - `Link <https://rocm.docs.amd.com/projects/rocRAND/en/latest/docs/USER_GUIDE.html#environment-variables>`_

   * - rocDecode
     - N/A

   * - rocTracer
     - `Link <https://rocm.docs.amd.com/projects/rocTracer/en/latest/docs/ENV_VAR.html>`_

   * - rocProfiler
     - `Link <https://rocm.docs.amd.com/projects/rocProfiler/en/latest/docs/ENVIRONMENT_VARIABLES.html>`_

Key single-variable details
===========================

This section provides detailed descriptions, in the standard format, for ROCm components
that feature a single, key environment variable (or a very minimal set) which is documented
directly on this page for convenience.

.. _amd-smi-vars-detail:

AMD SMI
-------

.. list-table::
    :header-rows: 1
    :widths: 70,30

    * - Environment variable
      - Value

    * - | ``ROCM_SMI_JSON_OUTPUT``
        | If set to ``1``, forces the ``rocm-smi`` command-line tool to produce output in JSON format,
        | overriding any command-line flags for output format. Useful for scripting.
      - | ``1`` (Enable JSON output)
        | Default: Not set (Output format determined by CLI flags or defaults to text).

.. _rocfft-vars-detail:

rocFFT
------

.. list-table::
    :header-rows: 1
    :widths: 70,30

    * - Environment variable
      - Value

    * - | ``ROCFFT_CACHE_PATH``
        | Specifies the directory path where rocFFT should store and look for pre-compiled kernel
        | caches (plans). Using a persistent cache can significantly reduce plan creation time
        | for repeated FFT configurations.
      - | *Path to a directory*
        | Default: Not set (Caching might occur in a temporary or default system location, or be disabled).
