```yaml title="docker-compose.yaml" linenums="1"
services:
    piper:
        image: lscr.io/linuxserver/piper:latest
        container_name: piper
        environment:
            - PUID=1000
            - PGID=1000
            - TZ=Etc/UTC
            - PIPER_VOICE=en_US-lessac-medium
            - PIPER_LENGTH=1.0 #optional
            - PIPER_NOISE=0.667 #optional
            - PIPER_NOISEW=0.333 #optional
            - PIPER_SPEAKER=0 #optional
            - PIPER_PROCS=1 #optional
        volumes:
            - ./config:/config
        ports:
            - 10200:10200
        restart: unless-stopped
```
