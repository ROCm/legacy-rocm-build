1. Configure ROCm PATH. Make sure you're in the `therock-tarball` directory before proceeding.

   ```bash
   export ROCM_PATH=$PWD/install
   export PATH=$PATH:$ROCM_PATH/bin
   ```

2. Configure `LD_LIBRARY_PATH`.

   ```bash
   export LD_LIBRARY_PATH=$ROCM_PATH/lib
   ```

3. Verify the ROCm installation.

   ```bash
   rocminfo
   amd-smi
   ```

   ```{eval-rst}
   .. dropdown:: Example output of ``rocminfo``

      .. code-block:: shell-session

         ROCk module is loaded
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

         [output truncated]
   ```
