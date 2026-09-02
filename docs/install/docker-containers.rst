.. meta::
   :description: Running ROCm workloads in Docker containers on AMD GPUs
   :keywords: Docker, AMD, ROCm, GPU, container, amd-container-runtime, CDI

**************************
Run ROCm Docker containers
**************************

Docker is a popular way to run ROCm workloads in a consistent, reproducible environment.
There are two ways to expose AMD GPUs to Docker containers:

* :ref:`AMD Container Runtime Toolkit <docker-with-toolkit>` — simplifies
  GPU access within Docker environments, enhances device discovery, and enables
  better integration with modern container technologies.

* :ref:`Manual Docker device passthrough <docker-manual>` — passes GPU device nodes
  directly to the container with ``--device``. No toolkit required.

Prerequisites
=============

Regardless of which approach you use, the following are required on the host system:

* On Linux, the AMD GPU driver (``amdgpu-dkms``). See :doc:`/install/rocm` for
  driver installation guidance for your environment.

* `Docker Engine <https://docs.docker.com/engine/install/>`__.

.. _docker-with-toolkit:

With the AMD Container Runtime Toolkit
======================================

The `AMD Container Runtime Toolkit
<https://instinct.docs.amd.com/projects/container-toolkit/en/latest/container-runtime/overview.html>`__
provides two mechanisms for GPU injection: CDI (recommended) and the
amd-container-runtime. Both require installing the toolkit first.

1. Install the toolkit by following the `Quick Start Guide (AMD Container Runtime Toolkit docs)
   <https://instinct.docs.amd.com/projects/container-toolkit/en/latest/container-runtime/quick-start-guide.html>`__.

2. See `Running Workloads (AMD Container Runtime Toolkit docs)
   <https://instinct.docs.amd.com/projects/container-toolkit/en/latest/container-runtime/running-workloads.html>`__
   to get started running containerized ROCm applications on AMD GPUs.

.. _docker-manual:

Without the AMD Container Runtime Toolkit
=========================================

If you prefer not to install the AMD Container Runtime Toolkit, or you're using older
versions of Docker Engine, you can pass GPU device nodes directly to the
container using Docker's ``--device`` flag. This approach requires no
additional software beyond Docker.

.. code-block:: shell

   docker run -it --rm \
       --device /dev/kfd \
       --device /dev/dri \
       --security-opt seccomp=unconfined \
       <image>

The purpose of each option:

* ``--device /dev/kfd``

  The main compute interface, shared by all GPUs.

* ``--device /dev/dri``

  Contains the Direct Rendering Interface (DRI) device nodes for each GPU.
  Passing the whole directory grants access to all GPUs. To restrict access
  to specific GPUs, see :ref:`docker-restrict-gpus`.

* ``--security-opt seccomp=unconfined`` (optional)

  Enables memory mapping. Recommended for HPC workloads that use ``numactl``
  for GPU/CPU affinity mappings.
  See `Optional security options (Docker docs)
  <https://docs.docker.com/reference/cli/docker/container/run/#security-opt>`_.

.. _docker-restrict-gpus:

Restricting GPU access
-----------------------

.. tip::

   `AMD Container Runtime Toolkit
   <https://instinct.docs.amd.com/projects/container-toolkit/en/latest/container-runtime/overview.html>`__
   simplifies GPU selection, removing the need to manually map the render
   nodes. This is recommended if your use case needs fine-grained GPU
   selection. See `Running Workloads (AMD Container Toolkit Runtime docs)
   <https://instinct.docs.amd.com/projects/container-toolkit/en/latest/container-runtime/running-workloads.html#running-workloads>`__
   for more information.

By default, ``--device /dev/dri`` grants access to all GPUs on the system.
To limit a container to specific GPUs, pass their individual render nodes instead.

List available render nodes on the host:

.. code-block:: shell

   ls /dev/dri/render*

GPU render nodes are typically named ``renderD128``, ``renderD129``, and so on.
Pass them individually alongside ``/dev/kfd``:

.. code-block:: shell

   docker run --device /dev/kfd \
       --device /dev/dri/renderD128 \
       --device /dev/dri/renderD129 \
       <image>

.. note::

   When GPUs are partitioned (for example, an Instinct MI300X or MI350X in DPX, QPX,
   or CPX mode), each partition appears as a separate render node. In CPX mode,
   ``renderD128`` through ``renderD136`` are partitions of the first physical GPU,
   and ``renderD137`` is the second GPU. Account for this when selecting render nodes.
   See `GPU partitioning
   <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/gpu-partitioning/mi300x/overview.html>`__
   for details.

Docker Compose
==============

Docker Compose can simplify complex Docker invocations. See `Docker Compose
usage <https://instinct.docs.amd.com/projects/container-toolkit/en/latest/container-runtime/docker-compose.html>`__
for AMD Container Toolkit configuration examples.

For manual Docker device passthrough, use the ``devices`` key in your Compose file:

.. code-block:: yaml

   services:
     myapp:
       image: <image>
       devices:
         - /dev/kfd
         - /dev/dri

Verifying GPU access
====================

Inside any container with ROCm installed, ``rocminfo`` and ``amd-smi list``
enumerate only the GPUs passed into that container. On the host, they enumerate
all ROCm-capable GPUs.

:doc:`rocminfo <rocminfo:index>` and :doc:`amd-smi <amdsmi:index>` are provided
by the ROCm Core SDK. Run either tool to confirm the expected GPUs are
visible.

Docker images
=============

The `ROCm Docker repository <https://github.com/ROCm/ROCm-docker>`_ hosts Dockerfiles
for building ROCm-capable containers. Pre-built images are available on
`Docker Hub <https://hub.docker.com/u/rocm>`_:

* ``rocm/rocm-terminal`` — minimal image with prerequisites to build HIP applications,
  without any libraries.

* `ROCm dev images <https://hub.docker.com/u/rocm?page=1&search=dev->`__ — a variety
  of OS and ROCm version combinations, suitable as a base for building applications.

* The ROCm `AI ecosystem
  <https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/>`__ provides
  Docker images for popular inference frameworks.
