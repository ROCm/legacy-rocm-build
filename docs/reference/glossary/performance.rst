.. meta::
  :description: Performance glossary for AMD GPUs
  :keywords: AMD, ROCm, GPU, performance, optimization, roofline, bottleneck,
    occupancy, bandwidth, latency hiding, divergence

.. _glossary-performance:

*****************************
Performance analysis glossary
*****************************

This section provides brief definitions of performance analysis concepts and
optimization techniques.

.. glossary::
    :sorted:
    
    Roofline model
        The roofline model is a visual performance model that determines whether
        a program is :term:`compute-bound <Compute-bound>` or
        :term:`memory-bound <Memory-bound>`. See :ref:`hip:roofline_model` for
        roofline analysis.
    
    Compute-bound
        Compute-bound kernels are limited by the
        :term:`arithmetic bandwidth <Arithmetic bandwidth>` of the GPU's
        :term:`compute units <Compute units>` rather than
        :term:`memory bandwidth <Memory bandwidth>`. See
        :ref:`hip:compute_bound` for compute-bound analysis.
    
    Memory-bound
        Memory-bound kernels are limited by
        :term:`memory bandwidth <Memory bandwidth>` rather than
        :term:`arithmetic bandwidth <Arithmetic bandwidth>`, typically due to
        low :term:`arithmetic intensity <Arithmetic intensity>`. See
        :ref:`hip:memory_bound` for memory-bound analysis.
    
    Arithmetic intensity
        Arithmetic intensity is the ratio of arithmetic operations to memory
        operations in a kernel, and determines performance characteristics. See
        :ref:`hip:arithmetic_intensity` for intensity analysis.
    
    Overhead
        Overhead latency is the time spent with no useful work being done, often
        due to CPU-side bottlenecks or kernel launch delays. See
        :ref:`hip:performance_bottlenecks` for details.
    
    Little's Law
        Little's Law relates concurrency, latency, and throughput, determining
        how much independent work must be in flight to hide latency. See
        :ref:`hip:littles_law` for latency hiding details.
    
    Memory bandwidth
        Memory bandwidth is the maximum rate at which data can be transferred
        between memory hierarchy levels, typically measured in bytes per
        second. See :ref:`hip:memory_bound` for details.
    
    Arithmetic bandwidth
        Arithmetic bandwidth is the peak rate at which arithmetic work can be
        performed, defining the compute roof in
        :term:`roofline models <Roofline model>`. See :ref:`hip:compute_bound`
        for details.
    
    Latency hiding
        Latency hiding masks long-latency operations by running many concurrent
        threads, keeping execution pipelines busy. See :ref:`hip:latency_hiding`
        for details.

    Wavefront execution state
        Wavefront execution states (*active*, *stalled*, *eligible*, *selected*)
        describe the scheduling status of :term:`wavefronts <Wavefront>` on AMD
        GPUs. See :ref:`hip:wavefront_execution` for state definitions.

    Active cycle
        An active cycle is a clock cycle in which a
        :term:`compute unit <Compute units>` has at least one active
        :term:`wavefront <Wavefront>` resident. See
        :ref:`hip:wavefront_execution` for details.

    Occupancy
        Occupancy is the ratio of active :term:`wavefronts <Wavefront>` to the
        maximum number of wavefronts that can be active on a
        :term:`compute unit <Compute units>`. See :ref:`hip:occupancy` for
        occupancy analysis.

    Pipe utilization
        Pipe utilization measures how effectively a kernel uses the execution
        pipelines within each :term:`compute unit <Compute units>`. See
        :ref:`hip:pipe_utilization` for utilization details.

    Peak rate
        Peak rate is the theoretical maximum throughput at which a hardware
        system can complete work under ideal conditions. See
        :ref:`hip:theoretical_performance_limits` for details.

    Issue efficiency
        Issue efficiency measures how effectively the
        :term:`wavefront scheduler <Wavefront scheduler>` keeps
        execution pipelines busy by issuing instructions. See
        :ref:`hip:issue_efficiency` for efficiency metrics.

    CU utilization
        CU utilization measures the percentage of time that
        :term:`compute units <Compute units>` are actively executing
        instructions. See :ref:`hip:cu_utilization` for utilization analysis.

    Wavefront divergence
        Wavefront divergence occurs when threads within a
        :term:`wavefront <Wavefront>` take different execution paths due to
        conditional statements. See :ref:`hip:branch_efficiency` for divergence
        handling details.

    Branch efficiency
        Branch efficiency measures how often all threads within a
        :term:`wavefront <Wavefront>` take the same execution path, quantifying
        control-flow uniformity. See :ref:`hip:branch_efficiency` for branch
        analysis.

    Memory coalescing
        Memory coalescing improves :term:`memory bandwidth <Memory bandwidth>`
        by servicing many logical loads or stores with fewer physical memory
        transactions. See :ref:`hip:memory_coalescing_theory` for coalescing
        patterns.

    Bank conflict
        A bank conflict occurs when multiple threads simultaneously access
        different addresses in the same :term:`LDS bank <Local data share>`,
        serializing accesses. See :ref:`hip:bank_conflicts_theory` for details.

    Register pressure
        Register pressure occurs when excessive register demand limits the
        number of active :term:`wavefronts <Wavefront>` per
        :term:`compute unit <Compute units>`, reducing
        :term:`occupancy <Occupancy>`. See
        :ref:`hip:register_pressure_theory` for details.
