.. meta::
    :description: Setting the number of CUs
    :keywords: CU, CUs, number of CUs, compute units

.. _settings-cus-reference:

*************************************************************
Setting the number of compute units
*************************************************************

The GPU driver provides two environment variables to set the number of CUs used:

- ``HSA_CU_MASK``
- ``ROC_GLOBAL_CU_MASK``

The ``ROC_GLOBAL_CU_MASK`` variable sets the CU mask on queues created by HIP or OpenCL runtimes. The ``HSA_CU_MASK`` variable sets the mask on a lower level of queue creation in the driver. It also sets the mask on the queues being profiled.

.. tip::

    When using GPUs to accelerate compute workloads, it sometimes becomes necessary to configure the hardware's usage of compute units (CU). This is a more advanced option, so please read this page before experimentation.

The environment variables have the following syntax:

::

    ID = [0-9][0-9]*                         ex. base 10 numbers
    ID_list = (ID | ID-ID)[, (ID | ID-ID)]*  ex. 0,2-4,7
    GPU_list = ID_list                       ex. 0,2-4,7
    CU_list = 0x[0-F]* | ID_list             ex. 0x337F OR 0,2-4,7
    CU_Set = GPU_list : CU_list              ex. 0,2-4,7:0-15,32-47 OR 0,2-4,7:0x337F
    HSA_CU_MASK = CU_Set [; CU_Set]*         ex. 0,2-4,7:0-15,32-47; 3-9:0x337F

The GPU indices are taken post ``ROCR_VISIBLE_DEVICES`` reordering. The listed or masked CUs are enabled for listed GPUs, and the others are disabled. Unlisted GPUs are not be affected, and their CUs are enabled.

The variable parsing stops when a syntax error occurs. The erroneous set and the following are ignored. Repeating GPU or CU IDs results in a syntax error. Specifying a mask with no usable CUs (CU_list is 0x0) results in a syntax error. To exclude GPU devices, use ``ROCR_VISIBLE_DEVICES``.

.. note::

    These environment variables only affect ROCm software, not graphics applications.

Not all CU configurations are valid on all devices. For example, on devices where two CUs can be combined into a WGP (for kernels running in WGP mode), it’s not valid to disable only a single CU in a WGP.

