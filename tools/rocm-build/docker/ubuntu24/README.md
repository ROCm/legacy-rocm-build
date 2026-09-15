# Steps to build the Docker Image

1. Clone this repository.

   ```bash
   git clone https://github.com/ROCm/ROCm.git
   ```

2. Go into the Ubuntu 24.04 Docker directory.

    ```bash
    cd ROCm/tools/rocm-build/docker/ubuntu24
    ```

3. Build the Docker image

    ```bash
    docker build -t <docker image name> .
    ```

    Replace the `<docker image name>` with a new Docker image name of your choice.

4. After successful build, check that your \<docker image name\> exist in the list of available Docker images.

    ```bash
    docker images
    ```
