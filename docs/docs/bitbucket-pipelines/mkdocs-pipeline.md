## MkDocs installed with pip

```yaml title="bitbucket-pipelines.yml" linenums="1"
image: atlassian/default-image:3
pipelines:
    tags:
        release/*:
            -   step:
                    name: 'Build and Test'
                    runs-on:
                        - 'self.hosted'
                        - 'linux'
                        - 'workspace'
                    script:
                        - apt-get update && apt-get install -y sshpass rsync openssh-client
                        - sshpass -p "${SSH_PASSWORD}" rsync -avzc --update -e "ssh -o StrictHostKeyChecking=no" docs/ ${SSH_USER}@${SSH_SERVER}:${SSH_DIRECTORY}
```

## MkDocs installed with Docker

```yaml title="bitbucket-pipelines.yml" linenums="1"
COMMING SOON
```