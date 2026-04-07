.. meta::
   :description: Pull and run ROCm Docker containers
   :keywords: installation instructions, Docker, AMD, ROCm

.. _docker-prerequisites:

**************************
Run ROCm Docker containers
**************************

Using Docker to run your ROCm applications is one of the best ways to get
consistent and reproducible environments.

Prerequisites
=============

Docker containers share the kernel with the host OS. Therefore, the AMD GPU
Driver (``amdgpu-dkms``) must be installed on the host.

* Check for ``amdgpu-dkms``. See `Verify kernel-mode driver installation
  <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/install/detailed-install/post-install.html#verify-kernel-mode-driver-installation>`__.

* If you don't have ``amdgpu-dkms``, `install the AMD GPU Driver
  <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/install/package-manager-index.html>`__.

.. seealso::

   You'll need Docker Engine installed on your system. See `Install Docker
   Engine (Docker docs) <https://docs.docker.com/engine/install/>`__.

.. _docker-access-gpus-in-container:

Accessing AMD GPUs in containers
================================

To grant a Docker container access to the host's AMD GPUs, run your container
with the following options, substituting ``<image>`` with the appropriate name.
See the `Docker documentation
<https://docs.docker.com/reference/cli/docker/container/run/>`__ to learn more
about the ``docker run`` command and its options.

.. code-block:: bash

    docker run \
        --device /dev/kfd \
        --device /dev/dri \
        --network=host \
        --ipc=host \
        --group-add video \
        --cap-add=SYS_PTRACE \
        --security-opt seccomp=unconfined \
        <image>

The purpose of the options is as follows:

``--device /dev/kfd``
  This is the main compute interface shared by all GPUs. The Docker CLI's
  ``--device`` option enables directly exposing host devices to a container.
  See `Add host device to container (Docker docs)
  <https://docs.docker.com/reference/cli/docker/container/run/#device>`_ for
  more information.

``--device /dev/dri``
  This directory contains the Direct Rendering Interface (DRI) for each GPU. To
  restrict access to specific GPUs, see :ref:`docker-restrict-gpus`.

``--network=host``
  Uses the host's network stack directly instead of Docker's isolated network
  namespace. This is required when running inference servers (such as vLLM or
  SGLang) that need to be reachable from the host or other machines without
  port mapping, and avoids network overhead that can affect throughput at high
  request rates.

``--ipc=host``
  Shares the host's IPC namespace, giving the container access to the host's
  shared memory (``/dev/shm``). AI frameworks use shared memory extensively for
  inter-process communication, such as tensor parallelism across multiple GPUs
  and passing data batches between workers. The default isolated container IPC
  namespace has a very small shared memory limit (64 MB) that is insufficient
  for most AI workloads.

``--group-add video``
  Adds the container user to the ``video`` group, which owns the ``/dev/dri``
  render nodes on the host. Without this, non-root users inside the container
  will be denied access to GPU render devices.

``--cap-add=SYS_PTRACE``
  Grants the ``ptrace`` capability, which is required by ROCm debugging and
  profiling tools. Some ROCm runtime internals also depend on this capability
  for GPU error reporting.

``--security-opt seccomp=unconfined``
  Disables the default seccomp syscall filter, enabling memory mapping and
  other syscalls that ROCm and HPC applications require. The performance of an
  application can vary depending on the assignment of GPUs and CPUs to the
  task. Typically, ``numactl`` is installed as part of many HPC applications to
  provide GPU/CPU mappings, and this option is required for those mappings to
  work correctly. See `Optional security options (Docker docs)
  <https://docs.docker.com/reference/cli/docker/container/run/#security-opt>`__.

Docker Compose
--------------

You can also use ``docker compose`` to launch your containers, even when
launching a single container. This can be a convenient way to run complex
Docker commands without having to remember all the CLI arguments. The following
snippet is an example ``compose.yaml`` file, which is equivalent to the
preceding ``docker run`` command:

.. code-block:: yaml

   services:
     my-service:
       image: <image>
       devices:
         - /dev/kfd
         - /dev/dri
       group_add:
         - video
       ipc: host
       network_mode: host
       cap_add:
         - SYS_PTRACE
       security_opt:
         - seccomp=unconfined

You can then run this using ``docker compose run my-service``.

.. _docker-restrict-gpus:

Restricting GPU access
----------------------

By default, passing ``--device /dev/dri`` grants access to all GPUs on the
system. To limit a container to a specific subset of GPUs, you can instead pass
in their individual device nodes.

GPU device nodes are located in ``/dev/dri/`` and are typically named
``renderD128``, ``renderD129``, and so on. You can list the available GPUs on
your host system with the following command:

.. code-block:: shell

   ls /dev/dri/render*

To expose only the first two GPUs to the container, specify them directly in
the run command. Note that ``/dev/kfd`` is always required for the compute
interface.

For example, to expose the first and second GPU:

.. code-block:: shell

    docker run \
        --device /dev/kfd \
        --device /dev/dri/renderD128 \
        --device /dev/dri/renderD129 \
        ...

.. note::

  When GPUs are partitioned (such as the Instinct MI300 or MI350 Series in DPX,
  QPX, or CPX mode), you must account for the number of partitions when
  selecting GPUs. For example, in CPX mode, ``renderD128`` and ``renderD137``
  correspond to the first and second GPUs. In CPX mode, ``renderD128`` to
  ``renderD136`` correspond to different partitions of the first GPU. For more
  information, see the `GPU partitioning overview
  <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/gpu-partitioning/mi300x/overview.html>`_.

Verifying the AMD GPU driver has been loaded on GPUs
----------------------------------------------------

``rocminfo`` is a command line tool included with base ROCm installations that
reports information about the HSA runtime, including system attributes and the
HSA agents visible to the current process. ``amd-smi`` is a command line tool
for monitoring and, where supported, managing AMD GPUs through the ``amdgpu``
kernel driver.

Keep in mind:

- Running ``rocminfo`` and ``amd-smi list`` inside the container will only
  enumerate the GPUs passed into the Docker container.

- Running ``rocminfo`` and ``amd-smi list`` on bare metal will enumerate all
  ROCm-capable GPUs on the machine.

.. _docker-rocm-images:

Docker images in the ROCm ecosystem
===================================

The `ROCm organization on Docker Hub <https://hub.docker.com/u/rocm>`__ hosts
validated Docker images, providing reproducible environments for ROCm and AI
development.

In particular:

* ``rocm/rocm-terminal`` is a small image with the prerequisites to build HIP applications, but does not
  include any libraries.

* `ROCm dev images <https://hub.docker.com/u/rocm?page=1&search=dev->`__
  provide a variety of OS and ROCm versions, and are a great starting place for
  building applications.

AI inference
------------

* ``rocm/vllm`` -- see :doc:`/ai-inference/vllm` for more information.
