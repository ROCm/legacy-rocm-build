**************************************************
Benchmark Llama 2 70B LoRA fine-tuning with MLPerf
**************************************************

This guide provides instructions to benchmark LoRA fine-tuning on the Llama 2
70B model. The benchmark follows the MLPerf training submission for
long-document summarization using the GovReport dataset.

The accompanying Docker image integrates the `ROCm 7.0 <https://rocm.docs.amd.com/en/latest/>`__
software stack and is optimized for AMD Instinct™ MI355X, MI350X, and MI300X
series accelerators.

Pull the Docker image
=====================

1. Use the following command to pull the `Docker image <https://hub.docker.com/layers/rocm/7.0-preview/rocm7.0_preview_ubuntu22.04_llama2_70b_training_mlperf_instinct_beta/images/sha256-e75ec355a0501cad57d258bdf055267edfbdce4339b07d203a1ca9cdced2f9c9>`__.

   .. code-block:: shell

      docker pull rocm/7.0:rocm7.0_ubuntu22.04_llama2_70B_training_ml_perf_instinct_20250915

2. Copy the benchmark scripts from the container to your host. These scripts
   are used to configure the environment and launch the benchmark.

   .. code-block:: shell

      container_id=$(docker create rocm/7.0:rocm7.0_ubuntu22.04_llama2_70B_training_ml_perf_instinct_20250915) && \
      docker cp $container_id:/workspace/code/runtime_tunables.sh . && \
      docker cp $container_id:/workspace/code/run_with_docker.sh . && \
      docker cp $container_id:/workspace/code/config_MI355X_1x8x1.sh . && \
      docker rm $container_id

   .. note::

      The ``config_*.sh`` files contain system-specific hyperparameters used in
      the :ref:`run step <system-config>`. You will need to copy the one that
      matches your hardware configuration.

Prepare the GovReport dataset
=============================

This benchmark uses the Llama 2 70B model with fused QKV and the GovReport dataset.
GovReport is a dataset for long document summarization that consists of
reports written by government research agencies. The dataset hosted on the
MLPerf drive is already tokenized and packed so that each sequence has
length 8192.

1. Download and preprocess the dataset.

   Start the Docker container by mounting the volume you want to use for
   downloading the data under ``/data`` within the container. This example uses
   ``/data/mlperf_llama2`` as the host's download directory:

   .. code-block:: shell

      docker run -it \
          --net=host \
          --uts=host \
          --ipc=host \
          --device /dev/dri \
          --device /dev/kfd \
          --privileged \
          --security-opt=seccomp=unconfined \
          --volume=/data/mlperf_llama2:/data \
          --volume=/data/mlperf_llama2/model:/ckpt \
          rocm/7.0:rocm7.0_ubuntu22.04_llama2_70B_training_ml_perf_instinct_20250915

2. From within the container, run the preparation script. This will download and
   preprocess the dataset and model.

   .. code-block:: shell

      bash ./scripts/prepare_data_and_model.sh

3. Verify the preprocessed files. After the script completes, check for the
   following files in the mounted directories.

   After preprocessing, you should see the following files in the ``/data/model`` directory:

   .. code-block:: shell-session

      <hash>_tokenizer.model  llama2-70b.nemo
      model_config.yaml       model_weights

   And the following files in ``/data/data``:

   .. code-block:: shell-session

      train.npy  validation.npy

4. Exit the container and return to your host shell.

   .. code-block:: shell

      exit

Run the benchmark
=================

With the dataset prepared, you can now configure and run the fine-tuning
benchmark from your host machine.

1. Set the environment variables. These variables point to the directories you used
   for data, the model, and where the resulting logs should be stored.

   .. code-block:: shell

      export DATADIR=/data/mlperf_llama2
      export LOGDIR=/data/mlperf_llama2/results
      export CONT=rocm/7.0:rocm7.0_ubuntu22.04_llama2_70B_training_ml_perf_instinct_20250915

   .. tip::

      Ensure the log directory exists and is writable by the container user.

      .. code-block:: shell

         mkdir -p $LOGDIR
         sudo chmod -R 777 $LOGDIR

.. _system-config:

2. Source the system-specific configuration file. The ``config_*.sh`` files
   contain optimized hyperparameters for different hardware configurations.

   .. code-block:: shell

      # Use the appropriate config
      source config_MI355X_1x8x1.sh  

3. To perform a single training run, use the following command.

   .. code-block:: shell

      export NEXP=1
      bash run_with_docker.sh

   Optionally, to perform 10 consecutive training runs:

   .. code-block:: shell

      export NEXP=10
      bash run_with_docker.sh

   .. note::

      To optimize performance, the ``run_with_docker.sh`` script automatically
      executes ``runtime_tunables.sh`` to apply system-level optimizations
      before starting the training job.

Upon run completion, the logs will be available under ``$LOGDIR``.
