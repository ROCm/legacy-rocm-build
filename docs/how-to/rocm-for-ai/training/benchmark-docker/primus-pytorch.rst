.. meta::
   :description: How to train a model using PyTorch for ROCm.
   :keywords: ROCm, AI, LLM, train, PyTorch, torch, Llama, flux, tutorial, docker

****************************************
Training a model with Primus and PyTorch
****************************************

`Primus <https://github.com/AMD-AGI/Primus>`__ is a unified and flexible
LLM training framework designed to streamline training. It streamlines LLM
training on AMD Instinct GPUs using a modular, reproducible configuration paradigm.
Primus now supports the PyTorch torchtitan backend.

.. note::

   For a unified training solution on AMD GPUs with ROCm, the `rocm/pytorch-training
   <https://hub.docker.com/r/rocm/pytorch-training/>`__ Docker Hub registry will be
   deprecated soon in favor of `rocm/primus <https://hub.docker.com/r/rocm/primus>`__.
   The ``rocm/primus`` Docker containers will cover PyTorch training ecosystem frameworks,
   including torchtitan and :doc:`Megatron-LM <primus-megatron>`.

   Primus with the PyTorch torchtitan backend is designed to replace the
   :doc:`ROCm PyTorch training <pytorch-training>` workflow. See
   :doc:`pytorch-training` to see steps to run workloads without Primus.

AMD provides a ready-to-use Docker image for MI355X, MI350X, MI325X, and
MI300X GPUs containing essential components for Primus and PyTorch training
with Primus Turbo optimizations.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/primus-pytorch-benchmark-models.yaml

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

.. _amd-primus-pytorch-model-support-v26.3:

Supported models
================

The following models are pre-optimized for performance on the AMD Instinct MI325X and MI300X GPUs.
Some instructions, commands, and training recommendations in this documentation might
vary by model -- select one to get started.

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/primus-pytorch-benchmark-models.yaml

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

.. seealso::

   For additional workloads, including Llama 3.3, Llama 3.2, Llama 2, GPT OSS, Qwen, and Flux models,
   see the documentation :doc:`pytorch-training` (without Primus)

.. _amd-primus-pytorch-performance-measurements-v26.3:

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

This Docker image is optimized for specific model configurations outlined
below. Performance can vary for other training workloads, as AMD
doesn’t test configurations and run conditions outside those described.

Pull the Docker image
=====================

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/primus-pytorch-benchmark-models.yaml

   Use the following command to pull the Docker image from Docker Hub.

   .. code-block:: shell

      docker pull {{ data.docker.pull_tag }}

Run training
============

Once the setup is complete, choose between the following two workflows to start benchmarking training.
For fine-tuning workloads and multi-node training examples, see :doc:`pytorch-training` (without Primus).
For best performance on MI325X, MI350X, and MI355X GPUs, you might need to
tweak some configurations (such as batch sizes).

.. datatemplate:yaml:: /data/how-to/rocm-for-ai/training/primus-pytorch-benchmark-models.yaml

   {% set docker = data.docker %}
   {% set model_groups = data.model_groups %}

   .. tab-set::

      .. tab-item:: Primus benchmarking

   {% for model_group in model_groups %}
      {% for model in model_group.models %}

         .. container:: model-doc {{ model.mad_tag }}

            The following run commands are tailored to {{ model.model }}.
            See :ref:`amd-primus-pytorch-model-support-v26.3` to switch to another available model.

            .. rubric:: Download the Docker image and required packages

            1. Pull the ``{{ docker.pull_tag }}`` Docker image from Docker Hub.

               .. code-block:: shell

                  docker pull {{ docker.pull_tag }}

            2. Run the Docker container.

               .. code-block:: shell

                  docker run -it \
                      --device /dev/dri \
                      --device /dev/kfd \
                      --network host \
                      --ipc host \
                      --group-add video \
                      --cap-add SYS_PTRACE \
                      --security-opt seccomp=unconfined \
                      --privileged \
                      -v $HOME:$HOME \
                      -v $HOME/.ssh:/root/.ssh \
                      --shm-size 64G \
                      --name training_env \
                      {{ docker.pull_tag }}

               Use these commands if you exit the ``training_env`` container and need to return to it.

               .. code-block:: shell

                  docker start training_env
                  docker exec -it training_env bash

               The Docker container hosts verified commit ``43a6e00`` of the `Primus
               <https://github.com/AMD-AGI/Primus/tree/43a6e006c419697208295c5523b99070e8198ad9>`__ repository.

            .. rubric:: Setup

            The following benchmarking examples require downloading models and datasets
            from Hugging Face. To ensure successful access to gated repos, set your
            ``HF_TOKEN``.

            .. code-block:: shell

               export HF_TOKEN=$your_personal_hugging_face_access_token

            To get started, navigate to the ``Primus`` directory in your container.

            .. code-block::

               cd /workspace/Primus

            Now, to start the pretraining benchmark, use the ``run_pretrain.sh`` script
            included with Primus with the appropriate options.

            .. rubric:: Pretraining examples

            .. container:: model-doc primus_pyt_train_llama-3.1-8b

               Use the following command to run train Llama 3.1 8B with BF16 precision using Primus torchtitan.

               .. tab-set::

                  .. tab-item:: MI355X and MI350X
                     :sync: MI355X

                     .. code-block:: shell

                        bash runner/primus-cli direct \
                          --log_file /tmp/primus_llama3.1_8B.log \
                          -- train pretrain \
                          --config examples/torchtitan/configs/MI355X/llama3.1_8B-BF16-pretrain.yaml

                  .. tab-item:: MI300X
                     :sync: MI300X

                     .. code-block:: shell

                        bash runner/primus-cli direct \
                          --log_file /tmp/primus_llama3.1_8B.log \
                          -- train pretrain \
                          --config examples/torchtitan/configs/MI300X/llama3.1_8B-BF16-pretrain.yaml

               To train Llama 3.1 8B with FP8 precision, use the following command.

               .. tab-set::

                  .. tab-item:: MI355X and MI350X
                     :sync: MI355X

                     .. code-block:: shell

                        bash runner/primus-cli direct \
                          --log_file /tmp/primus_llama3.1_8B_fp8.log \
                          -- train pretrain \
                          --config examples/torchtitan/configs/MI355X/llama3.1_8B-FP8-pretrain.yaml

                  .. tab-item:: MI300X
                     :sync: MI300X

                     .. code-block:: shell

                        bash runner/primus-cli direct \
                          --log_file /tmp/primus_llama3.1_8B_fp8.log \
                          -- train pretrain \
                          --config examples/torchtitan/configs/MI300X/llama3.1_8B-FP8-pretrain.yaml

            .. container:: model-doc primus_pyt_train_llama-3.1-70b

               Use the following command to run train Llama 3.1 70B with BF16 precision using Primus torchtitan.

               .. tab-set::

                  .. tab-item:: MI355X and MI350X
                     :sync: MI355X and MI300X

                     .. code-block:: shell

                        bash runner/primus-cli direct \
                          --log_file /tmp/primus_llama3.1_70B.log \
                          -- train pretrain \
                          --config examples/torchtitan/configs/MI355X/llama3.1_70B-BF16-pretrain.yaml

                  .. tab-item:: MI300X
                     :sync: MI300X

                     .. code-block:: shell

                        bash runner/primus-cli direct \
                          --log_file /tmp/primus_llama3.1_70B.log \
                          -- train pretrain \
                          --config examples/torchtitan/configs/MI300X/llama3.1_70B-BF16-pretrain.yaml

               To train Llama 3.1 70B with FP8 precision, use the following command.

               .. tab-set::

                  .. tab-item:: MI355X and MI350X
                     :sync: MI355X

                     .. code-block:: shell

                        bash runner/primus-cli direct \
                          --log_file /tmp/primus_llama3.1_70B_fp8.log \
                          -- train pretrain \
                          --config examples/torchtitan/configs/MI355X/llama3.1_70B-FP8-pretrain.yaml

                  .. tab-item:: MI300X
                     :sync: MI300X

                     .. code-block:: shell

                        bash runner/primus-cli direct \
                          --log_file /tmp/primus_llama3.1_70B_fp8.log \
                          -- train pretrain \
                          --config examples/torchtitan/configs/MI300X/llama3.1_70B-FP8-pretrain.yaml

            .. container:: model-doc primus_pyt_train_deepseek-v3-16b

               Use the following command to run train DeepSeek V3 16B with BF16 precision using Primus torchtitan.

               .. tab-set::

                  .. tab-item:: MI355X and MI350X
                     :sync: MI355X and MI300X

                     .. code-block:: shell

                        bash runner/primus-cli direct \
                          --log_file /tmp/primus_deepseek_v3_16b.log \
                          -- train pretrain \
                          --config examples/torchtitan/configs/MI355X/deepseek_v3_16b-pretrain.yaml

                  .. tab-item:: MI300X
                     :sync: MI300X

                     .. code-block:: shell

                        bash runner/primus-cli direct \
                          --log_file /tmp/primus_deepseek_v3_16b.log \
                          -- train pretrain \
                          --config examples/torchtitan/configs/MI300X/deepseek_v3_16b-pretrain.yaml
      {% endfor %}
   {% endfor %}

      .. tab-item:: MAD-integrated benchmarking

   {% for model_group in model_groups %}
      {% for model in model_group.models %}

         .. container:: model-doc {{ model.mad_tag }}

            The following run command is tailored to {{ model.model }}.
            See :ref:`amd-primus-pytorch-model-support-v26.3` to switch to another available model.

            1. Clone the ROCm Model Automation and Dashboarding (`<https://github.com/ROCm/MAD>`__) repository to a local
               directory and install the required packages on the host machine.

               .. code-block:: shell

                  git clone https://github.com/ROCm/MAD
                  cd MAD
                  pip install -r requirements.txt

            2. For example, use this command to run the performance benchmark test on the {{ model.model }} model
               using one node with the {{ model.precision }} data type on the host machine.

               .. code-block:: shell

                  export MAD_SECRETS_HFTOKEN="your personal Hugging Face token to access gated models"
                  madengine run \
                      --tags {{ model.mad_tag }} \
                      --keep-model-dir \
                      --live-output \
                      --timeout 28800

               MAD launches a Docker container with the name
               ``container_ci-{{ model.mad_tag }}``. The latency and throughput reports of the
               model are collected in ``~/MAD/perf.csv``.

      {% endfor %}
   {% endfor %}

Multi-node training examples
============================

Refer to :doc:`/how-to/rocm-for-ai/system-setup/multi-node-setup` to configure your environment for multi-node
training.

To run training on multiple nodes, use ``primus-cli`` to launch multi-node workloads. Use the following steps to set up your environment:

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

.. container:: model-doc primus_pyt_train_llama-3.1-8b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Llama 3.1 8B.
   See :ref:`amd-primus-pytorch-model-support-v26.3` to switch to another available model.

   To train Llama 3.1 8B FP8 on 8 nodes, run:

   .. code-block:: shell

      ./primus-cli slurm srun -N 8 -- train pretrain \
          --config examples/torchtitan/configs/MI300X/llama3.1_8B-FP8-pretrain.yaml

   To train Llama 3.1 8B BF16 on 8 nodes, run:

   .. code-block:: shell

      ./primus-cli slurm srun -N 8 -- train pretrain \
          --config examples/torchtitan/configs/MI300X/llama3.1_8B-BF16-pretrain.yaml

.. container:: model-doc primus_pyt_train_llama-3.1-70b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to Llama 3.1 70B.
   See :ref:`amd-primus-pytorch-model-support-v26.3` to switch to another available model.

   To train Llama 3.1 70B FP8 on 4 nodes using ``primus-cli`` (recommended), run:

   .. code-block:: shell

      # In the Primus directory
      ./primus-cli slurm srun -N 4 -- train pretrain \
          --config examples/torchtitan/configs/MI355X/llama3.1_70B-FP8-pretrain.yaml \
          --training.local_batch_size 6 \
          --training.global_batch_size 192 \
          --training.mock_data True

   Alternatively, using the legacy script:

   .. code-block:: shell

      NNODES=4 EXP=examples/torchtitan/configs/MI355X/llama3.1_70B-FP8-pretrain.yaml \
      bash examples/run_slurm_pretrain.sh \
          --training.local_batch_size 6 \
          --training.global_batch_size 192 \
          --training.mock_data True

.. container:: model-doc primus_pyt_train_deepseek-v3-16b

   Once setup is complete, run the appropriate training command.
   The following run commands are tailored to DeepSeek V3 16B.
   See :ref:`amd-primus-pytorch-model-support-v26.3` to switch to another available model.

   To train DeepSeek V3 16B BF16 on 8 nodes, run:

   .. code-block:: shell

      ./primus-cli slurm srun -N 8 -- train pretrain \
          --config examples/torchtitan/configs/MI300X/deepseek_v3_16b-pretrain.yaml

To train Llama 3.1 405B FP8 on 8 nodes using ``primus-cli`` (recommended), run:

.. code-block:: shell

   # In the Primus directory
   ./primus-cli slurm srun -N 8 -- train pretrain \
       --config examples/torchtitan/configs/MI355X/llama3.1_405B-FP8-pretrain.yaml \
       --training.local_batch_size 3 \
       --training.global_batch_size 192 \
       --training.mock_data True

Alternatively, using the legacy script:

.. code-block:: shell

   NNODES=8 EXP=examples/torchtitan/configs/MI355X/llama3.1_405B-FP8-pretrain.yaml \
   bash examples/run_slurm_pretrain.sh \
       --training.local_batch_size 3 \
       --training.global_batch_size 192 \
       --training.mock_data True

Further reading
===============

- For an introduction to Primus, see `Primus: A Lightweight, Unified Training
  Framework for Large Models on AMD GPUs <https://rocm.blogs.amd.com/software-tools-optimization/primus/README.html>`__.

- To learn more about MAD and the ``madengine`` CLI, see the `MAD usage guide <https://github.com/ROCm/MAD?tab=readme-ov-file#usage-guide>`__.

- To learn more about system settings and management practices to configure your system for
  AMD Instinct MI300X Series GPUs, see `AMD Instinct MI300X Customer Acceptance Guide <https://instinct.docs.amd.com/projects/system-acceptance/en/latest/gpus/mi300x.html>`_.

- For a list of other ready-made Docker images for AI with ROCm, see
  `AMD Infinity Hub <https://www.amd.com/en/developer/resources/infinity-hub.html#f-amd_hub_category=AI%20%26%20ML%20Models>`_.

Previous versions
=================

See :doc:`previous-versions/pytorch-training-history` to find documentation for previous releases
of the ``ROCm/pytorch-training`` Docker image.
