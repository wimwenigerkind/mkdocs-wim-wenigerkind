# Install MkDocs-Material Linux

## Install MkDocs

### Install Advanced Packaging Tools

    sudo apt update && apt upgrade -y

### Install Python and MkDocs

    sudo apt install python3-pip
    sudo apt install mkdocs

## Install MkDocs-Material

    pip install mkdocs-material

## Create first Site

    mkdocs new SITE_NAME

## Configure MkDocs to use MkDocs-Material

    cd SITE_NAME
    nano mkdocs.yml

mkdocs.yml
````yml
site_name: Docs
theme:
    name: material
````

## Start MkDocs

    mkdocs serve

Start with individual IP

    mkdocs serve -a 0.0.0.0:8000

Access the Site via IP and port 8000

## MkDocs-Material