# Steps to build the Docker Image

1. Clone this repository.

   ```bash
   git clone https://github.com/ROCm/rocm-build.git
   ```

2. Go into the OS-specific Docker directory in build-infra.

    ```bash
    cd rocm-build/build/docker/ubuntu22
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
