## Debian LXC container Proxmox
- Debian lxc container in Proxmox 1 CPU and 0.512GB ram

## Install piHole on Debian
```
sudo apt update && sudo apt upgrade -y
```
```
sudo wget -O basic-install.sh https://install.pi-hole.net
sudo bash basic-install.sh
```

## Setup
Follow the instructions in the vnc.

## Change password
```
pihole -a -p
```
