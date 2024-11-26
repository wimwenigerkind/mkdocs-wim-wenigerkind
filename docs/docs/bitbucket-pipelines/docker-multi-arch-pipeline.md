Mit dieser Bitbucket Pipeline kannst du Multi Architektur Docker Images Bauen und im Docker Hub veröffentlichen sowie bei Fehlern und Erfolg Discord Webhook Nachrichten senden. Die Pipeline verwendet die Container Structure Tests, um die Docker Images zu testen. Die Tests werden in einem JUnit-Format ausgegeben und können in Bitbucket Pipelines angezeigt werden.

Für die Pipeline verwende ich mein eigenes Docker Image, welches auch über diese Pipeline gebaut wird. Das Docker Image ist auf Docker Hub verfügbar und kann in der Pipeline verwendet werden.
[wimdevgroup/docker-buildx-pipeline:latest](https://hub.docker.com/r/wimdevgroup/docker-buildx-pipeline)

Die Pipeline benötigt einen Bitbucket Runner, um die Images zu bauen da Bitbucket das bauen von multi architektur Images nicht unterstützt. Daher wird der bau prozess auf einen eigenen Runner/Server ausgelagert.

Die verwendung vom Discord Webhook ist optional und kann entfernt werden. Die Pipeline ohne Discord Webhook werde ich auch zur verfügung stellen.

### Voraussetzungen

- Docker Hub Account
- Bitbucket
- Self Hosted Bitbucket Runner
- Ein System mit Docker und Docker Buildx auf dem der Bitbucket Runner läuft
- Discord Webhook URL

### Schritte

#### 1. Repositroy Forken

[Forke Repository](https://images.wimwenigerkind.com/clone-repository.png)

#### 2. Server einrichten

Docker und Docker Buildx auf dem Server installieren sowie auch den Bitbucket Runner einrichten.

#### 3. Repository vorbereiten

Repository Variablen setzten

Docker Hub Username und Passwort

    DOCKERHUB_USERNAME=your-dockerhub-username
    DOCKERHUB_PASSWORD=your-dockerhub-password

SSH Server, User, Passwort und Pfad

    SSH_USER=your-ssh-user
    SSH_PASSWORD=your-ssh-password
    SSH_HOST=your-ssh-host
    SSH_PATH=your-ssh-path

Discord Webhook URL

    DISCORD_WEBHOOK_URL=your-discord-webhook-url

### Ordnerstruktur des Repositorys

```plaintext
.
├── README.md
├── bitbucket-pipelines.yml
├── build.sh
├── container
│   └── <IMAGE-NAME>
│       ├── .Dockerfile
│       ├── .<TAG>.env
│       └── .version
├── container-structure-test-junit-compat.xsl
└── notification.sh
```

#### Bitucket Pipeline

```yaml title="bitbucket-pipelines.yml" linenums="1"
image: wimdevgroup/docker-buildx-pipeline:latest

definitions:
    strings:
        cst-install: &cst-install |
            curl -LO https://storage.googleapis.com/container-structure-test/latest/container-structure-test-linux-amd64;
            chmod +x container-structure-test-linux-amd64;
            mv container-structure-test-linux-amd64 /usr/local/bin/container-structure-test;
            export PATH=$PATH:/usr/local/bin/
    steps:
        - step: &build-step
              after-script:
                  - |
                      for report in $(find . -type f -name 'report*.xml'); do
                        xsltproc --output "${report}.tmp" container-structure-test-junit-compat.xsl "${report}";
                        mv "${report}.tmp" "${report}";
                      done
                      if [[ BITBUCKET_EXIT_CODE -eq 0 ]]; then
                        DISCORD_WEBHOOK_URL=${DISCORD_WEBHOOK_URL} BITBUCKET_WORKSPACE=${BITBUCKET_WORKSPACE} BITBUCKET_REPO_FULL_NAME=${BITBUCKET_REPO_FULL_NAME} CONTAINER=${container} BITBUCKET_PIPELINE_UUID=${BITBUCKET_PIPELINE_UUID} PIPELINE_STATE=1 ./notification.sh
                      else
                        DISCORD_WEBHOOK_URL=${DISCORD_WEBHOOK_URL} BITBUCKET_WORKSPACE=${BITBUCKET_WORKSPACE} BITBUCKET_REPO_FULL_NAME=${BITBUCKET_REPO_FULL_NAME} CONTAINER=${container} BITBUCKET_PIPELINE_UUID=${BITBUCKET_PIPELINE_UUID} PIPELINE_STATE=2 ./notification.sh
                      fi

pipelines:
    tags:
        release/*:
            - step:
                  <<: *build-step
                  name: Build and publish docker
                  runs-on:
                      - 'self.hosted'
                      - 'workspace'
                  deployment: production
                  script:
                      - DISCORD_WEBHOOK_URL=${DISCORD_WEBHOOK_URL} BITBUCKET_WORKSPACE=${BITBUCKET_WORKSPACE} BITBUCKET_REPO_FULL_NAME=${BITBUCKET_REPO_FULL_NAME} CONTAINER=${container} BITBUCKET_PIPELINE_UUID=${BITBUCKET_PIPELINE_UUID} PIPELINE_STATE=0 ./notification.sh
                      - *cst-install
                      - export SSH_KNOWN_HOSTS=$(ssh-keyscan -H ${SSH_HOST})
                      - mkdir -p ~/.ssh
                      - echo "$SSH_KNOWN_HOSTS" >> ~/.ssh/known_hosts
                      - ping -c 3 ${SSH_HOST}
                      - sshpass -p "${SSH_PASSWORD}" rsync -avz --progress build.sh container-structure-test-junit-compat.xsl "${SSH_USER}@${SSH_HOST}:pipeline/"
                      - sshpass -p ${SSH_PASSWORD} rsync -avz --progress container/ "${SSH_USER}@${SSH_HOST}:pipeline/container/"
                      - sshpass -p ${SSH_PASSWORD} ssh ${SSH_USER}@${SSH_HOST} "cd ${SSH_PATH} && DOCKERHUB_USERNAME=${DOCKERHUB_USERNAME} DOCKERHUB_PASSWORD=${DOCKERHUB_PASSWORD} ./build.sh ${container} --push"
                      - sshpass -p ${SSH_PASSWORD} ssh ${SSH_USER}@${SSH_HOST} "rm -rf pipeline"

    pull-requests:
        '**':
            - step:
                  <<: *build-step
                  name: Test build
                  runs-on:
                      - 'self.hosted'
                      - 'workspace'
                  script:
                      - DISCORD_WEBHOOK_URL=${DISCORD_WEBHOOK_URL} BITBUCKET_WORKSPACE=${BITBUCKET_WORKSPACE} BITBUCKET_REPO_FULL_NAME=${BITBUCKET_REPO_FULL_NAME} CONTAINER=${container} BITBUCKET_PIPELINE_UUID=${BITBUCKET_PIPELINE_UUID} PIPELINE_STATE=0 ./notification.sh
                      - *cst-install
                      - export SSH_KNOWN_HOSTS=$(ssh-keyscan -H ${SSH_HOST})
                      - mkdir -p ~/.ssh
                      - echo "$SSH_KNOWN_HOSTS" >> ~/.ssh/known_hosts
                      - ping -c 3 ${SSH_HOST}
                      - sshpass -p "${SSH_PASSWORD}" rsync -avz --progress build.sh container-structure-test-junit-compat.xsl "${SSH_USER}@${SSH_HOST}:pipeline/"
                      - sshpass -p ${SSH_PASSWORD} rsync -avz --progress container/ "${SSH_USER}@${SSH_HOST}:pipeline/container/"
                      - sshpass -p ${SSH_PASSWORD} ssh ${SSH_USER}@${SSH_HOST} "cd ${SSH_PATH} && DOCKERHUB_USERNAME=${DOCKERHUB_USERNAME} DOCKERHUB_PASSWORD=${DOCKERHUB_PASSWORD} ./build.sh ${container} --push"
                      - sshpass -p ${SSH_PASSWORD} ssh ${SSH_USER}@${SSH_HOST} "rm -rf pipeline"

    branches:
        main:
            - step:
                  name: Auto tag release
                  script:
                      - DISCORD_WEBHOOK_URL=${DISCORD_WEBHOOK_URL} BITBUCKET_WORKSPACE=${BITBUCKET_WORKSPACE} BITBUCKET_REPO_FULL_NAME=${BITBUCKET_REPO_FULL_NAME} CONTAINER=${container} BITBUCKET_PIPELINE_UUID=${BITBUCKET_PIPELINE_UUID} PIPELINE_STATE=3 ./notification.sh
                      - apt-get update && apt-get install -y --no-install-recommends git
                      - git tag -a "release/${BITBUCKET_BUILD_NUMBER}" -m "release/${BITBUCKET_BUILD_NUMBER} on ${BITBUCKET_COMMIT}" "${BITBUCKET_COMMIT}"
                      - git push origin "release/${BITBUCKET_BUILD_NUMBER}"
    custom:
        build-and-deploy:
            - variables:
                  - name: container
            - step:
                  <<: *build-step
                  name: Manual build and deploy
                  runs-on:
                      - 'self.hosted'
                      - 'workspace'
                  deployment: production
                  script:
                      - *cst-install
                      - chmod +x ./notification.sh
                      - DISCORD_WEBHOOK_URL=${DISCORD_WEBHOOK_URL} BITBUCKET_WORKSPACE=${BITBUCKET_WORKSPACE} BITBUCKET_REPO_FULL_NAME=${BITBUCKET_REPO_FULL_NAME} CONTAINER=${container} BITBUCKET_PIPELINE_UUID=${BITBUCKET_PIPELINE_UUID} PIPELINE_STATE=0 ./notification.sh
                      - export SSH_KNOWN_HOSTS=$(ssh-keyscan -H ${SSH_HOST})
                      - mkdir -p ~/.ssh
                      - echo "$SSH_KNOWN_HOSTS" >> ~/.ssh/known_hosts
                      - ping -c 3 ${SSH_HOST}
                      - sshpass -p "${SSH_PASSWORD}" rsync -avz --progress build.sh container-structure-test-junit-compat.xsl notification.sh "${SSH_USER}@${SSH_HOST}:pipeline/"
                      - sshpass -p ${SSH_PASSWORD} rsync -avz --progress container/ "${SSH_USER}@${SSH_HOST}:pipeline/container/"
                      - sshpass -p ${SSH_PASSWORD} ssh ${SSH_USER}@${SSH_HOST} "cd ${SSH_PATH} && DOCKERHUB_USERNAME=${DOCKERHUB_USERNAME} DOCKERHUB_PASSWORD=${DOCKERHUB_PASSWORD} ./build.sh ${container} --push"
                      - sshpass -p ${SSH_PASSWORD} ssh ${SSH_USER}@${SSH_HOST} "rm -rf pipeline"
```

#### build.sh
```shell title="build.sh" linenums="1"
#!/bin/bash

# @see https://stackoverflow.com/a/20460402
stringContains() {
    case $2 in
        *$1* )
            return 0
        ;;
        *)
            return 1
        ;;
    esac;
}

if [ -z ${DOCKERHUB_USERNAME+x} ]; then
    echo "[ERROR] DOCKERHUB_USERNAME is not provided. Username to a hub.docker.com profile expected"
    exit 1
fi;

if ! [ -x "$(command -v envsubst)" ]; then
    echo "[ERROR] envsubst is not installed."
    exit 1
fi;

if ! [ -x "$(command -v container-structure-test)" ]; then
    echo "[ERROR] container-structure-test is not installed."
    exit 1
fi;

if [[ "$@" == *"--push" ]]; then
    if [ -z ${DOCKERHUB_PASSWORD+x} ]; then
        echo "[ERROR] DOCKERHUB_PASSWORD is not provided. Password to the hub.docker.com profile ${DOCKERHUB_USERNAME} expected"
        exit 1
    fi;

    echo "[INFO] Logging into hub.docker.com"
    echo ${DOCKERHUB_PASSWORD} | docker login --username "${DOCKERHUB_USERNAME}" --password-stdin
    echo "[INFO] Logged into hub.docker.com Successfully"
fi

echo "[INFO] Check for cloud buildx builder version"
if !(docker buildx version); then
  echo "[ERROR] Failed to Check for cloud buildx builder version"
  exit 1
fi;

echo "[INFO] Check for cloud buildx builder"
if !(docker buildx ls); then
  echo "[ERROR] Failed to Check for cloud buildx builder"
  exit 1
fi;

echo "[INFO] Check for cloud buildx builder"
if !(docker buildx ls); then
  echo "[ERROR] Failed to Check for cloud buildx builder"
  exit 1
fi;

containerdir=container

if ! [ -z "$1" ] && [ -d "${containerdir}/$1" ]; then
    containerdir=${containerdir}/$1
fi

echo "[INFO] Search for images in ${containerdir}"

for dockerfile in $(find "${containerdir}" -type f -name .Dockerfile -exec ls {} \;); do
    dockerdir=$(dirname $dockerfile)
    versionfile="${dockerdir}/.version"
    testreportdir="${containerdir}/test-results/"

    mkdir -p "${testreportdir}"

    if ! [ -f "$versionfile" ]; then
        echo "[ERROR] No version file (${versionfile}) created"
        exit 1
    fi;

    if [ $(cat "$versionfile" | wc -m) == "0" ]; then
        echo "[INFO] No version defined in ${versionfile}"
    fi;

    VERSION=$(cat $versionfile)
    DOCKERIMAGE=$(basename $dockerdir)
    echo "[INFO] Process ${DOCKERIMAGE}@${VERSION} (${dockerdir})"

    for tagfile in $(find "$dockerdir" -maxdepth 1 -type f -name '.*.env' -exec ls {} \;); do
        tagfilename=$(basename "$tagfile" .env)
        TAG=${tagfilename:1}
        echo "[INFO] Process ${DOCKERIMAGE}:${TAG}"

        echo "[INFO] Reset build directory"
        if [ -d .build ]; then
            rm -rf .build
        fi;

        if !(mkdir .build); then
            echo "[ERROR] Cannot create build directory"
            exit 1
        fi;

        echo "[INFO] Process image template"

        envcontent=$(grep -v "^#" "$tagfile" | sed -e 's/^\\s*(.*?)\\s*$/\\1/' | sed -e 's/^$//')

        if [ -z ${envcontent+x} -o $(echo "$envcontent" | wc -m) -lt 2 ]; then
            echo "[INFO] Empty environment provided"
            cat "$dockerfile" | TAG=$TAG envsubst > .build/Dockerfile
        else
            cat "$dockerfile" | (export $(echo "$envcontent" | xargs) && TAG=$TAG envsubst > .build/Dockerfile)
        fi;

        if [ $(ls -1 "${dockerdir}" | wc -m) == "0" ]; then
            echo "[INFO] No data files to copy"
        else
            if !(cp -a ${dockerdir}/* .build); then
                echo "[ERROR] Cannot copy data to build directory"
                exit 1
            else
                echo "[INFO] Copy data to build directory"
            fi;
        fi;

        if [[ "$VERSION" =~ ^[0-9]+$ ]]; then
            echo "VERSION enthält nur Zahlen."
                if [[ "${TAG}" == "latest" ]]; then
                    tagversion="${VERSION}"
                    taglatest="latest"
                    echo "[INFO] Tag latest ${tagversion}"
                else
                    tagversion="${TAG}-${VERSION}"
                    taglatest="${TAG}-latest"
                    echo "[INFO] Tag ${tagversion}"
                fi;
        else
            tagversion="${TAG}"
        fi

        echo "[INFO] Build image"
        if !(docker buildx build --builder builder --tag "${DOCKERHUB_USERNAME}/${DOCKERIMAGE}:${tagversion}" --platform linux/amd64,linux/arm64 --push .build); then
            echo "[ERROR] Failed building image"
            exit 1
        fi;

        echo "[INFO] Prepare test files"
        [[ ! -d "${containerdir}/tests" ]] || rm -rf "${containerdir}/tests"
        mkdir -p "${containerdir}/tests/"

        for testfile in $(find "${containerdir}/.tests" -type f -name '*.yml' -exec ls {} \;); do
            testfile_basename=$(basename "${testfile}")
            # number of words determines, whether a version is in the file name
            testfile_basename_words="${testfile_basename//./ }"
            testfile_basename_n_words=$(echo "${testfile_basename_words}" | wc -w)

            if [[ ${testfile_basename_n_words} -ne 2 ]]; then # file has at least two dots and therefore has a tag in it
                if ! stringContains ".${TAG}.yml" "${testfile_basename}"; then # the filename has not the tag in question in it? then skip
                    echo "[INFO] Skip ${testfile} as it seems not to match the tag, that needs to be tested (testfile_basename_n_words: ${testfile_basename_n_words} ; testfile_basename_words: ${testfile_basename_words} ; TAG: ${TAG} ; testfile_basename: ${testfile_basename})"
                    continue
                fi

                echo "[INFO] Take ${testfile} as it seems to match the tag, that needs to be tested (testfile_basename_n_words: ${testfile_basename_n_words} ; testfile_basename_words: ${testfile_basename_words} ; TAG: ${TAG} ; testfile_basename: ${testfile_basename})"
            else
                echo "[INFO] Take ${testfile} as it seems to be used on any tag (testfile_basename_n_words: ${testfile_basename_n_words} ; testfile_basename_words: ${testfile_basename_words})"
            fi

            if [ -z ${envcontent+x} -o $(echo "$envcontent" | wc -m) -lt 2 ]; then # no env vars to replace
                cat "${testfile}" | TAG=$TAG envsubst > "${testfile/.tests/tests}"
            else
                cat "${testfile}" | (export $(echo "$envcontent" | xargs) && TAG=$TAG envsubst > "${testfile/.tests/tests}")
            fi;
        done

        for testfile in $(find "${containerdir}/tests" -type f -name '*.yml' -exec ls {} \;); do
            testfilename=$(basename "$testfile" .yml)
            reportfile=${testreportdir}/report-${DOCKERIMAGE}-${tagfilename}-${testfilename}.xml
            echo "[INFO] Test image against ${testfilename}"

            if !(container-structure-test test --image "${DOCKERHUB_USERNAME}/${DOCKERIMAGE}:${tagversion}" --config "${testfile}" --output junit --test-report "${reportfile}") then
                echo "[ERROR] Failed testing image"
                exit 1
            fi;
        done
    done;
done;
```

#### notification.sh
```shell title="notification.sh" linenums="1"
#!/bin/bash

# @see https://stackoverflow.com/a/20460402
stringContains() {
    case $2 in
        *$1* )
            return 0
        ;;
        *)
            return 1
        ;;
    esac;
}

if [ -z ${DISCORD_WEBHOOK_URL+x} ]; then
    echo "[ERROR] DISCORD_WEBHOOK_URL is not provided. Webhook to a discord.com channel expected."
    exit 1
fi;

if [ -z ${BITBUCKET_WORKSPACE+x} ]; then
    echo "[ERROR] BITBUCKET_WORKSPACE is not provided."
    exit 1
fi;

if [ -z ${BITBUCKET_REPO_FULL_NAME+x} ]; then
    echo "[INFO] BITBUCKET_REPO_FULL_NAME is not provided."
    BITBUCKET_REPO_FULL_NAME="unknown"
fi;

if [ -z ${container+x} ]; then
    echo "[INFO] container is not provided."
    DOCKER_IMAGE="All containers"
else
    DOCKER_IMAGE=$container
fi;

if [ -z ${PIPELINE_STATE+x} ]; then
    echo "[ERROR] $PIPELINE_STATE is not provided."
    exit 1
fi;

if [ $PIPELINE_STATE -eq 1 ]; then
    echo "[INFO] Pipeline is successful"
    PIPELINE_STATE="successful"
    PIPELINE_STATE_EMOTE="✅"
    COLOR=3066993
elif [ $PIPELINE_STATE -eq 2 ]; then
    echo "[INFO] Pipeline is failed"
    PIPELINE_STATE="failed"
    PIPELINE_STATE_EMOTE="❌"
    COLOR=15158332
elif [ $PIPELINE_STATE -eq 3 ]; then
    echo "[INFO] Automatic tag release"
    PIPELINE_STATE="Automatic tag release"
    PIPELINE_STATE_EMOTE="🔄"
    COLOR=3447003
else
    echo "[INFO] Pipeline is in progress"
    PIPELINE_STATE="in progress"
    PIPELINE_STATE_EMOTE="🔄"
    COLOR=3447003
fi

# Textvariablen und Testdaten
USERNAME="$BITBUCKET_WORKSPACE Bitbucket Pipeline for Repository $BITBUCKET_REPO_FULL_NAME"
MESSAGE="@everyone Pipeline $PIPELINE_STATE!"
DATA_TITLE="$PIPELINE_STATE_EMOTE Pipeline Status $PIPELINE_STATE $PIPELINE_STATE_EMOTE"
DATA="**Docker Image**\\n$DOCKER_IMAGE\\n\u200B\\n**Status**\\n$PIPELINE_STATE\\n\u200B\\n[$BITBUCKET_REPO_FULL_NAME](https://bitbucket.org/$BITBUCKET_REPO_FULL_NAME/pipelines/results/$BITBUCKET_PIPELINE_UUID)"
IMAGE_URL="https://images.wimwenigerkind.com/wimwenigerkind-transparent-icon.png"  # Ersetze dies mit der Bild-URL für das Profilbild

# JSON-Payload ausklappen und klar strukturiert ins Skript integrieren
PAYLOAD="{
  \"username\": \"$USERNAME\",
  \"avatar_url\": \"$IMAGE_URL\",
  \"content\": \"$MESSAGE\",
  \"embeds\": [
    {
      \"title\": \"$DATA_TITLE\",
      \"description\": \"$DATA\",
      \"color\": $COLOR
    }
  ]
}"

# Webhook senden
curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" $DISCORD_WEBHOOK_URL

echo "Webhook mit benutzerdefiniertem Profilbild gesendet!"
```

#### container-structure-test-junit-compat.xsl
```xml title="container-structure-test-junit-compat.xsl" linenums="1"
<xsl:stylesheet
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
    <xsl:output
            omit-xml-declaration="yes"
            indent="yes"
    />
    <xsl:strip-space elements="*" />

    <!-- recursive through all nodes -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" />
        </xsl:copy>
    </xsl:template>

    <!-- copy <testsuite> and add attributes "failure" and "tests" based in the testsuite children nodes -->
    <xsl:template match="testsuite">
        <testsuite
                failures="{count(testcase/failure)}"
                tests="{count(testcase)}"
        >
            <xsl:apply-templates select="node()|@*" />
        </testsuite>
    </xsl:template>
</xsl:stylesheet>
```