# Keycloak Docker Compose

## Docker Compose script
```yaml
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

    keycloak-node1:
        image: quay.io/keycloak/keycloak:26.0.0
        environment:
            - DB_VENDOR=postgres
            - DB_ADDR=postgres
            - DB_DATABASE=keycloak
            - DB_USER=keycloak
            - DB_PASSWORD=supersecurepassword
            - KEYCLOAK_ADMIN=admin
            - KEYCLOAK_ADMIN_PASSWORD=supersecurepassword
            - KC_HOSTNAME=https://keycloak.example.com
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

networks:
    keycloak-network:
        driver: bridge
    bridge:
```

[Help run the script](/docker-compose/#run-docker-compose)