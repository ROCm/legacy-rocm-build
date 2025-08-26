SGLang distributed inference
============================

Disaggregated inference refers to the process of splitting the inference of
LLMs into distinct phases -- separating the prefill and decode stages. This
approach can improve efficiency and resource allocation by allowing each phase
to be optimized independently.

## List of Models - focus SGlang Dissagerated P/D inference

Dense Models
- Qwen3-32B (https://huggingface.co/Qwen/Qwen3-32B)
- meta-llama/Llama-3.1-8B-Instruct (https://huggingface.co/meta-llama/Llama-3.1-8B-Instruct)
- amd/Llama-3.3-70B-Instruct-FP8-KV (https://huggingface.co/amd/Llama-3.3-70B-Instruct-FP8-KV)
- amd/Llama-3.1-405B-Instruct-FP8-KV (https://huggingface.co/amd/Llama-3.1-405B-Instruct-FP8-KV)

Small Experts Models
- DeepSeek-V2 (https://huggingface.co/deepseek-ai/DeepSeek-V2)
- Qwen3-30B-A3B (https://huggingface.co/Qwen/Qwen3-30B-A3B)
- Mixtral-8x7B-v0.1 (https://huggingface.co/mistralai/Mixtral-8x7B-v0.1)

This repository contains scripts and documentation to launch PD Disaggregation using the Mooncake framework for above models. You will find setup instructions, node assignment details and benchmarking commands.

Prerequisites
=============

- A Slurm cluster with required Nodes -> xP + yD + 1 (minimum size 3: xP=1 and xD=1)
- Docker container with SGLang, Mooncake, etcd and NIC drivers built-in. Refer to Building the Docker image section below.
- Access to a shared filesystem for log collection( cluster specific)


Building the Docker image
=========================

Access the Dockerfile located https://github.com/ROCm/MAD/docker/sglang_dissag_inference.ubuntu.amd.Dockerfile
It uses ‘lmsysorg/sglang:v0.4.9.post1-rocm630’ as the base docker image.

```bash
docker build  -t sglang_dissag_pd_image -f sglang_dissag_inference.ubuntu.amd.Dockerfile .
```

Scripts and benchmarking
========================

Run instructions - scripts/sglang_dissag/README.MD

Few files of significance:

scripts/sglang_dissag/run_xPyD_models.slurm - slurm script to launch docker containers on all nodes using sbatch or salloc  
scripts/sglang_dissag/sglang_disagg_server.sh - Script that runs inside each docker to start required proxy, prefill and decode services
scripts/sglang_dissag/benchmark_xPyD.sh - Benchmark script to run GSM8K for accuracy and sglang benchmarking tool for performance measurement
scripts/sglang_dissag/benchmark_parser.py - Log parser script to be run on CONCURRENY benchmark log file to generate tabulated data

## Sbatch run command (one-liner)
```bash

# Clone the repo
git clone https://github.com/ROCm/MAD.git
cd scripts/sglang_dissag

# Sbatch run command [run from the above folder]
export DOCKER_IMAGE_NAME=<DOCKER IMAGE NAME>
export xP=<num_prefill_nodes>; export yD=<num_decode_nodes>; export MODEL_NAME=Llama-3.1-8B-Instruct; sbatch -N <num_nodes> -n <num_nodes> --nodelist=<Nodes> run_xPyD_models.slurm

# num_nodes = xP + xD + 1
```

## Post execution Log files:
A directory inside the LOG_PATH variable in the slurm script is created by the name of slurm_job_ID. 

Inside that folder:

pd_sglang_bench_serving.sh_NODE<>.log - Overall log per ser Node 
etcd_NODE<>.log  - for etcd services
decode_NODE<>.log - Decode services
prefill_NODE<>.log - prefill services


## Benchmark parser ( for CONCURRENCY logs) to tabulate different data

.. code-block:: shell

   python3 benchmark_parser.py <log_path/benchmark_XXX_CONCURRENCY.log

## Sample curl command to test launched server ( from docker on the proxy node)

.. code-block:: shell

   curl -X POST http://127.0.0.1:30000/generate -H "Content-Type: application/json" -d '{ "text": "Let me tell you a story ", "sampling_params": { "temperature": 0.3 } }'
