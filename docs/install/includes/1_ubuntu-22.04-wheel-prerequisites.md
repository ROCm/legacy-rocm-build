1. Install Python 3.11.

   ```bash
   sudo apt install python3.11 python3.11-venv
   ```

2. Configure permissions for GPU access.

   ```bash
   sudo usermod -a -G render,video $LOGNAME # Add the current user to the render and video groups
   ```

   ```{note}
   To apply all settings, reboot your system.
   ```
