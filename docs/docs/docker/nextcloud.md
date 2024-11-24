```yaml title="docker-compose.yaml" linenums="1"
services:
    db:
        image: mariadb:10.6
        restart: always
        environment:
            MYSQL_ROOT_PASSWORD: example_root_password
            MYSQL_DATABASE: nextcloud
            MYSQL_USER: nextcloud_user
            MYSQL_PASSWORD: example_password
        volumes:
            - db:/var/lib/mysql
    app:
        image: nextcloud:apache
        restart: always
        ports:
            - :80
        volumes:
            - nextcloud:/var/www/html
            - apps:/var/www/html/custom_apps
            - config:/var/www/html/config
            - data:/var/www/html/data
        environment:
            MYSQL_HOST: db
            MYSQL_DATABASE: nextcloud
            MYSQL_USER: nextcloud_user
            MYSQL_PASSWORD: example_password
            NEXTCLOUD_ADMIN_USER: admin
            NEXTCLOUD_ADMIN_PASSWORD: admin_password
volumes:
    nextcloud:
    db:
    apps:
    config:
    data:
```
