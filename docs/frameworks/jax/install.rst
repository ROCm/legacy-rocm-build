:selector-toc2: Installation environment
:selector-toc2-icon: fa-solid fa-computer

.. _jax-install:

**********************************
Install JAX on ROCm |ROCM_VERSION|
**********************************

This topic guides you through installing JAX with ROCm support on AMD
hardware. It applies to :ref:`supported AMD GPUs and platforms
<release-ai-ecosystem>`.

.. selector:: Device family
   :key: fam

   .. selector-option:: AMD Instinct™
      :value: instinct w=compute
      :width: 4
      :toc-label: AMD Instinct

   .. selector-option:: AMD Radeon™
      :value: radeon w=compute
      :width: 4
      :toc-label: AMD Radeon

   .. selector-option:: AMD Ryzen™
      :value: ryzen w=compute
      :width: 4
      :toc-label: AMD Ryzen

.. include:: /install/include/gpu-selector.rst

.. selector:: Operating system
   :key: os

   .. selector-option:: Linux
      :value: linux
      :width: 12

.. selector:: JAX version
   :key: jax-ver

   .. selector-option:: 0.9.1
      :value: 0.9.1
      :width: 6

   .. selector-option:: 0.8.2
      :value: 0.8.2
      :width: 6

Prerequisites
=============

.. selected:: fam=instinct fam=radeon

   - Ensure your system has the AMD GPU Driver (amdgpu) installed. See the
     :ref:`compat-matrix` for driver support information. For installation
     instructions, see the `AMD GPU Driver documentation
     <https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.30.0-preview/index.html>`__.

- Ensure your system has a :ref:`supported Python version
  <rocm-compat-python>` installed and accessible: 3.11, 3.12, 3.13, or 3.14.

- :doc:`Install the ROCm Core SDK </install/rocm>` -- it's recommended to use
  pip to install JAX and the ROCm Core SDK in the same Python virtual
  environment.

  .. important::

     Unlike PyTorch, the JAX packages do not automatically install
     ``rocm[libraries]`` as a dependency.

.. _pip-install-jax:

Install JAX using pip
=====================

For prerequisite steps and post-installation recommendations, see the
:doc:`ROCm installation instructions </install/rocm>`.

.. _pip-install-jax-venv:

1. Set up your Python virtual environment. For example, run the following
   command to create one with Python 3.13:

   .. code-block:: shell

      python3.13 -m venv .venv

2. Activate your Python virtual environment. For example:

   .. selected:: os=linux

      .. code-block:: shell

         source .venv/bin/activate

3. Install the appropriate ROCm-enabled JAX libraries for your operating system
   and AMD hardware architecture.

   .. selected:: jax-ver=0.9.1

      .. note::

         The ``jax`` and ``jaxlib`` packages are not published to the AMD package
         repository. After installing GFX architecture-based ``jax_rocm7_plugin``
         and ``jax_rocm7_pjrt`` packages from the AMD repository, install
         ``jax`` and ``jaxlib`` from `PyPI <https://pypi.org/project/jax>`__.

   .. selected:: jax-ver=0.8.2

      .. note::

         The ``jax`` package is not published to the AMD package repository.
         After installing GFX architecture-based ``jaxlib``,
         ``jax_rocm7_plugin`` and ``jax_rocm7_pjrt`` packages from the AMD
         repository, install ``jax`` from `PyPI
         <https://pypi.org/project/jax>`__.

   .. selected:: jax-ver=0.9.1

      .. selected:: gfx=gfx950

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx950-dcgpu/ \
              "jax_rocm7_plugin==0.9.1+rocm7.13.0" \
              "jax_rocm7_pjrt==0.9.1+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install \
              "jax==0.9.1" \
              "jaxlib==0.9.1"

      .. selected:: gfx=gfx942

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx94X-dcgpu/ \
              "jax_rocm7_plugin==0.9.1+rocm7.13.0" \
              "jax_rocm7_pjrt==0.9.1+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install \
              "jax==0.9.1" \
              "jaxlib==0.9.1"

      .. selected:: gfx=gfx90a

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx90a/ \
              "jax_rocm7_plugin==0.9.1+rocm7.13.0" \
              "jax_rocm7_pjrt==0.9.1+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install \
              "jax==0.9.1" \
              "jaxlib==0.9.1"

      .. selected:: gfx=gfx908

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx908/ \
              "jax_rocm7_plugin==0.9.1+rocm7.13.0" \
              "jax_rocm7_pjrt==0.9.1+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install \
              "jax==0.9.1" \
              "jaxlib==0.9.1"

      .. selected:: gfx=gfx1201 gfx=gfx1200

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx120X-all/ \
              "jax_rocm7_plugin==0.9.1+rocm7.13.0" \
              "jax_rocm7_pjrt==0.9.1+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install \
              "jax==0.9.1" \
              "jaxlib==0.9.1"

      .. selected:: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx110X-all/ \
              "jax_rocm7_plugin==0.9.1+rocm7.13.0" \
              "jax_rocm7_pjrt==0.9.1+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install \
              "jax==0.9.1" \
              "jaxlib==0.9.1"

      .. selected:: gfx=gfx1030

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx103X-all/ \
              "jax_rocm7_plugin==0.9.1+rocm7.13.0" \
              "jax_rocm7_pjrt==0.9.1+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install \
              "jax==0.9.1" \
              "jaxlib==0.9.1"

      .. selected:: gfx=gfx1151

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1151/ \
              "jax_rocm7_plugin==0.9.1+rocm7.13.0" \
              "jax_rocm7_pjrt==0.9.1+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install \
              "jax==0.9.1" \
              "jaxlib==0.9.1"

      .. selected:: gfx=gfx1150

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1150/ \
              "jax_rocm7_plugin==0.9.1+rocm7.13.0" \
              "jax_rocm7_pjrt==0.9.1+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install \
              "jax==0.9.1" \
              "jaxlib==0.9.1"

      .. selected:: gfx=gfx1152

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1152/ \
              "jax_rocm7_plugin==0.9.1+rocm7.13.0" \
              "jax_rocm7_pjrt==0.9.1+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install \
              "jax==0.9.1" \
              "jaxlib==0.9.1"

   .. selected:: jax-ver=0.8.2

      .. selected:: gfx=gfx950

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx950-dcgpu/ \
              "jaxlib==0.8.2" \
              "jax_rocm7_plugin==0.8.2+rocm7.13.0" \
              "jax_rocm7_pjrt==0.8.2+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install "jax==0.8.2"

      .. selected:: gfx=gfx942

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx94X-dcgpu/ \
              "jaxlib==0.8.2" \
              "jax_rocm7_plugin==0.8.2+rocm7.13.0" \
              "jax_rocm7_pjrt==0.8.2+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install "jax==0.8.2"

      .. selected:: gfx=gfx90a

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx90a/ \
              "jaxlib==0.8.2" \
              "jax_rocm7_plugin==0.8.2+rocm7.13.0" \
              "jax_rocm7_pjrt==0.8.2+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install "jax==0.8.2"

      .. selected:: gfx=gfx908

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx908/ \
              "jaxlib==0.8.2" \
              "jax_rocm7_plugin==0.8.2+rocm7.13.0" \
              "jax_rocm7_pjrt==0.8.2+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install "jax==0.8.2"

      .. selected:: gfx=gfx1201 gfx=gfx1200

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx120X-all/ \
              "jaxlib==0.8.2" \
              "jax_rocm7_plugin==0.8.2+rocm7.13.0" \
              "jax_rocm7_pjrt==0.8.2+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install "jax==0.8.2"

      .. selected:: gfx=gfx1100 gfx=gfx1101 gfx=gfx1102 gfx=gfx1103

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx110X-all/ \
              "jaxlib==0.8.2" \
              "jax_rocm7_plugin==0.8.2+rocm7.13.0" \
              "jax_rocm7_pjrt==0.8.2+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install "jax==0.8.2"

      .. selected:: gfx=gfx1030

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx103X-all/ \
              "jaxlib==0.8.2" \
              "jax_rocm7_plugin==0.8.2+rocm7.13.0" \
              "jax_rocm7_pjrt==0.8.2+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install "jax==0.8.2"

      .. selected:: gfx=gfx1151

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1151/ \
              "jaxlib==0.8.2" \
              "jax_rocm7_plugin==0.8.2+rocm7.13.0" \
              "jax_rocm7_pjrt==0.8.2+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install "jax==0.8.2"

      .. selected:: gfx=gfx1150

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1150/ \
              "jaxlib==0.8.2" \
              "jax_rocm7_plugin==0.8.2+rocm7.13.0" \
              "jax_rocm7_pjrt==0.8.2+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install "jax==0.8.2"

      .. selected:: gfx=gfx1152

         .. code-block:: bash
            :substitutions:

            python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1152/ \
              "jaxlib==0.8.2" \
              "jax_rocm7_plugin==0.8.2+rocm7.13.0" \
              "jax_rocm7_pjrt==0.8.2+rocm7.13.0"

            # Install jax from PyPI
            python -m pip install "jax==0.8.2"

.. _install-jax-env-vars:

4. Set the following environment variable before running JAX as a workaround
   for a :ref:`known issue <jax-install-known-issues>`.

   .. code-block:: shell

      export XLA_FLAGS="--xla_gpu_enable_command_buffer="

5. Check your JAX installation.

   .. code-block:: shell

      python -c "import jax; print(jax.devices())"

   This prints something like ``[RocmDevice(id=0)]`` if JAX and ROCm are installed properly.

.. _jax-install-known-issues:

Known issues
============

These are known issues related to JAX installation on ROCm
|ROCM_VERSION| and their workarounds.

Segfaults with JAX 0.9.1
-------------------------

JAX 0.9.1 might segfault during execution. To work around this, disable XLA
command buffers by setting the following flag before running your script:

.. code-block:: shell

   export XLA_FLAGS="--xla_gpu_enable_command_buffer="
