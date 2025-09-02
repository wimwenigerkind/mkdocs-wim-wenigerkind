```yaml title="docker-compose.yaml" linenums="1"
services:
    mailpit:
        image: axllent/mailpit
        container_name: mailpit
        restart: unless-stopped
        volumes:
            - ./mailpit-data:/data
        environment:
            - MP_DATABASE=/data/mailpit.db
            - TZ=Europe/Berlin
        ports:
            - 8025:8025
            - 1025:1025
```
