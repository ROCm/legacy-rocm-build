Post-installation
=================

After installing ROCm |ROCM_VERSION|, complete these post-installation steps to
complete your system configuration and validate the installation.

.. _rocm-post-install-env:

.. selected:: w=compute

   .. selected:: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      .. selected:: i=tar
         :heading: Configure your environment
         :heading-level: 3

         Configure environment variables so that ROCm libraries and tools are
         available either to all users on the system or only to your user account.

         .. tab-set::

            .. tab-item:: System-wide setup
               :sync: env-system-setup

               Create a profile script so that all users inherit the ROCm
               environment variables when they start a shell session. Make sure
               you're in the ``therock-tarball`` directory before proceeding.

               .. code-block:: bash

                  # Configure ROCm PATH. Make sure you're in the therock-tarball directory before proceeding.
                  ROCM_INSTALL_PATH=$(pwd)/install
                  sudo tee /etc/profile.d/set-rocm-env.sh << EOF
                  export ROCM_PATH=$ROCM_INSTALL_PATH
                  export PATH=\$PATH:\$ROCM_PATH/bin
                  export LD_LIBRARY_PATH=\$ROCM_PATH/lib
                  EOF
                  sudo chmod +x /etc/profile.d/set-rocm-env.sh
                  source /etc/profile.d/set-rocm-env.sh

            .. tab-item:: User setup
               :sync: env-user-setup

               Configure the ROCm environment for your user by updating your shell
               startup configuration file.

               Use the following commands to update your shell configuration file
               (``~/.bashrc`` or ``~/.profile``) and add ROCm to your PATH. Before proceeding, make sure you're in the
               ``therock-tarball`` directory so the install path resolves correctly.

               .. tab-set::

                  .. tab-item:: .bashrc
                     :sync: bashrc

                     .. code-block:: bash

                        # Configure ROCm PATH. Make sure you're in the therock-tarball directory before proceeding.
                        ROCM_INSTALL_PATH=$(pwd)/install
                        tee --append ~/.bashrc << EOF

                        # BEGIN ROCm environment configuration
                        export ROCM_PATH=$ROCM_INSTALL_PATH
                        export PATH=\$PATH:\$ROCM_PATH/bin
                        export LD_LIBRARY_PATH=\$ROCM_PATH/lib
                        # END ROCm environment configuration
                        EOF
                        source ~/.bashrc

                  .. tab-item:: .profile
                     :sync: profile

                     .. code-block:: bash

                        # Configure ROCm PATH. Make sure you're in the therock-tarball directory before proceeding.
                        ROCM_INSTALL_PATH=$(pwd)/install
                        tee --append ~/.profile << EOF

                        # BEGIN ROCm environment configuration
                        export ROCM_PATH=$ROCM_INSTALL_PATH
                        export PATH=\$PATH:\$ROCM_PATH/bin
                        export LD_LIBRARY_PATH=\$ROCM_PATH/lib
                        # END ROCm environment configuration
                        EOF
                        source ~/.profile

.. selected:: os=windows

   .. selected:: i=tar
      :heading: Configure your environment
      :heading-level: 3

      Configure environment variables so that ROCm libraries and tools are
      available on your Windows system.

      1. **Run command prompt as an administrator** and set the following environment variables.

         .. code-block:: bat

            setx HIP_DEVICE_LIB_PATH "C:\TheRock\build\lib\llvm\amdgcn\bitcode" /M
            setx HIP_PATH "C:\TheRock\build" /M
            setx HIP_PLATFORM "amd" /M
            setx LLVM_PATH "C:\TheRock\build\lib\llvm" /M

      2. Add the following paths into the PATH environment variable.

         .. code-block:: bat

            setx PATH "%PATH%;C:\TheRock\build\bin;C:\TheRock\build\lib\llvm\bin" /M

      3. Open a new command prompt window for the environment variables to take effect. Run ``set``
         to see the list of active variables.

         .. code-block:: bat

            set

.. selected:: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles
   :heading: Verify your installation
   :heading-level: 3

   Use the following ROCm tools to verify that ROCm is correctly
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

            ROCk module version 6.16.6 is loaded
            =====================
            HSA System Attributes
            =====================
            Runtime Version:         1.21
            Runtime Ext Version:     1.21
            System Timestamp Freq.:  1000.000000MHz
            Sig. Max Wait Duration:  18446744073709551615 (0xFFFFFFFFFFFFFFFF) (timestamp count)
            Machine Model:           LARGE
            System Endianness:       LITTLE
            Mwaitx:                  ENABLED
            XNACK enabled:           NO
            DMAbuf Support:          YES
            VMM Support:             YES

            ==========
            HSA Agents
            ==========
            *******
            Agent 1
            *******
              Name:                    gfx950
              Uuid:                    GPU-5b920922d0067ea9
              Marketing Name:          AMD Instinct MI350X
              Vendor Name:             AMD

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

            AMDSMI Tool: 26.5.0+2b22ab01 | AMDSMI Library version: 26.5.0 | ROCm version: 7.14.0 | amdgpu version: 6.19.14.31400000 | ionic version: N/A

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

   Use the following ROCm tools to verify that ROCm is correctly
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

.. selected:: os=wsl
   :heading: Verify your installation
   :heading-level: 3

   Use ``rocminfo`` to verify that ROCm is correctly
   installed and that your AMD devices are visible to the system.

   .. code-block:: bash

      rocminfo

   .. dropdown:: Example output of ``rocminfo``
      :animate: fade-in-slide-down
      :color: success
      :icon: note
      :chevron: down-up

      .. code-block:: shell-session

         WSL2 environment detected.
         =====================
         HSA System Attributes
         =====================
         Runtime Version:         1.21
         Runtime Ext Version:     1.21
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
           Name:                    AMD RYZEN AI MAX+ 395 w/ Radeon 8060S
           Uuid:                    CPU-XX
           Marketing Name:          AMD RYZEN AI MAX+ 395 w/ Radeon 8060S
           Vendor Name:             CPU
           Feature:                 None specified
           Profile:                 FULL_PROFILE
           Float Round Mode:        NEAR
           Max Queue Number:        0(0x0)
           Queue Min Size:          0(0x0)
           Queue Max Size:          0(0x0)
           Queue Type:              MULTI
           Node:                    0
           Device Type:             CPU
           Cache Info:
             L1:                      49152(0xc000) KB
           Chip ID:                 0(0x0)
           Cacheline Size:          64(0x40)
           BDFID:                   0
           Internal Node ID:        0
           Compute Unit:            32
           SIMDs per CU:            0
           Shader Engines:          0
           Shader Arrs. per Eng.:   0
           Memory Properties:
           Features:                None
           Pool Info:
             Pool 1
               Segment:                 GLOBAL; FLAGS: FINE GRAINED
               Size:                    14123020(0xd7800c) KB
               Allocatable:             TRUE
               Alloc Granule:           4KB
               Alloc Recommended Granule:4KB
               Alloc Alignment:         4KB
               Accessible by all:       TRUE
             Pool 2
               Segment:                 GLOBAL; FLAGS: EXTENDED FINE GRAINED
               Size:                    14123020(0xd7800c) KB
               Allocatable:             TRUE
               Alloc Granule:           4KB
               Alloc Recommended Granule:4KB
               Alloc Alignment:         4KB
               Accessible by all:       TRUE
             Pool 3
               Segment:                 GLOBAL; FLAGS: KERNARG, FINE GRAINED
               Size:                    14123020(0xd7800c) KB
               Allocatable:             TRUE
               Alloc Granule:           4KB
               Alloc Recommended Granule:4KB
               Alloc Alignment:         4KB
               Accessible by all:       TRUE
             Pool 4
               Segment:                 GLOBAL; FLAGS: COARSE GRAINED
               Size:                    14123020(0xd7800c) KB
               Allocatable:             TRUE
               Alloc Granule:           4KB
               Alloc Recommended Granule:4KB
               Alloc Alignment:         4KB
               Accessible by all:       TRUE
           ISA Info:
         *******
         Agent 2
         *******
           Name:                    gfx1151
           Uuid:                    GPU-ffffffffffffffff
           Marketing Name:          AMD Radeon(TM) 8060S Graphics
           Vendor Name:             AMD

         ... [output truncated]

.. selected:: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

   .. selected:: i=pip
      :heading: Configure your environment
      :heading-level: 3

      .. note::

         Follow this step only if you installed the ``devel`` package.

      Initialize the ROCm SDK.

      .. code-block:: bash

         rocm-sdk init

   .. selected:: i=pip
      :heading: Test your installation
      :heading-level: 3

      Run the following commands from your Python virtual environment to confirm
      that the ROCm SDK is correctly configured and that basic checks complete
      successfully.

      .. code-block:: bash

         rocm-sdk targets
         rocm-sdk test

      To learn more about the ``rocm-sdk`` tool and to see example
      outputs, see `Using ROCm Python packages (TheRock)
      <https://github.com/ROCm/TheRock/blob/main/RELEASES.md#using-rocm-python-packages>`__.


.. selected:: os=windows

   .. selected:: i=pip
      :heading: Test your installation
      :heading-level: 3

      Run the following commands from your Python virtual environment to confirm
      that the ROCm SDK is correctly configured and that basic checks complete
      successfully.

      .. code-block:: bash

         rocm-sdk test

      To learn more about the ``rocm-sdk`` tool and to see example
      outputs, see `Using ROCm Python packages (TheRock)
      <https://github.com/ROCm/TheRock/blob/main/RELEASES.md#using-rocm-python-packages>`__.

.. selected:: i=pip

   .. tip::

      If you need to deactivate your Python virtual environment when finished, run:

      .. code-block:: bash

         deactivate

.. seealso::

   .. selected:: fam=all fam=instinct

      To install deep learning frameworks, including `PyTorch
      <https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/frameworks/pytorch/install.html>`__
      and `JAX
      <https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/frameworks/jax/install.html>`__,
      and get started with AI training and inference, see the `AI Ecosystem
      <https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/>`__
      documentation portal.

   .. selected:: fam=radeon fam=ryzen

      To install deep learning frameworks, including `PyTorch
      <https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/frameworks/pytorch/install.html>`__,
      and get started with AI training and inference, see the `AI Ecosystem
      <https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/>`__
      documentation portal.

   .. selected:: fam=all fam=instinct

      To learn about HPC libraries and applications, see
      :doc:`ROCm HPC SDK </components/hpc-sdk/index>`.

   .. selected:: fam=all fam=instinct fam=radeon

      To learn about ROCm Extras, which include supplementary tools for
      benchmarking and validating, see :doc:`ROCm Extras </components/extras>`.
