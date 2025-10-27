.. meta::
   :description: AMD Instinct GPU, AMD Radeon PRO, and AMD Radeon GPU
                 atomics operations information
   :keywords: Atomics operations, atomic bitwise functions, atomics add, atomics
              subtraction, atomics exchange, atomics min, atomics max

.. _hw_atomics_operation_support:

Hardware atomics operation support
================================================================================

:ref:`Atomic operations <atomic functions>` guarantee that the operation is
completed as an indivisible unit, preventing race conditions where simultaneous
access to the same memory location could lead to incorrect or undefined
behavior.

This topic summarizes the support of atomic read-modify-write
(atomicRMW) operations on AMD GPUs. This includes gfx9, gfx10,
gfx11, and gfx12 targets and the following Instinct™ Series:

- MI100

- MI200

- MI300

- MI350 

The atomics operation type behavior is affected by the memory locations, memory
granularity, and scope of operations.

Memory locations:

- :ref:`Device memory <hip:device_memory>`, that is, VRAM, the RAM on a discrete
  GPU device or in framebuffer carveout for APUs. This includes peer-device
  memory within an Infinity Fabric™ hive.

- :ref:`Host memory <hip:host_memory>`: in DRAM associated with the CPU (or
  peer device memory using PCIe® (PCI Express) peer-to-peer). This can be two sub-types:

  - Migratable memory: memory that is currently residing in host DRAM, but
    which can be migrated back to device memory. For example,
    ``hipMallocManaged()`` or :ref:`unified memory <hip:unified_memory>`
    allocations.

  - :ref:`Pinned memory <hip:pinned_host_memory>`: memory that is in host memory
    and cannot be migrated to the device (not necessarily pinned to a particular
    physical address, but can't be moved to device memory). ``hipHostMalloc()``,
    for example.

Memory granularity or :ref:`coherence <hip:coherence_control>`:

- Coarse-grained memory

  - This memory can be used for device-scope synchronization during the
    execution of a single GPU kernel. Any system-scope atomics sent to this type
    of memory will not achieve system-scope coherency and will instead be
    downgraded to device-scope as per the programming model.

  - This type of memory only available on AMD GPUs.

- Fine-grained memory

  - This memory can be used for device and system-scope synchronization during
    the execution of a single GPU kernel.

Scopes of operations:

- Device-scope or agent-scope

  - This atomic should happen atomically from the point of view of every thread
    within the device that the atomic-executing thread is in.

- System-scope

  - This atomic should happen atomically from the point of view of every thread
    in all devices and in the CPUs.

Support summary
================================================================================

AMD Instinct GPUs
--------------------------------------------------------------------------------

**MI300 and MI350 Series**

- All atomicRMW operations are forwarded out to the Infinity Fabric.
- Infinity Fabric supports common integer and bitwise atomics, FP32 atomic add,
  packed-FP16 atomic add, packed-BF16 atomic add, and FP64 add, min, and max.
- In discrete GPUs (dGPUs), if the data is stored in host memory, the atomic
  will be forwarded from the Infinity Fabric to PCIe.
- If the PCIe bus does not support the requested atomic, the GPU's PCIe
  controller changes it into a load-op-store sequence. All waves on the chip
  submitting atomics to that address will stall waiting for the load-op-store.
  It will seem like atomics to the wave, but the CPU sees it as a non-atomic
  load-op-store sequence. This downgrades system-scope atomics to device-scope.

**MI200 Series**

- L2 cache and Infinity Fabric both support common integer and bitwise atomics.
- L2 cache supports FP32 atomic add, packed-FP16 atomic add, and FP64 add,
  min, and max.
- The Infinity Fabric does not support FP32 atomic add, packed-FP16 atomic add,
  and FP64 add, min, and max atomics and these commands cannot be sent to the
  Infinity Fabric.
- Coarse-grained memory is marked as cacheable, and atomic operations will be
  processed in the L2 cache.
- Fine-grained memory is marked write-uncacheable through the page tables.
- Atomics that hit write-uncached memory are forwarded to the Infinity Fabric.
- If the uncached data is stored in host memory on a PCIe system, the atomic
  will be forwarded from Infinity Fabric to PCIe. Any atomic not supported by
  the PCIe bus will be a NOP and give incorrect result.
- If the uncached data is stored in host memory on an A+A system (system with
  AMD CPU and AMD GPU connected via Infinity Fabric), the atomic operation will
  be forwarded to the remote location and will succeed if supported by Infinity
  Fabric.
- If the float atomics access write-uncached memory, they cannot be forwarded to
  the Infinity Fabric, resulting in a NOP and an incorrect outcome.

**MI100**

- L2 cache and Infinity Fabric both support common integer and bitwise atomics.
- L2 cache supports no returns (NoReturn) versions of packed-FP16 and FP32
  atomic adds, that cannot return data.
- The Infinity Fabric does not support packed-FP16 or FP32 atomic adds,
  preventing these commands from being transmitted through it.
- Coarse-grained memory is marked as cacheable, and atomic operations will be
  processed in the L2 cache.
- Fine-grained memory is marked uncacheable through the page tables.
- Atomics that hit uncached memory are forwarded to the Infinity Fabric.
- If the uncached data is stored in host memory, the atomic will be forwarded
  from Infinity Fabric to PCIe. Any atomic not supported by the PCIe bus will
  be a NOP and give incorrect result.
- If an float atomic add hits uncached memory, it cannot be forwarded to the
  Infinity Fabric so it will NOP and give incorrect result.

AMD gfx generic targets
--------------------------------------------------------------------------------

**gfx9**

- L2 cache and Infinity Fabric both support common integer and bitwise atomics.
- Coarse-grained memory is marked as cacheable, and atomic operations will be
  processed in the L2 cache.
- Fine-grained memory is marked uncacheable through the page tables.
- Atomics that hit uncached memory are forwarded to the Infinity Fabric.
- In a dGPU: if the uncached data is stored in host memory, the atomic will be
  forwarded from Infinity Fabric to PCIe. Any atomic not supported by the PCIe
  bus will be a NOP and.

**gfx10**

- L2 cache and Infinity Fabric both support common integer and bitwise atomics.
- Coarse-grained memory is marked as cacheable, and atomic operations will be
  processed in the L2 cache.
- Fine-grained memory is marked uncacheable through the page tables.
- Atomics that hit uncached memory are forwarded to the Infinity Fabric.
- In a dGPU: if the uncached data is stored in host memory, the atomic will be
  forwarded from Infinity Fabric to PCIe. Any atomic not supported by the PCIe
  bus will be a NOP and give incorrect result.
- Supports floating-point atomic min/max.
- The Infinity Fabric does not support floating-point atomic min/max atomics
  and these commands cannot be sent to the Infinity Fabric.
- If the floating-point atomics hit uncached memory, they cannot be forwarded to
  the Infinity Fabric, so they will NOP and give incorrect result.

**gfx11**

- L2 cache and Infinity Fabric both support common integer and bitwise atomics.
- L2 cache supports FP32 atomic add, min and max.
- The Infinity Fabric does not support FP32 atomic add, min and max atomics and
  these commands cannot be sent to the Infinity Fabric.
- Coarse-grained memory is marked as cacheable, and atomic operations will be
  processed in the L2 cache.
- Fine-grained memory is marked uncacheable through the page tables.
- Atomics that hit write-uncached memory are forwarded to the Infinity Fabric.
- In a dGPU: if the uncached data is stored in host memory, the atomic will be
  forwarded from Infinity Fabric to PCIe. Any atomic not supported by the PCIe
  bus will be a NOP and give incorrect result.
- If the float atomics hit uncached memory, they cannot be forwarded to the
  Infinity Fabric, so they will NOP and give incorrect result.

**gfx12**

- L2 cache and Infinity Fabric both support common integer and bitwise atomics.

- L2 cache and Infinity Fabric both also support FP32 atomic add, min and max,
  and packed-FP16 atomic add, and packed-BF16 atomic add.

- Coarse-grained memory is marked as cacheable, and atomic operations will be
  processed in the L2 cache.

- Fine-grained device memory is marked uncacheable through the page tables.

  - Atomics that hit write-uncached memory are forwarded to the Infinity Fabric.

- Fine-grained system memory is marked as cacheable through the page tables.

  - Device-scope atomic operations will process in the L2 cache.

  - System-scope atomic operations will bypass the L2 cache and be forwarded to
    the Infinity Fabric.

- Atomics that hit write-uncached memory are forwarded to the Infinity Fabric.

- In dGPUs, if the data is stored in host memory, the atomic will be forwarded
  from the Infinity Fabric to PCIe.

- If the PCIe bus does not support the requested atomic, the GPU's PCIe
  controller changes it into a load-op-store sequence. All waves on the chip
  submitting atomics to that address will stall waiting for the load-op-store.
  It will seem like atomics to the wave, but the CPU sees it as a non-atomic
  load-op-store sequence. This downgrades system-scope atomics to device-scope.

GPUs atomics support
================================================================================

This section presents a series of tables that show the level of atomic
operations support for the different hardware devices described above, and
different datatypes, different operations and different scopes.

Hardware atomics support refers to the ability of GPUs to natively perform
atomic operations—special low-level operations that ensure data consistency when
multiple threads access and modify memory concurrently.

CAS (Compare-and-Swap) atomic support refers to the hardware or software
capability to perform an atomic Compare-and-Swap operation.

PCIe atomics are a feature of the PCIe interface that enable
atomic operations between devices and hosts across the PCIe bus. For further
information, please check `How ROCm uses PCIe atomics <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/conceptual/pcie-atomics.html>`_.

The tables that follow show the correctness of atomics operations on the
hardware using the following notations:

- ✅: Produces the correct answer.

- ⚠️: Produces the correct answer, but works only at a weaker scope.

- ❌: The atomics operation fails.

The tables show the different types of atomic operations used by specific
devices:

- Native: Computes the correct result using a hardware-native atomic
  instruction.

- CAS: Generates the correct result, but the atomic operation is implemented by
  the compiler for this ISA using a compare-and-swap emulation loop.

- ✅ NoReturn: Produces the correct correct result but does not precisely
  conform to the atomic API.

- Scope Downgrade: Generates the correct result but operates at a weaker scope
  than requested. For example, if a user specifies a system-scope atomic, the
  operation may only function at the device scope.

- NOP: The atomic operation is not executed on the target location, and the
  requesting thread receives back 0 as a return value.

- n/a: The atomic type is not supported and cannot be executed on the specific
  hardware.

The tables selectors or options are the following:

- Highest level option:

  - "HW atomics", where software attempts to use hardware atomics.

  - "CAS emulation", where software attempts to use CAS emulation.

- Second-level option:

  - "No PCIe atomics" means the system does not support PCIe atomics between
    the GPU and peer/host-memory.

  - "PCIe atomics" means the system supports PCIe atomics between the
    GPU and peer/host-memory.

- The third-level option is the memory granularity of the memory target.

- The final option is the scope of atomic access.

Integer atomics operations
--------------------------------------------------------------------------------

The integer type atomic operations that are supported by different hardware.

- 32 bit integer

  - Add

  - Subtract

  - Min

  - Max

  - IncDec

- 64 bit integer

  - Add

  - Min

  - Max

AMD Instinct GPUs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The integer type atomic operations that are supported by different AMD
Instinct GPUs listed in the following table.

.. <!-- spellcheck-disable -->

.. The relative path not working in datatemplate, that's why we also need the absolute path of docs folder.

.. datatemplate:nodata::

  {% set ns = namespace(offset=2, previous_csv='') %}

  .. tab-set::
    {% for (atomics_type_text, atomics_type_key) in config.html_context['atomics_type'] %}
    .. tab-item:: {{ atomics_type_text }}
      :sync: {{ atomics_type_key }}

      .. tab-set::
        {% for (pcie_type_text, pcie_type_key) in config.html_context['pcie_type'] %}
        .. tab-item:: {{ pcie_type_text }}
          :sync: {{ pcie_type_key }}

          .. tab-set::
            {% for (memory_type_text, memory_type_key) in config.html_context['memory_type'] %}
            .. tab-item:: {{ memory_type_text }}
              :sync: {{ memory_type_key }}

              .. tab-set::
                {% for (granularity_type_text, granularity_type_key) in config.html_context['granularity_type'] %}
                .. tab-item:: {{ granularity_type_text }}
                  :sync: {{ granularity_type_key }}

                  .. tab-set::
                    {% for (scope_type_text, scope_type_key) in config.html_context['scope_type'] %}
                    .. tab-item:: {{ scope_type_text }}
                      :sync: {{ scope_type_key }}

                      {# Build the CSV file path for this branch #}
                      {% set current_csv = "data/reference/gpu-atomics-operation/"
                          ~ atomics_type_key ~ "_" ~ pcie_type_key ~ "_instinct.csv" %}
                      {# If we have a new CSV file, reset the offset #}
                      {% if current_csv != ns.previous_csv %}
                        {% set ns.offset = 2 %}
                      {% endif %}
                      {% set ns.previous_csv = current_csv %}

                      {# Compute the row numbers for this leaf #}
                      {% set start = ns.offset %}
                      {% set end   = ns.offset + 8 %}

                      .. csv-to-list-table::
                        :file: {{ current_csv }}
                        :rows: {{ start }}-{{ end }}

                      {# Update the offset: block (9 rows) plus gap (18 rows) #}
                      {% set ns.offset = ns.offset + 9 + 18 %}

                    {% endfor %}
                  {% endfor %}
              {% endfor %}
          {% endfor %}
      {% endfor %}

.. <!-- spellcheck-enable -->

AMD gfx generic targets
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The integer type atomic operations that are supported by different gfx generic
targets listed in the following table.

.. <!-- spellcheck-disable -->

.. The relative path not working in datatemplate, that's why we also need the absolute path of docs folder.

.. datatemplate:nodata::

  {% set ns = namespace(offset=2, previous_csv='') %}

  .. tab-set::
    {% for (atomics_type_text, atomics_type_key) in config.html_context['atomics_type'] %}
    .. tab-item:: {{ atomics_type_text }}
      :sync: {{ atomics_type_key }}

      .. tab-set::
        {% for (pcie_type_text, pcie_type_key) in config.html_context['pcie_type'] %}
        .. tab-item:: {{ pcie_type_text }}
          :sync: {{ pcie_type_key }}

          .. tab-set::
            {% for (memory_type_text, memory_type_key) in config.html_context['memory_type'] %}
            .. tab-item:: {{ memory_type_text }}
              :sync: {{ memory_type_key }}

              .. tab-set::
                {% for (granularity_type_text, granularity_type_key) in config.html_context['granularity_type'] %}
                .. tab-item:: {{ granularity_type_text }}
                  :sync: {{ granularity_type_key }}

                  .. tab-set::
                    {% for (scope_type_text, scope_type_key) in config.html_context['scope_type'] %}
                    .. tab-item:: {{ scope_type_text }}
                      :sync: {{ scope_type_key }}

                      {# Build the CSV file path for this branch #}
                      {% set current_csv = "data/reference/gpu-atomics-operation/"
                          ~ atomics_type_key ~ "_" ~ pcie_type_key ~ "_gfx.csv" %}
                      {# If we switch CSV files, reset the offset to 2 (to skip the header row) #}
                      {% if current_csv != ns.previous_csv %}
                        {% set ns.offset = 2 %}
                      {% endif %}
                      {% set ns.previous_csv = current_csv %}

                      {# Determine the increment based on atomics_type_key #}
                      {% if atomics_type_key == "hw-atomics" %}
                        {% set increment = 20 %}
                      {% elif atomics_type_key == "cas-atomics" %}
                        {% set increment = 18 %}
                      {% endif %}

                      {# Compute start and end rows (end is inclusive) #}
                      {% set start = ns.offset %}
                      {% set end   = ns.offset + 8 %}

                      .. csv-to-list-table::
                        :file: {{ current_csv }}
                        :rows: {{ start }}-{{ end }}

                      {# Update the offset for the next table in this CSV #}
                      {% set ns.offset = ns.offset + 9 + increment %}

                    {% endfor %}
                  {% endfor %}
              {% endfor %}
          {% endfor %}
      {% endfor %}

.. <!-- spellcheck-enable -->

Bitwise atomics operations
--------------------------------------------------------------------------------

The bitwise atomic operations that are supported by different hardware.

- 32 bit bitwise

  - Exchange

  - Compare-and-Swap (CAS)

  - AND

  - OR

  - XOR

- 64 bit bitwise

  - Exchange

  - CAS

  - AND

  - OR

  - XOR


.. note::

  128-bit bitwise Exchange and CAS are not supported on AMD GPUs

AMD Instinct GPUs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The bitwise atomic operations that are supported by different AMD Instinct
GPUs listed in the following table.

.. <!-- spellcheck-disable -->

.. The relative path not working in datatemplate, that's why we also need the absolute path of docs folder.

.. datatemplate:nodata::

  {% set ns = namespace(offset=19, previous_csv='') %}

  .. tab-set::
    {% for (atomics_type_text, atomics_type_key) in config.html_context['atomics_type'] %}
    .. tab-item:: {{ atomics_type_text }}
      :sync: {{ atomics_type_key }}

      .. tab-set::
        {% for (pcie_type_text, pcie_type_key) in config.html_context['pcie_type'] %}
        .. tab-item:: {{ pcie_type_text }}
          :sync: {{ pcie_type_key }}

          .. tab-set::
            {% for (memory_type_text, memory_type_key) in config.html_context['memory_type'] %}
            .. tab-item:: {{ memory_type_text }}
              :sync: {{ memory_type_key }}

              .. tab-set::
                {% for (granularity_type_text, granularity_type_key) in config.html_context['granularity_type'] %}
                .. tab-item:: {{ granularity_type_text }}
                  :sync: {{ granularity_type_key }}

                  .. tab-set::
                    {% for (scope_type_text, scope_type_key) in config.html_context['scope_type'] %}
                    .. tab-item:: {{ scope_type_text }}
                      :sync: {{ scope_type_key }}

                      {# Build the CSV file path for this branch #}
                      {% set current_csv = "data/reference/gpu-atomics-operation/"
                          ~ atomics_type_key ~ "_" ~ pcie_type_key ~ "_instinct.csv" %}
                      {# If we have a new CSV file, reset the offset #}
                      {% if current_csv != ns.previous_csv %}
                        {% set ns.offset = 19 %}
                      {% endif %}
                      {% set ns.previous_csv = current_csv %}

                      {# Compute the row numbers for this leaf #}
                      {% set start = ns.offset %}
                      {% set end   = ns.offset + 9 %}

                      .. csv-to-list-table::
                        :file: {{ current_csv }}
                        :rows: {{ start }}-{{ end }}

                      {# Update the offset: block (10 rows) plus gap (17 rows) #}
                      {% set ns.offset = ns.offset + 10 + 17 %}

                    {% endfor %}
                  {% endfor %}
              {% endfor %}
          {% endfor %}
      {% endfor %}

.. <!-- spellcheck-enable -->

AMD gfx generic targets
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The bitwise atomic operations that are supported by different AMD gfx generic
targets listed in the following table.

.. <!-- spellcheck-disable -->

.. The relative path not working in datatemplate, that's why we also need the absolute path of docs folder.

.. datatemplate:nodata::

  {% set ns = namespace(offset=19, previous_csv='') %}

  .. tab-set::
    {% for (atomics_type_text, atomics_type_key) in config.html_context['atomics_type'] %}
    .. tab-item:: {{ atomics_type_text }}
      :sync: {{ atomics_type_key }}

      .. tab-set::
        {% for (pcie_type_text, pcie_type_key) in config.html_context['pcie_type'] %}
        .. tab-item:: {{ pcie_type_text }}
          :sync: {{ pcie_type_key }}

          .. tab-set::
            {% for (memory_type_text, memory_type_key) in config.html_context['memory_type'] %}
            .. tab-item:: {{ memory_type_text }}
              :sync: {{ memory_type_key }}

              .. tab-set::
                {% for (granularity_type_text, granularity_type_key) in config.html_context['granularity_type'] %}
                .. tab-item:: {{ granularity_type_text }}
                  :sync: {{ granularity_type_key }}

                  .. tab-set::
                    {% for (scope_type_text, scope_type_key) in config.html_context['scope_type'] %}
                    .. tab-item:: {{ scope_type_text }}
                      :sync: {{ scope_type_key }}

                      {# Build the CSV file path for this branch #}
                      {% set current_csv = "data/reference/gpu-atomics-operation/"
                          ~ atomics_type_key ~ "_" ~ pcie_type_key ~ "_gfx.csv" %}
                      {# If we switch CSV files, reset the offset to 2 (to skip the header row) #}
                      {% if current_csv != ns.previous_csv %}
                        {% set ns.offset = 19 %}
                      {% endif %}
                      {% set ns.previous_csv = current_csv %}

                      {# Determine the increment based on atomics_type_key #}
                      {% if atomics_type_key == "hw-atomics" %}
                        {% set increment = 19 %}
                      {% elif atomics_type_key == "cas-atomics" %}
                        {% set increment = 17 %}
                      {% endif %}

                      {# Compute start and end rows (end is inclusive) #}
                      {% set start = ns.offset %}
                      {% set end   = ns.offset + 9 %}

                      .. csv-to-list-table::
                        :file: {{ current_csv }}
                        :rows: {{ start }}-{{ end }}

                      {# Update the offset for the next table in this CSV #}
                      {% set ns.offset = ns.offset + 10 + increment %}

                    {% endfor %}
                  {% endfor %}
              {% endfor %}
          {% endfor %}
      {% endfor %}

.. <!-- spellcheck-enable -->

Float atomics operations
--------------------------------------------------------------------------------

The float types atomic operations that are supported by different hardware.

- 32-bit IEEE 754 floating point ('single precision', FP32)

  - Add

  - Min

  - Max

- 64-bit IEEE 754 floating point ('double precision', FP64)

  - Add

  - Min

  - Max

- 16-bit IEEE 754 floating point ('half precision", FP16)

  - Add

- 2xPacked 16-bit IEEE 754 floating point ('half precision', FP16)

  - Add

- BrainFloat-16 floating point (BF16)

  - Add

- 2xPacked BrainFloat-16 floating point (BF16)

  - Add

AMD Instinct GPUs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The float type atomic operations that are supported by different AMD Instinct
GPUs listed in the following table.

.. <!-- spellcheck-disable -->

.. The relative path not working in datatemplate, that's why we also need the absolute path of docs folder.

.. datatemplate:nodata::

  {% set ns = namespace(offset=11, previous_csv='') %}

  .. tab-set::
    {% for (atomics_type_text, atomics_type_key) in config.html_context['atomics_type'] %}
    .. tab-item:: {{ atomics_type_text }}
      :sync: {{ atomics_type_key }}

      .. tab-set::
        {% for (pcie_type_text, pcie_type_key) in config.html_context['pcie_type'] %}
        .. tab-item:: {{ pcie_type_text }}
          :sync: {{ pcie_type_key }}

          .. tab-set::
            {% for (memory_type_text, memory_type_key) in config.html_context['memory_type'] %}
            .. tab-item:: {{ memory_type_text }}
              :sync: {{ memory_type_key }}

              .. tab-set::
                {% for (granularity_type_text, granularity_type_key) in config.html_context['granularity_type'] %}
                .. tab-item:: {{ granularity_type_text }}
                  :sync: {{ granularity_type_key }}

                  .. tab-set::
                    {% for (scope_type_text, scope_type_key) in config.html_context['scope_type'] %}
                    .. tab-item:: {{ scope_type_text }}
                      :sync: {{ scope_type_key }}

                      {# Build the CSV file path for this branch #}
                      {% set current_csv = "data/reference/gpu-atomics-operation/"
                          ~ atomics_type_key ~ "_" ~ pcie_type_key ~ "_instinct.csv" %}
                      {# If we have a new CSV file, reset the offset #}
                      {% if current_csv != ns.previous_csv %}
                        {% set ns.offset = 11 %}
                      {% endif %}
                      {% set ns.previous_csv = current_csv %}

                      {# Compute the row numbers for this leaf #}
                      {% set start = ns.offset %}
                      {% set end   = ns.offset + 7 %}

                      .. csv-to-list-table::
                        :file: {{ current_csv }}
                        :rows: {{ start }}-{{ end }}

                      {# Update the offset: block (8 rows) plus gap (19 rows) #}
                      {% set ns.offset = ns.offset + 8 + 19 %}

                    {% endfor %}
                  {% endfor %}
              {% endfor %}
          {% endfor %}
      {% endfor %}

.. <!-- spellcheck-enable -->

AMD gfx generic targets
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The float types atomic operations that are supported by different AMD gfx
generic targets listed in the following table.

.. <!-- spellcheck-disable -->

.. The relative path not working in datatemplate, that's why we also need the absolute path of docs folder.

.. datatemplate:nodata::

  {% set ns = namespace(offset=11, previous_csv='') %}

  .. tab-set::
    {% for (atomics_type_text, atomics_type_key) in config.html_context['atomics_type'] %}
    .. tab-item:: {{ atomics_type_text }}
      :sync: {{ atomics_type_key }}

      .. tab-set::
        {% for (pcie_type_text, pcie_type_key) in config.html_context['pcie_type'] %}
        .. tab-item:: {{ pcie_type_text }}
          :sync: {{ pcie_type_key }}

          .. tab-set::
            {% for (memory_type_text, memory_type_key) in config.html_context['memory_type'] %}
            .. tab-item:: {{ memory_type_text }}
              :sync: {{ memory_type_key }}

              .. tab-set::
                {% for (granularity_type_text, granularity_type_key) in config.html_context['granularity_type'] %}
                .. tab-item:: {{ granularity_type_text }}
                  :sync: {{ granularity_type_key }}

                  .. tab-set::
                    {% for (scope_type_text, scope_type_key) in config.html_context['scope_type'] %}
                    .. tab-item:: {{ scope_type_text }}
                      :sync: {{ scope_type_key }}

                      {# Build the CSV file path for this branch #}
                      {% set current_csv = "data/reference/gpu-atomics-operation/"
                          ~ atomics_type_key ~ "_" ~ pcie_type_key ~ "_gfx.csv" %}
                      {# If we switch CSV files, reset the offset to 2 (to skip the header row) #}
                      {% if current_csv != ns.previous_csv %}
                        {% set ns.offset = 11 %}
                      {% endif %}
                      {% set ns.previous_csv = current_csv %}

                      {# Determine the increment based on atomics_type_key #}
                      {% if atomics_type_key == "hw-atomics" %}
                        {% set increment = 21 %}
                      {% elif atomics_type_key == "cas-atomics" %}
                        {% set increment = 19 %}
                      {% endif %}

                      {# Compute start and end rows (end is inclusive) #}
                      {% set start = ns.offset %}
                      {% set end   = ns.offset + 7 %}

                      .. csv-to-list-table::
                        :file: {{ current_csv }}
                        :rows: {{ start }}-{{ end }}

                      {# Update the offset for the next table in this CSV #}
                      {% set ns.offset = ns.offset + 8 + increment %}

                    {% endfor %}
                  {% endfor %}
              {% endfor %}
          {% endfor %}
      {% endfor %}

.. <!-- spellcheck-enable -->