.. meta::
   :description: How to fine-tune LLMs with ROCm
   :keywords: ROCm, LLM, fine-tuning, usage, tutorial, GPUs, Llama, accelerators

*********************************
Fine-tuning on AMD GPUs with ROCm
*********************************

Fine-tuning is an essential technique in machine learning, where a pre-trained
model, typically trained on a large-scale dataset, is further refined to
achieve better performance and adapt to a particular task or dataset of
interest.

Fine-tuning using ROCm involves leveraging AMD's GPU-accelerated
:doc:`libraries <rocm:reference/api-libraries>` and :doc:`tools
<rocm:reference/rocm-tools>` to optimize and train deep learning models. ROCm
provides a comprehensive ecosystem for deep learning development, including
open-source libraries for optimized deep learning operations and ROCm-enabled
versions of deep learning frameworks such as PyTorch and JAX.

Throughout the following topics, this guide discusses the goals and :ref:`challenges of fine-tuning a large language
model <fine-tuning-llms-concept-challenge>` like Llama 2. In the
sections that follow, you'll find practical guides on libraries and tools to accelerate your fine-tuning.

The AI Developer Hub contains `AMD ROCm tutorials <https://rocm.docs.amd.com/projects/ai-developer-hub/en/latest/>`_ for
training, fine-tuning, and inference. It leverages popular machine learning frameworks on AMD GPUs.

- :doc:`Conceptual overview of fine-tuning LLMs <overview>`

- :doc:`Fine-tuning and inference <fine-tuning-and-inference>` using a
  :doc:`single-accelerator <single-gpu-fine-tuning>` or
  :doc:`multi-accelerator <multi-gpu-fine-tuning>` system.
