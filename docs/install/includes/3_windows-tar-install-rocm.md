```{important}
- Do not copy/replace the ROCm-SDK compiler and runtime DLLs to
`System32` as this can cause conflicts.

- Disable the following Windows security features as they
  can interfere with ROCm functionality:

  - Turn off WDAG (Windows Defender Application Guard)
    - Control Panel > Programs > Programs and Features > Turn Windows features on or off > **Deselect** "Microsoft Defender Application Guard"
  - Turn off SAC (Smart App Control)
    - Settings > Privacy & security > Windows Security > App & browser control > Smart App Control settings > **Off**
```

1. Create the installation directory in `C:\TheRock\build`.

   ```{note}
   Subsequent commands assume you're working with the
   `C:\TheRock\build` directory.
   ```

2. Download the tarball and extract the contents to
   `C:\TheRock\build`.

   - Download link: [https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx1151-7.9.0rc1.tar.gz](https://repo.amd.com/rocm/tarball/therock-dist-windows-gfx1151-7.9.0rc1.tar.gz)

3. Set the following environment variables using the command
   prompt as an administrator:

   ```bat
   setx HIP_DEVICE_LIB_PATH “C:\TheRock\build\lib\llvm\amdgcn\bitcode” /M
   setx HIP_PATH “C:\TheRock\build” /M
   setx HIP_PLATFORM “amd” /M
   setx LLVM_PATH “C:\TheRock\build\lib\llvm” /M
   ```

4. Add the following paths into PATH environment variable using your system settings GUI.

   - `C:\TheRock\build\bin`

   - `C:\TheRock\build\lib\llvm\bin`

5. Open a new command prompt window for the environment variables to take effect. Run `set`
   to see the list of active variables.

   ```bat
   set
   ````
