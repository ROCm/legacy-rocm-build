.. meta::
   :description: AMD ROCm control and monitoring tools for inspecting and managing AMD GPU hardware state.
   :keywords: monitoring, AMD SMI, rocminfo, RDC, GPU, management, ROCm

****************************************
ROCm system control and monitoring tools
****************************************

ROCm control and monitoring tools provide interfaces for inspecting and
managing AMD GPU hardware state in workstation and data center environments.

* :doc:`AMD SMI <amdsmi:index>` -- System management interface to control AMD
  GPU settings, monitor performance, and retrieve device and process
  information.

  For RAS ECC error injection on Instinct GPUs, use
  ``rocm-smi --rasinject BLOCK ERRTYPE`` from the public ``rocm_smi_lib`` CLI.
  Note: ``amdgpuras`` is not shipped in public ROCm releases; if you were
  directed to that tool from internal documentation, please use the public
  ``rocm-smi`` path or contact AMD support for enterprise deployment options.

* :doc:`ROCm Data Center Tool <rdc:index>` (RDC) -- Simplifies administration
  and addresses key infrastructure challenges in AMD GPUs in cluster and
  data-center environments.

* :doc:`rocminfo <rocminfo:index>` -- Reports system information.
