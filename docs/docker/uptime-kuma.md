[Uptime Kuma](https://uptime.kuma.pet/) installation on Docker

## Install Uptime Kuma

    docker run -d --restart=always -p 3001:3001 -v uptime-kuma:/app/data --name uptime-kuma louislam/uptime-kuma:1
