.. meta::
   :description: How to train a model using Megatron-LM for ROCm.
   :keywords: ROCm, AI, LLM, train, Megatron-LM, megatron, Llama, tutorial, docker, torch

********************************************
Training a model with Primus and Megatron-LM
********************************************

`Primus <https://github.com/AMD-AGI/Primus>`__ is a unified and flexible
training framework for AMD Instinct GPUs designed to support multiple training
engine backends -- including Megatron -- to deliver scalable, high-performance
model training. Performance acceleration is powered by `Primus Turbo
<https://github.com/AMD-AGI/Primus-Turbo>`__ and ROCm libraries.

.. note::

   The ``rocm/pytorch-training`` Docker Hub registry will be deprecated soon in
   favor of `rocm/primus <https://hub.docker.com/r/rocm/primus>`__.
   The ``rocm/primus`` Docker containers will cover PyTorch training ecosystem frameworks,
   including Megatron-LM and :doc:`torchtitan <primus-pytorch>`.

   Primus with Megatron is designed to replace the :doc:`ROCm Megatron-LM
   training <megatron-lm>` workflow. To learn how to migrate workloads from
   Megatron-LM to Primus with Megatron, see
   :doc:`previous-versions/megatron-lm-primus-migration-guide`.

AMD provides a ready-to-use Docker images for MI355X, MI350X,
MI325X, and MI300X GPUs containing essential components for Primus, ROCm, and
Megatron-LM.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/primus-megatron-benchmark-models.yaml

   .. tab-set::

      .. tab-item:: {{ data.docker.pull_tag }}
         :sync: {{ data.docker.pull_tag }}

         .. list-table::
            :header-rows: 1

            * - Software component
              - Version

            {% for component_name, component_version in data.docker.components.items() %}
            * - {{ component_name }}
              - {{ component_version }}
            {% endfor %}

.. _amd-primus-megatron-lm-model-support-v26.3:

Supported models
================

The following models are pre-optimized for performance on AMD Instinct GPUs.
Some instructions, commands, and training examples in this documentation
might vary by model -- select one to get started.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/primus-megatron-benchmark-models.yaml

   {% set model_groups = data.model_groups %}
   .. raw:: html

      <div id="vllm-benchmark-ud-params-picker" class="container-fluid">
         <div class="row gx-0">
            <div class="col-2 me-1 px-2 model-param-head">Model</div>
            <div class="row col-10 pe-0">
      {% for model_group in model_groups %}
               <div class="col-6 px-2 model-param" data-param-k="model-group" data-param-v="{{ model_group.tag }}" tabindex="0">{{ model_group.group }}</div>
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

.. _mi300x-amd-primus-megatron-lm-training-v26.3:

Environment setup
=================

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/primus-megatron-benchmark-models.yaml

   Use the following instructions to set up the environment, configure the script to train models, and
   reproduce the benchmark results on AMD Instinct GPUs.

.. _amd-primus-megatron-lm-requirements-v26.3:

Pull the Docker image

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/primus-megatron-benchmark-models.yaml

   {% set docker = data.docker %}

   1. Pull the ``{{ docker.pull_tag }}`` Docker image from Docker Hub.

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

      Use these commands if you exit the ``primus_training_env`` container and need to return to it.

      .. code-block:: shell

         docker start primus_training_env
         docker exec -it primus_training_env bash

The Docker container hosts verified commit ``43a6e00`` of the `Primus
<https://github.com/AMD-AGI/Primus/tree/43a6e006c419697208295c5523b99070e8198ad9>`__ repository.

.. _amd-primus-megatron-lm-environment-setup-v26.3:

Configuration
=============

Primus defines a training configuration in YAML for each model in
`examples/megatron/configs <https://github.com/AMD-AGI/Primus/tree/43a6e006c419697208295c5523b99070e8198ad9/examples/megatron/configs>`__.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/primus-megatron-benchmark-models.yaml

   {% set model_groups = data.model_groups %}
   {% for model_group in model_groups %}
      {% for model in model_group.models %}
   .. container:: model-doc {{ model.mad_tag }}

      For example, to update training parameters for {{ model.model }}, you can
      update ``examples/megatron/configs/{{ model.config_name }}``. Training
      configuration YAML files for other models follow this naming convention.

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

.. _amd-primus-megatron-lm-tokenizer-v26.3:

Tokenizer
---------

Set the ``HF_TOKEN`` environment variable with
right permissions to access the tokenizer for each model.

.. code-block:: bash

   # Export your HF_TOKEN in the workspace
   export HF_TOKEN=<your_hftoken>

.. _amd-primus-megatron-lm-run-training-v26.3:

Run training
============

Use the following example commands to set up the environment, configure
:ref:`key options <amd-primus-megatron-lm-benchmark-test-vars>`, and run training on
AMD Instinct GPUs using Primus with the Megatron backend.

Single node training
--------------------

To run training on a single node, navigate to ``/workspace/Primus`` and use the following setup command:

.. code-block:: shell

   pip install -r requirements.txt

.. container:: model-doc primus_pyt_megatron_lm_train_llama-3.3-70b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Llama 3.3 70B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To run pre-training for Llama 3.3 70B BF16, run:

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_llama3.3_70B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/llama3.3_70B-BF16-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_llama3.3_70B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/llama3.3_70B-BF16-pretrain.yaml

.. container:: model-doc primus_pyt_megatron_lm_train_llama-3.1-8b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Llama 3.1 8B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To run pre-training for Llama 3.1 8B FP8, run:

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_llama3.1_8B_fp8.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/llama3.1_8B-FP8-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_llama3.1_8B_fp8.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/llama3.1_8B-FP8-pretrain.yaml

   For Llama 3.1 8B BF16, use the following command:

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_llama3.1_8B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/llama3.1_8B-BF16-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_llama3.1_8B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/llama3.1_8B-BF16-pretrain.yaml

.. container:: model-doc primus_pyt_megatron_lm_train_llama-3.1-70b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Llama 3.1 70B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To run pre-training for Llama 3.1 70B BF16, run:

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_llama3.1_70B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/llama3.1_70B-BF16-pretrain.yaml \
              --micro_batch_size 8 \
              --global_batch_size 128

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_llama3.1_70B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/llama3.1_70B-BF16-pretrain.yaml

   To run the training on a single node for Llama 3.1 70B FP8, use the following command.

   .. note::

      The MI300X configuration uses a proxy model. On MI300X GPUs, use two or more nodes
      to run the full Llama 3.1 70B model with FP8 precision. MI355X and MI350X GPUs
      can support the full 70B model with FP8 precision on a single node.

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_llama3.1_70B_fp8.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/llama3.1_70B-FP8-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_llama3.1_70B_fp8_proxy.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/llama3.1_70B-FP8-pretrain.yaml \
              --train_iters 50 \
              --num_layers 40 \
              --fp8 hybrid \
              --no_fp8_weight_transpose_cache true

.. container:: model-doc primus_pyt_megatron_lm_train_llama-2-7b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Llama 2 7B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To run pre-training for Llama 2 7B FP8, run:

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_llama2_7B_fp8.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/llama2_7B-FP8-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_llama2_7B_fp8.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/llama2_7B-FP8-pretrain.yaml

   To run pre-training for Llama 2 7B BF16, run:

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_llama2_7B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/llama2_7B-BF16-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_llama2_7B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/llama2_7B-BF16-pretrain.yaml

.. container:: model-doc primus_pyt_megatron_lm_train_llama-2-70b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Llama 2 70B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To run pre-training for Llama 2 70B BF16, run:

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_llama2_70B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/llama2_70B-BF16-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_llama2_70B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/llama2_70B-BF16-pretrain.yaml

.. container:: model-doc primus_pyt_megatron_lm_train_deepseek-v2-lite-16b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to DeepSeek-V2-Lite.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To run training on a single node for DeepSeek-V2-Lite (MoE with expert parallel) BF16,
   use the following command:

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_deepseek_v2_lite.log \
              -- train pretrain \
              --config examples/megatron/configs//MI355X/deepseek_v2_lite-BF16-pretrain.yaml \
              --use_turbo_grouped_mlp False \
              --moe_use_legacy_grouped_gemm True \
              --moe_use_fused_router_with_aux_score True \
              --moe_permute_fusion True

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_deepseek_v2_lite.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/deepseek_v2_lite-BF16-pretrain.yaml

.. container:: model-doc primus_pyt_megatron_lm_train_mixtral-8x7b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Mixtral 8x7B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To run training on a single node for Mixtral 8x7B (MoE with expert parallel),
   use the following command:

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_mixtral_8x7B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/mixtral_8x7B_v0.1-BF16-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_mixtral_8x7B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/mixtral_8x7B_v0.1-BF16-pretrain.yaml

.. container:: model-doc primus_pyt_megatron_lm_train_qwen3-32b-lora

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to post-training Qwen 3 32B (LoRA).
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To run training on a single node for Qwen 3 32B BF16 (SFT), use the following
   command:

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_qwen3_32b.log \
              -- train posttrain \
              --config examples/megatron_bridge/configs/MI355X/qwen3_32b_lora_posttrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_qwen3_32b.log \
              -- train posttrain \
              --config examples/megatron_bridge/configs/MI300X/qwen3_32b_lora_posttrain.yaml

.. container:: model-doc primus_pyt_megatron_lm_train_qwen3-32b-sft

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to post-training Qwen 3 32B (SFT).
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To run training on a single node for Qwen 3 32B BF16 (SFT), use the following
   command:

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_qwen3_32b_sft.log \
              -- train posttrain \
              --config examples/megatron_bridge/configs/MI355X/qwen3_32b_sft_posttrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_qwen3_32b_sft.log \
              -- train posttrain \
              --config examples/megatron_bridge/configs/MI300X/qwen3_32b_sft_posttrain.yaml

.. container:: model-doc primus_pyt_megatron_lm_train_qwen2.5-7b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Qwen 2.5 7B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To run training on a single node for Qwen 2.5 7B BF16, use the following
   command:

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_qwen2.5_7B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/qwen2.5_7B-BF16-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_qwen2.5_7B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/qwen2.5_7B-BF16-pretrain.yaml

   For FP8, use the following command.

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_qwen2.5_7B_fp8.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/qwen2.5_7B-FP8-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_qwen2.5_7B_fp8.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/qwen2.5_7B-FP8-pretrain.yaml

.. container:: model-doc primus_pyt_megatron_lm_train_qwen2.5-72b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Qwen 2.5 72B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To run the training on a single node for Qwen 2.5 72B BF16, use the following command.

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_qwen2.5_72B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/qwen2.5_72B-BF16-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_qwen2.5_72B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/qwen2.5_72B-BF16-pretrain.yaml

.. container:: model-doc primus_pyt_megatron_lm_train_zebra-llama-1b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Zebra-Llama 1B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To run the training on a single node for AMD Zebra-Llama 1B BF16, use the following command.

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            PRIMUS_TRAIN_RUNTIME=legacy bash runner/primus-cli direct \
              --log_file /tmp/primus_zebra_llama_1B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/zebra_llama_1B-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            PRIMUS_TRAIN_RUNTIME=legacy bash runner/primus-cli direct \
              --log_file /tmp/primus_zebra_llama_1B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/zebra_llama_1B-pretrain.yaml

.. container:: model-doc primus_pyt_megatron_lm_train_zebra-llama-3b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Zebra-Llama 3B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To run the training on a single node for AMD Zebra-Llama 3B BF16, use the following command.

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            PRIMUS_TRAIN_RUNTIME=legacy bash runner/primus-cli direct \
              --log_file /tmp/primus_zebra_llama_3B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/zebra_llama_3B-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            PRIMUS_TRAIN_RUNTIME=legacy bash runner/primus-cli direct \
              --log_file /tmp/primus_zebra_llama_3B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/zebra_llama_3B-pretrain.yaml

.. container:: model-doc primus_pyt_megatron_lm_train_zebra-llama-8b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Zebra Llama 8B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To run the training on a single node for AMD Zebra-Llama 8B BF16, use the following command.

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            PRIMUS_TRAIN_RUNTIME=legacy bash runner/primus-cli direct \
              --log_file /tmp/primus_zebra_llama_8B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/zebra_llama_8B-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            PRIMUS_TRAIN_RUNTIME=legacy bash runner/primus-cli direct \
              --log_file /tmp/primus_zebra_llama_8B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/zebra_llama_8B-pretrain.yaml

.. container:: model-doc primus_pyt_megatron_lm_train_qwen3-30b-a3b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Qwen 3 30B (A3B).
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To run training on a single node for Qwen 3 30B (A3B) BF16, use the following command:

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_qwen3_30B_A3B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/qwen3_30B_A3B-BF16-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_qwen3_30B_A3B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/qwen3_30B_A3B-BF16-pretrain.yaml

   For FP8, use the following command.

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_qwen3_30B_A3B_fp8.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/qwen3_30B_A3B-FP8-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_qwen3_30B_A3B_fp8.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/qwen3_30B_A3B-FP8-pretrain.yaml

.. container:: model-doc primus_pyt_megatron_lm_train_gpt-oss-20b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to GPT-OSS-20B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To run training on a single node for GPT-OSS-20B BF16, use the following command:

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_gpt_oss_20B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/gpt_oss_20B-BF16-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_gpt_oss_20B.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/gpt_oss_20B-BF16-pretrain.yaml

   For FP8, use the following command.

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            bash runner/primus-cli direct \
              --log_file /tmp/primus_gpt_oss_20B_fp8.log \
              -- train pretrain \
              --config examples/megatron/configs/MI355X/gpt_oss_20B-FP8-pretrain.yaml

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            # Set the variables for better performance
            # only on MI325X and MI300X
            export HSA_NO_SCRATCH_RECLAIM=1
            export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
            export NVTE_CK_IS_V3_ATOMIC_FP32=1

            bash runner/primus-cli direct \
              --log_file /tmp/primus_gpt_oss_20B_fp8.log \
              -- train pretrain \
              --config examples/megatron/configs/MI300X/gpt_oss_20B-FP8-pretrain.yaml

.. _amd-primus-megatron-multi-node-examples-v26.3:

Multi-node training examples
----------------------------

Refer to :doc:`/how-to/rocm-for-ai/system-setup/multi-node-setup` to configure your environment for multi-node
training.

To run training on multiple nodes, you can use ``primus-cli`` (recommended) or the
`run_slurm_pretrain.sh <https://github.com/AMD-AGI/Primus/blob/main/examples/run_slurm_pretrain.sh>`__
script to launch multi-node workloads. Use the following steps to set up your environment:

.. important::

   **Verify NCCL / network environment first.** The ``primus-cli`` launcher sets sensible
   ``NCCL_*`` defaults via ``base_env.sh``, but auto-detection can pick the wrong device
   on multi-NIC nodes. Always confirm ``NCCL_IB_HCA``, ``NCCL_IB_GID_INDEX``,
   ``NCCL_SOCKET_IFNAME``, and ``GLOO_SOCKET_IFNAME`` (set to the same value as
   ``NCCL_SOCKET_IFNAME``) are correct for your fabric. If necessary, export these
   environment variables before running.

.. code-block:: shell

   git clone --recurse-submodules https://github.com/AMD-AGI/Primus.git
   cd Primus/
   git checkout release/v26.3
   git submodule update --init --recursive
   export DOCKER_IMAGE=rocm/primus:v26.3
   export HF_TOKEN=<your_HF_token>
   export NCCL_IB_HCA=<your_NCCL_IB_HCA> # specify which RDMA interfaces to use for communication
   export NCCL_SOCKET_IFNAME=<your_NCCL_SOCKET_IFNAME> # your Network Interface
   export GLOO_SOCKET_IFNAME=<your_GLOO_SOCKET_IFNAME> # your Network Interface
   export NCCL_IB_GID_INDEX=3 # Set InfiniBand GID index for NCCL communication. Default is 3 for ROCE

   # MI300/MI325X only -- for better performance
   export HSA_NO_SCRATCH_RECLAIM=1
   export PRIMUS_TURBO_ATTN_V3_ATOMIC_FP32=1
   export NVTE_CK_IS_V3_ATOMIC_FP32=1

For clusters using AMD AINIC, also set the following:

.. code-block:: shell

   export USING_AINIC=1
   export NCCL_PXN_DISABLE=0
   export NCCL_IB_GID_INDEX=1

.. note::

   * Make sure correct network drivers are installed on the nodes. If inside a Docker, either install the drivers inside the Docker container or pass the network drivers from the host while creating the Docker container.
   * If ``NCCL_IB_HCA`` and ``NCCL_SOCKET_IFNAME`` are not set, Primus will try to auto-detect. However, since NICs can vary across different clusters, it is encouraged to explicitly export your NCCL parameters for the cluster.
   * To find your network interface, you can use ``ip a``.
   * To find RDMA interfaces, you can use ``ibv_devices`` to get the list of all the RDMA/IB devices.

.. container:: model-doc primus_pyt_megatron_lm_train_llama-3.1-8b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Llama 3.1 8B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To train Llama 3.1 8B FP8 on 8 nodes, run:

   .. code-block:: shell

      # Adjust the training parameters.
      # For example, `global_batch_size: 8 * #single_node_bs` for 8 nodes in this case.
      NNODES=8 EXP=examples/megatron/configs/MI300X/llama3.1_8B-FP8-pretrain.yaml \
      bash ./examples/run_slurm_pretrain.sh --global_batch_size 1024

.. container:: model-doc primus_pyt_megatron_lm_train_llama-2-7b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Llama 2 7B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To train Llama 2 7B FP8 on 8 nodes, run:

   .. code-block:: shell

      # Adjust the training parameters.
      # For example, `global_batch_size: 8 * #single_node_bs` for 8 nodes in this case.
      NNODES=8 EXP=examples/megatron/configs/MI300X/llama2_7B-FP8-pretrain.yaml \
      bash ./examples/run_slurm_pretrain.sh --global_batch_size 2048

.. container:: model-doc primus_pyt_megatron_lm_train_llama-3.1-70b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Llama 3.1 70B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To train Llama 3.1 70B FP8 on 8 nodes, run:

   .. code-block:: shell

      NNODES=8 EXP=examples/megatron/configs/MI300X/llama3.1_70B-FP8-pretrain.yaml \
      bash examples/run_slurm_pretrain.sh \
          --micro_batch_size 4 --global_batch_size 256 --recompute_num_layers 80

   To train Llama 3.1 70B BF16 on 8 nodes, run:

   .. code-block:: shell

      NNODES=8 EXP=examples/megatron/configs/MI300X/llama3.1_70B-BF16-pretrain.yaml \
      bash examples/run_slurm_pretrain.sh \
          --micro_batch_size 1 --global_batch_size 256 --recompute_num_layers 12

.. container:: model-doc primus_pyt_megatron_lm_train_llama-2-70b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Llama 2 70B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To train Llama 2 70B FP8 on 8 nodes, run:

   .. code-block:: shell

      NNODES=8 EXP=examples/megatron/configs/MI300X/llama2_70B-FP8-pretrain.yaml \
      bash examples/run_slurm_pretrain.sh \
          --micro_batch_size 10 --global_batch_size 640 --recompute_num_layers 80

   To train Llama 2 70B BF16 on 8 nodes, run:

   .. code-block:: shell

      NNODES=8 EXP=examples/megatron/configs/MI300X/llama2_70B-BF16-pretrain.yaml \
      bash ./examples/run_slurm_pretrain.sh \
          --micro_batch_size 2 --global_batch_size 1536 --recompute_num_layers 12

.. container:: model-doc primus_pyt_megatron_lm_train_llama-3.3-70b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Llama 3.3 70B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To train Llama 3.3 70B FP8 on 8 nodes, run:

   .. code-block:: shell

      NNODES=8 EXP=examples/megatron/configs/MI300X/llama3.3_70B-FP8-pretrain.yaml \
      bash examples/run_slurm_pretrain.sh \
          --micro_batch_size 4 --global_batch_size 256 --recompute_num_layers 80

   To train Llama 3.3 70B BF16 on 8 nodes, run:

   .. code-block:: shell

      NNODES=8 EXP=examples/megatron/configs/MI300X/llama3.3_70B-BF16-pretrain.yaml \
      bash examples/run_slurm_pretrain.sh \
          --micro_batch_size 1 --global_batch_size 256 --recompute_num_layers 12

.. container:: model-doc primus_pyt_megatron_lm_train_mixtral-8x7b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Mixtral 8x7B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To train Mixtral 8x7B BF16 on 8 nodes, run:

   .. code-block:: shell

      NNODES=8 EXP=examples/megatron/configs/MI300X/mixtral_8x7B_v0.1-BF16-pretrain.yaml \
      bash examples/run_slurm_pretrain.sh \
          --micro_batch_size 2 --global_batch_size 256

To train Mixtral 8x22B BF16 on 4 nodes using ``primus-cli`` (recommended), run:

.. code-block:: shell

   # In the Primus directory
   ./primus-cli slurm srun -N 4 -- train pretrain \
       --config examples/megatron/configs/MI355X/mixtral_8x22B_v0.1-BF16-pretrain.yaml \
       --micro_batch_size 1 \
       --global_batch_size 512 \
       --num_virtual_stages_per_pipeline_rank 2 \
       --pipeline_model_parallel_size 4 \
       --expert_model_parallel_size 8 \
       --recompute_num_layers 1 \
       --moe_use_legacy_grouped_gemm True \
       --gradient_accumulation_fusion True

Alternatively, using the legacy script:

.. code-block:: shell

   NNODES=4 EXP=examples/megatron/configs/MI355X/mixtral_8x22B_v0.1-BF16-pretrain.yaml \
   bash examples/run_slurm_pretrain.sh \
       --micro_batch_size 1 \
       --global_batch_size 512 \
       --num_virtual_stages_per_pipeline_rank 2 \
       --pipeline_model_parallel_size 4 \
       --expert_model_parallel_size 8 \
       --recompute_num_layers 1 \
       --moe_use_legacy_grouped_gemm True \
       --gradient_accumulation_fusion True

.. container:: model-doc primus_pyt_megatron_lm_train_qwen2.5-72b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Qwen 2.5 72B.
   See :ref:`amd-primus-megatron-lm-model-support-v26.3` to switch to another available model.

   To train Qwen 2.5 72B FP8 on 8 nodes, run:

   .. code-block:: shell

      NNODES=8 EXP=examples/megatron/configs/MI300X/qwen2.5_72B-FP8-pretrain.yaml \
      bash examples/run_slurm_pretrain.sh \
          --micro_batch_size 8 --global_batch_size 512 --recompute_num_layers 80

To train Llama 3.1 405B FP8 on 8 nodes using ``primus-cli`` (recommended), run:

.. code-block:: shell

   # In the Primus directory
   # TP=8 is used for Llama 3.1 405B on 8 nodes. The model has 126 layers which is not
   # divisible by 8, so decoder_first_pipeline_num_layers and
   # decoder_last_pipeline_num_layers must be set explicitly.
   ./primus-cli slurm srun -N 8 -- train pretrain \
       --config examples/megatron/configs/MI325X/llama3.1_405B-FP8-pretrain.yaml \
       --micro_batch_size 1 \
       --global_batch_size 256 \
       --decoder_first_pipeline_num_layers 15 \
       --decoder_last_pipeline_num_layers 15

Alternatively, using the legacy script:

.. code-block:: shell

   NNODES=8 EXP=examples/megatron/configs/MI300X/llama3.1_405B-FP8-pretrain.yaml \
   bash examples/run_slurm_pretrain.sh \
       --micro_batch_size 1 \
       --global_batch_size 256 \
       --decoder_first_pipeline_num_layers 15 \
       --decoder_last_pipeline_num_layers 15

.. _amd-primus-megatron-lm-benchmark-test-vars-v26.3:

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

Further reading
===============

- For an introduction to Primus, see `Primus: A Lightweight, Unified Training
  Framework for Large Models on AMD GPUs <https://rocm.blogs.amd.com/software-tools-optimization/primus/README.html>`__.

- To learn more about system settings and management practices to configure your system for
  AMD Instinct MI300X Series GPUs, see `AMD Instinct MI300X system optimization <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/system-optimization/mi300x.html>`_.

- For a list of other ready-made Docker images for AI with ROCm, see
  `AMD Infinity Hub <https://www.amd.com/en/developer/resources/infinity-hub.html#f-amd_hub_category=AI%20%26%20ML%20Models>`_.

Previous versions
=================

See :doc:`previous-versions/megatron-lm-history` to find documentation for previous releases
of the ``ROCm/megatron-lm`` Docker image.

This training environment now uses Primus with Megatron as the primary
configuration. Limited support for the legacy ROCm Megatron-LM is still
available; see the :doc:`megatron-lm` documentation.
