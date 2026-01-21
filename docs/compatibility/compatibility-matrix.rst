****************************************
ROCm |ROCM_VERSION| compatibility matrix
****************************************

To plan your ROCm |ROCM_VERSION| installation, use the following selector to
view ROCm compatibility and system requirements information for your AMD
hardware configuration. For installation instructions, see
:doc:`/install/rocm`.

.. include:: ./includes/selector.rst

----

Hardware, software, and firmware requirements
=============================================

ROCm depends on a coordinated stack of compatible firmware, driver, and user
space components. Maintaining version alignment between these layers ensures
expected GPU operation and performance, especially for AMD data center products.
Future preview releases will expand hardware and operating system coverage.

ROCm 7.11.0 enables support for primarily compute workloads. Future releases
will support mixed workloads (compute and graphics).

.. selected:: os=ubuntu os=rhel os=sles

   .. selected:: fam=radeon-pro fam=radeon

      If you’re interested in testing AMD Radeon GPUs with preview support for
      graphics use cases with AMD ROCm 7.11.0, install Radeon Software for Linux
      version 25.35 from `Linux Drivers for AMD Radeon and Radeon PRO
      Graphics <https://www.amd.com/en/support/download/linux-drivers.html>`__.

   .. selected:: fam=ryzen

      If you're interested in testing AMD Ryzen APUs with preview support for
      graphics use cases with AMD ROCm 7.11.0, use the inbox graphics drivers of
      Ubuntu 24.04.3.

.. include:: ./includes/system-instinct.rst

.. include:: ./includes/system-radeon-pro.rst

.. include:: ./includes/system-radeon.rst

.. include:: ./includes/system-ryzen.rst

----

.. _rocm-compat-frameworks:

Deep learning frameworks
========================

ROCm |ROCM_VERSION| provides optimized support for popular deep learning
frameworks. The following table lists supported frameworks and their supported
versions.

.. _rocm-compat-pytorch:

.. matrix::

   .. matrix-head::

      .. matrix-row::

         .. matrix-cell:: Framework
            :header:

         .. matrix-cell:: Supported versions
            :header:

   .. matrix-row::
      :show-when: fam=instinct fam=ryzen

      .. matrix-cell:: PyTorch

      .. matrix-cell:: 2.9.1, 2.8.0, 2.7.1
         :show-when: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      .. matrix-cell:: 2.9.1
         :show-when: os=windows

   .. matrix-row::
      :show-when: fam=radeon fam=radeon-pro

      .. matrix-cell:: PyTorch

      .. matrix-cell:: 2.9.1

For installation instructions, see :ref:`pip-install-pytorch`.

.. _rocm-compat-python:

.. note::

   ROCm |ROCM_VERSION| is compatible with Python versions 3.11, 3.12, and
   3.13.

----

ROCm Core SDK components
========================

The following table lists core components included in the ROCm |ROCM_VERSION|
release. Expect future releases in this stream to expand the list of
components.

.. include:: ./includes/core-sdk-components-linux.rst

.. include:: ./includes/core-sdk-components-windows.rst

----

.. include:: ./includes/virtualization-instinct.rst
