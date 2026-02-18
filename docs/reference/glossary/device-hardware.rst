.. meta::
  :description: Device hardware glossary for AMD GPUs
  :keywords: AMD, ROCm, GPU, device hardware, compute units, cores, MFMA,
    architecture, register file, cache, HBM

.. _glossary-device-hardware:

************************
Device hardware glossary
************************

This section provides concise definitions of hardware components and architectural
features of AMD GPUs.

.. glossary::
    :sorted:

    AMD device architecture
        AMD device architecture is based on unified, programmable compute
        engines known as :term:`compute units (CUs) <Compute units>`. See
        :ref:`hip:hardware_implementation` for details.

    Compute units
        Compute units (CUs) are the fundamental programmable execution engines
        in AMD GPUs capable of running complex programs. See
        :ref:`hip:compute_unit` for details.

    Vector arithmetic logic units
        Vector arithmetic logic units (VALUs) are the primary arithmetic engines
        that execute mathematical and logical operations within
        :term:`compute units <Compute units>`. See :ref:`hip:valu` for details.

    Special function unit
        Special function units (SFUs) accelerate transcendental and reciprocal
        mathematical functions such as ``exp``, ``log``, ``sin``, and ``cos``.
        See :ref:`hip:sfu` for details.

    Load/store unit
        Load/store units (LSUs) handle data transfer between
        :term:`compute units <Compute units>` and the GPU's memory subsystems,
        managing thousands of concurrent memory operations. See :ref:`hip:lsu`
        for details.

    Work-group (Block)
        A work-group (also called a block) is a collection of
        :term:`wavefronts <Wavefront (Warp)>` scheduled together on a single
        :term:`compute unit <Compute units>` that can coordinate through
        :term:`Local data share <Local data share>` memory. See
        :ref:`hip:inherent_thread_hierarchy_block` for work-group details.

    Work-item (Thread)
        A work-item (also called a thread) is the smallest unit of execution on
        an AMD GPU and represents a single element of work. See
        :ref:`hip:work-item` for thread hierarchy details.

    Wavefront (Warp)
        A wavefront (also called a warp) is a group of
        :term:`work-items <Work-item (Thread)>` that execute in parallel on a
        single :term:`compute unit <Compute units>`, sharing one
        instruction stream. See :ref:`hip:wavefront` for execution details.

    Wavefront scheduler
        The wavefront scheduler in each :term:`compute unit <Compute units>`
        decides which :term:`wavefront <wavefront>` to execute each clock cycle,
        enabling rapid context switching for latency hiding. See
        :ref:`hip:wave-scheduling` for details.

    SIMD core
        SIMD cores are execution lanes that perform scalar and vector arithmetic
        operations inside each :term:`compute unit <Compute unit>`. See
        :ref:`hip:cdna_architecture` and :ref:`hip:rdna_architecture` for
        details.

    Matrix cores (MFMA units)
        Matrix cores (MFMA units) are specialized execution units that perform
        large-scale matrix operations in a single instruction, delivering high
        throughput for AI and HPC workloads. See :ref:`hip:mfma_units` for
        details.

    Data movement engine
        Data movement engines (DMEs) are specialized hardware units in AMD
        Instinct MI300 and MI350 series GPUs that accelerate multi-dimensional
        tensor data copies between global memory and on-chip memory. See
        :ref:`hip:dme` for details.

    Compute unit versioning
        :term:`Compute units <Compute units>` are versioned with GFX IP
        identifiers that define their microarchitectural features and
        instruction set compatibility. See :ref:`hip:gfx_ip` for details.

    Register file
        The register file is the primary on-chip memory store in each
        :term:`compute unit <Compute units>`, holding data between arithmetic
        and memory operations. See :ref:`hip:memory_hierarchy` for details.

    L0 caches
        On AMD Radeon GPUs, the L0 caches (instruction cache, vector data cache,
        scalar data cache) are local to a single
        :term:`compute unit <Compute units>` within a :term:`WGP <WGP>`,
        providing fast access to recently used data.

    L1 caches
        On AMD Instinct GPUs, the L1 caches (instruction cache, vector data
        cache, scalar data cache) are local to a single
        :term:`compute unit <Compute units>`. AMD Radeon GPUs additionally
        feature a L1 graphics cache. On Radeon GPUs, the L1 caches are local to
        a single :term:`WGP <WGP>` and thus shared between the WGP's compute
        units. L1 caches provide fast access to recently used
        data. See :ref:`hip:vl1`, :ref:`hip:sl1` and :ref:`hip:memory_coherence`
        for details.

    L2 caches
        On AMD Instinct MI100 series GPUs, the L2 cache is shared across the
        entire chip, while for all other AMD GPUs the L2 caches are shared by
        the :term:`compute units <Compute units>` on the same :term:`GCD <GCD>`
        or :term:`XCD <XCD>`.

    Infinity Cache
        On AMD Instinct MI300 and MI350 series GPUs and AMD Radeon GPUs, the
        Infinity Cache is the last level cache of the cache hierarchy. It is
        shared by all :term:`compute units <Compute units>` and
        :term:`WGPs <WGP>` on the GPU.

    GPU RAM
        GPU RAM, also known as :term:`global memory <Global memory>` in the HIP
        programming model, is the large, high-capacity off-chip memory subsystem
        accessible by all :term:`compute units <Compute units>`, forming the
        foundation of the device's :ref:`memory hierarchy <hip:hbm>`.

    Local data share
        Local data share (LDS) is fast on-chip memory local to each
        :term:`compute unit <Compute units>` and shared among
        :term:`work-items <Work-item (Thread)>` in a
        :term:`work-group <Work-group (Block)>`, enabling efficient coordination
        and data reuse. In the HIP programming model, the LDS is known as shared
        memory. See :ref:`hip:lds` for LDS programming details.

    Registers
        Registers are the lowest level of the memory hierarchy, storing
        per-thread temporary variables and intermediate results. See
        :ref:`hip:memory_hierarchy` for register usage details.

    XCD
        On AMD Instinct MI300 and MI350 series GPUs, the Accelerator Complex Die
        (XCD) contains the GPU's computational elements and lower levels of the
        cache hierarchy. See :doc:`../../conceptual/mi300` for details.

    GCD
        On AMD Instinct MI100 and MI250 series GPUs and AMD Radeon GPUs, the
        Graphics Compute Die (GCD) contains the GPU's computational elements
        and lower levels of the cache hierarchy. See
        :doc:`../../conceptual/mi250` for details.

    WGP
        A Workgroup Processor (WGP) is a hardware unit on AMD Radeon GPUs that
        contains two :term:`compute units <Compute units>` and their associated
        resources, enabling efficient scheduling and execution of
        :term:`wavefronts <wavefront>`. See :ref:`hip:rdna_architecture` for
        details.