.. meta::
   :description: How to install ROCm and popular deep learning frameworks.
   :keywords: ROCm, AI, LLM, train, fine-tune, FSDP, DeepSpeed, LLaMA, tutorial

.. _rocm-for-ai-install:

********************************************
Installing ROCm and deep learning frameworks
********************************************

Before getting started, install ROCm and supported deep learning frameworks.

.. grid:: 1

   .. grid-item-card:: Pre-install

      Each release of ROCm supports specific hardware and software configurations. Before installing, consult the
      :doc:`System requirements <rocm-install-on-linux:reference/system-requirements>` and
      :doc:`Installation prerequisites <rocm-install-on-linux:install/prerequisites>` guides.

If you’re new to ROCm, refer to the :doc:`ROCm quick start install guide for Linux
<rocm-install-on-linux:install/quick-start>`.

If you’re using a Radeon GPU for graphics-accelerated applications, refer to the
`Radeon installation instructions <https://rocm.docs.amd.com/projects/radeon/en/docs-6.1.3/docs/install/native_linux/install-radeon.html>`_.

You can install ROCm on :ref:`compatible systems <rocm-install-on-linux:reference/system-requirements>` via your Linux
distribution's package manager. See the following documentation resources to get started:

* :doc:`ROCm installation overview <rocm-install-on-linux:install/install-overview>`

* :doc:`Using your Linux distribution's package manager <rocm-install-on-linux:install/install-methods/package-manager-index>`

* :ref:`Multi-version installation <rocm-install-on-linux:installation-types>`

.. grid:: 1

   .. grid-item-card:: Post-install

      Follow the :doc:`post-installation instructions <rocm-install-on-linux:install/post-install>` to
      configure your system linker, PATH, and verify the installation.

      If you encounter any issues during installation, refer to the
      :doc:`Installation troubleshooting <rocm-install-on-linux:reference/install-faq>` guide.

Deep learning frameworks
========================

ROCm supports deep learning frameworks and libraries including `PyTorch
<https://pytorch.org/blog/pytorch-for-amd-rocm-platform-now-available-as-python-package>`_, `TensorFlow
<https://tensorflow.org>`_, `JAX <https://jax.readthedocs.io/en/latest>`_, and more.

Review the :doc:`framework installation documentation <../deep-learning-rocm>`. For ease-of-use, it's recommended to use official ROCm prebuilt Docker
images with the framework pre-installed.

Next steps
==========

After installing ROCm and your desired ML libraries -- and before running AI workloads -- conduct system health benchmarks
to test the optimal performance of your AMD hardware. See :doc:`system-health-check` to get started.
