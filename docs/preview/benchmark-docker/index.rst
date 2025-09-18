.. meta::
  :description: Benchmarking AI model training, fine-tuning, and inference
  :keywords: composable kernel, CK, ROCm, API, documentation

*******************************************
Docker images for AI training and inference
*******************************************

.. note::

   For the latest iteration of AI training and inference performance for ROCm
   7.0, see `Infinity Hub
   <https://www.amd.com/en/developer/resources/infinity-hub.html#q=ROCm%207>`__
   and the `ROCm 7.0 AI training and inference performance
   <https://rocm.docs.amd.com/en/docs-7.0-docker/benchmark-docker/index.html>`__
   documentation.

This page accompanies preview Docker images designed to reproduce
training performance on AMD Instinct™ MI355X, MI350X, and MI300X series
accelerators. The images provide access to Beta versions of the ROCm 7.0
software stack and are targeted at early-access users evaluating training and
inference workloads using next-generation AMD accelerators.

.. important::

   The following AI workload benchmarks use the ROCm 7.0 Beta preview on AMD Instinct
   MI355X, MI350X, and MI300X series accelerators.

   If you're looking for production-level workloads for MI300X series accelerators, see
   `Infinity Hub <https://www.amd.com/en/developer/resources/infinity-hub.html>`_.

.. grid:: 2

   .. grid-item-card:: Training

      * :doc:`training-megatron-lm-llama-3`

      * :doc:`training-torchtitan-llama-3`

      * :doc:`training-mlperf-fine-tuning-llama-2-70b`

   .. grid-item-card:: Inference

      * :doc:`inference-vllm-llama-3.1-405b-fp4`

      * :doc:`inference-vllm-llama-3.3-70b-fp8`

      * :doc:`inference-vllm-gpt-oss-120b`

      * :doc:`inference-sglang-deepseek-r1-fp4`
