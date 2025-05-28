.. meta::
   :description: How to train a model using Megatron-LM for ROCm.
   :keywords: ROCm, AI, LLM, train, Megatron-LM, megatron, Llama, tutorial, docker, torch

******************************************
Training a model with Megatron-LM for ROCm
******************************************

The `Megatron-LM framework for ROCm <https://github.com/ROCm/Megatron-LM>`_ is
a specialized fork of the robust Megatron-LM, designed to enable efficient
training of large-scale language models on AMD GPUs. By leveraging AMD
Instinct™ MI300X series accelerators, Megatron-LM delivers enhanced
scalability, performance, and resource utilization for AI workloads. It is
purpose-built to support models like Llama, DeepSeek, and Mixtral,
enabling developers to train next-generation AI models more
efficiently.

AMD provides a ready-to-use Docker image for MI300X series accelerators containing
essential components, including PyTorch, ROCm libraries, and Megatron-LM
utilities. It contains the following software components to accelerate training
workloads:

+--------------------------+--------------------------------+
| Software component       | Version                        |
+==========================+================================+
| ROCm                     | 6.3.4                          |
+--------------------------+--------------------------------+
| PyTorch                  | 2.8.0a0+gite2f9759             |
+--------------------------+--------------------------------+
| Python                   | 3.12 or 3.10                   |
+--------------------------+--------------------------------+
| Transformer Engine       | 1.13.0+bb061ade                |
+--------------------------+--------------------------------+
| Flash Attention          | 3.0.0                          |
+--------------------------+--------------------------------+
| hipBLASLt                | 0.13.0-4f18bf6                 |
+--------------------------+--------------------------------+
| Triton                   | 3.3.0                          |
+--------------------------+--------------------------------+
| RCCL                     | 2.22.3                         |
+--------------------------+--------------------------------+

Megatron-LM provides the following key features to train large language models efficiently:

- Transformer Engine (TE)

- APEX

- GEMM tuning

- Torch.compile

- 3D parallelism: TP + SP + CP

- Distributed optimizer

- Flash Attention (FA) 3

- Fused kernels

- Pre-training

.. _amd-megatron-lm-model-support:

The following models are pre-optimized for performance on AMD Instinct MI300X series accelerators.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/megatron-lm-benchmark-models.yaml

   Supported models
   ================

   The following models are supported for training performance benchmarking with Megatron-LM and ROCm.
   Some instructions, commands, and training recommendations in this documentation might
   vary by model -- select one to get started.

   {% set model_groups = data["megatron-lm_benchmark"].model_groups %}

   .. raw:: html

         <div id="vllm-benchmark-ud-params-picker" class="container-fluid">
           <div class="row">
             <div class="col-2 me-2 model-param-head">Model</div>
             <div class="row col-10">
      {% for model_group in model_groups %}
               <div class="col-4 model-param" data-param-k="model-group" data-param-v="{{ model_group.tag }}" tabindex="0">{{ model_group.group }}</div>
      {% endfor %}
             </div>
           </div>

           <div class="row mt-1">
             <div class="col-2 me-2 model-param-head">Model variant</div>
             <div class="row col-10">
      {% for model_group in model_groups %}
         {% set models = model_group.models %}
         {% for model in models %}
            {% if models|length % 3 == 0 %}
               <div class="col-4 model-param" data-param-k="model" data-param-v="{{ model.mad_tag }}" data-param-group="{{ model_group.tag }}" tabindex="0">{{ model.model }}</div>
            {% else %}
               <div class="col-6 model-param" data-param-k="model" data-param-v="{{ model.mad_tag }}" data-param-group="{{ model_group.tag }}" tabindex="0">{{ model.model }}</div>
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
`Performance results with AMD ROCm software <https://www.amd.com/en/developer/resources/rocm-hub/dev-ai/performance-results.html#tabs-a8deaeb413-item-21cea50186-tab>`_
page provides reference throughput and latency measurements for training
popular AI models.

.. note::

   The performance data presented in
   `Performance results with AMD ROCm software <https://www.amd.com/en/developer/resources/rocm-hub/dev-ai/performance-results.html#tabs-a8deaeb413-item-21cea50186-tab>`_
   should not be interpreted as the peak performance achievable by AMD
   Instinct MI325X and MI300X accelerators or ROCm software.

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
reproduce the benchmark results on MI300X series accelerators with the AMD Megatron-LM Docker
image.

.. _amd-megatron-lm-requirements:
 
Download the Docker image
-------------------------

1. Use the following command to pull the Docker image from Docker Hub.

   .. tab-set:: 

      .. tab-item:: Ubuntu 24.04 + Python 3.12

         .. code-block:: shell

            docker pull rocm/megatron-lm:v25.5_py312

      .. tab-item:: Ubuntu 22.04 + Python 3.10

         .. code-block:: shell

            docker pull rocm/megatron-lm:v25.5_py310

2. Launch the Docker container.

   .. code-block:: shell

      docker run -it --device /dev/dri --device /dev/kfd --device /dev/infiniband --network host --ipc host --group-add video --cap-add SYS_PTRACE --security-opt seccomp=unconfined --privileged -v $HOME:$HOME -v  $HOME/.ssh:/root/.ssh --shm-size 64G --name megatron_training_env rocm/megatron-lm:v25.5

3. Use these commands if you exit the ``megatron_training_env`` container and need to return to it.

   .. code-block:: shell

      docker start megatron_training_env
      docker exec -it megatron_training_env bash

The Docker container includes a pre-installed, verified version of the ROCm
Megatron-LM development branch
`<https://github.com/ROCm/Megatron-LM/tree/rocm_dev>`__, including necessary
training scripts.

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

Network interface
-----------------

Update the network interface in the script to match your system's network interface. To
find your network interface, run the following (outside of any Docker container):

.. code-block:: bash

   ip a

Look for an active interface that has an IP address in the same subnet as
your other nodes. Then, update the following variables in the script, for
example:

.. code-block:: bash

   export NCCL_SOCKET_IFNAME=ens50f0np0

   export GLOO_SOCKET_IFNAME=ens50f0np0

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

.. container:: model-doc pyt_megatron_lm_train_llama-3.3-70b pyt_megatron_lm_train_llama-3.1-8b pyt_megatron_lm_train_llama-3.1-70b pyt_megatron_lm_train_llama-2-7b pyt_megatron_lm_train_llama-2-70b

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
      wget https://atp-modelzoo-wlcb-pai.oss-cn-wulanchabu.aliyuncs.com/release/models/pai-megatron-patch/deepseek-datasets/mmap_deepseekv2_datasets_text_document.bin
      wget https://atp-modelzoo-wlcb-pai.oss-cn-wulanchabu.aliyuncs.com/release/models/pai-megatron-patch/deepseek-datasets/mmap_deepseekv2_datasets_text_document.idx

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
      wget https://atp-modelzoo-wlcb-pai.oss-cn-wulanchabu.aliyuncs.com/release/models/pai-megatron-patch/deepseek-datasets/mmap_deepseekv2_datasets_text_document.bin
      wget https://atp-modelzoo-wlcb-pai.oss-cn-wulanchabu.aliyuncs.com/release/models/pai-megatron-patch/deepseek-datasets/mmap_deepseekv2_datasets_text_document.idx

   To train on this data, update the ``DATA_DIR`` variable to point to the location of your dataset.

   .. code-block:: bash

      MOCK_DATA=0 # Train on real data

      DATA_DIR="<path-to>/deepseek-datasets"  # Change to where your dataset is stored

      Ensure that the files are accessible inside the Docker container.

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

Multi-node configuration
------------------------

If you're running multi-node training, update the following environment variables. They can
also be passed as command line arguments. Refer to the following example configurations.

* Change ``localhost`` to the master node's hostname:

  .. code-block:: shell

     MASTER_ADDR="${MASTER_ADDR:-localhost}"

* Set the number of nodes you want to train on (for instance, ``2``, ``4``, ``8``):

  .. code-block:: shell

     NNODES="${NNODES:-1}"

* Set the rank of each node (0 for master, 1 for the first worker node, and so on):

  .. code-block:: shell

     NODE_RANK="${NODE_RANK:-0}"

* Set ``DATA_CACHE_PATH`` to a common directory accessible by all the nodes (for example, an
  NFS directory) for multi-node runs:

  .. code-block:: shell

     DATA_CACHE_PATH=/root/cache # Set to a common directory for multi-node runs

* For multi-node runs, make sure the correct network drivers are installed on the nodes. If
  inside a Docker container, either install the drivers inside the Docker container or pass the network
  drivers from the host while creating the Docker container.

  .. code-block:: shell

     # Specify which RDMA interfaces to use for communication
     export NCCL_IB_HCA=rdma0,rdma1,rdma2,rdma3,rdma4,rdma5,rdma6,rdma7

Getting started
===============

The prebuilt Megatron-LM with ROCm training environment allows users to quickly validate
system performance, conduct training benchmarks, and achieve superior
performance for models like Llama, DeepSeek, and Mixtral. This container should not be
expected to provide generalized performance across all training workloads. You
can expect the container to perform in the model configurations described in
the following section, but other configurations are not validated by AMD.

.. _amd-megatron-lm-run-training:

Run training
------------

Use the following example commands to set up the environment, configure
:ref:`key options <amd-megatron-lm-benchmark-test-vars>`, and run training on
MI300X series accelerators with the AMD Megatron-LM environment.

Single node training
^^^^^^^^^^^^^^^^^^^^

.. container:: model-doc pyt_megatron_lm_train_llama-3.3-70b

   To run the training on a single node for Llama 3.3 70B BF16 with FSDP-v2 enabled, add the ``FSDP=1`` argument.
   For example, use the following command:

   .. code-block:: shell

      TEE_OUTPUT=1 RECOMPUTE=1 SEQ_LENGTH=8192 MBS=2 BS=16 TE_FP8=0 TP=1 PP=1 FSDP=1 MODEL_SIZE=70 TOTAL_ITERS=50 bash examples/llama/train_llama3.sh 

   .. note::

      It is suggested to use ``TP=1`` when FSDP is enabled for higher
      throughput. FSDP-v2 is not supported with pipeline parallelism, expert
      parallelism, MCore's distributed optimizer, gradient accumulation fusion,
      or FP16.

      Currently, FSDP is only compatible with BF16 precision.

.. container:: model-doc pyt_megatron_lm_train_llama-3.1-8b

   To run training on a single node for Llama 3.1 8B FP8, navigate to the Megatron-LM folder and use the
   following command.

   .. code-block:: shell

      TEE_OUTPUT=1 MBS=2 BS=128 TP=1 TE_FP8=1 SEQ_LENGTH=8192 MODEL_SIZE=8 TOTAL_ITERS=50 bash examples/llama/train_llama3.sh

   For Llama 3.1 8B BF16, use the following command:

   .. code-block:: shell

      TEE_OUTPUT=1 MBS=2 BS=128 TP=1 TE_FP8=0 SEQ_LENGTH=8192 MODEL_SIZE=8 TOTAL_ITERS=50 bash examples/llama/train_llama3.sh

.. container:: model-doc pyt_megatron_lm_train_llama-3.1-70b

   To run the training on a single node for Llama 3.1 70B BF16 with FSDP-v2 enabled, add the ``FSDP=1`` argument.
   For example, use the following command:

   .. code-block:: shell

      TEE_OUTPUT=1 MBS=3 BS=24 TP=1 TE_FP8=0 FSDP=1 RECOMPUTE=1 SEQ_LENGTH=8192 MODEL_SIZE=70 TOTAL_ITERS=50 bash examples/llama/train_llama3.sh

   .. note::

      It is suggested to use ``TP=1`` when FSDP is enabled for higher
      throughput. FSDP-v2 is not supported with pipeline parallelism, expert
      parallelism, MCore's distributed optimizer, gradient accumulation fusion,
      or FP16.

      Currently, FSDP is only compatible with BF16 precision.

.. container:: model-doc pyt_megatron_lm_train_llama-2-7b

   To run training on a single node for Llama 2 7B FP8, navigate to the Megatron-LM folder and use the
   following command.

   .. code-block:: shell

      TEE_OUTPUT=1 MBS=4 BS=256 TP=1 TE_FP8=1 SEQ_LENGTH=4096 MODEL_SIZE=7 TOTAL_ITERS=50 bash examples/llama/train_llama2.sh

   For Llama 2 7B BF16, use the following command:

   .. code-block:: shell

      TEE_OUTPUT=1 MBS=4 BS=256 TP=1 TE_FP8=0 SEQ_LENGTH=4096 MODEL_SIZE=7 TOTAL_ITERS=50 bash examples/llama/train_llama2.sh

.. container:: model-doc pyt_megatron_lm_train_llama-2-70b

   To run the training on a single node for Llama 2 70B BF16 with FSDP-v2 enabled, add the ``FSDP=1`` argument.
   For example, use the following command:

   .. code-block:: shell

      TEE_OUTPUT=1 MBS=7 BS=56 TP=1 TE_FP8=0 FSDP=1 RECOMPUTE=1 SEQ_LENGTH=4096 MODEL_SIZE=70 TOTAL_ITERS=50 bash examples/llama/train_llama2.sh

   .. note::

      It is suggested to use ``TP=1`` when FSDP is enabled for higher
      throughput. FSDP-v2 is not supported with pipeline parallelism, expert
      parallelism, MCore's distributed optimizer, gradient accumulation fusion,
      or FP16.

      Currently, FSDP is only compatible with BF16 precision.

.. container:: model-doc pyt_megatron_lm_train_deepseek-v3-proxy

   To run training on a single node for DeepSeek-V3 (MoE with expert parallel) with 3-layer proxy, 
   navigate to the Megatron-LM folder and use the following command.

   .. code-block:: shell

      FORCE_BANLANCE=true \
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

      GEMM_TUNING=1 PR=bf16 MBS=4 AC=none SEQ_LEN=4096 PAD_LEN=4096 TRAIN_ITERS=50 bash examples/deepseek_v2/train_deepseekv2.sh

.. container:: model-doc pyt_megatron_lm_train_mixtral-8x7b

   To run training on a single node for Mixtral 8x7B (MoE with expert parallel),
   navigate to the Megatron-LM folder and use the following command.

   .. code-block:: shell

      RECOMPUTE_NUM_LAYERS=0 TEE_OUTPUT=1 MBS=1 GBS=16 TP_SIZE=1 PP_SIZE=1 AC=none PR=bf16 EP_SIZE=8 ETP_SIZE=1 SEQLEN=4096 FORCE_BALANCE=true MOCK_DATA=1 RUN_ENV=cluster MODEL_SIZE=8x7B TRAIN_ITERS=50 bash examples/mixtral/train_mixtral_moe.sh

.. container:: model-doc pyt_megatron_lm_train_mixtral-8x22b-proxy

   To run training on a single node for Mixtral 8x7B (MoE with expert parallel) with 4-layer proxy,
   navigate to the Megatron-LM folder and use the following command.

   .. code-block:: shell

      RECOMPUTE_NUM_LAYERS=4 TEE_OUTPUT=1 MBS=1 GBS=16 TP_SIZE=1 PP_SIZE=1 AC=full NUM_LAYERS=4 PR=bf16 EP_SIZE=8 ETP_SIZE=1 SEQLEN=8192 FORCE_BALANCE=true MOCK_DATA=1 RUN_ENV=cluster MODEL_SIZE=8x22B TRAIN_ITERS=50 bash examples/mixtral/train_mixtral_moe.sh

Multi-node training
^^^^^^^^^^^^^^^^^^^

To run training on multiple nodes, launch the Docker container on each node.
For example, for Llama 3 using a two node setup (``NODE0`` as the master node),
use these commands.

* On the master node ``NODE0``:

  .. code-block:: shell

     TEE_OUTPUT=1 MBS=2 BS=256 TP=1 TE_FP8=1 SEQ_LENGTH=8192 MODEL_SIZE=8  MASTER_ADDR=IP_NODE0 NNODES=2 NODE_RANK=0 bash examples/llama/train_llama3.sh

* On the worker node ``NODE1``:

  .. code-block:: shell

     TEE_OUTPUT=1 MBS=2 BS=256 TP=1 TE_FP8=1 SEQ_LENGTH=8192 MODEL_SIZE=8  MASTER_ADDR=IP_NODE0 NNODES=2 NODE_RANK=1 bash examples/llama/train_llama3.sh

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

Previous versions
=================

This table lists previous versions of the ROCm Megatron-LM Docker image for training
performance testing. For detailed information about available models for
benchmarking, see the version-specific documentation.

.. list-table::
   :header-rows: 1
   :stub-columns: 1

   * - Image version
     - ROCm version
     - PyTorch version
     - Resources

   * - 25.4
     - 6.3.0
     - 2.7.0a0+git637433 
     - 
       * `Documentation <https://rocm.docs.amd.com/en/docs-6.3.3/how-to/rocm-for-ai/training/benchmark-docker/megatron-lm.html>`_
       * `Docker Hub <https://hub.docker.com/layers/rocm/megatron-lm/v25.4/images/sha256-941aa5387918ea91c376c13083aa1e6c9cab40bb1875abbbb73bbb65d8736b3f>`_

   * - 25.3
     - 6.3.0
     - 2.7.0a0+git637433 
     - 
       * `Documentation <https://rocm.docs.amd.com/en/docs-6.3.2/how-to/rocm-for-ai/training/benchmark-docker/megatron-lm.html>`_
       * `Docker Hub <https://hub.docker.com/layers/rocm/megatron-lm/v25.3/images/sha256-1e6ed9bdc3f4ca397300d5a9907e084ab5e8ad1519815ee1f868faf2af1e04e2>`_

   * - 24.12-dev
     - 6.1.0
     - 2.4.0
     - 
       * `Documentation <https://rocm.docs.amd.com/en/docs-6.3.0/how-to/rocm-for-ai/train-a-model.html>`_
       * `Docker Hub <https://hub.docker.com/layers/rocm/megatron-lm/24.12-dev/images/sha256-5818c50334ce3d69deeeb8f589d83ec29003817da34158ebc9e2d112b929bf2e>`_
