:orphan:

.. meta::
   :description: How to train a model using Megatron-LM for ROCm.
   :keywords: ROCm, AI, LLM, train, Megatron-LM, megatron, Llama, tutorial, docker, torch

********************************************
Training a model with Primus and Megatron-LM
********************************************

.. caution::

   This documentation does not reflect the latest version of ROCm Megatron-LM
   training performance documentation. See :doc:`../primus-megatron` for the latest version.

`Primus <https://github.com/AMD-AGI/Primus>`__ is a unified and flexible
LLM training framework designed to streamline training. It streamlines LLM
training on AMD Instinct GPUs using a modular, reproducible configuration paradigm.
Primus is backend-agnostic and supports multiple training engines -- including Megatron.

.. note::

   Primus with the Megatron backend is intended to replace ROCm
   Megatron-LM in this Dockerized training environment. To learn how to migrate
   workloads from Megatron-LM to Primus with Megatron, see
   :doc:`megatron-lm-primus-migration-guide`.

For ease of use, AMD provides a ready-to-use Docker image for MI300 Series GPUs
containing essential components for Primus and Megatron-LM.

.. note::

   This Docker environment is based on Python 3.10 and Ubuntu 22.04. For an alternative environment with
   Python 3.12 and Ubuntu 24.04, see the :doc:`previous ROCm Megatron-LM v25.6 Docker release <megatron-lm-v25.6>`.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/previous-versions/primus-megatron-v25.7-benchmark-models.yaml

   {% set dockers = data.dockers %}
   {% set docker = dockers[0] %}
   .. list-table::
      :header-rows: 1

      * - Software component
        - Version

      {% for component_name, component_version in docker.components.items() %}
      * - {{ component_name }}
        - {{ component_version }}
      {% endfor %}

.. _amd-primus-megatron-lm-model-support-v257:

Supported models
================

The following models are pre-optimized for performance on AMD Instinct MI300X Series GPUs.
Some instructions, commands, and training examples in this documentation might
vary by model -- select one to get started.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/previous-versions/primus-megatron-v25.7-benchmark-models.yaml

   {% set model_groups = data.model_groups %}
   .. raw:: html

      <div id="vllm-benchmark-ud-params-picker" class="container-fluid">
         <div class="row gx-0">
            <div class="col-2 me-1 px-2 model-param-head">Model</div>
            <div class="row col-10 pe-0">
      {% for model_group in model_groups %}
               <div class="col-3 px-2 model-param" data-param-k="model-group" data-param-v="{{ model_group.tag }}" tabindex="0">{{ model_group.group }}</div>
      {% endfor %}
            </div>
         </div>

         <div class="row gx-0 pt-1">
            <div class="col-2 me-1 px-2 model-param-head">Variant</div>
            <div class="row col-10 pe-0">
      {% for model_group in model_groups %}
         {% set models = model_group.models %}
         {% for model in models %}
            {% if models|length % 3 == 0 %}
               <div class="col-4 px-2 model-param" data-param-k="model" data-param-v="{{ model.mad_tag }}" data-param-group="{{ model_group.tag }}" tabindex="0">{{ model.model }}</div>
            {% else %}
               <div class="col-6 px-2 model-param" data-param-k="model" data-param-v="{{ model.mad_tag }}" data-param-group="{{ model_group.tag }}" tabindex="0">{{ model.model }}</div>
            {% endif %}
         {% endfor %}
      {% endfor %}
            </div>
         </div>
      </div>

.. note::

   Some models, such as Llama, require an external license agreement through
   a third party (for example, Meta).

System validation
=================

Before running AI workloads, it's important to validate that your AMD hardware is configured
correctly and performing optimally.

If you have already validated your system settings, including aspects like NUMA auto-balancing, you
can skip this step. Otherwise, complete the procedures in the :ref:`System validation and
optimization <rocm-for-ai-system-optimization>` guide to properly configure your system settings
before starting training.

To test for optimal performance, consult the recommended :ref:`System health benchmarks
<rocm-for-ai-system-health-bench>`. This suite of tests will help you verify and fine-tune your
system's configuration.

.. _mi300x-amd-primus-megatron-lm-training-v257:

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/previous-versions/primus-megatron-v25.7-benchmark-models.yaml

   {% set dockers = data.dockers %}
      {% set docker = dockers[0] %}

   Environment setup
   =================

   Use the following instructions to set up the environment, configure the script to train models, and
   reproduce the benchmark results on MI300X Series GPUs with the ``{{ docker.pull_tag }}`` image.

   .. _amd-primus-megatron-lm-requirements-v257:

   Download the Docker image
   -------------------------

   1. Use the following command to pull the Docker image from Docker Hub.

      .. code-block:: shell

         docker pull {{ docker.pull_tag }}

   2. Launch the Docker container.

      .. code-block:: shell

         docker run -it \
             --device /dev/dri \
             --device /dev/kfd \
             --device /dev/infiniband \
             --network host --ipc host \
             --group-add video \
             --cap-add SYS_PTRACE \
             --security-opt seccomp=unconfined \
             --privileged \
             -v $HOME:$HOME \
             --shm-size 128G \
             --name primus_training_env \
             {{ docker.pull_tag }}

3. Use these commands if you exit the ``primus_training_env`` container and need to return to it.

   .. code-block:: shell

      docker start primus_training_env
      docker exec -it primus_training_env bash

The Docker container hosts verified release tag ``v0.1.0-rc1`` of the `Primus
<https://github.com/AMD-AIG-AIMA/Primus/tree/v0.1.0-rc1>`__ repository.

.. _amd-primus-megatron-lm-environment-setup-v257:

Configuration
=============

Primus defines a training configuration in YAML for each model in
`examples/megatron/configs <https://github.com/AMD-AIG-AIMA/Primus/tree/v0.1.0-rc1/examples/megatron/configs>`__.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/previous-versions/primus-megatron-v25.7-benchmark-models.yaml

   {% set model_groups = data.model_groups %}
   {% for model_group in model_groups %}
      {% for model in model_group.models %}
   .. container:: model-doc {{ model.mad_tag }}

      To update training parameters for {{ model.model }}, you can update ``examples/megatron/configs/{{ model.config_name }}``.
      Note that training configuration YAML files for other models follow this naming convention.

      {% endfor %}
   {% endfor %}

.. note::

   See :ref:`Key options <amd-primus-megatron-lm-benchmark-test-vars>` for more information on configuration options.

Dataset options
---------------

You can use either mock data or real data for training.

* Mock data can be useful for testing and validation. Use the ``mock_data`` field to toggle between mock and real data. The default
  value is ``true`` for enabled.

  .. code-block:: yaml

     mock_data: true

* If you're using a real dataset, update the ``train_data_path`` field to point to the location of your dataset.

  .. code-block:: bash

     mock_data: false
     train_data_path: /path/to/your/dataset

  Ensure that the files are accessible inside the Docker container.

.. _amd-primus-megatron-lm-tokenizer-v257:

Tokenizer
---------

In Primus, each model uses a tokenizer from Hugging Face. For example, Llama
3.1 8B model uses ``tokenizer_model: meta-llama/Llama-3.1-8B`` and
``tokenizer_type: Llama3Tokenizer`` defined in the `llama3.1-8B model
<https://github.com/AMD-AIG-AIMA/Primus/tree/v0.1.0-rc1/primus/configs/models/megatron/llama3.1_8B.yaml>`__
definition. As such, you need to set the ``HF_TOKEN`` environment variable with
right permissions to access the tokenizer for each model.

.. code-block:: bash

   # Export your HF_TOKEN in the workspace
   export HF_TOKEN=<your_hftoken>

.. _amd-primus-megatron-lm-run-training-v257:

Run training
============

Use the following example commands to set up the environment, configure
:ref:`key options <amd-primus-megatron-lm-benchmark-test-vars>`, and run training on
MI300X Series GPUs with the AMD Megatron-LM environment.

Single node training
--------------------

To run training on a single node, navigate to ``/workspace/Primus`` and use the following setup command:

.. code-block:: shell

   pip install -r requirements.txt
   export HSA_NO_SCRATCH_RECLAIM=1
   export NVTE_CK_USES_BWD_V3=1

Once setup is complete, run the appropriate training command.

.. container:: model-doc primus_pyt_megatron_lm_train_llama-3.3-70b

   To run pre-training for Llama 3.3 70B BF16, run:

   .. code-block:: shell

      EXP=examples/megatron/configs/llama3.3_70B-pretrain.yaml \
      bash ./examples/run_pretrain.sh \
          --micro_batch_size 2 \
          --global_batch_size 16 \
          --train_iters 50

.. container:: model-doc primus_pyt_megatron_lm_train_llama-3.1-8b

   To run pre-training for Llama 3.1 8B FP8, run:

   .. code-block:: shell

      EXP=examples/megatron/configs/llama3.1_8B-pretrain.yaml \
      bash ./examples/run_pretrain.sh \
          --train_iters 50 \
          --fp8 hybrid

   For Llama 3.1 8B BF16, use the following command:

   .. code-block:: shell

      EXP=examples/megatron/configs/llama3.1_8B-pretrain.yaml \
      bash ./examples/run_pretrain.sh --train_iters 50

.. container:: model-doc primus_pyt_megatron_lm_train_llama-3.1-70b

   To run pre-training for Llama 3.1 70B BF16, run:

   .. code-block:: shell

      EXP=examples/megatron/configs/llama3.1_70B-pretrain.yaml \
      bash ./examples/run_pretrain.sh \
           --train_iters 50

   To run the training on a single node for Llama 3.1 70B FP8 with proxy, use the following command:

   .. code-block:: shell

      EXP=examples/megatron/configs/llama3.1_70B-pretrain.yaml \
      bash ./examples/run_pretrain.sh \
          --train_iters 50 \
          --num_layers 40 \
          --fp8 hybrid \
          --no_fp8_weight_transpose_cache true

   .. note::

      Use two or more nodes to run the *full* Llama 70B model with FP8 precision.

.. container:: model-doc primus_pyt_megatron_lm_train_llama-2-7b

   To run pre-training for Llama 2 7B FP8, run:

   .. code-block:: shell

      EXP=examples/megatron/configs/llama2_7B-pretrain.yaml \
      bash ./examples/run_pretrain.sh \
          --train_iters 50 \
          --fp8 hybrid

   To run pre-training for Llama 2 7B BF16, run:

   .. code-block:: shell

      EXP=examples/megatron/configs/llama2_7B-pretrain.yaml \
      bash ./examples/run_pretrain.sh --train_iters 50

.. container:: model-doc primus_pyt_megatron_lm_train_llama-2-70b

   To run pre-training for Llama 2 70B BF16, run:

   .. code-block:: shell

      EXP=examples/megatron/configs/llama2_70B-pretrain.yaml \
      bash ./examples/run_pretrain.sh --train_iters 50 

.. container:: model-doc primus_pyt_megatron_lm_train_deepseek-v3-proxy

   To run training on a single node for DeepSeek-V3 (MoE with expert parallel) with 3-layer proxy, 
   use the following command:

   .. code-block:: shell

      EXP=examples/megatron/configs/deepseek_v3-pretrain.yaml \
      bash examples/run_pretrain.sh \
          --num_layers 3 \
          --moe_layer_freq 1 \
          --train_iters 50

.. container:: model-doc primus_pyt_megatron_lm_train_deepseek-v2-lite-16b

   To run training on a single node for DeepSeek-V2-Lite (MoE with expert parallel),
   use the following command:

   .. code-block:: shell

      EXP=examples/megatron/configs/deepseek_v2_lite-pretrain.yaml \
      bash examples/run_pretrain.sh \
          --global_batch_size 256 \
          --train_iters 50

.. container:: model-doc primus_pyt_megatron_lm_train_mixtral-8x7b

   To run training on a single node for Mixtral 8x7B (MoE with expert parallel),
   use the following command:

   .. code-block:: shell

      EXP=examples/megatron/configs/mixtral_8x7B_v0.1-pretrain.yaml \
      bash examples/run_pretrain.sh --train_iters 50

.. container:: model-doc primus_pyt_megatron_lm_train_mixtral-8x22b-proxy

   To run training on a single node for Mixtral 8x7B (MoE with expert parallel) with 4-layer proxy,
   use the following command:

   .. code-block:: shell

      EXP=examples/megatron/configs/mixtral_8x22B_v0.1-pretrain.yaml \
      bash examples/run_pretrain.sh \
          --num_layers 4 \
          --pipeline_model_parallel_size 1 \
          --micro_batch_size 1 \
          --global_batch_size 16 \
          --train_iters 50

.. container:: model-doc primus_pyt_megatron_lm_train_qwen2.5-7b

   To run training on a single node for Qwen 2.5 7B BF16, use the following
   command:

   .. code-block:: shell

      EXP=examples/megatron/configs/qwen2.5_7B-pretrain.yaml \
      bash examples/run_pretrain.sh --train_iters 50

   For FP8, use the following command.

   .. code-block:: shell

      EXP=examples/megatron/configs/qwen2.5_7B-pretrain.yaml \
      bash examples/run_pretrain.sh \
          --train_iters 50 \
          --fp8 hybrid

.. container:: model-doc primus_pyt_megatron_lm_train_qwen2.5-72b

   To run the training on a single node for Qwen 2.5 72B BF16, use the following command.

   .. code-block:: shell

      EXP=examples/megatron/configs/qwen2.5_72B-pretrain.yaml \
      bash examples/run_pretrain.sh --train_iters 50

Multi-node training examples
----------------------------

To run training on multiple nodes, you can use the
`run_slurm_pretrain.sh <https://github.com/AMD-AIG-AIMA/Primus/tree/v0.1.0-rc1/examples/run_slurm_pretrain.sh>`__
to launch the multi-node workload. Use the following steps to setup your environment:

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/previous-versions/primus-megatron-v25.7-benchmark-models.yaml

   {% set dockers = data.dockers %}
   {% set docker = dockers[0] %}

   .. code-block:: shell

      cd /workspace/Primus/
      export DOCKER_IMAGE={{ docker.pull_tag }}
      export HF_TOKEN=<your_HF_token>
      export HSA_NO_SCRATCH_RECLAIM=1
      export NVTE_CK_USES_BWD_V3=1
      export NCCL_IB_HCA=<your_NCCL_IB_HCA> # specify which RDMA interfaces to use for communication
      export NCCL_SOCKET_IFNAME=<your_NCCL_SOCKET_IFNAME> # your Network Interface
      export GLOO_SOCKET_IFNAME=<your_GLOO_SOCKET_IFNAME> # your Network Interface
      export NCCL_IB_GID_INDEX=3 # Set InfiniBand GID index for NCCL communication. Default is 3 for ROCE

.. note::

   * Make sure correct network drivers are installed on the nodes. If inside a Docker, either install the drivers inside the Docker container or pass the network drivers from the host while creating Docker container.
   * If ``NCCL_IB_HCA`` and ``NCCL_SOCKET_IFNAME`` are not set, Primus will try to auto-detect. However, since NICs can vary accross different cluster, it is encouraged to explicitly export your NCCL parameters for the cluster.
   * To find your network interface, you can use ``ip a``.
   * To find RDMA interfaces, you can use ``ibv_devices`` to get the list of all the RDMA/IB  devices.

.. container:: model-doc primus_pyt_megatron_lm_train_llama-3.3-70b

   To train Llama 3.3 70B FP8 on 8 nodes, run:

   .. code-block:: shell

      NNODES=8 EXP=examples/megatron/configs/llama3.3_70B-pretrain.yaml \
      bash examples/run_slurm_pretrain.sh \
          --micro_batch_size 4 \
          --global_batch_size 256 \
          --recompute_num_layers 80 \
          --no_fp8_weight_transpose_cache true \
          --fp8 hybrid

   To train Llama 3.3 70B BF16 on 8 nodes, run:

   .. code-block:: shell

      NNODES=8 EXP=examples/megatron/configs/llama3.3_70B-pretrain.yaml \
      bash examples/run_slurm_pretrain.sh \
          --micro_batch_size 1 \
          --global_batch_size 256 \
          --recompute_num_layers 12

.. container:: model-doc primus_pyt_megatron_lm_train_llama-3.1-8b

   To train Llama 3.1 8B FP8 on 8 nodes, run:

   .. code-block:: shell

      # Adjust the training parameters. For e.g., `global_batch_size: 8 * #single_node_bs` for 8 nodes in this case 
      NNODES=8 EXP=examples/megatron/configs/llama3.1_8B-pretrain.yaml \
      bash ./examples/run_slurm_pretrain.sh \
          --global_batch_size 1024 \
          --fp8 hybrid

.. container:: model-doc primus_pyt_megatron_lm_train_llama-3.1-70b

   To train Llama 3.1 70B FP8 on 8 nodes, run:

   .. code-block:: shell

      NNODES=8 EXP=examples/megatron/configs/llama3.1_70B-pretrain.yaml \
      bash examples/run_slurm_pretrain.sh \
          --micro_batch_size 4 \
          --global_batch_size 256 \
          --recompute_num_layers 80 \
          --no_fp8_weight_transpose_cache true \
          --fp8 hybrid

   To train Llama 3.1 70B BF16 on 8 nodes, run:

   .. code-block:: shell

      NNODES=8 EXP=examples/megatron/configs/llama3.1_70B-pretrain.yaml \
      bash examples/run_slurm_pretrain.sh \
          --micro_batch_size 1 \
          --global_batch_size 256 \
          --recompute_num_layers 12

.. container:: model-doc primus_pyt_megatron_lm_train_llama-2-7b

   To train Llama 2 8B FP8 on 8 nodes, run:

   .. code-block:: shell

      # Adjust the training parameters. For e.g., `global_batch_size: 8 * #single_node_bs` for 8 nodes in this case 
      NNODES=8 EXP=examples/megatron/configs/llama2_7B-pretrain.yaml bash ./examples/run_slurm_pretrain.sh --global_batch_size 2048 --fp8 hybrid

.. container:: model-doc primus_pyt_megatron_lm_train_llama-2-70b

   To train Llama 2 70B FP8 on 8 nodes, run:

   .. code-block:: shell

      NNODES=8 EXP=examples/megatron/configs/llama2_70B-pretrain.yaml \
      bash examples/run_slurm_pretrain.sh \
          --micro_batch_size 10 \
          --global_batch_size 640 \
          --recompute_num_layers 80 \
          --no_fp8_weight_transpose_cache true \
          --fp8 hybrid

   To train Llama 2 70B BF16 on 8 nodes, run:

   .. code-block:: shell

      NNODES=8 EXP=examples/megatron/configs/llama2_70B-pretrain.yaml \
      bash ./examples/run_slurm_pretrain.sh \
          --micro_batch_size 2 \
          --global_batch_size 1536 \
          --recompute_num_layers 12

.. container:: model-doc primus_pyt_megatron_lm_train_mixtral-8x7b

   To train Mixtral 8x7B BF16 on 8 nodes, run:

   .. code-block:: shell

      NNODES=8 EXP=examples/megatron/configs/mixtral_8x7B_v0.1-pretrain.yaml \
      bash examples/run_slurm_pretrain.sh \
          --micro_batch_size 2 \
          --global_batch_size 256

.. container:: model-doc primus_pyt_megatron_lm_train_qwen2.5-72b

   To train Qwen2.5 72B FP8 on 8 nodes, run:

   .. code-block:: shell

      NNODES=8 EXP=examples/megatron/configs/qwen2.5_72B-pretrain.yaml \
      bash examples/run_slurm_pretrain.sh \
          --micro_batch_size 8 \
          --global_batch_size 512 \
          --recompute_num_layers 80 \
          --no_fp8_weight_transpose_cache true \
          --fp8 hybrid

.. _amd-primus-megatron-lm-benchmark-test-vars-v257:

Key options
-----------

The following are key options to take note of

fp8
  ``hybrid`` enables FP8 GEMMs.

use_torch_fsdp2
  ``use_torch_fsdp2: 1``  enables torch fsdp-v2. If FSDP is enabled,
  set ``use_distributed_optimizer`` and ``overlap_param_gather`` to ``false``.

profile
  To enable PyTorch profiling, set these parameters:

  .. code-block:: yaml

     profile: true
     use_pytorch_profiler: true
     profile_step_end: 7
     profile_step_start: 6

train_iters
  The total number of iterations (default: 50).

mock_data
  True by default.

micro_batch_size
  Micro batch size.

global_batch_size
  Global batch size.

recompute_granularity
  For activation checkpointing.

num_layers
  For using a reduced number of layers as with proxy models.

Previous versions
=================

See :doc:`megatron-lm-history` to find documentation for previous releases
of the ``ROCm/megatron-lm`` Docker image.
