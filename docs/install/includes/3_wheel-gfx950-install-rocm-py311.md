1. Set up your Python virtual environment.

   ```bash
   python3.11 -m venv .venv
   source .venv/bin/activate
   ```

2. Install ROCm wheels packages.

   ```bash
   python -m pip install --index-url https://repo.amd.com/rocm/whl/gfx950-dcgpu/ "rocm[libraries,devel]"
   ```
