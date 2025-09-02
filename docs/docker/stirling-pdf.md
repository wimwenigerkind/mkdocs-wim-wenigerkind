```yaml title="docker-compose.yaml" linenums="1"
services:
    stirling-pdf:
        image: frooodle/s-pdf:latest
        ports:
            - '8080:8080'
        volumes:
            - /docker/stirling_pdf/trainingData:/usr/share/testdata
            - /docker/stirling_pdf/extraConfigs:/configs
            - /docker/stirling_pdf/customFiles:/customFiles/
            - /docker/stirling_pdf/logs:/logs/
        environment:
            - DOCKER_ENABLE_SECURITY=false
            - INSTALL_BOOK_AND_ADVANCED_HTML_OPS=false
            - LANGS=en_GBs
```
