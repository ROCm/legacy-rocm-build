Post-installation
=================

.. dropdown:: Installation environment
   :animate: fade-in-slide-down
   :icon: desktop-download
   :chevron: down-up

   .. include:: ./includes/selector.rst

After installing the ROCm Core SDK |ROCM_VERSION|, complete these
post-installation steps to complete your system configuration and validate the
installation.

.. selected:: i=tar

   .. selected:: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles
      :heading: Configure your environment
      :heading-level: 3

      Configure environment variables so that ROCm libraries and tools are
      available either to all users on the system or only to your user account.

      .. _rocm-post-install-system-wide:

      .. tab-set::

         .. tab-item:: System-wide setup

            Create a profile script so that all users inherit the ROCm
            environment variables when they start a shell session. Make sure
            you're in the ``therock-tarball`` directory before proceeding.

            .. code-block:: bash

               # Configure ROCm PATH. Make sure you're in the therock-tarball directory before proceeding.
               ROCM_INSTALL_PATH=$(pwd)/install
               sudo tee /etc/profile.d/set-rocm-env.sh << EOF
               export ROCM_PATH=$ROCM_INSTALL_PATH
               export PATH=\$PATH:\$ROCM_PATH/bin
               export LD_LIBRARY_PATH=\$ROCM_PATH/lib:\$ROCM_PATH/llvm/lib:\$ROCM_PATH/lib/rocprofiler-systems
               EOF
               sudo chmod +x /etc/profile.d/set-rocm-env.sh
               source /etc/profile.d/set-rocm-env.sh

         .. tab-item:: User setup

            Configure the ROCm environment for your user by updating your shell
            configuration file.

            1. Add the following to your shell configuration file
               (``~/.bashrc``, ``~/.profile``). Make sure you're in the
               ``therock-tarball`` directory before proceeding.

               .. code-block:: bash

                  # Configure ROCm PATH. Make sure you're in the therock-tarball directory before proceeding.
                  export ROCM_PATH=$PWD/install
                  export PATH=$PATH:$ROCM_PATH/bin
                  export LD_LIBRARY_PATH=$ROCM_PATH/lib:$ROCM_PATH/llvm/lib:$ROCM_PATH/lib/rocprofiler-systems

            2. After modifying your shell configuration, apply the change to
               your current session by sourcing your updated shell
               configuration file.

               .. tab-set::

                  .. tab-item:: .bashrc

                     .. code-block:: bash

                        source ~/.bashrc

                  .. tab-item:: .profile

                     .. code-block:: bash

                        source ~/.profile

   .. selected:: os=windows
      :heading: Configure your environment
      :heading-level: 3

      Configure environment variables so that ROCm libraries and tools are
      available on your Windows system.

      1. **Run command prompt as an administrator** and set the following environment variables.

         .. code-block:: cmd

            setx HIP_DEVICE_LIB_PATH “C:\TheRock\build\lib\llvm\amdgcn\bitcode” /M
            setx HIP_PATH “C:\TheRock\build” /M
            setx HIP_PLATFORM “amd” /M
            setx LLVM_PATH “C:\TheRock\build\lib\llvm” /M

      2. Add the following paths into the PATH environment variable.

         .. code-block:: cmd

            setx PATH "%PATH%;C:\TheRock\build\bin" /M
            setx PATH "%PATH%;C:\TheRock\build\lib\llvm\bin" /M

      3. Open a new command prompt window for the environment variables to take effect. Run ``set``
         to see the list of active variables.

         .. code-block:: bat

            set

.. selected:: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles
   :heading: Verify your installation
   :heading-level: 3

   Use the following ROCm tools to verify that the ROCm Core SDK is correctly
   installed and that your AMD devices are visible to the system.

   1. Use ``rocminfo`` to list detected AMD GPUs and confirm that the ROCm
      runtimes and drivers are correctly installed and loaded.

      .. code-block:: bash

         rocminfo

      .. dropdown:: Example output of ``rocminfo``
         :animate: fade-in-slide-down
         :color: success
         :icon: note
         :chevron: down-up

         .. code-block:: shell-session

            ROCk module version 6.18.4 is loaded
            =====================
            HSA System Attributes
            =====================
            Runtime Version:         1.18
            Runtime Ext Version:     1.14
            System Timestamp Freq.:  1000.000000MHz
            Sig. Max Wait Duration:  18446744073709551615 (0xFFFFFFFFFFFFFFFF) (timestamp count)
            Machine Model:           LARGE
            System Endianness:       LITTLE
            Mwaitx:                  DISABLED
            XNACK enabled:           NO
            DMAbuf Support:          YES
            VMM Support:             YES

            ==========
            HSA Agents
            ==========
            *******
            Agent 1
            *******
              Name:                    AMD RYZEN AI MAX+ PRO 395 w/ Radeon 8060S
              Uuid:                    CPU-XX
              Marketing Name:          AMD RYZEN AI MAX+ PRO 395 w/ Radeon 8060S
              Vendor Name:             CPU

            ... [output truncated]

   2. Use the AMD SMI CLI ``amd-smi`` to validate system information.

      .. code-block:: bash

         amd-smi version

      .. dropdown:: Example output of ``amd-smi version``
         :animate: fade-in-slide-down
         :color: success
         :icon: note
         :chevron: down-up

         .. code-block:: shell-session

            AMDSMI Tool: 26.2.1+7b886380f9 | AMDSMI Library version: 26.2.1 | ROCm version: 7.11.0 | amdgpu version: 6.18.4 | hsmp version: N/A

   .. selected:: i=pip

      3. Inspect your installation in your Python environment and confirm that
         ROCm packages, including the ``rocm-sdk`` CLI, are available.

         .. code-block:: bash

            pip freeze | grep rocm
            which rocm-sdk
            ls .venv/bin

.. selected:: os=windows
   :heading: Verify your installation
   :heading-level: 3

   Use the following ROCm tools to verify that the ROCm Core SDK is correctly
   installed and that your AMD devices are visible to the system.

   .. selected:: i=pip

      1. Use ``hipinfo`` to list detected AMD GPUs and confirm that the ROCm
         runtimes and drivers are correctly installed and loaded.

         .. code-block:: bash

            hipinfo

         .. dropdown:: Example output of ``hipinfo``
            :animate: fade-in-slide-down
            :color: success
            :icon: note
            :chevron: down-up

            .. code-block:: shell-session

               --------------------------------------------------------------------------------
               device#                           0
               Name:                             AMD Radeon(TM) 8060S Graphics
               pciBusID:                         197
               pciDeviceID:                      0
               pciDomainID:                      0
               multiProcessorCount:              20

               ... [output truncated]

      2. Inspect your installation in your Python environment and confirm that
         ROCm packages, including the ``rocm-sdk`` CLI, are available.

         .. code-block:: bash

            pip freeze
            where rocm-sdk
            dir .venv\Scripts

   .. selected:: i=tar

      Use ``hipinfo`` to list detected AMD GPUs and confirm that the ROCm
      runtimes and drivers are correctly installed and loaded.

      .. code-block:: bash

         hipinfo

      .. dropdown:: Example output of ``hipinfo``
         :animate: fade-in-slide-down
         :color: success
         :icon: note
         :chevron: down-up

         .. code-block:: shell-session

            --------------------------------------------------------------------------------
            device#                           0
            Name:                             AMD Radeon(TM) 8060S Graphics
            pciBusID:                         197
            pciDeviceID:                      0
            pciDomainID:                      0
            multiProcessorCount:              20

            ... [output truncated]

.. selected:: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

   .. selected:: i=pip
      :heading: Test your installation
      :heading-level: 3

      Run the following commands from your Python virtual environment to confirm
      that the ROCm SDK is correctly configured and that basic checks complete
      successfully.

      .. code-block:: bash

         rocm-sdk targets
         rocm-sdk path --cmake
         rocm-sdk path --bin
         rocm-sdk path --root
         rocm-sdk test

      To learn more about the ``rocm-sdk`` tool and to see example expected
      outputs, see `Using ROCm Python packages (TheRock)
      <https://github.com/ROCm/TheRock/blob/main/RELEASES.md#using-rocm-python-packages>`__.

   .. selected:: i=tar
      :heading: Test your installation
      :heading-level: 3

      Run the ``test_hip_api`` tool to verify that the HIP runtime can access
      your GPU and execute a simple workload.

      .. code-block:: bash

         test_hip_api

.. selected:: os=windows

   .. selected:: i=pip
      :heading: Test your installation
      :heading-level: 3

      Run the following commands from your Python virtual environment to confirm
      that the ROCm SDK is correctly configured and that basic checks complete
      successfully.

      .. code-block:: bash

         rocm-sdk test

      To learn more about the ``rocm-sdk`` tool and to see example expected
      outputs, see `Using ROCm Python packages (TheRock)
      <https://github.com/ROCm/TheRock/blob/main/RELEASES.md#using-rocm-python-packages>`__.

.. selected:: i=pip

   .. tip::

      If you need to deactivate your Python virtual environment when finished, run:

      .. code-block:: bash

         deactivate

