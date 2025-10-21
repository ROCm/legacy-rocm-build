1. Verify the ROCm installation.

   ```bash
   hipinfo
   ```

   ```{eval-rst}
   .. dropdown:: Example output of ``hipinfo``

      .. code-block:: shell-session

         --------------------------------------------------------------------------------
         device#                           0
         Name:                             AMD Radeon(TM) 8060S Graphics
         pciBusID:                         197
         pciDeviceID:                      0
         pciDomainID:                      0
         multiProcessorCount:              20

         [output truncated]
   ```

2. Inspect your ROCm installation in your Python environment.

   ```bash
   pip freeze
   where rocm-sdk
   dir .venv\Scripts
   ```

3. Test your ROCm installation.

   ```bash
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
