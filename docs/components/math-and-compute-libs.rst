.. meta::
   :description: AMD ROCm math and compute libraries for GPU-accelerated linear algebra, FFTs, random number generation, and deep learning.
   :keywords: math, compute, library, hipBLAS, rocBLAS, MIOpen, rocFFT, rocSPARSE, ROCm

*******************************
ROCm math and compute libraries
*******************************

ROCm math and compute libraries provide GPU-accelerated implementations of
common numerical operations including dense and sparse linear algebra, FFTs,
random number generation, and deep learning primitives.

Libraries prefixed with ``roc*`` are native, high-performance implementations
written in HIP specifically for AMD GPUs. Libraries prefixed with ``hip*`` are
portable wrappers that implement NVIDIA CUDA-equivalent APIs, allowing CUDA applications
to be ported to AMD GPUs with minimal code changes.

* :doc:`Composable Kernel <composable_kernel:index>` -- Provides a programming
  model for writing performance critical kernels for machine learning workloads
  across multiple architectures.

* :doc:`hipBLAS <hipblas:index>` -- BLAS-marshalling library that supports
  rocBLAS and cuBLAS backends.

* :doc:`hipBLASLt <hipblaslt:index>` -- Provides general matrix-matrix
  operations with a flexible API and extends functionalities beyond traditional
  BLAS library.

* :doc:`hipCUB <hipcub:index>` -- Thin header-only wrapper library on top of
  rocPRIM or CUB that allows project porting using the CUB library to the HIP
  layer.

* :doc:`hipFFT <hipfft:index>` -- Fast Fourier transforms (FFT)-marshalling
  library that supports rocFFT or cuFFT backends.

* :doc:`hipRAND <hiprand:index>` -- Ports CUDA applications that use the
  cuRAND library into the HIP layer.

* :doc:`hipSOLVER <hipsolver:index>` -- An LAPACK-marshalling library that
  supports rocSOLVER and cuSOLVER backends.

* :doc:`hipSPARSE <hipsparse:index>` -- SPARSE-marshalling library that
  supports rocSPARSE and cuSPARSE backends.

* :doc:`hipSPARSELt <hipsparselt:index>` -- SPARSE-marshalling library with
  multiple supported backends.

* :doc:`MIOpen <miopen:index>` -- An open source deep-learning library.

* :doc:`rocBLAS <rocblas:index>` -- BLAS implementation (in the HIP
  programming language) on the ROCm runtime and toolchains.

* :doc:`rocFFT <rocfft:index>` -- Software library for computing fast Fourier
  transforms (FFTs) written in HIP.

* :doc:`rocRAND <rocrand:index>` -- Provides functions that generate
  pseudorandom and quasirandom numbers.

* :doc:`rocSOLVER <rocsolver:index>` -- An implementation of LAPACK routines
  on ROCm software, implemented in the HIP programming language and optimized
  for AMD's latest discrete GPUs.

* :doc:`rocSPARSE <rocsparse:index>` -- Exposes a common interface that
  provides BLAS for sparse computation implemented on ROCm runtime and
  toolchains (in the HIP programming language).

* :doc:`rocPRIM <rocprim:index>` -- Header-only library for HIP parallel
  primitives.

* :doc:`rocThrust <rocthrust:index>` -- Parallel algorithm library.

* :doc:`rocWMMA <rocwmma:index>` -- C++ library for accelerating
  mixed-precision matrix multiply-accumulate (MMA) operations.
