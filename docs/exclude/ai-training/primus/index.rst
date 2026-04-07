*****************************
AMD Primus training framework
*****************************

`Primus-LM <https://github.com/AMD-AGI/Primus>`__ is a unified and flexible
training framework for AMD GPUs. It supports multiple training engine backends
and delivers scalable, high-performance model training accelerated by `Primus
Turbo <https://github.com/AMD-AGI/Primus-Turbo>`__ and ROCm libraries.

* :doc:`primus-megatron` -- pre-train and post-train large language models on
  AMD Instinct GPUs using Primus with the Megatron-LM backend.

* :doc:`primus-torch` -- pre-train large language models on AMD Instinct GPUs
  using Primus with the PyTorch torchtitan backend.

* :doc:`primus-jax-maxtext` -- pre-train large language models on AMD Instinct
  GPUs using Primus with the JAX MaxText backend.

For a brief introduction to Primus, see the blog `Primus: A Lightweight,
Unified Training Framework for Large Models on AMD GPUs
<https://rocm.blogs.amd.com/software-tools-optimization/primus/README.html>`__.

For more Primus documentation, see
`<https://github.com/AMD-AGI/Primus/blob/main/docs/README.md>`__.
