## Wireguard

WireGuard ist ein Open-Source-VPN-Protokoll, das entwickelt wurde, um eine schnellere, einfachere und sicherere VPN-Lösung im Vergleich zu älteren Protokollen wie OpenVPN und IPSec bereitzustellen. Es wurde von Jason A. Donenfeld entwickelt und ist in den Linux-Kernel integriert worden, was seine Integration und Verbreitung erleichtert.

## Docker Hub Images

- [linuxserver/wireguard image](https://hub.docker.com/r/linuxserver/wireguard)
- [ngoduykhanh/wireguard-ui image](https://hub.docker.com/r/ngoduykhanh/wireguard-ui)

## Docker-Compose.yml
```yaml
version: "3"

services:
  wireguard:
    image: linuxserver/wireguard:v1.0.20210914-ls7 #Use this image, latest seems to have issues
    container_name: wireguard
    cap_add:
      - NET_ADMIN
    volumes:
      - ./config:/config
    ports:
      - "5000:5000"
      - "51820:51820/udp"

  wireguard-ui:
    image: ngoduykhanh/wireguard-ui:latest
    container_name: wireguard-ui
    depends_on:
      - wireguard
    cap_add:
      - NET_ADMIN
    network_mode: service:wireguard
    environment:
      - SENDGRID_API_KEY
      - EMAIL_FROM_ADDRESS
      - EMAIL_FROM_NAME
      - SESSION_SECRET
      - WGUI_USERNAME=admin
      - WGUI_PASSWORD=password
      - WG_CONF_TEMPLATE
      - WGUI_MANAGE_START=true
      - WGUI_MANAGE_RESTART=true
    logging:
      driver: json-file
      options:
        max-size: 50m
    volumes:
      - ./db:/app/db
      - ./config:/etc/wireguard
```

