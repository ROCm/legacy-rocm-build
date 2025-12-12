Installation
============

.. dropdown:: Installation environment
   :animate: fade-in-slide-down
   :icon: desktop-download
   :chevron: down-up

   .. include:: ./includes/selector.rst

Before getting started, make sure you've completed the :ref:`rocm-prerequisites`.
For information about supported operating systems and compatible AMD devices,
see the :doc:`Compatibility matrix </compatibility/compatibility-matrix>`.

.. selected:: os=windows

   .. caution::

      Do not copy/replace the ROCm compiler and runtime DLLs to System32 as
      this can cause conflicts.

.. selected:: fam=instinct

   .. selected:: os=ubuntu
      :heading: Install kernel driver
      :heading-level: 3

      For information about AMD GPU Driver (amdgpu) compatibility, see the
      :doc:`Compatibility matrix </compatibility/compatibility-matrix>`.

      For instructions on installing the AMD GPU Driver (amdgpu), see `Ubuntu native
      installation
      <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/install/detailed-install/package-manager/package-manager-ubuntu.html>`__
      in the AMD Instinct Data Center GPU Documentation.

   .. selected:: os=rhel
      :heading: Install kernel driver
      :heading-level: 3

      For information about AMD GPU Driver (amdgpu) compatibility, see the
      :doc:`Compatibility matrix </compatibility/compatibility-matrix>`.

      For instructions on installing the AMD GPU Driver (amdgpu), see `RHEL native
      installation
      <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/install/detailed-install/package-manager/package-manager-rhel.html>`__
      in the AMD Instinct Data Center GPU Documentation.

   .. selected:: os=sles
      :heading: Install kernel driver
      :heading-level: 3

      For information about AMD GPU Driver (amdgpu) compatibility, see the
      :doc:`Compatibility matrix </compatibility/compatibility-matrix>`.

      For instructions on installing the AMD GPU Driver (amdgpu), see `SLES native
      installation
      <https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/install/detailed-install/package-manager/package-manager-sles.html>`__
      in the AMD Instinct Data Center GPU Documentation.

.. selected:: fam=radeon-pro fam=radeon

   .. selected:: os=ubuntu os=rhel os=sles
      :heading: Install kernel driver
      :heading-level: 3

      For information about driver compatibility for Linux on Radeon, see the
      :doc:`Compatibility matrix </compatibility/compatibility-matrix>`.

      To download the Radeon Software for Linux package,
      see `Linux Drivers for AMD Radeon and Radeon PRO Graphics
      <https://www.amd.com/en/support/download/linux-drivers.html>`__.

.. selected:: fam=ryzen

   .. selected:: os=ubuntu os=rhel os=sles
      :heading: About the kernel driver
      :heading-level: 3

      Supported Ryzen AI APUs require the inbox kernel driver included with
      Ubuntu 24.04.3.

Install ROCm
------------

Use the following instructions to install the ROCm Core SDK on your system.

.. selected:: i=pip
   :heading: Set up your Python virtual environment
   :heading-level: 4

   Create and activate the Python virtual environment where you'll install
   ROCm packages.

   .. selected:: os=ubuntu

      .. selected:: os-version=24

         For example, to create and activate a Python 3.12 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.12 -m venv .venv
            source ./.venv/bin/activate

      .. selected:: os-version=22

         For example, to create and activate a Python 3.11 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.11 -m venv .venv
            source ./.venv/bin/activate

   .. selected:: os=rhel

      .. selected:: os-version=10.1 os-version=10.0

         For example, to create and activate a Python 3.12 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.12 -m venv .venv
            source ./.venv/bin/activate

      .. selected:: os-version=9.7 os-version=9.6

         For example, to create and activate a Python 3.11 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.11 -m venv .venv
            source ./.venv/bin/activate

      .. selected:: os-version=8

         For example, to create and activate a Python 3.11 virtual environment,
         run the following command:

         .. code-block:: bash

            python3.11 -m venv .venv
            source ./.venv/bin/activate

   .. selected:: os=sles

      For example, to create and activate a Python 3.11 virtual environment,
      run the following command:

      .. code-block:: bash

         python3.11 -m venv .venv
         source ./.venv/bin/activate

   .. selected:: os=windows

      For example, to create and activate a Python 3.12 virtual environment,
      run the following command:

      .. code-block:: bat

         python3.12 -m venv .venv
         .venv\Scripts\activate

.. selected:: i=pip
   :heading: Install ROCm wheel packages
   :heading-level: 4

   .. selected:: gfx=950

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx950`` GPU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx950-dcgpu/ "rocm[libraries,devel]"

   .. selected:: gfx=942

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx942`` device.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx94X-dcgpu/ "rocm[libraries,devel]"

   .. selected:: gfx=90a

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx90a`` GPU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx90X-dcgpu/ "rocm[libraries,devel]"

   .. selected:: gfx=1100

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx1100`` GPU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx110X-dgpu/ "rocm[libraries,devel]"

   .. selected:: gfx=1101

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx1101`` GPU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx110X-dgpu/ "rocm[libraries,devel]"

   .. selected:: gfx=1150

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx1150`` GPU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1150/ "rocm[libraries,devel]"

   .. selected:: gfx=1151

      Use pip to install the ROCm Core SDK libraries and development tools for
      your ``gfx1151`` GPU.

      Run the following command:

      .. code-block:: bash

         python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx1151/ "rocm[libraries,devel]"

.. selected:: i=tar
   :heading: Create the installation directory
   :heading-level: 4

   .. selected:: os=ubuntu os=rhel os=sles

      Run the following command in your desired location to create your
      installation directory:

      .. code-block:: bash

         mkdir therock-tarball && cd therock-tarball

      .. important::

         Subsequent commands assume you're working with the ``therock-tarball``
         directory. If you choose a different directory name, adjust the
         commands accordingly.


   .. selected:: os=windows

      Create the installation directory in ``C:\TheRock\build``.

      .. important::

         Subsequent commands assume you're working with the
         ``C:\TheRock\build`` directory. If you choose a different directory
         name, adjust the commands accordingly.

.. selected:: i=tar
   :heading: Download and unpack the tarball
   :heading-level: 4

   .. selected:: os=ubuntu os=rhel os=sles

      .. selected:: gfx=950

         Use the following commands to download and untar the ROCm tarball for
         your ``gfx950`` GPU.

         Run the following command:

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx950-dcgpu-7.10.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gfx=942

         Use the following commands to download and untar the ROCm tarball for
         your ``gfx942`` GPU.

         Run the following command:

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx94X-dcgpu-7.10.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gfx=90a

         Use the following commands to download and untar the ROCm tarball for
         your ``gfx90a`` GPU.

         Run the following command:

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx90X-dcgpu-7.10.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gfx=1100

         Use the following commands to download and untar the ROCm tarball for
         your ``gfx1100`` GPU.

         Run the following command:

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx110X-dgpu-7.10.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gfx=1101

         Use the following commands to download and untar the ROCm tarball for
         your ``gfx1101`` GPU.

         Run the following command:

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx110X-dgpu-7.10.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gfx=1150

         Use the following commands to download and untar the ROCm tarball for
         your ``gfx1150`` GPU.

         Run the following command:

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx1150-7.10.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

      .. selected:: gfx=1151

         Use the following commands to download and untar the ROCm tarball for
         your ``gfx1151`` GPU.

         Run the following command:

         .. code-block:: bash

            wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx1151-7.10.0.tar.gz
            mkdir install
            tar -xf *.tar.gz -C install

   .. selected:: os=windows

      .. selected:: gfx=1100

         Download the tarball for your ``gfx1100`` GPU and extract the contents
         to ``C:\TheRock\build``.

         - Download link: `therock-dist-windows-gfx110X-dgpu-7.10.0.tar.gz
           <https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx110X-dgpu-7.10.0.tar.gz>`__

      .. selected:: gfx=1101

         Download the tarball for your ``gfx1101`` GPU and extract the contents
         to ``C:\TheRock\build``.

         - Download link: `therock-dist-windows-gfx110X-dgpu-7.10.0.tar.gz
           <https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx110X-dgpu-7.10.0.tar.gz>`__

      .. selected:: gfx=1150

         Download the tarball for your ``gfx1150`` GPU and extract the contents
         to ``C:\TheRock\build``.

         - Download link: `therock-dist-windows-gfx1150-7.10.0.tar.gz
           <https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx1150-7.10.0.tar.gz>`__

      .. selected:: gfx=1151

         Download the tarball for your ``gfx1151`` GPU and extract the contents
         to ``C:\TheRock\build``.

         - Download link: `therock-dist-windows-gfx1151-7.10.0.tar.gz
           <https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx1151-7.10.0.tar.gz>`__
