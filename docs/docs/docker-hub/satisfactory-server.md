# Satisfactory Server Docker

This is a Docker image for running a Satisfactory server. It is based on the official steamcmd `cm2network/steamcmd:latest` Docker image and includes the necessary dependencies to run a Satisfactory server.

```yaml
---
services:
  satisfactory-server:
    image: wimdevgroup/satisfactory:latest
    environment:
      - CPU_MHZ=2500
    ports:
      - "7777:7777/udp"
      - "7777:7777/tcp"
      - "15777:15777/udp"
      - "15000:15000/udp"
    restart: unless-stopped
    volumes:
      - satisfactory-data:/satisfactory
volumes:
  satisfactory-data:
```