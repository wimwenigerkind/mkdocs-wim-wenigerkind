```yaml title="docker-compose.yaml" linenums="1"
services:
    faster-whisper:
        image: lscr.io/linuxserver/faster-whisper:latest
        container_name: faster-whisper
        environment:
            - PUID=1000
            - PGID=1000
            - TZ=Etc/UTC
            - WHISPER_MODEL=tiny-int8
            - WHISPER_BEAM=1 #optional
            - WHISPER_LANG=en #optional
        volumes:
            - ./config:/config
        ports:
            - 10300:10300
        restart: unless-stopped
```
