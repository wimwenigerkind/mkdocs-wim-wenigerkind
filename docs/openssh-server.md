Install OpenSSH-Server on Linux with root password access.

## Install OpenSSH-Server

    sudo apt update && apt upgrade -y
    sudo apt install openssh-server

## Configure the SSH config to allow root password access

    nano /etc/ssh/sshd_config

Change PermitRootLogin to yes

    PermitRootLogin yes

Restart the SSH service
    
    service ssh restart