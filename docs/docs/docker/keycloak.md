# Keycloak Docker Compose

```yaml title="docker-compose.yaml" linenums="1"
services:

  # Postgres
  postgres-prod-01:
    image: postgres:14
    container_name: postgres-prod-01
    environment:
      - POSTGRES_DB=${POSTGRES_DB}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - ./postgres_data:/var/lib/postgresql/data
    networks:
      - keycloak

  # Keycloak
  keycloak-prod-01:
    image: quay.io/keycloak/keycloak:26.2.4
    environment:
      - DB_VENDOR=postgres
      - KC_DB_URL=jdbc:postgresql://postgres-prod-01/${POSTGRES_DB}
      - KC_DB=postgres
      - KC_DB_USERNAME=${POSTGRES_USER}
      - KC_DB_PASSWORD=${POSTGRES_PASSWORD}
      - KC_BOOTSTRAP_ADMIN_USERNAME=${KC_BOOTSTRAP_ADMIN_USERNAME}
      - KC_BOOTSTRAP_ADMIN_PASSWORD=${KC_BOOTSTRAP_ADMIN_PASSWORD}
      - KC_HOSTNAME=${DOMAIN}
      - KC_PROXY_ADDRESS_FORWARDING=true
      #- KC_HOSTNAME_STRICT=false
      #- KC_PROXY=edge
      - KC_HTTP_ENABLED=true
      - KC_HOSTNAME_DEBUG=true
      - KC_PROXY_HEADERS=xforwarded
      #- KC_FEATURES=passkeys,recovery-codes,login,docker,scripts
    ports:
      - "8080:8080"
    networks:
      - keycloak
      - frontend
    volumes:
      - ./keycloak_data:/opt/keycloak/data
      - ./keycloak_themes:/opt/keycloak/themes
      - ./keycloak_providers:/opt/keycloak/providers
    command: ['start']
    labels:
      - traefik.enable=true
      - traefik.http.routers.keycloak_prod.tls=true
      - traefik.http.routers.keycloak_prod.tls.certresolver=cloudflare
      - traefik.http.routers.keycloak_prod.entrypoints=websecure
      - traefik.http.routers.keycloak_prod.rule=Host(`${DOMAIN}`)
      - traefik.http.services.keycloak_prod.loadbalancer.server.port=8080

networks:
  keycloak:
    driver: bridge
  frontend:
    external: true
```

[Help run the script](/docker/docker-compose/#run-docker-compose)