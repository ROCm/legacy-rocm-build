:orphan:

.. meta::
   :description: How to train a model using Megatron-LM for ROCm.
   :keywords: ROCm, AI, LLM, train, Megatron-LM, megatron, Llama, tutorial, docker, torch

******************************************
Training a model with Megatron-LM on ROCm
******************************************

.. caution::

   This documentation does not reflect the latest version of ROCm Megatron-LM
   training performance documentation. See :doc:`../megatron-lm` for the latest version.

   For a unified training solution on AMD GPUs with ROCm, the `rocm/megatron-lm
   <https://hub.docker.com/r/rocm/megatron-lm/>`__ Docker Hub registry will be
   deprecated soon in favor of `rocm/primus <https://hub.docker.com/r/rocm/primus>`__.
   The ``rocm/primus`` Docker containers will cover PyTorch training ecosystem frameworks,
   including Megatron-LM and :doc:`torchtitan <../primus-pytorch>`.

   Primus with Megatron is designed to replace this ROCm Megatron-LM training workflow.
   To learn how to migrate workloads from Megatron-LM to Primus with Megatron,
   see :doc:`megatron-lm-primus-migration-guide`.

The `Megatron-LM framework for ROCm <https://github.com/ROCm/Megatron-LM>`_ is
a specialized fork of the robust Megatron-LM, designed to enable efficient
training of large-scale language models on AMD GPUs. By leveraging AMD
Instinct™ GPUs, Megatron-LM delivers enhanced scalability, performance, and
resource utilization for AI workloads. It is
purpose-built to support models like Llama, DeepSeek, and Mixtral,
enabling developers to train next-generation AI models more
efficiently.

AMD provides ready-to-use Docker images for MI355X, MI350X, MI325X, and MI300X
GPUs containing essential components, including PyTorch, ROCm libraries, and
Megatron-LM utilities. It contains the following software components to
accelerate training workloads:

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/previous-versions/megatron-lm-v25.9-benchmark-models.yaml

   {% set dockers = data.dockers %}
   .. tab-set::

   {% for supported_gpus, docker in dockers.items() %}
      .. tab-item:: {{ supported_gpus }}
         :sync: {{ supported_gpus }}

         .. list-table::
            :header-rows: 1

            * - Software component
              - Version

            {% for component_name, component_version in docker.components.items() %}
            * - {{ component_name }}
              - {{ component_version }}
            {% endfor %}
   {% endfor %}
   .. _amd-megatron-lm-model-support:

   Supported models
   ================

   The following models are supported for training performance benchmarking with Megatron-LM and ROCm
   on AMD Instinct MI300X Series GPUs.
   Some instructions, commands, and training recommendations in this documentation might
   vary by model -- select one to get started.

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

.. _amd-megatron-lm-performance-measurements:

Performance measurements
========================

To evaluate performance, the
`Performance results with AMD ROCm software <https://www.amd.com/en/developer/resources/rocm-hub/dev-ai/performance-results.html#tabs-a8deaeb413-item-21cea50186-tab>`__
page provides reference throughput and latency measurements for training
popular AI models.

.. important::

   The performance data presented in
   `Performance results with AMD ROCm software <https://www.amd.com/en/developer/resources/rocm-hub/dev-ai/performance-results.html>`__
   only reflects the latest version of this training benchmarking environment.
   The listed measurements should not be interpreted as the peak performance achievable by AMD Instinct MI325X and MI300X GPUs or ROCm software.

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

.. _mi300x-amd-megatron-lm-training:

Environment setup
=================

Use the following instructions to set up the environment, configure the script to train models, and
reproduce the benchmark results on MI300X Series GPUs with the AMD Megatron-LM Docker
image.

.. _amd-megatron-lm-requirements:

Download the Docker image
-------------------------

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/previous-versions/megatron-lm-v25.9-benchmark-models.yaml

   {% set dockers = data.dockers %}
   1. Use the following command to pull the Docker image from Docker Hub.

      .. tab-set::

         {% for supported_gpus, docker in dockers.items() %}
         .. tab-item:: {{ supported_gpus }}
            :sync: {{ supported_gpus }}

            .. code-block:: shell

               docker pull {{ docker.pull_tag }}
         {% endfor %}

   2. Launch the Docker container.

      .. tab-set::

         {% for supported_gpus, docker in dockers.items() %}
         .. tab-item:: {{ supported_gpus }}
            :sync: {{ supported_gpus }}

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
                   -v $HOME/.ssh:/root/.ssh \
                   --shm-size 128G \
                   --name megatron_training_env \
                   {{ docker.pull_tag }}
         {% endfor %}

3. Use these commands if you exit the ``megatron_training_env`` container and need to return to it.

   .. code-block:: shell

      docker start megatron_training_env
      docker exec -it megatron_training_env bash

4. **Megatron-LM backward compatibility setup** -- this Docker is primarily intended for use with Primus, but it maintains Megatron-LM compatibility with limited support.
   To roll back to using Megatron-LM, follow these steps:

   .. code-block:: shell

      cd /workspace/Megatron-LM/
      pip uninstall megatron-core
      pip install -e .

The Docker container hosts a verified commit of
`<https://github.com/ROCm/Megatron-LM/tree/rocm_dev>`__.

.. _amd-megatron-lm-environment-setup:

Configuration
=============

.. container:: model-doc pyt_megatron_lm_train_llama-3.3-70b pyt_megatron_lm_train_llama-3.1-8b pyt_megatron_lm_train_llama-3.1-70b

   Update the ``train_llama3.sh`` configuration script in the ``examples/llama``
   directory of
   `<https://github.com/ROCm/Megatron-LM/tree/rocm_dev/examples/llama>`__ to configure your training run.
   Options can also be passed as command line arguments as described in :ref:`Run training <amd-megatron-lm-run-training>`.

.. container:: model-doc pyt_megatron_lm_train_llama-2-7b pyt_megatron_lm_train_llama-2-70b

   Update the ``train_llama2.sh`` configuration script in the ``examples/llama``
   directory of
   `<https://github.com/ROCm/Megatron-LM/tree/rocm_dev/examples/llama>`__ to configure your training run.
   Options can also be passed as command line arguments as described in :ref:`Run training <amd-megatron-lm-run-training>`.

.. container:: model-doc pyt_megatron_lm_train_deepseek-v3-proxy

   Update the ``train_deepseekv3.sh`` configuration script in the ``examples/deepseek_v3``
   directory of
   `<https://github.com/ROCm/Megatron-LM/tree/rocm_dev/examples/deepseek_v3>`__ to configure your training run.
   Options can also be passed as command line arguments as described in :ref:`Run training <amd-megatron-lm-run-training>`.

.. container:: model-doc pyt_megatron_lm_train_deepseek-v2-lite-16b

   Update the ``train_deepseekv2.sh`` configuration script in the ``examples/deepseek_v2``
   directory of
   `<https://github.com/ROCm/Megatron-LM/tree/rocm_dev/examples/deepseek_v2>`__ to configure your training run.
   Options can also be passed as command line arguments as described in :ref:`Run training <amd-megatron-lm-run-training>`.

.. container:: model-doc pyt_megatron_lm_train_mixtral-8x7b pyt_megatron_lm_train_mixtral-8x22b-proxy

   Update the ``train_mixtral_moe.sh`` configuration script in the ``examples/mixtral``
   directory of
   `<https://github.com/ROCm/Megatron-LM/tree/rocm_dev/examples/mixtral>`__ to configure your training run.
   Options can also be passed as command line arguments as described in :ref:`Run training <amd-megatron-lm-run-training>`.

.. note::

   See :ref:`Key options <amd-megatron-lm-benchmark-test-vars>` for more information on configuration options.

Multi-node configuration
------------------------

Refer to :doc:`/how-to/rocm-for-ai/system-setup/multi-node-setup` to configure your environment for multi-node
training. See :ref:`amd-megatron-lm-multi-node-examples` for example run commands.

.. _amd-megatron-lm-tokenizer:

Tokenizer
---------

You can assign the path of an existing tokenizer to the ``TOKENIZER_MODEL`` as shown in the following examples.
If the tokenizer is not found, it'll be downloaded if publicly available.

.. container:: model-doc pyt_megatron_lm_train_llama-3.3-70b

   If you do not have Llama 3.3 tokenizer locally, you need to use your
   personal Hugging Face access token ``HF_TOKEN`` to download the tokenizer.
   See `Llama-3.3-70B-Instruct
   <https://huggingface.co/meta-llama/Llama-3.3-70B-Instruct>`_. After you are
   authorized, use your ``HF_TOKEN`` to download the tokenizer and set the
   variable ``TOKENIZER_MODEL`` to the tokenizer path.

   .. code-block:: shell

      export HF_TOKEN=<Your personal Hugging Face access token>

   The training script uses the ``HuggingFaceTokenizer``. Set ``TOKENIZER_MODEL`` to the appropriate Hugging Face model path.

   .. code-block:: shell

      TOKENIZER_MODEL="meta-llama/Llama-3.3-70B-Instruct"

.. container:: model-doc pyt_megatron_lm_train_llama-3.1-8b

   The training script uses the ``HuggingFaceTokenizer``. Set ``TOKENIZER_MODEL`` to the appropriate Hugging Face model path.

   .. code-block:: shell

      TOKENIZER_MODEL="meta-llama/Llama-3.1-8B"

.. container:: model-doc pyt_megatron_lm_train_llama-3.1-70b

   The training script uses the ``HuggingFaceTokenizer``. Set ``TOKENIZER_MODEL`` to the appropriate Hugging Face model path.

   .. code-block:: shell

      TOKENIZER_MODEL="meta-llama/Llama-3.1-70B"

.. container:: model-doc pyt_megatron_lm_train_llama-2-7b pyt_megatron_lm_train_llama-2-70b

   The training script uses either the ``Llama2Tokenizer`` or ``HuggingFaceTokenizer`` by default.

.. container:: model-doc pyt_megatron_lm_train_deepseek-v3-proxy

   The training script uses the ``HuggingFaceTokenizer``. Set ``TOKENIZER_MODEL`` to the appropriate Hugging Face model path.

   .. code-block:: shell

      TOKENIZER_MODEL="deepseek-ai/DeepSeek-V3"

.. container:: model-doc pyt_megatron_lm_train_deepseek-v2-lite-16b

   The training script uses the ``HuggingFaceTokenizer``. Set ``TOKENIZER_MODEL`` to the appropriate Hugging Face model path.

   .. code-block:: shell

      TOKENIZER_MODEL="deepseek-ai/DeepSeek-V2-Lite"

.. container:: model-doc pyt_megatron_lm_train_mixtral-8x7b pyt_megatron_lm_train_mixtral-8x22b-proxy

   Download the Mixtral tokenizer.

   .. code-block:: shell

      mkdir tokenizer
      cd tokenizer
      export HF_TOKEN=<Your personal Hugging Face access token>
      wget --header="Authorization: Bearer $HF_TOKEN" -O ./tokenizer.model https://huggingface.co/mistralai/Mixtral-8x7B-v0.1/resolve/main/tokenizer.model

   Use the ``HuggingFaceTokenizer``. Set ``TOKENIZER_MODEL`` to the appropriate Hugging Face model path.

   .. code-block:: shell

      TOKENIZER_MODEL=tokenizer/tokenizer.model

.. container:: model-doc pyt_megatron_lm_train_qwen2.5-7b

   The training script uses the ``HuggingFaceTokenizer``. Set ``TOKENIZER_MODEL`` to the appropriate Hugging Face model path.

   .. code-block:: shell

      TOKENIZER_MODEL="Qwen/Qwen2.5-7B"

.. container:: model-doc pyt_megatron_lm_train_qwen2.5-72b

   The training script uses the ``HuggingFaceTokenizer``. Set ``TOKENIZER_MODEL`` to the appropriate Hugging Face model path.

   .. code-block:: shell

      TOKENIZER_MODEL="Qwen/Qwen2.5-72B"

Dataset options
---------------

You can use either mock data or real data for training.

* Mock data can be useful for testing and validation. Use the ``MOCK_DATA`` variable to toggle between mock and real data. The default
  value is ``1`` for enabled.

  .. code-block:: bash

     MOCK_DATA=1

* If you're using a real dataset, update the ``DATA_PATH`` variable to point to the location of your dataset.

  .. code-block:: bash

     MOCK_DATA=0

     DATA_PATH="/data/bookcorpus_text_sentence"  # Change to where your dataset is stored

  Ensure that the files are accessible inside the Docker container.

Download the dataset
^^^^^^^^^^^^^^^^^^^^

.. container:: model-doc pyt_megatron_lm_train_llama-3.3-70b pyt_megatron_lm_train_llama-3.1-8b pyt_megatron_lm_train_llama-3.1-70b pyt_megatron_lm_train_llama-2-7b pyt_megatron_lm_train_llama-2-70b pyt_megatron_lm_train_llama-3.1-70b-proxy

   For Llama models, use the `prepare_dataset.sh
   <https://github.com/ROCm/Megatron-LM/tree/rocm_dev/examples/llama>`_ script
   to prepare your dataset.
   To download the dataset, set the ``DATASET`` variable to the dataset you'd
   like to use. Three datasets are supported: ``DATASET=wiki``, ``DATASET=fineweb``, and
   ``DATASET=bookcorpus``.

   .. code-block:: shell

      DATASET=wiki TOKENIZER_MODEL=NousResearch/Llama-2-7b-chat-hf bash examples/llama/prepare_dataset.sh #for wiki-en dataset
      DATASET=bookcorpus TOKENIZER_MODEL=NousResearch/Llama-2-7b-chat-hf bash examples/llama/prepare_dataset.sh #for bookcorpus dataset

   ``TOKENIZER_MODEL`` can be any accessible Hugging Face tokenizer.
   Remember to either pre-download the tokenizer or setup Hugging Face access
   otherwise when needed -- see the :ref:`Tokenizer <amd-megatron-lm-tokenizer>` section.

   .. note::

      When training set ``DATA_PATH`` to the specific file name prefix pointing to the ``.bin`` or ``.idx``
      as in the following example:

      .. code-block:: shell

         DATA_PATH="data/bookcorpus_text_sentence" # Change to where your dataset is stored.

.. container:: model-doc pyt_megatron_lm_train_deepseek-v3-proxy

   If you don't already have the dataset, download the DeepSeek dataset using the following
   commands:

   .. code-block:: shell

      mkdir deepseek-datasets
      cd deepseek-datasets
      wget https://atp-modelzoo-wlcb-pai.oss-cn-wulanchabu.aliyuncs.com/release/models/pai-megatron-patch/deepseek-datasets/SlimPajama.json
      wget https://atp-modelzoo-wlcb-pai.oss-cn-wulanchabu.aliyuncs.com/release/models/pai-megatron-patch/deepseek-datasets/alpaca_zh-train.json
      wget https://atp-modelzoo-wlcb-pai.oss-cn-wulanchabu.aliyuncs.com/release/models/pai-megatron-patch/deepseek-datasets/alpaca_zh-valid.json
      cd ..
      bash tools/run_make_pretraining_dataset_megatron.sh deepseek-datasets/SlimPajama.json DeepSeekV3Tokenizer text deepseek-datasets deepseek-ai/DeepSeek-V3

   To train on this data, update the ``DATA_DIR`` variable to point to the location of your dataset.

   .. code-block:: bash

      MOCK_DATA=0 # Train on real data

      DATA_DIR="<path-to>/deepseek-datasets"  # Change to where your dataset is stored

      Ensure that the files are accessible inside the Docker container.

.. container:: model-doc pyt_megatron_lm_train_deepseek-v2-lite-16b

   If you don't already have the dataset, download the DeepSeek dataset using the following
   commands:

   .. code-block:: shell

      mkdir deepseek-datasets
      cd deepseek-datasets
      wget https://atp-modelzoo-wlcb-pai.oss-cn-wulanchabu.aliyuncs.com/release/models/pai-megatron-patch/deepseek-datasets/SlimPajama.json
      wget https://atp-modelzoo-wlcb-pai.oss-cn-wulanchabu.aliyuncs.com/release/models/pai-megatron-patch/deepseek-datasets/alpaca_zh-train.json
      wget https://atp-modelzoo-wlcb-pai.oss-cn-wulanchabu.aliyuncs.com/release/models/pai-megatron-patch/deepseek-datasets/alpaca_zh-valid.json
      cd ..
      bash tools/run_make_pretraining_dataset_megatron.sh deepseek-datasets/SlimPajama.json DeepSeekV3Tokenizer text deepseek-datasets deepseek-ai/DeepSeek-V3

   To train on this data, update the ``DATA_DIR`` variable to point to the location of your dataset.

   .. code-block:: bash

      MOCK_DATA=0 # Train on real data

      DATA_DIR="<path-to>/deepseek-datasets"  # Change to where your dataset is stored

.. container:: model-doc pyt_megatron_lm_train_mixtral-8x7b pyt_megatron_lm_train_mixtral-8x22b-proxy

   If you don't already have the dataset, download the Mixtral dataset using the following
   commands:

   .. code-block:: shell

      mkdir mixtral-datasets
      cd mixtral-datasets
      wget https://atp-modelzoo-wlcb-pai.oss-cn-wulanchabu.aliyuncs.com/release/models/pai-megatron-patch/mistral-datasets/wudao_mistralbpe_content_document.bin
      wget https://atp-modelzoo-wlcb-pai.oss-cn-wulanchabu.aliyuncs.com/release/models/pai-megatron-patch/mistral-datasets/wudao_mistralbpe_content_document.idx

   To train on this data, update the ``DATA_DIR`` variable to point to the location of your dataset.

   .. code-block:: bash

      MOCK_DATA=0 # Train on real data

      DATA_DIR="<path-to>/mixtral-datasets"  # Change to where your dataset is stored

   Ensure that the files are accessible inside the Docker container.

.. container:: model-doc pyt_megatron_lm_train_qwen2.5-7b pyt_megatron_lm_train_qwen2.5-72b

   If you don't already have the dataset, download the Mixtral dataset using the following
   commands:

   .. code-block:: shell

      mkdir -p temp/qwen-datasets
      wget https://atp-modelzoo-wlcb-pai.oss-cn-wulanchabu.aliyuncs.com/release/models/pai-megatron-patch/qwen-datasets/wudao_qwenbpe_text_document.bin
      wget https://atp-modelzoo-wlcb-pai.oss-cn-wulanchabu.aliyuncs.com/release/models/pai-megatron-patch/qwen-datasets/wudao_qwenbpe_text_document.idx

   To train on this data, update the ``DATA_DIR`` variable to point to the location of your dataset.

   .. code-block:: bash

      MOCK_DATA=0 # Train on real data

      DATA_DIR="<path-to>/qwen-datasets"  # Change to where your dataset is stored

   Ensure that the files are accessible inside the Docker container.

.. _amd-megatron-lm-run-training:

Run training
============

Use the following example commands to set up the environment, configure
:ref:`key options <amd-megatron-lm-benchmark-test-vars>`, and run training on
MI300X Series GPUs with the AMD Megatron-LM environment.

Single node training
--------------------

.. container:: model-doc pyt_megatron_lm_train_llama-3.3-70b

   To run the training on a single node for Llama 3.3 70B BF16 with FSDP-v2 enabled, add the ``FSDP=1`` argument.
   For example, use the following command:

   .. code-block:: shell

      TOKENIZER_MODEL=meta-llama/Llama-3.3-70B-Instruct \
      CKPT_FORMAT=torch_dist \
      TEE_OUTPUT=1 \
      RECOMPUTE=1 \
      SEQ_LENGTH=8192 \
      MBS=2 \
      BS=16 \
      TE_FP8=0 \
      TP=1 \
      PP=1 \
      FSDP=1 \
      MODEL_SIZE=70 \
      TOTAL_ITERS=50 \
      bash examples/llama/train_llama3.sh

   .. note::

      It is suggested to use ``TP=1`` when FSDP is enabled for higher
      throughput. FSDP-v2 is not supported with pipeline parallelism, expert
      parallelism, MCore's distributed optimizer, gradient accumulation fusion,
      or FP16.

.. container:: model-doc pyt_megatron_lm_train_llama-3.1-8b

   To run training on a single node for Llama 3.1 8B FP8, navigate to the Megatron-LM folder and use the
   following command.

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            TEE_OUTPUT=1 \
            MBS=4 \
            BS=512 \
            TP=1 \
            TE_FP8=1 \
            SEQ_LENGTH=8192 \
            MODEL_SIZE=8 \
            TOTAL_ITERS=10 \
            GEMM_TUNING=0 \
            bash examples/llama/train_llama3.sh

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            TEE_OUTPUT=1 \
            MBS=2 \
            BS=128 \
            TP=1 \
            TE_FP8=1 \
            SEQ_LENGTH=8192 \
            MODEL_SIZE=8 \
            TOTAL_ITERS=50 \
            bash examples/llama/train_llama3.sh

   For Llama 3.1 8B BF16, use the following command:

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            TEE_OUTPUT=1 \
            MBS=4 \
            BS=512 \
            TP=1 \
            TE_FP8=0 \
            SEQ_LENGTH=8192 \
            MODEL_SIZE=8 \
            TOTAL_ITERS=10 \
            GEMM_TUNING=1 \
            bash examples/llama/train_llama3.sh

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            TEE_OUTPUT=1 \
            MBS=2 \
            BS=128 \
            TP=1 \
            TE_FP8=0 \
            SEQ_LENGTH=8192 \
            MODEL_SIZE=8 \
            TOTAL_ITERS=50 \
            bash examples/llama/train_llama3.sh

.. container:: model-doc pyt_megatron_lm_train_llama-3.1-70b

   To run the training on a single node for Llama 3.1 70B BF16 with FSDP-v2 enabled, add the ``FSDP=1`` argument.
   For example, use the following command:

   .. code-block:: shell

      CKPT_FORMAT=torch_dist \
      TEE_OUTPUT=1 \
      MBS=3 \
      BS=24 \
      TP=1 \
      TE_FP8=0 \
      FSDP=1 \
      RECOMPUTE=1 \
      SEQ_LENGTH=8192 \
      MODEL_SIZE=70 \
      TOTAL_ITERS=50 \
      bash examples/llama/train_llama3.sh

   .. note::

      It is suggested to use ``TP=1`` when FSDP is enabled for higher
      throughput. FSDP-v2 is not supported with pipeline parallelism, expert
      parallelism, MCore's distributed optimizer, gradient accumulation fusion,
      or FP16.

   To run the training on a single node for Llama 3.1 70B FP8, use the
   following command.

   .. note::

      The MI300X configuration uses a proxy model. On MI300X GPUs, use two or more nodes
      to run the full Llama 3.1 70B model with FP8 precision. MI355X and MI350X GPUs
      can support the full 70B model with FP8 precision on a single node.

   .. tab-set::

      .. tab-item:: MI355X and MI350X
         :sync: MI355X and MI350X

         .. code-block:: shell

            CKPT_FORMAT=torch_dist \
            TEE_OUTPUT=1 \
            RECOMPUTE=1 \
            MBS=3 \
            BS=24 \
            TP=1 \
            TE_FP8=1 \
            SEQ_LENGTH=8192 \
            MODEL_SIZE=70 \
            FSDP=1 \
            TOTAL_ITERS=10 \
            bash examples/llama/train_llama3.sh

      .. tab-item:: MI300X
         :sync: MI325X and MI300X

         .. code-block:: shell

            FP8_WEIGHT_TRANSPOSE_CACHE=0 \
            CKPT_FORMAT=torch_dist \
            TEE_OUTPUT=1 \
            RECOMPUTE=1 \
            MBS=3 \
            BS=24 \
            TP=1 \
            TE_FP8=1 \
            SEQ_LENGTH=8192 \
            MODEL_SIZE=70 \
            FSDP=1 \
            TOTAL_ITERS=10 \
            NUM_LAYERS=40 \
            bash examples/llama/train_llama3.sh

   .. note::

      The MI300X configuration uses a proxy model. On MI300X GPUs, use two or more nodes
      to run the full Llama 3.1 70B model with FP8 precision. MI355X and MI350X GPUs
      can support the full 70B model with FP8 precision on a single node.

   .. note::

      It is suggested to use ``TP=1`` when FSDP is enabled for higher
      throughput. FSDP-v2 is not supported with pipeline parallelism, expert
      parallelism, MCore's distributed optimizer, gradient accumulation fusion,
      or FP16.

.. container:: model-doc pyt_megatron_lm_train_llama-2-7b

   To run training on a single node for Llama 2 7B FP8, navigate to the Megatron-LM folder and use the
   following command.

   .. code-block:: shell

      TEE_OUTPUT=1 \
      MBS=4 \
      BS=256 \
      TP=1 \
      TE_FP8=1 \
      SEQ_LENGTH=4096 \
      MODEL_SIZE=7 \
      TOTAL_ITERS=50 \
      bash examples/llama/train_llama2.sh

   For Llama 2 7B BF16, use the following command:

   .. code-block:: shell

      TEE_OUTPUT=1 \
      MBS=4 \
      BS=256 \
      TP=1 \
      TE_FP8=0 \
      SEQ_LENGTH=4096 \
      MODEL_SIZE=7 \
      TOTAL_ITERS=50 \
      bash examples/llama/train_llama2.sh

.. container:: model-doc pyt_megatron_lm_train_llama-2-70b

   To run the training on a single node for Llama 2 70B BF16 with FSDP-v2 enabled, add the ``FSDP=1`` argument.
   For example, use the following command:

   .. code-block:: shell

      CKPT_FORMAT=torch_dist \
      TEE_OUTPUT=1 \
      MBS=7 \
      BS=56 \
      TP=1 \
      TE_FP8=0 \
      FSDP=1 \
      RECOMPUTE=1 \
      SEQ_LENGTH=4096 \
      MODEL_SIZE=70 \
      TOTAL_ITERS=50 \
      bash examples/llama/train_llama2.sh

   .. note::

      It is suggested to use ``TP=1`` when FSDP is enabled for higher
      throughput. FSDP-v2 is not supported with pipeline parallelism, expert
      parallelism, MCore's distributed optimizer, gradient accumulation fusion,
      or FP16.

.. container:: model-doc pyt_megatron_lm_train_deepseek-v3-proxy

   To run training on a single node for DeepSeek-V3 (MoE with expert parallel) with 3-layer proxy,
   navigate to the Megatron-LM folder and use the following command.

   .. code-block:: shell

      export NVTE_FUSED_ATTN_CK=0
      FORCE_BALANCE=true \
      RUN_ENV=cluster \
      MODEL_SIZE=671B \
      TRAIN_ITERS=50 \
      SEQ_LEN=4096 \
      NUM_LAYERS=3 \
      MICRO_BATCH_SIZE=1 GLOBAL_BATCH_SIZE=32 \
      PR=bf16 \
      TP=1 PP=1 ETP=1 EP=8 \
      GEMM_TUNING=1 \
      NVTE_CK_USES_BWD_V3=1 \
      USE_GROUPED_GEMM=true MOE_USE_LEGACY_GROUPED_GEMM=true \
      GPT_LAYER_IN_TE=true \
      bash examples/deepseek_v3/train_deepseekv3.sh

.. container:: model-doc pyt_megatron_lm_train_deepseek-v2-lite-16b

   To run training on a single node for DeepSeek-V2-Lite (MoE with expert parallel),
   navigate to the Megatron-LM folder and use the following command.

   .. code-block:: shell

      export NVTE_FUSED_ATTN_CK=0
      GEMM_TUNING=1 \
      PR=bf16 \
      MBS=4 \
      AC=none \
      SEQ_LEN=4096 \
      PAD_LEN=4096 \
      TRAIN_ITERS=20 \
      bash examples/deepseek_v2/train_deepseekv2.sh

   .. note::

      Note that DeepSeek-V2-Lite is experiencing instability due to GPU memory access fault
      for large iterations.
      For stability, it's recommended to use Primus for this workload.
      See :doc:`../primus-megatron`.

.. container:: model-doc pyt_megatron_lm_train_mixtral-8x7b

   To run training on a single node for Mixtral 8x7B (MoE with expert parallel),
   navigate to the Megatron-LM folder and use the following command.

   .. code-block:: shell

      TOKENIZER_MODEL=<path/to/tokenizer/model>
      RECOMPUTE_NUM_LAYERS=0 \
      TEE_OUTPUT=1 \
      MBS=1 \
      GBS=16 \
      TP_SIZE=1 \
      PP_SIZE=1 \
      AC=none \
      PR=bf16 \
      EP_SIZE=8 \
      ETP_SIZE=1 \
      SEQLEN=4096 \
      FORCE_BALANCE=true \
      MOCK_DATA=1 \
      RUN_ENV=cluster \
      MODEL_SIZE=8x7B \
      TRAIN_ITERS=50 \
      bash examples/mixtral/train_mixtral_moe.sh

.. container:: model-doc pyt_megatron_lm_train_mixtral-8x22b-proxy

   To run training on a single node for Mixtral 8x7B (MoE with expert parallel) with 4-layer proxy,
   navigate to the Megatron-LM folder and use the following command.

   .. code-block:: shell

      TOKENIZER_MODEL=<path/to/tokenizer/model>
      RECOMPUTE_NUM_LAYERS=4 \
      TEE_OUTPUT=1 \
      MBS=1 \
      GBS=16 \
      TP_SIZE=1 \
      PP_SIZE=1 \
      AC=full \
      NUM_LAYERS=4 \
      PR=bf16 \
      EP_SIZE=8 \
      ETP_SIZE=1 \
      SEQLEN=8192 \
      FORCE_BALANCE=true \
      MOCK_DATA=1 \
      RUN_ENV=cluster \
      MODEL_SIZE=8x22B \
      TRAIN_ITERS=50 \
      bash examples/mixtral/train_mixtral_moe.sh

.. container:: model-doc pyt_megatron_lm_train_qwen2.5-7b

   To run training on a single node for Qwen 2.5 7B BF16, use the following
   command.

   .. code-block:: shell

      bash examples/qwen/train_qwen2.sh TP=1 \
          CP=1 \
          PP=1 \
          MBS=10 \
          BS=640 \
          TE_FP8=0 \
          MODEL_SIZE=7 \
          SEQ_LENGTH=2048 \
          TOTAL_ITERS=50 \
          MOCK_DATA=1 \
          TOKENIZER_MODEL=Qwen/Qwen2.5-7B

   For FP8, use the following command.

   .. code-block:: shell

      bash examples/qwen/train_qwen2.sh \
          TP=1 \
          CP=1 \
          PP=1 \
          MBS=10 \
          BS=640 \
          TE_FP8=1 \
          MODEL_SIZE=7 \
          SEQ_LENGTH=2048 \
          TOTAL_ITERS=50 \
          MOCK_DATA=1 \
          TOKENIZER_MODEL=Qwen/Qwen2.5-7B

.. container:: model-doc pyt_megatron_lm_train_qwen2.5-72b

   To run the training on a single node for Qwen 2.5 72B BF16, use the following command.

   .. code-block:: shell

      bash examples/qwen/train_qwen2.sh \
          FSDP=1 \
          CP=1 \
          PP=1 \
          MBS=3 \
          BS=24 \
          TE_FP8=0 \
          MODEL_SIZE=72 \
          SEQ_LENGTH=2048 \
          TOTAL_ITERS=50 \
          MOCK_DATA=1 \
          TOKENIZER_MODEL=Qwen/Qwen2.5-72B \
          RECOMPUTE_ACTIVATIONS=full \
          CKPT_FORMAT=torch_dist

.. _amd-megatron-lm-multi-node-examples:

Multi-node training examples
----------------------------

To run training on multiple nodes, launch the Docker container on each node.
For example, for Llama 3 using a two node setup (``NODE0`` as the master node),
use these commands.

* On the master node ``NODE0``:

  .. code-block:: shell

     TEE_OUTPUT=1 \
     MBS=2 \
     BS=256 \
     TP=1 \
     TE_FP8=1 \
     SEQ_LENGTH=8192 \
     MODEL_SIZE=8  \
     MASTER_ADDR=IP_NODE0 \
     NNODES=2 \
     NODE_RANK=0 \
     bash examples/llama/train_llama3.sh

* On the worker node ``NODE1``:

  .. code-block:: shell

     TEE_OUTPUT=1 \
     MBS=2 \
     BS=256 \
     TP=1 \
     TE_FP8=1 \
     SEQ_LENGTH=8192 \
     MODEL_SIZE=8  \
     MASTER_ADDR=IP_NODE0 \
     NNODES=2 \
     NODE_RANK=1 \
     bash examples/llama/train_llama3.sh

Or, for DeepSeek-V3, an example script ``train_deepseek_v3_slurm.sh`` is
provided in
`<https://github.com/ROCm/Megatron-LM/tree/rocm_dev/examples/deepseek_v3>`__ to
enable training at scale under a SLURM environment. For example, to run
training on 16 nodes, try the following command:

.. code-block:: shell

   sbatch examples/deepseek_v3/train_deepseek_v3_slurm.sh

.. _amd-megatron-lm-benchmark-test-vars:

Key options
-----------

The benchmark tests support the following sets of variables.

``TEE_OUTPUT``
  ``1`` to enable training logs or ``0`` to disable.

``TE_FP8``
  ``0`` for B16 or ``1`` for FP8 -- ``0`` by default.

``GEMM_TUNING``
  ``1`` to enable GEMM tuning, which boosts performance by using the best GEMM kernels.

``USE_FLASH_ATTN``
  ``1`` to enable Flash Attention.

``FSDP``
  ``1`` to enable PyTorch FSDP2. If FSDP is enabled, ``--use-distributed-optimizer``,
  ``--overlap-param-gather``, and ``--sequence-parallel`` are automatically disabled.

``ENABLE_PROFILING``
  ``1`` to enable PyTorch profiling for performance analysis.

``transformer-impl``
  ``transformer_engine`` to use the Transformer Engine (TE) or ``local`` to disable TE.

``MODEL_SIZE``
  ``8B`` or ``70B`` for Llama 3 and 3.1. ``7B`` or ``70B`` for Llama 2, for example.

``TOTAL_ITERS``
  The total number of iterations -- ``10`` by default.

``MOCK_DATA``
  ``1`` to use mock data or ``0`` to use real data you provide.

``MBS``
  Micro batch size.

``BS``
  Global batch size.

``TP`` / ``TP_SIZE``
  Tensor parallel (``1``, ``2``, ``4``, ``8``). ``TP`` is disabled when ``FSDP`` is turned on.

``EP`` / ``EP_SIZE``
  Expert parallel for MoE models.

``SEQ_LENGTH``
  Input sequence length.

``PR``
  Precision for training. ``bf16`` for BF16 (default) or ``fp8`` for FP8 GEMMs.

``AC``
  Activation checkpointing (``none``, ``sel``, or ``full``) -- ``sel`` by default.

``NUM_LAYERS``
  Use reduced number of layers as a proxy model.

``RECOMPUTE_NUM_LAYERS``
  Number of layers used for checkpointing recompute.

Known issues
============

PyTorch Profiler may produce inaccurate traces when CPU activity profiling is enabled.

Previous versions
=================

See :doc:`megatron-lm-history` to find documentation for previous releases
of the ``ROCm/megatron-lm`` Docker image.
