.. meta::
   :description: SGLang multi-node disaggregated distributed inference using Mooncake
   :keywords: model, sglang, mooncake, disagg, disaggregated, distributed, multi-node, docker

******************************************
SGLang distributed inference with Mooncake
******************************************

As LLM inference increasingly demands handling massive models and dynamic workloads, efficient
distributed inference becomes essential. Traditional co-located architectures face bottlenecks due
to tightly coupled memory and compute resources, which limits scalability and flexibility.
Disaggregated inference refers to the process of splitting the inference of LLMs into distinct
phases. This architecture, facilitated by libraries like Mooncake, uses high-bandwidth
RDMA to transfer the Key-Value (KV) cache between prefill and decode nodes.
This allows for independent resource scaling and optimization, resulting in
improved efficiency and throughput.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/sglang-distributed-benchmark-models.yaml

   {% set docker = data.dockers[0] %}

   `SGLang <https://docs.sglang.ai>`__ is a high-performance inference and
   serving engine for large language models (LLMs) and vision models. The
   ROCm-enabled `SGLang base Docker image <{{ docker.docker_hub_url }}>`__
   bundles SGLang with PyTorch, which is optimized for AMD Instinct MI300X Series
   GPUs. It includes the following software components:

   .. list-table::
      :header-rows: 1

      * - Software component
        - Version

      {% for component_name, component_version in docker.components.items() %}
      * - {{ component_name }}
        - {{ component_version }}
      {% endfor %}

The following guides on setting up and running SGLang and Mooncake for disaggregated
distributed inference on a Slurm cluster using AMD Instinct MI300X Series GPUs backed by
Mellanox CX-7 NICs.

Prerequisites
=============

Before starting, ensure you have:

* A Slurm cluster with at least three nodes: one for the proxy, one for prefill (``xP``), and one for decode (``yD``).

  ``Nodes -> xP + yD + 1``

* A Dockerized environment with SGLang, Mooncake, etcd, and NIC drivers built in. See :ref:`sglang-disagg-inf-build-docker-image` for instructions.

* A shared filesystem for storing models, scripts, and logs (cluster-specific).

Supported models
================

The following models are supported for SGLang disaggregated prefill/decode
inference. Some instructions, commands, and recommendations in this
documentation might vary by selected model.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/sglang-distributed-benchmark-models.yaml

   {% set model_groups = data.model_groups %}
   .. raw:: html

      <div id="vllm-benchmark-ud-params-picker" class="container-fluid">
         <div class="row gx-0">
            <div class="col-2 me-1 px-2 model-param-head">Model type</div>
            <div class="row col-10 pe-0">
      {% for model_group in model_groups %}
               <div class="col-6 px-2 model-param" data-param-k="model-group" data-param-v="{{ model_group.tag }}" tabindex="0">{{ model_group.group }}</div>
      {% endfor %}
            </div>
         </div>

         <div class="row gx-0 pt-1">
            <div class="col-2 me-1 px-2 model-param-head">Model</div>
            <div class="row col-10 pe-0">
      {% for model_group in model_groups %}
         {% set models = model_group.models %}
         {% for model in models %}
            {% if models|length % 3 == 0 %}
               <div class="col-4 px-2 model-param" data-param-k="model" data-param-v="{{ model.model_repo | lower }}" data-param-group="{{ model_group.tag }}" tabindex="0">{{ model.model }}</div>
            {% else %}
               <div class="col-6 px-2 model-param" data-param-k="model" data-param-v="{{ model.model_repo | lower }}" data-param-group="{{ model_group.tag }}" tabindex="0">{{ model.model }}</div>
            {% endif %}
         {% endfor %}
      {% endfor %}
            </div>
         </div>
      </div>

   {% for model_group in model_groups %}
      {% for model in model_group.models %}

   .. container:: model-doc {{ model.model_repo }}

      .. note::

         See the `{{ model.model }} model card on Hugging Face <{{ model.url }}>`__ to learn more about this model.
         Some models require access authorization prior to use through an external license agreement with a third party.

      {% endfor %}
   {% endfor %}

.. _sglang-disagg-inf-build-docker-image:

Build the Docker image
----------------------

Get the Dockerfile located in
`<https://github.com/ROCm/MAD/blob/develop/docker/sglang_disagg_inference.ubuntu.amd.Dockerfile>`__.
It uses `lmsysorg/sglang:v0.5.2rc1-rocm700-mi30x
<https://hub.docker.com/layers/lmsysorg/sglang/v0.4.9.post1-rocm630/images/sha256-2f6b1748e4bcc70717875a7da76c87795fd8aa46a9646e08d38aa7232fc78538>`__
as the base Docker image and installs the necessary components for Mooncake, etcd, and Mellanox network
drivers.

.. code-block:: shell

   git clone https://github.com/ROCm/MAD.git
   cd MAD/docker
   docker build \
       -t sglang_disagg_pd_image \
       -f sglang_disagg_inference.ubuntu.amd.Dockerfile .

Benchmarking
============

The `<https://github.com/ROCm/MAD/tree/develop/scripts/sglang_disagg>`__
repository contains scripts to launch SGLang inference with prefill/decode
disaggregation via Mooncake for supported models.

* `scripts/sglang_dissag/run_xPyD_models.slurm <https://github.com/ROCm/MAD/blob/develop/scripts/sglang_disagg/run_xPyD_models.slurm>`__
  -- the main Slurm batch script to launch Docker containers on all nodes using ``sbatch`` or ``salloc``.

* `scripts/sglang_dissag/sglang_disagg_server.sh <https://github.com/ROCm/MAD/blob/develop/scripts/sglang_disagg/sglang_disagg_server.sh>`__
  -- the entrypoint script that runs inside each container to start the correct service -- proxy, prefill, or decode.

* `scripts/sglang_dissag/benchmark_xPyD.sh <https://github.com/ROCm/MAD/blob/develop/scripts/sglang_disagg/benchmark_xPyD.sh>`__
  -- the benchmark script to run the GSM8K accuracy benchmark and the SGLang benchmarking tool for performance measurement.

* `scripts/sglang_dissag/benchmark_parser.py <https://github.com/ROCm/MAD/blob/develop/scripts/sglang_disagg/benchmark_parser.py>`__
  -- the log parser script to be run on the concurrency benchmark log file to generate tabulated data.

Launch the service
------------------

The service is deployed using a Slurm batch script that orchestrates the containers across the
allocated nodes.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/inference/sglang-distributed-benchmark-models.yaml

   {% set model_groups = data.model_groups %}
   {% for model_group in model_groups %}
      {% for model in model_group.models %}

   .. container:: model-doc {{ model.model_repo }}

      .. code-block:: shell

         # Clone the MAD repo if you haven't already and
         # navigate to the scripts directory
         git clone https://github.com/ROCm/MAD.git
         cd MAD/scripts/sglang_disagg/

         # Slurm sbatch run command
         export DOCKER_IMAGE_NAME=sglang_disagg_pd_image
         export xP=<num_prefill_nodes>
         export yD=<num_decode_nodes>
         export MODEL_NAME={{ model.model_repo }}
         # num_nodes = xP + yD + 1
         sbatch -N <num_nodes> -n <num_nodes> --nodelist=<Nodes> run_xPyD_models.slurm

      {% endfor %}
   {% endfor %}

Post-run logs and testing
-------------------------

Logs are stored in your shared filesystem in the directory specified by the ``LOG_PATH`` variable in the Slurm script.
A new directory named after the Slurm job ID is created for each run.

Inside that directory, you can access various logs:

* ``pd_sglang_bench_serving.sh_NODE<...>.log`` -- the main log for each server node.

* ``etcd_NODE<...>.log`` -- logs for etcd services.

* ``prefill_NODE<...>.log`` -- logs for the prefill services.

* ``decode_NODE<...>.log`` -- logs for the decode services.

Use the benchmark parser script for concurrency logs to tabulate different data.

.. code-block:: shell

   python3 benchmark_parser.py <log_path/benchmark_XXX_CONCURRENCY.log>

To verify the service is responsive, you can try sending a ``curl`` request to test the launched
server from the Docker container on the proxy node. For example:

.. code-block:: shell

   curl -X POST http://127.0.0.1:30000/generate \
       -H "Content-Type: application/json" \
       -d '{ "text": "Let me tell you a story ", "sampling_params": { "temperature": 0.3 } }'

Known issues
============

When running larger models, such as DeepSeek-V3 and Llama-3.1-405B-Instruct-FP8-KV, at
higher concurrency levels (512+), the following error might occur:

.. code-block:: shell-session

   <TransferEncodingError: 400, message:
    Not enough data to satisfy transfer length header.

   The above exception was the direct cause of the following exception:

   Traceback (most recent call last):
   ...

This leads to dropping requests and lower throughput.

Further reading
===============

- To learn about Mooncake, see `Welcome to Mooncake <https://kvcache-ai.github.io/Mooncake/>`__.

- To learn more about the options for latency and throughput benchmark scripts,
  see `<https://github.com/sgl-project/sglang/tree/main/benchmark/blog_v0_2>`__.

- See the base upstream Docker image on `Docker Hub <https://hub.docker.com/layers/lmsysorg/sglang/v0.5.2rc1-rocm700-mi30x/images/sha256-10c4ee502ddba44dd8c13325e6e03868bfe7f43d23d0a44780a8ee8b393f4729>`__.

- To learn more about system settings and management practices to configure your system for
  MI300X Series GPUs, see `AMD Instinct MI300X system optimization <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/system-optimization/mi300x.html>`__.

- For application performance optimization strategies for HPC and AI workloads,
  including inference with vLLM, see :doc:`/how-to/rocm-for-ai/inference-optimization/workload`.

- To learn how to run community models from Hugging Face on AMD GPUs, see
  :doc:`Running models from Hugging Face </how-to/rocm-for-ai/inference/hugging-face-models>`.

- To learn how to fine-tune LLMs and optimize inference, see
  :doc:`Fine-tuning LLMs and inference optimization </how-to/rocm-for-ai/fine-tuning/fine-tuning-and-inference>`.

- For a list of other ready-made Docker images for AI with ROCm, see
  `AMD Infinity Hub <https://www.amd.com/en/developer/resources/infinity-hub.html#f-amd_hub_category=AI%20%26%20ML%20Models>`_.

Previous versions
=================

See :doc:`previous-versions/sglang-history` to find documentation for previous releases
of SGLang inference performance testing.
