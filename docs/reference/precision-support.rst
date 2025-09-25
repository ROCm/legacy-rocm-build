.. meta::
  :description: Supported data types of AMD GPUs and libraries in ROCm.
  :keywords: precision, data types, HIP types, int8, float8, float8 (E4M3),
             float8 (E5M2), bfloat8, float16, half, bfloat16, tensorfloat32,
             float, float32, float64, double, AMD data types, HIP data types,
             ROCm precision, ROCm data types

*************************************************************
Data types and precision support
*************************************************************

This topic summarizes the data types supported on AMD GPUs and accelerators and
ROCm libraries, along with corresponding :doc:`HIP <hip:index>` data types.

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
      - float4 (E2M1)
      - | ``__hip_fp4_e2m1``
      - A 4-bit floating-point number with **E2M1** bit layout, as described
        in :doc:`low precision floating point types page <hip:reference/low_fp_types>`.

    *
      - float6 (E3M2)
      - | ``__hip_fp6_e3m2``
      - A 6-bit floating-point number with **E3M2** bit layout, as described
        in :doc:`low precision floating point types page <hip:reference/low_fp_types>`.

    *
      - float6 (E2M3)
      - | ``__hip_fp6_e2m3``
      - A 6-bit floating-point number with **E2M3** bit layout, as described
        in :doc:`low precision floating point types page <hip:reference/low_fp_types>`.

    *
      - float8 (E4M3)
      - | ``__hip_fp8_e4m3_fnuz``,
        | ``__hip_fp8_e4m3``
      - An 8-bit floating-point number with **E4M3** bit layout, as described in :doc:`low precision floating point types page <hip:reference/low_fp_types>`.
        The FNUZ variant has expanded range with no infinity or signed zero (NaN represented as negative zero),
        while the OCP variant follows the Open Compute Project specification.

    *
      - float8 (E5M2)
      - | ``__hip_fp8_e5m2_fnuz``,
        | ``__hip_fp8_e5m2``
      - An 8-bit floating-point number with **E5M2** bit layout, as described in :doc:`low precision floating point types page <hip:reference/low_fp_types>`.
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

  * CDNA3 natively supports FP8 FNUZ (E4M3 and E5M2), which differs from the customized
    FP8 format used with NVIDIA H100
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

* CDNA1 such as MI100
* CDNA2 such as MI210, MI250, and MI250X
* CDNA3 such as MI300A, MI300X, and MI325X
* CDNA4 such as MI350X and MI355X
* RDNA2 such as PRO W6800 and PRO V620
* RDNA3 such as RX 7900XT and RX 7900XTX
* RDNA4 such as RX 9070 and RX 9070XT

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
      - CDNA4
      - RDNA2
      - RDNA3
      - RDNA4

    *
      - ``int8_t``, ``uint8_t``
      - ✅
      - ✅
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
      - ✅
      - ✅

    *
      - ``int32_t``, ``uint32_t``
      - ✅
      - ✅
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
      - ✅
      - ✅

    *
      - ``__hip_fp4_e2m1``
      - ❌
      - ❌
      - ❌
      - ✅
      - ❌
      - ❌
      - ❌

    *
      - ``__hip_fp6_e2m3``
      - ❌
      - ❌
      - ❌
      - ✅
      - ❌
      - ❌
      - ❌

    *
      - ``__hip_fp6_e3m2``
      - ❌
      - ❌
      - ❌
      - ✅
      - ❌
      - ❌
      - ❌

    *
      - ``__hip_fp8_e4m3_fnuz``
      - ❌
      - ❌
      - ✅
      - ❌
      - ❌
      - ❌
      - ❌

    *
      - ``__hip_fp8_e5m2_fnuz``
      - ❌
      - ❌
      - ✅
      - ❌
      - ❌
      - ❌
      - ❌

    *
      - ``__hip_fp8_e4m3``
      - ❌
      - ❌
      - ❌
      - ✅
      - ❌
      - ❌
      - ✅

    *
      - ``__hip_fp8_e5m2``
      - ❌
      - ❌
      - ❌
      - ✅
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
      - ✅
      - ✅

    *
      - ``bfloat16``
      - ✅
      - ✅
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
      - ✅
      - ✅

    *
      - ``double``
      - ✅
      - ✅
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
        - CDNA4
        - ✅
        - ✅
        - ✅
        - ✅

      *
        - RDNA2
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

  .. tab-item:: Low precision floating-point types
    :sync: floating-point-type-low

    .. list-table::
      :header-rows: 1

      *
        - Type name
        - float4
        - float6 (E2M3)
        - float6 (E3M2)
        - float8 (E4M3)
        - float8 (E5M2)

      *
        - CDNA1
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

      *
        - CDNA2
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

      *
        - CDNA3
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

      *
        - CDNA4
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

      *
        - RDNA2
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

      *
        - RDNA3
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

      *
        - RDNA4
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

  .. tab-item:: High precision floating-point types
    :sync: floating-point-type-high

    .. list-table::
      :header-rows: 1

      *
        - Type name
        - float16
        - bfloat16
        - tensorfloat32
        - float32
        - float64

      *
        - CDNA1
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅

      *
        - CDNA2
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅

      *
        - CDNA3
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅

      *
        - CDNA4
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅

      *
        - RDNA2
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅

      *
        - RDNA3
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅

      *
        - RDNA4
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
        - CDNA4
        - ✅
        - ❌
        - ❌
        - ❌

      *
        - RDNA2
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

  .. tab-item:: Low precision floating-point types
    :sync: floating-point-type-low

    .. list-table::
      :header-rows: 1

      *
        - Type name
        - float4
        - float6 (E2M3)
        - float6 (E3M2)
        - float8 (E4M3)
        - float8 (E5M2)

      *
        - CDNA1
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

      *
        - CDNA2
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

      *
        - CDNA3
        - ❌
        - ❌
        - ❌
        - ✅
        - ✅

      *
        - CDNA4
        - ✅
        - ✅
        - ✅
        - ✅
        - ✅

      *
        - RDNA2
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

      *
        - RDNA3
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

      *
        - RDNA4
        - ❌
        - ❌
        - ❌
        - ✅
        - ✅

  .. tab-item:: High precision floating-point types
    :sync: floating-point-type-high

    .. list-table::
      :header-rows: 1

      *
        - Type name
        - float16
        - bfloat16
        - tensorfloat32
        - float32
        - float64

      *
        - CDNA1
        - ✅
        - ✅
        - ❌
        - ✅
        - ❌

      *
        - CDNA2
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

      *
        - CDNA4
        - ✅
        - ✅
        - ✅
        - ✅
        - ✅

      *
        - RDNA2
        - ✅
        - ✅
        - ❌
        - ❌
        - ❌

      *
        - RDNA3
        - ✅
        - ✅
        - ❌
        - ❌
        - ❌

      *
        - RDNA4
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

  .. tab-item:: Low precision floating-point types
    :sync: floating-point-type-low

    .. list-table::
      :header-rows: 1

      *
        - Type name
        - float4
        - float6 (E2M3)
        - float6 (E3M2)
        - float8 (E4M3)
        - float8 (E5M2)

      *
        - CDNA1
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

      *
        - CDNA2
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

      *
        - CDNA3
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

      *
        - CDNA4
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

      *
        - RDNA2
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

      *
        - RDNA3
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

      *
        - RDNA4
        - ❌
        - ❌
        - ❌
        - ❌
        - ❌

  .. tab-item:: High precision floating-point types
    :sync: floating-point-type-high

    .. list-table::
      :header-rows: 1

      *
        - Type name
        - 2 x float16
        - 2 x bfloat16
        - tensorfloat32
        - float32
        - float64

      *
        - CDNA1
        - ✅
        - ✅
        - ❌
        - ✅
        - ❌

      *
        - CDNA2
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅

      *
        - CDNA3
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅

      *
        - CDNA4
        - ✅
        - ✅
        - ❌
        - ✅
        - ✅

      *
        - RDNA2
        - ❌
        - ❌
        - ❌
        - ✅
        - ❌

      *
        - RDNA3
        - ❌
        - ❌
        - ❌
        - ✅
        - ❌

      *
        - RDNA4
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
data types. Select a library from the below table to view the supported data
types.

.. datatemplate:yaml:: /data/reference/precision-support/precision-support.yaml

    {% set library_groups = data.library_groups %}

    .. raw:: html

        <div id="vllm-benchmark-ud-params-picker" class="container-fluid">
            <div class="row">
                <div class="col-2 me-2 model-param-head">Category</div>
                <div class="row col-10">
    {% for group in library_groups %}
                    <div class="col-6 model-param" data-param-k="model-group" data-param-v="{{ group.tag }}" tabindex="0">{{ group.group }}</div>
    {% endfor %}
                </div>
            </div>

            <div class="row mt-1">
                <div class="col-2 me-2 model-param-head">Library</div>
                <div class="row col-10">
    {% for group in library_groups %}
        {% for library in group.libraries %}
                    <div class="col-6 model-param" data-param-k="model" data-param-v="{{ library.tag }}" data-param-group="{{ group.tag }}" tabindex="0">{{ library.name }}</div>
        {% endfor %}
    {% endfor %}
                </div>
            </div>
        </div>

    {% for group in library_groups %}
        {% for library in group.libraries %}

    .. container:: model-doc {{ library.tag }}

        For more information, please visit :doc:`{{ library.name }} <{{ library.doc_link }}>`.

        .. list-table::
            :header-rows: 1
            :widths: 70, 30

            *
                - Data Type
                - Support
    {% for data_type in library.data_types %}
            *
                - {{ data_type.type }}
                - {{ data_type.support }}
    {% endfor %}

        {% endfor %}
    {% endfor %}

.. note::

  The meaning of partial support depends on the library. Please refer to the individual
  libraries' documentation for more information.

.. note::

  As random number generation libraries, rocRAND and hipRAND only specify output
  data types for the random values they generate, with no need for input data
  types.

.. note::

  hipBLASLt supports additional data types as internal compute types, which may
  differ from the supported input/output types shown in the tables above. While
  TensorFloat32 is not supported as an input or output type in this library, it
  is available as an internal compute type. For complete details on supported
  compute types, refer to the :doc:`hipBLASLt <hipblaslt:reference/data-type-support>`
  documentation.

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
      - ``HIP_R_6F_E2M3``
      - ``__hip_fp6_e2m3``
      - 31
      - 6-bit real float6 precision floating-point.

    *
      - ``HIP_R_6F_E3M2``
      - ``__hip_fp6_e3m2``
      - 32
      - 6-bit real bfloat6 precision floating-point.

    *
      - ``HIP_R_4F_E2M1``
      - ``__hip_fp4_e2m1``
      - 33
      - 4-bit real float4 precision floating-point.

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

The full list of the ``hipDataType`` enumeration listed in `library_types.h <https://github.com/ROCm/hip/blob/amd-staging/include/hip/library_types.h>`_.
