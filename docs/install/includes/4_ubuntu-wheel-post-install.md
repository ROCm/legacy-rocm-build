1. Verify the ROCm installation.

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

2. Inspect your ROCm installation in your Python environment.

   ```bash
   pip freeze | grep rocm
   which rocm-sdk
   ls .venv/bin
   ```

3. Test your ROCm installation.

   ```bash
   rocm-sdk targets
   rocm-sdk path --cmake
   rocm-sdk path --bin
   rocm-sdk path --root
   rocm-sdk test
   ```

   To learn more about the `rocm-sdk` tool and to see example expected outputs,
   see [Using ROCm Python packages
   (TheRock)](https://github.com/ROCm/TheRock/blob/main/RELEASES.md#using-rocm-python-packages).

````{tip}
If you need to deactivate your Python virtual environment when finished,
run:

```shell
deactivate
```
````
