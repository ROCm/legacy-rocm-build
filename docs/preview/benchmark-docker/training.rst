************************
Benchmark model training
************************

.. note::

   For the latest iteration of AI training and inference performance for ROCm
   7.0, see `Infinity Hub
   <https://www.amd.com/en/developer/resources/infinity-hub.html#q=ROCm%207>`__
   and the `ROCm 7.0 AI training and inference performance
   <https://rocm.docs.amd.com/en/docs-7.0-docker/benchmark-docker/index.html>`__
   documentation.

The process of training models is computationally intensive, requiring
specialized hardware like GPUs to accelerate computations and reduce training
time. Training models on AMD GPUs involves leveraging the parallel processing
capabilities of these GPUs to significantly speed up the model training process
in deep learning tasks.

Training models on AMD GPUs with the ROCm software platform allows you to use
the powerful parallel processing capabilities and efficient compute resource
management, significantly improving training time and overall performance in
machine learning applications.

.. grid:: 1

   .. grid-item-card:: Training benchmarking

      * :doc:`pre-training-megatron-lm-llama-3-8b`

      * :doc:`pre-training-torchtitan-llama-3-70b`
