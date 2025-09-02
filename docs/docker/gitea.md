```yaml title="docker-compose.yaml" linenums="1"
services:
    gitea:
        image: gitea/gitea:latest
        container_name: gitea
        environment:
            - USER_UID=1000
            - USER_GID=1000
        volumes:
            - ./gitea/git-server:/data
        ports:
            - "3000:3000"
            - "22:22"
        restart: always
    db:
        image: mariadb:latest
        container_name: gitea_db
        environment:
            - MYSQL_ROOT_PASSWORD=gitea_root_password
            - MYSQL_DATABASE=gitea
            - MYSQL_USER=gitea
            - MYSQL_PASSWORD=gitea_password
        volumes:
            - ./gitea/git-server-db:/var/lib/mysql
        restart: always
```
