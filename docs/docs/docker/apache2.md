```yaml title="docker-compose.yaml" linenums="1"
services:
    apache:
        image: ubuntu/apache2:latest
        container_name: apache-node-1
        ports:
            - "80:80"
        volumes:
            - ./apache-data:/var/www/html
        restart: unless-stopped
```
