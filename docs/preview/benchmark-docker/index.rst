***************************************************
AI training and inference performance with ROCm 7.0
***************************************************

AMD ROCm is an open-source software platform optimized to extract HPC and AI
workload performance from AMD Instinct™ accelerators and GPUs while maintaining
compatibility with industry software frameworks.

This documentation accompanies preview Docker images designed to reproduce
training and inference performance on AMD Instinct™ MI355X, MI350X, and MI300X
series accelerators with ROCm 7.0. The images provide the 7.0.0 release of the
ROCm software stack and are targeted at early-access users evaluating AI
inference workloads using next-generation AMD accelerators. See the Docker image repository
on `rocm/7.0-preview <https://hub.docker.com/r/rocm/7.0-preview/>`__.

.. note::

   ROCm 7.0 is available. See the documentation at `ROCm 7.0 documentation
   <https://rocm.docs.amd.com/en/docs-7.0.0/>`__.

.. important::

   The following AI workload benchmarks use ROCm 7.0 on AMD Instinct MI355X,
   MI350X, and MI300X series accelerators.

   If you're looking for production-level workloads for MI300X series accelerators, see
   `Infinity Hub <https://www.amd.com/en/developer/resources/infinity-hub.html>`_.

.. grid:: 2

   .. grid-item-card:: Training

      * :doc:`inference-vllm-llama-3.1-405b-fp4`

      * :doc:`inference-vllm-llama-3.3-70b-fp8`

      * :doc:`inference-vllm-gpt-oss-120b`

      * :doc:`inference-sglang-deepseek-r1-fp4`

      * :doc:`inference-sglang-deepseek-r1-fp8`

   .. grid-item-card:: Inference

      * :doc:`inference-vllm-llama-3.1-405b-fp4`

      * :doc:`inference-vllm-llama-3.3-70b-fp8`

      * :doc:`inference-vllm-gpt-oss-120b`

      * :doc:`inference-sglang-deepseek-r1-fp4`

      * :doc:`inference-sglang-deepseek-r1-fp8`
