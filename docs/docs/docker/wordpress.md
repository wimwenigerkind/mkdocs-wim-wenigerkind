```yaml title="docker-compose.yaml" linenums="1"
services:
    wordpress:
        image: wordpress:php8.1-apache
        container_name: wordpress
        ports:
            - "80:80"
        environment:
            WORDPRESS_DB_HOST: db
            WORDPRESS_DB_USER: wp_user
            WORDPRESS_DB_PASSWORD: wp_pass
            WORDPRESS_DB_NAME: wp_database
        volumes:
            - wp_data:/var/www/html
        networks:
            - wordpress_network
        depends_on:
            - db
    db:
        image: mysql:5.7
        container_name: wordpress_db
        environment:
            MYSQL_DATABASE: wp_database
            MYSQL_USER: wp_user
            MYSQL_PASSWORD: wp_pass
            MYSQL_ROOT_PASSWORD: root_pass
        volumes:
            - db_data:/var/lib/mysql
        networks:
            - wordpress_network
networks:
    wordpress_network:
        driver: bridge
volumes:
    wp_data:
    db_data:
```
