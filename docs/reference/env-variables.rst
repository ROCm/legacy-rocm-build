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

HIP environment variables
=========================

The following tables list the HIP environment variables.

GPU isolation variables
--------------------------------------------------------------------------------

.. remote-content::
   :repo: ROCm/rocm-systems
   :path: /projects/hip/docs/reference/env_variables/gpu_isolation_hip_env.rst
   :default_branch: develop
   :tag_prefix: docs/


Profiling variables
--------------------------------------------------------------------------------

.. remote-content::
   :repo: ROCm/rocm-systems
   :path: /projects/hip/docs/reference/env_variables/profiling_hip_env.rst
   :default_branch: develop
   :tag_prefix: docs/


Debug variables
--------------------------------------------------------------------------------

.. remote-content::
   :repo: ROCm/rocm-systems
   :path: /projects/hip/docs/reference/env_variables/debug_hip_env.rst
   :default_branch: develop
   :tag_prefix: docs/

Memory management related variables
--------------------------------------------------------------------------------

.. remote-content::
   :repo: ROCm/rocm-systems
   :path: /projects/hip/docs/reference/env_variables/memory_management_hip_env.rst
   :default_branch: develop
   :tag_prefix: docs/

Other useful variables
--------------------------------------------------------------------------------

.. remote-content::
   :repo: ROCm/rocm-systems
   :path: /projects/hip/docs/reference/env_variables/miscellaneous_hip_env.rst
   :default_branch: develop
   :tag_prefix: docs/

ROCR-Runtime environment variables
==================================

The following table lists the ROCR-Runtime environment variables:

.. remote-content::
   :repo: ROCm/rocm-systems
   :path: /projects/rocr-runtime/runtime/docs/data/env_variables.rst
   :default_branch: develop
   :tag_prefix: docs/

HIPCC environment variables
===========================

This topic provides descriptions of the HIPCC environment variables.

.. remote-content::
   :repo: ROCm/llvm-project
   :path: amd/hipcc/docs/env.rst
   :default_branch: amd-staging
   :start_line: 14
   :tag_prefix: docs/

Environment variables in ROCm libraries
=======================================

Many ROCm libraries define environment variables for specific tuning, debugging,
or behavioral control. The table below provides an overview and links to further
documentation.

.. list-table::
    :header-rows: 1
    :widths: 30, 70

    * - Library
      - Purpose of Environment Variables

    * - :doc:`hipBLASLt <hipblaslt:reference/env-variables>`
      - Manage logging, debugging, offline tuning, and stream-K configuration
        for hipBLASLt.

    * - :doc:`hipSPARSELt <hipsparselt:reference/env-variables>`
      - Control logging, debugging and performance monitoring of hipSPARSELt.

    * - :doc:`rocBLAS <rocblas:reference/env-variables>`
      - Performance tuning, kernel selection, logging, and debugging for BLAS
        operations.

    * - :doc:`rocSolver <rocsolver:reference/env_variables>`
      - Control logging of rocSolver.

    * - :doc:`rocSPARSE <rocsparse:reference/env_variables>`
      - Control logging of rocSPARSE.

    * - :doc:`MIGraphX <amdmigraphx:reference/MIGraphX-dev-env-vars>`
      - Control debugging, testing, and model performance tuning options for
        MIGraphX.

    * - :doc:`MIOpen <miopen:reference/env_variables>`
      - Control MIOpen logging and debugging, find mode and algorithm behavior
        and others.

    * - :doc:`MIVisionX <mivisionx:reference/MIVisionX-env-variables>`
      - Control core OpenVX, GPU/device and debugging/profiling, stitching and
        chroma key configurations, file I/O operations, model deployment, and
        neural network parameters of MIVisionX.

    * - :doc:`RCCL <rccl:api-reference/env-variables>`
      - Control the logging, debugging, compiler and assembly behavior, and
        cache of RPP.

    * - :doc:`RPP <rpp:reference/rpp-env-variables>`
      - Logging, debugging, compiler and assembly management, and cache control in RPP

    * - `Tensile <https://rocm.docs.amd.com/projects/Tensile/en/latest/src/reference/environment-variables.html>`_
      - Enable testing, debugging, and experimental features for Tensile clients and applications

Key single-variable details
===========================

This section provides detailed descriptions, in the standard format, for ROCm
libraries that feature a single, key environment variable (or a very minimal set)
which is documented directly on this page for convenience.

.. _rocalution-vars-detail:

rocALUTION
----------

.. list-table::
    :header-rows: 1
    :widths: 70,30

    * - Environment variable
      - Value

    * - | ``ROCALUTION_LAYER``
        | If set to ``1``, enable file logging. Logs each rocALUTION function call including object constructor/destructor, address of the object, memory allocation, data transfers, all function calls for matrices, vectors, solvers, and preconditioners. The log file is placed in the working directory.
      - | ``1`` (Enable trace file logging)
        | Default: Not set.
