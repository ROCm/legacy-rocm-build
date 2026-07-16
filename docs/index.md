<style>
.sd-card-footer {
    border-top: none !important;
}
.sd-card-footer a {
    color: inherit;
    text-decoration-color: var(--pst-color-link);
}
.sd-card-footer a::after {
    font-family: "Font Awesome 6 Free";
    font-weight: 900;
    content: "\f054";
    color: var(--pst-color-link);
    margin-left: 0.4em;
    font-size: 0.8em;
    display: inline-block;
    transition: transform 0.2s ease;
}
.sd-card-footer a:hover::after {
    transform: translateX(4px);
}
</style>

# AMD ROCm

ROCm is AMD's open-source GPGPU computing platform: an end‑to‑end ecosystem of
compilers, runtimes, and libraries for AI, HPC, and domain‑specific workloads.
It is open source, cross‑platform (Linux and Windows), and optimized for AMD
Instinct™, AMD Radeon™, and AMD Ryzen™ AI devices.

::::{grid} 1 1 2 2
:gutter: 3

:::{grid-item-card} Core SDK
The foundational libraries, runtimes, and tools for GPU computing on AMD
hardware — math and compute libraries, communication primitives, HIP runtime,
profiling and debugging tools, and more.

- [Install the ROCm Core SDK](./install/rocm)
- [ROCm {{ ROCM_VERSION }} compatibility](./compatibility/compatibility-matrix)
+++
[Go to Core SDK docs](about/release-notes)
:::

:::{grid-item-card} AI Ecosystem
Full-stack documentation and recipes to deploy AI workloads on AMD
GPUs using popular ROCm-enabled frameworks.

- Deep learning frameworks
  - [PyTorch](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/frameworks/pytorch/install.html)
  - [JAX](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/frameworks/jax/install.html)
- Inference
  - [vLLM](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/inference/vllm.html)
  - [SGLang](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/inference/sglang.html)
+++
[Go to AI Ecosystem docs](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/index.html)
:::

:::{grid-item-card} GPU Systems and Infrastructure
Deployment and operations guidance for AMD Instinct GPUs at scale, including
AMD GPU Driver installation, cluster management, GPU partitioning, monitoring,
virtualization, cloud deployments, and containers.

- [AMD GPU Driver (amdgpu)](https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/)
- [Network Operator (Kubernetes)](https://instinct.docs.amd.com/projects/network-operator/en/latest/overview.html)
+++
[Go to GPU Systems docs](https://instinct.docs.amd.com)
:::

:::{grid-item-card} Toolkits
Open-source collections of ROCm-accelerated libraries for building
high-performance domain-specific applications.

- [ROCm Data Science](https://rocm.docs.amd.com/projects/rocm-ds/en/latest/index.html)
- [ROCm Finance](https://rocm.docs.amd.com/projects/rocm-finance/en/latest/index.html)
- [ROCm Life Science](https://rocm.docs.amd.com/projects/rocm-ls/en/latest/index.html)
- [ROCm LLMExt](https://rocm.docs.amd.com/projects/rocm-llmext/en/latest/index.html)
- [ROCm Simulation](https://rocm.docs.amd.com/projects/rocm-simulation/en/latest/index.html)
:::
::::
