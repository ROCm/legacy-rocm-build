:selector-toc2: Installation environment
:selector-toc2-icon: fa-solid fa-computer

.. _compat-matrix:

****************************************
ROCm |ROCM_VERSION| compatibility matrix
****************************************

To plan your ROCm |ROCM_VERSION| installation, use the following selector to
view ROCm compatibility and system requirements information for your AMD
hardware configuration and system environment. For installation instructions,
see :doc:`/install/rocm`.

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

.. include:: /install/include/os-selector.rst

----

.. _system-requirements:

System requirements and information
===================================

ROCm depends on a coordinated stack of compatible firmware, driver, and user
space components. Maintaining version alignment between these layers ensures
expected GPU operation and performance, especially for AMD data center
products. This table lists GPU details followed by supported operating systems,
kernel driver, and firmware versions.

.. include:: ./include/system-instinct.rst

.. include:: ./include/system-radeon.rst

.. include:: ./include/system-ryzen.rst

For hardware specifications, see :ref:`gpu-specs`.

----

ROCm Core SDK components
========================

The following table lists core components included in the ROCm |ROCM_VERSION|
release. Expect future releases in this stream to expand the list of
components.

.. include:: ./include/core-sdk-components-linux.rst

.. include:: ./include/core-sdk-components-windows.rst

----

.. include:: ./include/virtualization-instinct.rst

.. include:: ./include/virtualization-radeon.rst

----

.. include:: ./include/partitioning-instinct.rst

.. _rocm-compat-frameworks:

.. _rocm-compat-python:

.. _rocm-compat-pytorch:

AI ecosystem compatibility
==========================

ROCm |ROCM_VERSION| provides optimized support for popular deep learning
frameworks and AI inference engines. The following table lists supported
frameworks and libraries, their validated versions, and compatible Python
versions.

.. include:: ./include/ai-ecosystem.rst
