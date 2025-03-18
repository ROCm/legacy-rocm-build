.. meta::
  :description: Supported data types of AMD GPUs and libraries in ROCm.
  :keywords: precision, data types, HIP types, int8, float8, float8 (E4M3),
             float8 (E5M2), bfloat8, float16, half, bfloat16, tensorfloat32,
             float, float32, float64, double, AMD data types, HIP data types,
             ROCm precision, ROCm data types

*************************************************************
Data types and precision support
*************************************************************

This topic lists the data types support on AMD GPUs, ROCm libraries along
with corresponding :doc:`HIP <hip:index>` data types.

Integral types
==============

The signed and unsigned integral types supported by ROCm are listed in
the following table.

.. list-table::
    :header-rows: 1
    :widths: 15,35,50

    *
      - Type name
      - HIP type
      - Description
    *
      - int8
      - ``int8_t``, ``uint8_t``
      - A signed or unsigned 8-bit integer
    *
      - int16
      - ``int16_t``, ``uint16_t``
      - A signed or unsigned 16-bit integer
    *
      - int32
      - ``int32_t``, ``uint32_t``
      - A signed or unsigned 32-bit integer
    *
      - int64
      - ``int64_t``, ``uint64_t``
      - A signed or unsigned 64-bit integer

.. _precision_support_floating_point_types:

Floating-point types
====================

The floating-point types supported by ROCm are listed in the following table.

.. image:: ../data/about/compatibility/floating-point-data-types.png
    :alt: Supported floating-point types

.. list-table::
    :header-rows: 1
    :widths: 15,25,60

    *
      - Type name
      - HIP type
      - Description
    *
      - float8 (E4M3)
      - | ``__hip_fp8_e4m3_fnuz``,
        | ``__hip_fp8_e4m3``
      - An 8-bit floating-point number with **S1E4M3** bit layout, as described in :doc:`low precision floating point types page <hip:reference/low_fp_types>`.
        The FNUZ variant has expanded range with no infinity or signed zero (NaN represented as negative zero),
        while the OCP variant follows the Open Compute Project specification.
    *
      - float8 (E5M2)
      - | ``__hip_fp8_e5m2_fnuz``,
        | ``__hip_fp8_e5m2``
      - An 8-bit floating-point number with **S1E5M2** bit layout, as described in :doc:`low precision floating point types page <hip:reference/low_fp_types>`.
        The FNUZ variant has expanded range with no infinity or signed zero (NaN represented as negative zero),
        while the OCP variant follows the Open Compute Project specification.

    *
      - float16
      - ``half``
      - A 16-bit floating-point number that conforms to the IEEE 754-2008
        half-precision storage format.
    *
      - bfloat16
      - ``bfloat16``
      - A shortened 16-bit version of the IEEE 754 single-precision storage
        format.
    *
      - tensorfloat32
      - Not available
      - A floating-point number that occupies 32 bits or less of storage,
        providing improved range compared to half (16-bit) format, at
        (potentially) greater throughput than single-precision (32-bit) formats.
    *
      - float32
      - ``float``
      - A 32-bit floating-point number that conforms to the IEEE 754
        single-precision storage format.
    *
      - float64
      - ``double``
      - A 64-bit floating-point number that conforms to the IEEE 754
        double-precision storage format.

.. note::

  * The float8 and tensorfloat32 types are internal types used in calculations
    in Matrix Cores and can be stored in any type of the same size.

  * CNDA3 natively supports FP8 FNUZ (E4M3 and E5M2), which differs from the customised
    FP8 format used in NVIDIA's H100
    (`FP8 Formats for Deep Learning <https://arxiv.org/abs/2209.05433>`_).

  * In some AMD documents and articles, float8 (E5M2) is referred to as bfloat8.

  * The :doc:`low precision floating point types page <hip:reference/low_fp_types>`
    describes how to use these types in HIP with examples.

Level of support definitions
============================

In the following sections, icons represent the level of support. These icons,
described in the following table, are also used in the library data type support
pages.

.. list-table::
    :header-rows: 1

    *
      - Icon
      - Definition

    *
      - NA
      - Not applicable

    *
      - ❌
      - Not supported

    *
      - ⚠️
      - Partial support

    *
      - ✅
      - Full support

.. note::

  * Full support means that the type is supported natively or with hardware
    emulation.

  * Native support means that the operations for that type are implemented in
    hardware. Types that are not natively supported are emulated with the
    available hardware. The performance of non-natively supported types can
    differ from the full instruction throughput rate. For example, 16-bit
    integer operations can be performed on the 32-bit integer ALUs at full rate;
    however, 64-bit integer operations might need several instructions on the
    32-bit integer ALUs.

  * Any type can be emulated by software, but this page does not cover such
    cases.

Data type support by hardware architecture
==========================================

AMD's GPU lineup spans multiple architecture generations:

* CDNA1 architecture: includes models such as MI100
* CDNA2 architecture: includes models such as MI210, MI250, and MI250X
* CDNA3 architecture: includes models such as MI300A, MI300X, and MI325X
* RDNA3 architecture: includes models such as RX 7900XT and RX 7900XTX
* RDNA4 architecture: includes models such as RX 9070 and RX 9070XT

HIP C++ type implementation support
-----------------------------------

The HIP C++ types available on different hardware platforms are listed in the
following table.

.. list-table::
    :header-rows: 1

    *
      - HIP C++ Type
      - CDNA1
      - CDNA2
      - CDNA3
      - RDNA3
      - RDNA4

    *
      - ``int8_t``, ``uint8_t``
      - ✅
      - ✅
      - ✅
      - ✅
      - ✅

    *
      - ``int16_t``, ``uint16_t``
      - ✅
      - ✅
      - ✅
      - ✅
      - ✅

    *
      - ``int32_t``, ``uint32_t``
      - ✅
      - ✅
      - ✅
      - ✅
      - ✅

    *
      - ``int64_t``, ``uint64_t``
      - ✅
      - ✅
      - ✅
      - ✅
      - ✅

    *
      - ``__hip_fp8_e4m3_fnuz``
      - ❌
      - ❌
      - ✅
      - ❌
      - ❌

    *
      - ``__hip_fp8_e5m2_fnuz``
      - ❌
      - ❌
      - ✅
      - ❌
      - ❌

    *
      - ``__hip_fp8_e4m3``
      - ❌
      - ❌
      - ❌
      - ❌
      - ✅

    *
      - ``__hip_fp8_e5m2``
      - ❌
      - ❌
      - ❌
      - ❌
      - ✅

    *
      - ``half``
      - ✅
      - ✅
      - ✅
      - ✅
      - ✅

    *
      - ``bfloat16``
      - ✅
      - ✅
      - ✅
      - ✅
      - ✅

    *
      - ``float``
      - ✅
      - ✅
      - ✅
      - ✅
      - ✅

    *
      - ``double``
      - ✅
      - ✅
      - ✅
      - ✅
      - ✅

.. note::

  Library support for specific data types is contingent upon hardware support.
  Even if a ROCm library indicates support for a particular data type, that type
  will only be fully functional if the underlying hardware architecture (as shown
  in the table above) also supports it. For example, fp8 types are only available
  on architectures shown with a checkmark in the relevant rows.

Compute units support
---------------------

The following table lists data type support for compute units.

.. tab-set::

  .. tab-item:: Integral types
    :sync: integral-type

    .. list-table::
      :header-rows: 1

      *
        - Type name
        - int8
        - int16
        - int32
        - int64
      *
        - CDNA1
        - ✅
        - ✅
        - ✅
        - ✅
      *
        - CDNA2
        - ✅
        - ✅
        - ✅
        - ✅
      *
        - CDNA3
        - ✅
        - ✅
        - ✅
        - ✅

      *
        - RDNA3
        - ✅
        - ✅
        - ✅
        - ✅

      *
        - RDNA4
        - ✅
        - ✅
        - ✅
        - ✅

  .. tab-item:: Floating-point types
    :sync: floating-point-type

    .. list-table::
      :header-rows: 1

      *
        - Type name
        - float8 (E4M3)
        - float8 (E5M2)
        - float16
        - bfloat16
        - tensorfloat32
        - float32
        - float64
      *
        - CDNA1
        - ❌
        - ❌
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅
      *
        - CDNA2
        - ❌
        - ❌
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅
      *
        - CDNA3
        - ❌
        - ❌
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅

      *
        - RDNA3
        - ❌
        - ❌
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅

      *
        - RDNA4
        - ❌
        - ❌
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅

Matrix core support
-------------------

The following table lists data type support for AMD GPU matrix cores.

.. tab-set::

  .. tab-item:: Integral types
    :sync: integral-type

    .. list-table::
      :header-rows: 1

      *
        - Type name
        - int8
        - int16
        - int32
        - int64
      *
        - CDNA1
        - ✅
        - ❌
        - ❌
        - ❌
      *
        - CDNA2
        - ✅
        - ❌
        - ❌
        - ❌
      *
        - CDNA3
        - ✅
        - ❌
        - ❌
        - ❌

      *
        - RDNA3
        - ✅
        - ❌
        - ❌
        - ❌

      *
        - RDNA4
        - ✅
        - ❌
        - ❌
        - ❌

  .. tab-item:: Floating-point types
    :sync: floating-point-type

    .. list-table::
      :header-rows: 1

      *
        - Type name
        - float8 (E4M3)
        - float8 (E5M2)
        - float16
        - bfloat16
        - tensorfloat32
        - float32
        - float64
      *
        - CDNA1
        - ❌
        - ❌
        - ✅
        - ✅
        - ❌
        - ✅
        - ❌
      *
        - CDNA2
        - ❌
        - ❌
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅
      *
        - CDNA3
        - ✅
        - ✅
        - ✅
        - ✅
        - ✅
        - ✅
        - ✅

      *
        - RDNA3
        - ❌
        - ❌
        - ✅
        - ✅
        - ❌
        - ❌
        - ❌

      *
        - RDNA4
        - ✅
        - ✅
        - ✅
        - ✅
        - ❌
        - ❌
        - ❌

Atomic operations support
-------------------------

The following table lists which data types are supported for atomic
operations on AMD GPUs. The atomics operation type behavior is affected by the
memory locations, memory granularity, or scope of operations. For detailed
various support of atomic read-modify-write (atomicRMW) operations collected on
the :ref:`Hardware atomics operation support <hw_atomics_operation_support>`
page.

.. tab-set::

  .. tab-item:: Integral types
    :sync: integral-type

    .. list-table::
      :header-rows: 1

      *
        - Type name
        - int8
        - int16
        - int32
        - int64
      *
        - CDNA1
        - ❌
        - ❌
        - ✅
        - ✅
      *
        - CDNA2
        - ❌
        - ❌
        - ✅
        - ✅
      *
        - CDNA3
        - ❌
        - ❌
        - ✅
        - ✅

      *
        - RDNA3
        - ❌
        - ❌
        - ✅
        - ✅

      *
        - RDNA4
        - ❌
        - ❌
        - ✅
        - ✅

  .. tab-item:: Floating-point types
    :sync: floating-point-type

    .. list-table::
      :header-rows: 1

      *
        - Type name
        - float8 (E4M3)
        - float8 (E5M2)
        - 2 x float16
        - 2 x bfloat16
        - tensorfloat32
        - float32
        - float64
      *
        - CDNA1
        - ❌
        - ❌
        - ✅
        - ✅
        - ❌
        - ✅
        - ❌
      *
        - CDNA2
        - ❌
        - ❌
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅
      *
        - CDNA3
        - ❌
        - ❌
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅

      *
        - RDNA3
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌
        - ✅
        - ❌

      *
        - RDNA4
        - ❌
        - ❌
        - ✅
        - ✅
        - ❌
        - ✅
        - ❌

.. note::

  You can emulate atomic operations using software for cases that are not
  natively supported. Software-emulated atomic operations have a high negative
  performance impact when they frequently access the same memory address.

Data type support in ROCm libraries
===================================

ROCm library support for int8, float8 (E4M3), float8 (E5M2), int16, float16,
bfloat16, int32, tensorfloat32, float32, int64, and float64 is listed in the
following tables.

Libraries input/output type support
-----------------------------------

The following tables list ROCm library support for specific input and output
data types. Refer to the corresponding library data type support page for a
detailed description.

.. tab-set::

  .. tab-item:: Integral types
    :sync: integral-type

    .. list-table::
      :header-rows: 1

      *
        - Library input/output data type name
        - int8
        - int16
        - int32
        - int64

      *
        - :doc:`Composable Kernel <composable_kernel:reference/Composable_Kernel_supported_scalar_types>`
        - ✅/✅
        - ❌/❌
        - ✅/✅
        - ❌/❌

      *
        - :doc:`hipCUB <hipcub:api-reference/data-type-support>`
        - ✅/✅
        - ✅/✅
        - ✅/✅
        - ✅/✅

      *
        - :doc:`hipRAND <hiprand:api-reference/data-type-support>`
        - NA/✅
        - NA/✅
        - NA/✅
        - NA/✅

      *
        - :doc:`hipSOLVER <hipsolver:reference/precision>`
        - ❌/❌
        - ❌/❌
        - ❌/❌
        - ❌/❌

      *
        - :doc:`hipSPARSELt <hipsparselt:reference/data-type-support>`
        - ✅/✅
        - ❌/❌
        - ❌/❌
        - ❌/❌

      *
        - :doc:`hipTensor <hiptensor:api-reference/api-reference>`
        - ❌/❌
        - ❌/❌
        - ❌/❌
        - ❌/❌

      *
        - :doc:`MIGraphX <amdmigraphx:reference/cpp>`
        - ✅/✅
        - ✅/✅
        - ✅/✅
        - ✅/✅

      *
        - :doc:`MIOpen <miopen:reference/datatypes>`
        - ⚠️/⚠️
        - ❌/❌
        - ⚠️/⚠️
        - ❌/❌

      *
        - :doc:`RCCL <rccl:api-reference/library-specification>`
        - ✅/✅
        - ❌/❌
        - ✅/✅
        - ✅/✅

      *
        - :doc:`rocFFT <rocfft:reference/api>`
        - ❌/❌
        - ❌/❌
        - ❌/❌
        - ❌/❌

      *
        -  :doc:`rocPRIM <rocprim:reference/data-type-support>`
        - ✅/✅
        - ✅/✅
        - ✅/✅
        - ✅/✅

      *
        - :doc:`rocRAND <rocrand:api-reference/data-type-support>`
        - NA/✅
        - NA/✅
        - NA/✅
        - NA/✅

      *
        - :doc:`rocSOLVER <rocsolver:reference/precision>`
        - ❌/❌
        - ❌/❌
        - ❌/❌
        - ❌/❌

      *
        - :doc:`rocThrust <rocthrust:data-type-support>`
        - ✅/✅
        - ✅/✅
        - ✅/✅
        - ✅/✅

      *
        - :doc:`rocWMMA <rocwmma:api-reference/api-reference-guide>`
        - ✅/✅
        - ❌/❌
        - ❌/✅
        - ❌/❌


  .. tab-item:: Floating-point types
    :sync: floating-point-type

    .. list-table::
      :header-rows: 1

      *
        - Library input/output data type name
        - float8 (E4M3)
        - float8 (E5M2)
        - float16
        - bfloat16
        - tensorfloat32
        - float32
        - float64

      *
        - :doc:`Composable Kernel <composable_kernel:reference/Composable_Kernel_supported_scalar_types>`
        - ✅/✅
        - ✅/✅
        - ✅/✅
        - ✅/✅
        - ❌/❌
        - ✅/✅
        - ✅/✅

      *
        - :doc:`hipCUB <hipcub:api-reference/data-type-support>`
        - ❌/❌
        - ❌/❌
        - ✅/✅
        - ✅/✅
        - ❌/❌
        - ✅/✅
        - ✅/✅

      *
        - :doc:`hipRAND <hiprand:api-reference/data-type-support>`
        - NA/❌
        - NA/❌
        - NA/✅
        - NA/❌
        - NA/❌
        - NA/✅
        - NA/✅

      *
        - :doc:`hipSOLVER <hipsolver:reference/precision>`
        - ❌/❌
        - ❌/❌
        - ❌/❌
        - ❌/❌
        - ❌/❌
        - ✅/✅
        - ✅/✅

      *
        - :doc:`hipSPARSELt <hipsparselt:reference/data-type-support>`
        - ✅/✅
        - ✅/✅
        - ✅/✅
        - ✅/✅
        - ❌/❌
        - ❌/❌
        - ❌/❌

      *
        - :doc:`hipTensor <hiptensor:api-reference/api-reference>`
        - ❌/❌
        - ❌/❌
        - ✅/✅
        - ✅/✅
        - ❌/❌
        - ✅/✅
        - ✅/✅

      *
        - :doc:`MIGraphX <amdmigraphx:reference/cpp>`
        - ✅/✅
        - ✅/✅
        - ✅/✅
        - ✅/✅
        - ✅/✅
        - ✅/✅
        - ✅/✅

      *
        - :doc:`MIOpen <miopen:reference/datatypes>`
        - ⚠️/⚠️
        - ⚠️/⚠️
        - ✅/✅
        - ⚠️/⚠️
        - ❌/❌
        - ✅/✅
        - ⚠️/⚠️

      *
        - :doc:`RCCL <rccl:api-reference/library-specification>`
        - ✅/✅
        - ✅/✅
        - ✅/✅
        - ✅/✅
        - ❌/❌
        - ✅/✅
        - ✅/✅

      *
        - :doc:`rocFFT <rocfft:reference/api>`
        - ❌/❌
        - ❌/❌
        - ✅/✅
        - ❌/❌
        - ❌/❌
        - ✅/✅
        - ✅/✅

      *
        - :doc:`rocPRIM <rocprim:reference/data-type-support>`
        - ❌/❌
        - ❌/❌
        - ✅/✅
        - ✅/✅
        - ❌/❌
        - ✅/✅
        - ✅/✅

      *
        - :doc:`rocRAND <rocrand:api-reference/data-type-support>`
        - NA/❌
        - NA/❌
        - NA/✅
        - NA/❌
        - NA/❌
        - NA/✅
        - NA/✅

      *
        - :doc:`rocSOLVER <rocsolver:reference/precision>`
        - ❌/❌
        - ❌/❌
        - ❌/❌
        - ❌/❌
        - ❌/❌
        - ✅/✅
        - ✅/✅

      *
        - :doc:`rocThrust <rocthrust:data-type-support>`
        - ❌/❌
        - ❌/❌
        - ⚠️/⚠️
        - ⚠️/⚠️
        - ❌/❌
        - ✅/✅
        - ✅/✅

      *
        - :doc:`rocWMMA <rocwmma:api-reference/api-reference-guide>`
        - ✅/❌
        - ✅/❌
        - ✅/✅
        - ✅/✅
        - ✅/✅
        - ✅/✅
        - ✅/✅

.. note::

  As random number generation libraries, rocRAND and hipRAND only specify output
  data types for the random values they generate, with no need for input data
  types.

hipDataType enumeration
-----------------------

The ``hipDataType`` enumeration defines data precision types and is primarily
used when the data reference itself does not include type information, such as
in ``void*`` pointers. This enumeration is mainly utilized in BLAS libraries.
The HIP type equivalents of the ``hipDataType`` enumeration are listed in the
following table with descriptions and values.

.. list-table::
    :header-rows: 1
    :widths: 25,25,10,40

    *
      - hipDataType
      - HIP type
      - Value
      - Description

    *
      - ``HIP_R_8I``
      - ``int8_t``
      - 3
      - 8-bit real signed integer.

    *
      - ``HIP_R_8U``
      - ``uint8_t``
      - 8
      - 8-bit real unsigned integer.

    *
      - ``HIP_R_16I``
      - ``int16_t``
      - 20
      - 16-bit real signed integer.

    *
      - ``HIP_R_16U``
      - ``uint16_t``
      - 22
      - 16-bit real unsigned integer.

    *
      - ``HIP_R_32I``
      - ``int32_t``
      - 10
      - 32-bit real signed integer.

    *
      - ``HIP_R_32U``
      - ``uint32_t``
      - 12
      - 32-bit real unsigned integer.

    *
      - ``HIP_R_32F``
      - ``float``
      - 0
      - 32-bit real single precision floating-point.

    *
      - ``HIP_R_64F``
      - ``double``
      - 1
      - 64-bit real double precision floating-point.

    *
      - ``HIP_R_16F``
      - ``half``
      - 2
      - 16-bit real half precision floating-point.

    *
      - ``HIP_R_16BF``
      - ``bfloat16``
      - 14
      - 16-bit real bfloat16 precision floating-point.

    *
      - ``HIP_R_8F_E4M3``
      - ``__hip_fp8_e4m3``
      - 28
      - 8-bit real float8 precision floating-point (OCP version).

    *
      - ``HIP_R_8F_E5M2``
      - ``__hip_fp8_e5m2``
      - 29
      - 8-bit real bfloat8 precision floating-point (OCP version).

    *
      - ``HIP_R_8F_E4M3_FNUZ``
      - ``__hip_fp8_e4m3_fnuz``
      - 1000
      - 8-bit real float8 precision floating-point (FNUZ version).

    *
      - ``HIP_R_8F_E5M2_FNUZ``
      - ``__hip_fp8_e5m2_fnuz``
      - 1001
      - 8-bit real bfloat8 precision floating-point (FNUZ version).

The full list of the ``hipDataType`` enumeration listed in `library_types.h <https://github.com/ROCm/hip/blob/amd-staging/include/hip/library_types.h>`_ .
