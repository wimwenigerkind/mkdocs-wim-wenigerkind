[Portainer](https://docs.portainer.io/start/install-ce/server/docker/linux) installation on Docker

## Install Portainer

### Create Volume

    docker volume create portainer_data

### Run Installation Script

    docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
    