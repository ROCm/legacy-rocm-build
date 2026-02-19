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

    ALU
        Arithmetic logic units (ALUs) are the primary arithmetic engines that
        execute mathematical and logical operations within
        :term:`compute units <Compute units>`. See :ref:`hip:valu` for details. 

    SALU
        Scalar :term:`ALUs <ALU>` (SALUs) operate on a single value per
        :term:`wavefront <Wavefront>` and manage all control flow.

    VALU
        Vector :term:`ALUs <ALU>` (VALUs) perform an arithmetic or logical
        operation on data for each :term:`work-item <Work-item (Thread)>` in a
        :term:`wavefront <Wavefront>`, enabling data-parallel execution.

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

    Wavefront size
        The wavefront size is the number of
        :term:`work-items <Work-item (Thread)>` that execute together in a
        single :term:`wavefront <Wavefront (Warp)>`. For AMD Instinct GPUs, the
        wavefront size is 64 threads, while AMD Radeon GPUs have a wavefront
        size of 32 threads. See :ref:`hip:wavefront` for details.

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

    GFX IP
        GFX IP (Graphics IP) versions are identifiers that specify which
        instruction formats, memory models, and compute features are supported
        by each AMD GPU generation. See :ref:`hip:gfx_ip` for versioning
        information.

    GFX IP major version
        The :term:`GFX IP <GFX IP>` major version represents the GPU's core
        instruction set and architecture. For example, a GFX IP `11` major
        version corresponds to the RDNA3 architecture, influencing driver
        support and available compute features. See :ref:`hip:gfx_ip` for
        versioning information.

    GFX IP minor version
        The :term:`GFX IP <GFX IP>` minor version represents specific variations
        within a :term:`GFX IP <GFX IP>` major version and affects feature sets,
        optimizations, and driver behavior. Different GPU models within the same
        major version can have unique capabilities, impacting performance and
        supported instructions. See :ref:`hip:gfx_ip` for versioning
        information.
    
    Compute unit versioning
        :term:`Compute units <Compute units>` are versioned with
        :term:`GFX IP <GFX IP>` identifiers that define their microarchitectural
        features and instruction set compatibility. See :ref:`hip:gfx_ip` for
        details.

    Register file
        The register file is the primary on-chip memory store in each
        :term:`compute unit <Compute units>`, holding data between arithmetic
        and memory operations. See :ref:`hip:memory_hierarchy` for details.

    SGPR file
        The :term:`SGPR <SGPR>` file is the
        :term:`register file <Register file>` that holds data used by the
        :term:`scalar ALU <SALU>`.
    
    VGPR file
        The :term:`VGPR <VGPR>` file is the
        :term:`register file <Register file>` that holds data used by the
        :term:`vector ALU <VALU>`. GPUs with
        :term:`matrix cores <Matrix cores (MFMA units)>` also have
        :term:`AccVGPR <AccVGPR>` files, used specifically for matrix
        instructions.

    L0 instruction cache
        On AMD Radeon GPUs, the level 0 (L0) instruction cache is local to each
        :term:`WGP <WGP>` and thus shared between the WGP's
        :term:`compute units <Compute units>`.

    L0 scalar cache
        On AMD Radeon GPUs, the level 0 (L0) scalar data cache is local to each
        :term:`WGP <WGP>` and thus shared between the WGP's
        :term:`compute units <Compute units>`. It provides the
        :term:`scalar ALU <SALU>` with fast access to recently used data.

    L0 vector cache 
        On AMD Radeon GPUs, the level 0 (L0) vector data cache is local to each
        :term:`WGP <WGP>` and thus shared between the WGP's
        :term:`compute units <Compute units>`. It provides the
        :term:`vector ALU <VALU>` with fast access to recently used data.

    L1 instruction cache
        On AMD Instinct GPUs, the level 1 (L1) instruction cache is local to
        each :term:`compute unit <Compute units>`. On AMD Radeon GPUs, the
        L1 instruction cache does not exist as a separate cache level, and
        instructions are stored in the
        :term:`L0 instruction cache <L0 instruction cache>`.

    L1 scalar cache
        On AMD Instinct GPUs, the level 1 (L1) scalar data cache is local to
        each :term:`compute unit <Compute units>`, providing the 
        :term:`scalar ALU <SALU>` with fast access to recently used data. On AMD
        Radeon GPUs, the L1 scalar cache does not exist as a separate cache
        level, and recently used scalar data is stored in the
        :term:`L0 scalar cache <L0 scalar cache>`.

    L1 vector cache
        On AMD Instinct GPUs, the level 1 (L1) vector data cache is local to
        each :term:`compute unit <Compute units>`, providing the 
        :term:`vector ALU <VALU>` with fast access to recently used data. On AMD
        Radeon GPUs, the L1 vector cache does not exist as a separate cache
        level, and recently used vector data is stored in the
        :term:`L0 vector cache <L0 vector cache>`.

    Graphics L1 cache
        On AMD Radeon GPUs, the read-only graphics level 1 (L1) cache is local
        to groups of :term:`WGPs <WGP>` called shader arrays, providing fast
        access to recently used data. AMD Instinct GPUs do not feature the
        graphics L1 cache.

    L2 cache
        On AMD Instinct MI100 series GPUs, the L2 cache is shared across the
        entire chip, while for all other AMD GPUs the L2 caches are shared by
        the :term:`compute units <Compute units>` on the same :term:`GCD <GCD>`
        or :term:`XCD <XCD>`.

    Infinity Cache (L3 cache)
        On AMD Instinct MI300 and MI350 series GPUs and AMD Radeon GPUs, the
        Infinity Cache is the last level cache of the cache hierarchy. It is
        shared by all :term:`compute units <Compute units>` and
        :term:`WGPs <WGP>` on the GPU.

    GPU RAM (VRAM)
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

    SGPR
        Scalar general-purpose :term:`registers <Registers>` (SGPRs) hold data
        produced and consumed by a :term:`compute unit <Compute units>`'s
        :term:`scalar ALU <SALU>`.

    VGPR
        Vector general-purpose :term:`registers <Registers>` (VGPRs) hold data
        produced and consumed by a :term:`compute unit <Compute units>`'s
        :term:`vector ALU <VALU>`.

    AccVGPR
        Accumulation General Purpose Vector Registers (AccVGPRs) are a special
        type of :term:`VGPRs <VGPR>` used exclusively for matrix operations.

    XCD
        On AMD Instinct MI300 and MI350 series GPUs, the Accelerator Complex Die
        (XCD) contains the GPU's computational elements and lower levels of the
        cache hierarchy. See :doc:`../../conceptual/gpu-arch/mi300` for details.

    GCD
        On AMD Instinct MI100 and MI250 series GPUs and AMD Radeon GPUs, the
        Graphics Compute Die (GCD) contains the GPU's computational elements
        and lower levels of the cache hierarchy. See
        :doc:`../../conceptual/gpu-arch/mi250` for details.

    WGP
        A Workgroup Processor (WGP) is a hardware unit on AMD Radeon GPUs that
        contains two :term:`compute units <Compute units>` and their associated
        resources, enabling efficient scheduling and execution of
        :term:`wavefronts <wavefront>`. See :ref:`hip:rdna_architecture` for
        details.
