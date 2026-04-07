.. selected:: i=pkgman

   .. selected:: os=ubuntu

      This installation method uses Ubuntu's native package manager ``apt``
      to install ROCm. This method suits standard system-wide installations
      where ROCm packages should be tracked, updated, and removed through
      system package workflows.

   .. selected:: os=debian

      This installation method uses Debian's native package manager ``apt``
      to install ROCm. This method suits standard system-wide installations
      where ROCm packages should be tracked, updated, and removed through
      system package workflows.

   .. selected:: os=rhel

      This installation method uses RHEL's native package manager ``dnf`` to
      install ROCm. This method suits standard system-wide installations where
      ROCm packages should be tracked, updated, and removed through system
      package workflows.

   .. selected:: os=oracle-linux

      This installation method uses Oracle Linux's native package manager
      ``dnf`` to install ROCm. This method suits standard system-wide
      installations where ROCm packages should be tracked, updated, and removed
      through system package workflows.

   .. selected:: os=rocky-linux

      This installation method uses Rocky Linux's native package manager
      ``dnf`` to install ROCm. This method suits standard system-wide
      installations where ROCm packages should be tracked, updated, and removed
      through system package workflows.

   .. selected:: os=sles

      This installation method uses SLES's native package manager ``zypper``
      to install ROCm. This method suits standard system-wide installations
      where ROCm packages should be tracked, updated, and removed through
      system package workflows.

.. selected:: i=pip

   The pip installation method provides ROCm components as Python wheel
   packages in a virtual environment. This method suits Python-focused
   development workflows that use an isolated, per-project ROCm environment
   managed with standard Python packaging tools.

.. selected:: i=tar

   The tarball installation method provides ROCm as a self-contained
   installation from a pre-built archive. This method suits controlled or
   restricted environments requiring manual placement, updates, and removal
   outside the system package manager.

.. selected:: i=runfile

   The ROCm Runfile Installer can install ROCm and/or the AMD GPU Driver (amdgpu)
   without using a native Linux package management system, making it ideal for
   systems with policy constraints or restricted environments. Network access is
   not needed for install as long as dependencies for ROCm and/or AMD GPU driver
   (amdgpu) are met. A single installer supports all GFX architectures, automates
   post-installation configuration, and offers an interactive command line TUI for
   guided setup.

.. selected:: os=wsl

   Installing ROCm in a Windows Subsystem for Linux (WSL) environment requires
   building the AMD ROCDXG library from source. See
   `<https://github.com/ROCm/librocdxg>`__ for more information.

.. selected:: w=graphics

   .. selected:: os=ubuntu os=rhel

      Use the ``amdgpu-install`` script to install ROCm, the AMD GPU driver,
      graphics components, and other packages. It simplifies installation by
      automating GPU-specific and distro-specific package selection. The script
      also runs post-installation checks and installs an uninstallation script,
      allowing you to remove the entire ROCm stack with a single command.
