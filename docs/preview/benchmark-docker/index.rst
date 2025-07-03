.. meta::
  :description: Benchmarking AI model training, fine-tuning, and inference
  :keywords: composable kernel, CK, ROCm, API, documentation

*******************************************
Docker images for AI training and inference
*******************************************

This page accompanies preview Docker images designed to validate and reproduce
training performance on AMD Instinct™ MI355X and MI350X accelerators. The images provide access to
Alpha versions of the ROCm 7.0 software stack and are targeted at early-access users evaluating
training workloads using next-generation AMD accelerators.

This preview offers hands-on benchmarking using representative large-scale
language and reasoning models with optimized compute precisions and
configurations.

.. important::

   The following AI workload benchmarks only support the ROCm 7.0 Alpha release on AMD Instinct
   MI355X and MI350X accelerators.

   If you're looking for production-level workloads for the MI300X series, see
   `Infinity Hub <https://www.amd.com/en/developer/resources/infinity-hub.html>`_.

.. grid:: 2

   .. grid-item-card:: Training

      * :doc:`pre-training-megatron-lm-llama-3-8b`

      * :doc:`pre-training-torchtitan-llama-3-70b`
