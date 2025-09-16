***************************************************
AI training and inference performance with ROCm 7.0
***************************************************

AMD ROCm is an open-source software platform optimized to extract HPC and AI
workload performance from AMD Instinct™ accelerators and GPUs while maintaining
compatibility with industry software frameworks.

This documentation accompanies preview Docker images designed to reproduce
training and inference performance on AMD Instinct™ MI355X, MI350X, and MI300X
series accelerators with ROCm 7.0. The images provide the 7.0 release of the
ROCm software stack and are targeted at users evaluating AI inference workloads
using next-generation AMD accelerators. See the Docker image repository at
`rocm/7.0 <https://hub.docker.com/r/rocm/7.0/>`__.

.. note::

   ROCm 7.0 is now available. See the documentation at `ROCm 7.0 documentation
   <https://rocm.docs.amd.com/en/docs-7.0.0/>`__.

.. important::

   The following AI workload benchmarks use ROCm 7.0 on AMD Instinct MI355X,
   MI350X, and MI300X series accelerators.

    For other workloads for MI300X series accelerators, see
   `Infinity Hub <https://www.amd.com/en/developer/resources/infinity-hub.html>`_.

.. grid:: 2

   .. grid-item-card:: Training

      * :doc:`training-maxtext-llama-3.rst`

      * :doc:`training-maxtext-mixtral-8x7b.rst`

      * :doc:`training-megatron-lm-llama-3.rst`

      * :doc:`training-mlperf-fine-tuning-llama-2-70b.rst`

      * :doc:`training-torchtitan-llama-3.rst`

   .. grid-item-card:: Inference

      * :doc:`inference-vllm-llama-3.1-405b-fp4`

      * :doc:`inference-vllm-llama-3.3-70b-fp8`

      * :doc:`inference-vllm-gpt-oss-120b`

      * :doc:`inference-sglang-deepseek-r1-fp4`

      * :doc:`inference-sglang-deepseek-r1-fp8`
