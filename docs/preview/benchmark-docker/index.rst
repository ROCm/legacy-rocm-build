*******************************************
Docker images for AI inference
*******************************************

This page accompanies preview Docker images designed to reproduce
inference performance on AMD Instinct™ MI355X, MI350X, and MI300X series
accelerators. The images provide access to preview versions of the ROCm 7.0
software stack and are targeted at early-access users evaluating AI
inference workloads using next-generation AMD accelerators.

.. important::

   The following AI workload benchmarks use the ROCm 7.0 release candidate
   preview on AMD Instinct MI355X, MI350X, and MI300X series accelerators.

   If you're looking for production-level workloads for MI300X series accelerators, see
   `Infinity Hub <https://www.amd.com/en/developer/resources/infinity-hub.html>`_.

RC2
===

.. grid:: 2

   .. grid-item-card:: Training

      * :doc:`rc2/inference-vllm-llama-3.1-405b-fp4`

      * :doc:`rc2/inference-vllm-llama-3.3-70b-fp8`

      * :doc:`rc2/inference-vllm-gpt-oss-120b`

      * :doc:`rc2/inference-sglang-deepseek-r1-fp4`

      * :doc:`rc2/inference-sglang-deepseek-r1-fp8`

   .. grid-item-card:: Inference

      * :doc:`rc2/inference-vllm-llama-3.1-405b-fp4`

      * :doc:`rc2/inference-vllm-llama-3.3-70b-fp8`

      * :doc:`rc2/inference-vllm-gpt-oss-120b`

      * :doc:`rc2/inference-sglang-deepseek-r1-fp4`

      * :doc:`rc2/inference-sglang-deepseek-r1-fp8`

RC1
===

.. grid:: 1

   .. grid-item-card:: Inference

      * :doc:`rc1/inference-vllm-llama-3.1-405b-fp4`

      * :doc:`rc1/inference-vllm-llama-3.3-70b-fp8`

      * :doc:`rc1/inference-vllm-gpt-oss-120b`

      * :doc:`rc1/inference-sglang-deepseek-r1-fp4`

      * :doc:`rc1/inference-sglang-deepseek-r1-fp8`
