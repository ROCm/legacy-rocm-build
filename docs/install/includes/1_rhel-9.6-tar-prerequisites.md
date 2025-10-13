1. Register your Enterprise Linux.

   ```bash
   subscription-manager register --username <username> --password <password>
   sudo subscription-manager attach --auto
   ```

2. Update your Enterprise Linux.

   ```bash
   sudo dnf update --releasever=9.6 --exclude=\*release\*
   ```

3. Configure permissions for GPU access.

   ```bash
   sudo usermod -a -G render,video $LOGNAME # Add the current user to the render and video groups
   ```

   ```{note}
   To apply all settings, reboot your system.
   ```
