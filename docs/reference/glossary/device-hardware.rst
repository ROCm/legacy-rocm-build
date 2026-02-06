.. meta::
  :description: Device hardware glossary for AMD GPUs
  :keywords: AMD, ROCm, GPU, device hardware, compute units, cores, MFMA,
    architecture, register file, cache, HBM

.. _glossary-device-hardware:

***************
Device hardware
***************

This section provides brief definitions of hardware components and architectural
features of AMD GPUs.

.. glossary::
    :sorted:

    AMD device architecture
        AMD's device architecture is based on unified, programmable compute
        engines called Compute Units. See :ref:`hip:hardware_implementation` for
        details.

    Compute units
        Compute Units (CUs) are the fundamental programmable execution engines
        in AMD GPUs that manage thousands of lightweight threads. See
        :ref:`hip:compute_unit` for details.

    Vector arithmetic logic units
        Vector arithmetic logic units (VALUs) are the primary arithmetic engines
        that execute mathematical and logical operations within AMD Compute
        Units. See :ref:`hip:valu` for details.

    Special function unit
        Special Function Units (SFUs) accelerate transcendental and reciprocal
        mathematical functions such as ``exp``, ``log``, ``sin``, and ``cos``.
        See :ref:`hip:sfu` for details.

    Load and store unit
        Load/Store Units (LSUs) handle data transfer between Compute Units and
        the GPU's memory subsystems, managing thousands of concurrent memory
        operations. See :ref:`hip:lsu` for details.

    Wavefront scheduler
        The Wavefront Scheduler in each Compute Unit decides which group of
        threads to execute each clock cycle, enabling rapid context switching
        for latency hiding. See :ref:`hip:wave-scheduling` for details.

    SIMD core
        SIMD Cores are execution lanes that perform scalar and vector arithmetic
        operations inside each Compute Unit. See :ref:`hip:cdna_architecture`
        and :ref:`hip:rdna_architecture` for details.

    Matrix core and MFMA
        Matrix Cores (MFMA units) are specialized execution units that perform
        large-scale matrix operations in a single instruction, delivering high
        throughput for AI and HPC workloads. See :ref:`hip:mfma_units` for
        details.

    Data movement engine
        Data Movement Engines (DMEs) are specialized hardware units in CDNA3 and
        CDNA4 that accelerate multi-dimensional tensor data copies between
        global memory and on-chip memory. See :ref:`hip:dme` for details.

    Compute unit versioning
        Compute Units are versioned with GFX IP identifiers that define their
        microarchitectural features and instruction set compatibility. See
        :ref:`hip:gfx_ip` for details.

    Register file
        The register file is the primary on-chip memory store in each Compute
        Unit, holding data between arithmetic and memory operations. See
        :ref:`hip:memory_hierarchy` for details.

    L1 data cache
        The L1 Data Cache is the private on-chip memory associated with each
        Compute Unit, providing fast access to recently used data. See
        :ref:`hip:vl1`, :ref:`hip:sl1` and :ref:`hip:memory_coherence` for
        details.

    GPU RAM and HBM
        GPU RAM is the large, high-capacity High Bandwidth Memory (HBM)
        subsystem accessible by all Compute Units, forming the foundation of the
        device's data storage hierarchy. See :ref:`hip:hbm` for details.
