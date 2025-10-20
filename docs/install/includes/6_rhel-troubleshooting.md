Docker images often only include a minimal set of installations, meaning some
essential packages might be missing. When installing ROCm within a Docker
container, you might need to install additional packages for a successful
installation. Use the following commands to install the prerequisite packages.

```bash
dnf install sudo libatomic
```
