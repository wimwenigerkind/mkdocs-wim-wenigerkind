    mkdir /homepage
	cd /homepage

## docker-compose.yaml

    nano docker-compose.yaml


```yaml
version: "3.3"
services:
  homepage:
    image: ghcr.io/gethomepage/homepage:latest
    container_name: homepage
    restart: unless-stopped
    ports:
      - 3000:3000
    env_file: .env
    volumes:
      - ./config:/app/config # Make sure your local config directory exists
      # - /var/run/docker.sock:/var/run/docker.sock # (optional) For docker integrations, see alternative methods
    environment:
      PUID: $PUID
      PGID: $PGID
``` 
## create .env

	touch .env

PUID and PGID

	id

edit the .env file to add the PUID and PGID

	nano .env

add the PUID and PGID to .env file

	PUID=0
	PGID=0
	
