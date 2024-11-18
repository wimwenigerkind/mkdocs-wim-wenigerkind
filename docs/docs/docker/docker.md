[Docker](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) Installation on Linux

## Install Docker

### Add Docker's official GPG key

```bash
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

### Add the repository to Apt sources

```bash
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

### Install Latest version of Docker

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## Run a Docker container

To run a Docker container, you can use the following command, replacing `<image_name>` with the name of the image you want to run:

```bash
sudo docker run -d --name <container_name> <image_name>
```

This command will pull the Docker image if not already present locally, start a container in detached mode, and assign it the given name.

## Create your own Docker Image and Push it to Docker Hub
WIP