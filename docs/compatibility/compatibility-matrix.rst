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

ROCm 7.12.0 enables support for primarily compute workloads. Future releases
will support mixed workloads (compute and graphics).

.. include:: ./includes/system-instinct.rst

.. include:: ./includes/system-radeon-pro.rst

.. include:: ./includes/system-radeon.rst

.. include:: ./includes/system-ryzen.rst

----

.. _rocm-compat-frameworks:

.. _rocm-compat-python:

.. _rocm-compat-pytorch:

AI ecosystem
============

ROCm |ROCM_VERSION| provides optimized support for popular deep learning frameworks and
AI inference engines. The following table lists supported frameworks and
libraries, their validated versions, and compatible operating systems.

.. include:: ./includes/ai-ecosystem.rst

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
