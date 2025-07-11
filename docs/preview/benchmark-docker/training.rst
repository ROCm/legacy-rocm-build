************************
Benchmark model training
************************

The process of training models is computationally intensive, requiring
specialized hardware like GPUs to accelerate computations and reduce training
time. Training models on AMD GPUs involves leveraging the parallel processing
capabilities of these GPUs to significantly speed up the model training process
in deep learning tasks.

Training models on AMD GPUs with the ROCm software platform allows you to use
the powerful parallel processing capabilities and efficient compute resource
management, significantly improving training time and overall performance in
machine learning applications.

AMD provides ready-to-use Docker images for MI355X and MI350X series
accelerators containing essential software components and optimizations to
accelerate and benchmark training workloads for popular models.
See the following sections for instructions.

.. grid:: 1

   .. grid-item-card:: Training benchmarking

      * :doc:`pre-training-megatron-lm-llama-3-8b`

      * :doc:`pre-training-torchtitan-llama-3-70b`
