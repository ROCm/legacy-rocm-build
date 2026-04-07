.. meta::
   :description: AMD ROCm runtimes and compilers for GPU application development, including HIP, HIPIFY, and LLVM.
   :keywords: runtime, compiler, HIP, HIPIFY, LLVM, amdclang, ROCm

***************************
ROCm runtimes and compilers
***************************

ROCm runtimes and compilers provide the core execution environment and
programming tools for GPU application development on AMD hardware.

* :doc:`HIP <hip:index>` -- A C++ runtime API and kernel programming language
  designed for AMD GPUs. By providing an interface closely aligned with NVIDIA
  CUDA, HIP allows developers to write portable applications and efficiently
  migrate existing CUDA code to AMD platforms.

* :doc:`HIPIFY <hipify:index>` -- Translates CUDA source code into portable
  HIP C++.

* :doc:`LLVM <llvm-project:index>` -- AMD's LLVM-based compiler
  infrastructure, including the ROCm device compiler (``amdclang``), which
  compiles HIP and OpenCL code for AMD GPUs.
