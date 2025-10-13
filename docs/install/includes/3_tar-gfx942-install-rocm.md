1. Create the installation directory. For example:

   ```bash
   mkdir therock-tarball && cd therock-tarball
   ```

   ```{note}
   Subsequent commands assume you're working with the
   `therock-tarball` directory.
   If you choose a different directory name, adjust the
   subsequent commands accordingly.
   ```

2. Download and unpack the tarball.

   ```bash
   wget https://repo.amd.com/rocm/tarball/therock-dist-linux-gfx94X-dcgpu-7.9.0rc1.tar.gz
   mkdir install
   tar -xf *.tar.gz -C install
   ```
