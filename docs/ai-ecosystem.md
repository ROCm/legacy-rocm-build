# AMD ROCm AI ecosystem

The [AMD ROCm AI ecosystem documentation
portal](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/index.html)
includes guides covering deep framework installation and setup, large-scale
model training, LLM and diffusion inference serving, and AI workload
performance optimization on AMD GPUs. The ROCm AI ecosystem lives on top of the
[ROCm Core SDK](/about/what-is-rocm), which provides the underlying GPU
runtimes (HIP), compilers, and math libraries.

::::{grid} 1 2 2 2
:gutter: 3

:::{grid-item-card} Deep learning frameworks
Install PyTorch and JAX on AMD GPUs. Includes hardware-specific instructions
for AMD Instinct and Radeon GPUs and Ryzen APUs across Linux and Windows using
pip.

- [Install PyTorch](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/frameworks/pytorch/install.html)
- [Install JAX](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/frameworks/jax/install.html)
:::

:::{grid-item-card} Training
Scale model training across multiple AMD GPUs using PyTorch distributed primitives
(DDP, RPC, collective communication) for large models that exceed single-GPU memory.

- [Scale model training](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/training/scale-model-training.html)
:::

:::{grid-item-card} Inference
Serve LLMs and generative AI models using high-performance inference frameworks.
Covers single-node and distributed multi-GPU deployments.

- [vLLM](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/inference/vllm.html)
- [SGLang](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/inference/sglang.html)
- [MIGraphX](https://rocm.docs.amd.com/projects/AMDMIGraphX)
- [ONNX Runtime](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/inference/onnxruntime.html)
- [xDiT](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/inference/xdit.html)
- [ComfyUI](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/inference/comfy.html)
:::

:::{grid-item-card} Distributed inference
Multi-node prefill-decode disaggregated serving over RDMA networking
using MoRI (Modular RDMA Interface) on MI355X clusters.

- [vLLM with MoRI recipe](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/inference/distributed/vllm-mori-recipe.html)
- [SGLang with MoRI recipe](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/inference/distributed/sglang-mori-recipe.html)
:::

:::{grid-item-card} Optimization
Improve throughput, latency, and memory efficiency for AI workloads on AMD Instinct GPUs.

- [Workload optimization](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/optimization/workload-optimization.html)
- [vLLM V1 performance](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/optimization/vllm-v1-optimization.html)
- [Model quantization](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/optimization/model-quantization.html)
- [Model acceleration libraries](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/optimization/model-acceleration-libs.html)
- [Triton kernels](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/optimization/optimize-triton-kernels.html)
- [Composable Kernel](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/optimization/optimize-with-composable-kernel.html)
:::

:::{grid-item-card} Tutorials
Hands-on guides and recipes for building AI applications on AMD hardware.

- [AI Playbooks](https://developer.amd.com/playbooks)
- [AI Developer Hub](https://rocm.docs.amd.com/projects/ai-developer-hub)
:::
::::
