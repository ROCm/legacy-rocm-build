1. Register your Enterprise Linux.

   ```bash
   subscription-manager register --username <username> --password <password>
   ```

2. Update your Enterprise Linux.

   ```bash
   sudo dnf update --releasever=10.0 --exclude=\*release\*
   ```

3. Install Python 3.12 or 3.13.

   ```bash
   sudo dnf install python3.12 python3.12-pip
   ```

4. Configure permissions for GPU access.

   ```bash
   sudo usermod -a -G render,video $LOGNAME # Add the current user to the render and video groups
   ```

   ```{note}
   To apply all settings, reboot your system.
   ```
