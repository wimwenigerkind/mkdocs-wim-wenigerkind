# Symfony 7 Pipeline Image

## EN

### Description

A Docker image for a Symfony 7 application with a CI/CD pipeline. This image allows for easy deployment of Symfony 7 applications with a pre-configured CI/CD pipeline.

Base Dockerfile Image: `debian:bullseye-slim`

[Symfony 7 Pipeline Docker Hub Repository](https://hub.docker.com/r/wimdevgroup/symfony-7-pipeline)

### Features

- **PHP**: Pre-installed PHP for running Symfony 7 applications.
- **Composer**: Pre-installed Composer for managing Symfony 7 applications.
- **XDdebug**: Pre-installed Xdebug for debugging Symfony 7 applications.
- **Deployer**: Pre-installed Deployer for deploying Symfony 7 applications.

### PHP

The following PHP configuration is set in the `docker.ini` file:
```ini
upload_max_filesize = 128M
post_max_size = 128M
max_execution_time = 30
memory_limit = 1G
date.timezone = "Europe/Berlin"
```

### Pre-installed Packages

- PHP
- XDdebug
- Deployer
- Composer
- wget
- ca-certificates
- rsync
- ssh
- tar
- build-essential
- gcc
- g++
- jq
- zip
- git
- sudo
- gpg
- gpg-agent
- curl
- unzip
- nano
- msmtp
- xsltproc
