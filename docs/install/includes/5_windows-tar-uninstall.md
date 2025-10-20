1. Delete the `C:\TheRock\build` and its contents.

2. Delete the environment variables. For example, using PowerShell as an administrator:

   ```powershell
   [Environment]::SetEnvironmentVariable("HIP_PATH", $null, "Machine")
   [Environment]::SetEnvironmentVariable("HIP_DEVICE_LIB_PATH", $null, "Machine")
   [Environment]::SetEnvironmentVariable("HIP_PLATFORM", $null, "Machine")
   [Environment]::SetEnvironmentVariable("LLVM_PATH", $null, "Machine")
   ```

3. Remove the following paths from your PATH environment variable using your system settings GUI.

   - `C:\TheRock\build\bin`

   - `C:\TheRock\build\lib\llvm\bin`

4. If you want to uninstall the Adrenalin driver, see [Uninstall AMD Software](https://www.amd.com/en/resources/support-articles/faqs/RSX2-UNINSTALL.html).
