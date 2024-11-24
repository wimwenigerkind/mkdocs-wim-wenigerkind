# Keycloak Docker Compose

```yaml title="docker-compose.yaml" linenums="1"
services:
    postgres:
        image: postgres:14
        environment:
            - POSTGRES_DB=keycloak
            - POSTGRES_USER=keycloak
            - POSTGRES_PASSWORD=supersecurepassword
        volumes:
            - ./postgres_data:/var/lib/postgresql/data
        networks:
            - keycloak-network
    keycloak:
        image: quay.io/keycloak/keycloak:26.0.0
        environment:
            - DB_VENDOR=postgres
            - DB_ADDR=postgres
            - DB_DATABASE=keycloak
            - DB_USER=keycloak
            - DB_PASSWORD=supersecurepassword
            - KEYCLOAK_ADMIN=admin
            - KEYCLOAK_ADMIN_PASSWORD=noaccess
            - KC_HOSTNAME=https://sso.wimwenigerkind.com
            #- KC_HOSTNAME=localhost
            - KC_PROXY=edge
        ports:
            - "8888:8080"
        networks:
            - keycloak-network
        volumes:
            - ./keycloak_data:/opt/keycloak/data
            - ./keycloak_themes:/opt/keycloak/themes
        command:
            - start
            #- --optimized
networks:
    keycloak-network:
        driver: bridge
```

[Help run the script](/docker/docker-compose/#run-docker-compose)