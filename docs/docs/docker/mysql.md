``` yaml title="docker-compose.yaml" linenums="1"
services:
    mysql:
        image: mysql:lastest # (1)
        container_name: mysql-container
        environment:
            MYSQL_ROOT_PASSWORD: supersecurepassword
        ports:
            - "3309:3306"
        volumes:
            - ./mysql_data:/var/lib/mysql
```