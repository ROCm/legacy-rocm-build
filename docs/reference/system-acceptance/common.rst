.. meta::
   :description: Common system settings for AMD GPUs including GPU isolation and BAR access configuration.
   :keywords: GPU isolation, BAR access, compute units, system settings, AMD, ROCm

***************************
Common system settings
***************************

These topics discuss system-level GPU configuration that applies across AMD
hardware and workload types.

* :doc:`GPU isolation techniques <gpu-isolation>` -- Restrict application
  access to a subset of GPUs using environment variables, cgroups, or
  virtual machines.

* :doc:`BAR access limits <bar-access-limits>` -- Understand Base Address
  Register (BAR) physical addressing limits and how to handle peer-to-peer
  DMA access restrictions.
