.. meta::
  :description: Performance glossary for AMD GPUs
  :keywords: AMD, ROCm, GPU, performance, optimization, roofline, bottleneck,
    occupancy, bandwidth, latency hiding, divergence

.. _glossary-performance:

***********
Performance
***********

This section provides brief definitions of performance analysis concepts and
optimization techniques.

.. glossary::
    :sorted:
    
    Performance bottleneck
        A performance bottleneck is a resource that limits the rate at which
        work can be completed, such as compute throughput or memory bandwidth.
        See :ref:`hip:performance_bottlenecks` for bottleneck analysis.
    
    Roofline model
        The roofline model is a visual performance model that determines whether
        a program is limited by memory bandwidth or arithmetic bandwidth. See
        :ref:`hip:roofline_model` for roofline analysis.
    
    Compute-bound
        Compute-bound kernels are limited by the arithmetic bandwidth of the
        GPU's compute units rather than memory bandwidth. See
        :ref:`hip:compute_bound` for compute-bound analysis.
    
    Memory-bound
        Memory-bound kernels are limited by memory bandwidth rather than
        arithmetic throughput, typically due to low arithmetic intensity. See
        :ref:`hip:memory_bound` for memory-bound analysis.
    
    Arithmetic intensity
        Arithmetic intensity is the ratio of arithmetic operations to memory
        operations in a kernel, determining performance characteristics. See
        :ref:`hip:arithmetic_intensity` for intensity analysis.
    
    Overhead
        Overhead latency is time spent with no useful work being done, often
        from CPU-side bottlenecks or kernel launch delays. See
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
        performed, defining the compute roof in roofline models. See
        :ref:`hip:compute_bound` for details.
    
    Latency hiding
        Latency hiding masks long-latency operations by running many concurrent
        threads, keeping execution pipelines busy. See :ref:`hip:latency_hiding`
        for details.

    Wavefront execution state
        Wavefront execution states (*active*, *stalled*, *eligible*, *selected*)
        describe the scheduling status of wavefronts on AMD GPUs. See
        :ref:`hip:wavefront_execution` for state definitions.

    Active cycle
        An active cycle is a clock cycle in which a Compute Unit has at least
        one active wavefront resident. See :ref:`hip:wavefront_execution` for
        details.

    Occupancy
        Occupancy is the ratio of active wavefronts to the maximum number of
        wavefronts that can be active on a Compute Unit. See
        :ref:`hip:occupancy` for occupancy analysis.

    Pipe utilization
        Pipe utilization measures how effectively a kernel uses the execution
        pipelines within each Compute Unit. See :ref:`hip:pipe_utilization` for
        utilization details.

    Peak rate
        Peak rate is the theoretical maximum throughput at which a hardware
        system can complete work under ideal conditions. See
        :ref:`hip:theoretical_performance_limits` for details.

    Issue efficiency
        Issue efficiency measures how effectively the wavefront scheduler keeps
        execution pipelines busy by issuing instructions. See
        :ref:`hip:issue_efficiency` for efficiency metrics.

    CU utilization
        CU utilization measures the percentage of time that Compute Units are
        actively executing instructions. See :ref:`hip:cu_utilization` for
        utilization analysis.

    Wavefront divergence
        Wavefront divergence occurs when threads within a wavefront take
        different execution paths due to conditional statements. See
        :ref:`hip:branch_efficiency` for divergence handling details.

    Branch efficiency
        Branch efficiency measures how often all threads within a wavefront take
        the same execution path, quantifying control flow uniformity. See
        :ref:`hip:branch_efficiency` for branch analysis.

    Memory coalescing
        Memory coalescing improves memory bandwidth by servicing many logical
        loads or stores with fewer physical memory transactions. See
        :ref:`hip:memory_coalescing_theory` for coalescing patterns.

    Bank conflict
        A bank conflict occurs when multiple threads simultaneously access
        different addresses in the same LDS bank, serializing accesses. See
        :ref:`hip:bank_conflicts_theory` for details.

    Register pressure
        Register pressure occurs when excessive register demand limits the
        number of active wavefronts per Compute Unit, reducing occupancy. See
        :ref:`hip:register_pressure_theory` for details.
