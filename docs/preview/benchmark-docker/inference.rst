****************************
Benchmarking model inference
****************************

.. note::

   For the latest iteration of AI training and inference performance for ROCm
   7.0, see `Infinity Hub
   <https://www.amd.com/en/developer/resources/infinity-hub.html#q=ROCm%207>`__
   and the `ROCm 7.0 AI training and inference performance
   <https://rocm.docs.amd.com/en/docs-7.0-docker/benchmark-docker/index.html>`__
   documentation.

AI inference is a process of deploying a trained machine learning model to make
predictions or classifications on new data. By leveraging the ROCm platform's
capabilities, you can harness the power of high-performance computing and
efficient resource management to run inference workloads, leading to faster
predictions and classifications on real-time data.

AMD provides prebuilt, optimized environments for validating the inference
performance of popular models on AMD Instinct™ MI355X and MI350X accelerators.
See the following sections for instructions.

.. grid::

   .. grid-item-card:: Inference benchmarking

      * :doc:`inference-sglang-deepseek-r1-fp4`

      * :doc:`inference-vllm-llama-3.1-405b-fp4`
