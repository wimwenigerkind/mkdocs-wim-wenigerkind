# Minecraft Server Docker Image

## EN

### Description

A Docker image for a Minecraft server based on OpenJDK. This image allows for easy hosting of a Minecraft server. With flexible memory configuration, you can get your own Minecraft server up and running in just a few minutes.

[Minecraft Server Docker Hub Repository](https://hub.docker.com/r/wimdevgroup/minecraft)

### Features

- **Easy Setup**: Start your Minecraft server in just a few minutes with minimal effort.
- **Customizable Memory**: Configure the maximum and minimum memory for the Java Virtual Machine through environment variables.
- **Download Server JAR**: Automatically download the Minecraft server JAR from a specified URL.
- **EULA Acceptance**: Automatically accept the Minecraft EULA upon startup.

### Usage with Tags

#### 1. **Pull Image**

```bash
docker pull wimdevgroup/minecraft:fabric-1.21.1
```

#### 2. **Start Container**

To start a new Minecraft server container, use the following command:

```bash
docker run -d -p 25565:25565 -e MEMORY=2G --name minecraft-server wimdevgroup/minecraft:fabric-1.21.1
```

- **VERSION**: Replace `fabric-1.21.1` with the desired Minecraft version.
- **MEMORY**: (Optional) Set the amount of RAM that the Minecraft server should use (default: 2G).

### Usage with Custom Server JAR URL

#### 1. **Pull Image**

```bash
docker pull wimdevgroup/minecraft:universal
```

#### 2. **Start Container**

To start a new Minecraft server container, use the following command:

```bash
docker run -d -p 25565:25565 -e MEMORY=2G -e JAR=<SERVER-JAR-URL> --name minecraft-server wimdevgroup/minecraft:universal
```

- **MEMORY**: (Optional) Set the amount of RAM that the Minecraft server should use (default: 2G).
- **JAR**: Change the URL to the required Minecraft server JAR.

### Environment Variables

| Variable | Description                               | Default Value  |
|----------|-------------------------------------------|-----------------|
| MEMORY   | Maximum and minimum memory (e.g., 2G)    | 2G              |
| JAR      | URL to the Minecraft server JAR          | -               |

### Exposed Ports

- **25565**: Default port for Minecraft servers.

### Support

If you have questions or issues, please contact me at [info@wimwenigerkind.com](mailto:info@wimwenigerkind.com) or through Docker Hub support.

## DE

### Beschreibung

Ein Docker-Image für einen Minecraft-Server, das auf OpenJDK basiert. Dieses Image ermöglicht das einfache Hosting eines Minecraft-Servers. Mit einer flexiblen Konfiguration zur Anpassung des Arbeitsspeichers kannst du deinen eigenen Minecraft-Server in wenigen Minuten zum Laufen bringen.

[Minecraft Server Docker Hub Repository](https://hub.docker.com/r/wimdevgroup/minecraft)

### Features

- **Einfaches Setup**: Starte deinen Minecraft-Server in nur wenigen Minuten mit minimalem Aufwand.
- **Anpassbarer Arbeitsspeicher**: Stelle den maximalen und minimalen Arbeitsspeicher für die Java Virtual Machine über Umgebungsvariablen ein.
- **Download der Server-JAR**: Lade die Minecraft-Server-JAR automatisch von einer angegebenen URL.
- **EULA-Akzeptanz**: Akzeptiere die Minecraft EULA automatisch beim Start.

### Verwendung mit Tags

#### 1. **Image herunterladen**

```bash
docker pull wimdevgroup/minecraft:fabric-1.21.1
```

#### 2. **Container starten**

Um einen neuen Minecraft-Server-Container zu starten, verwende den folgenden Befehl:

```bash
docker run -d -p 25565:25565 -e MEMORY=2G --name minecraft-server wimdevgroup/minecraft:fabric-1.21.1
```

- **VERSION**: Ersetze `fabric-1.21.1` mit der gewollten Minecraft-Version.
- **MEMORY**: (Optional) Setze die Menge an RAM, die der Minecraft-Server verwenden soll (Standard: 2G).

### Verwendung mit eigener Server-JAR-URL

#### 1. **Image herunterladen**

```bash
docker pull wimdevgroup/minecraft:universal
```

#### 2. **Container starten**

Um einen neuen Minecraft-Server-Container zu starten, verwende den folgenden Befehl:

```bash
docker run -d -p 25565:25565 -e MEMORY=2G -e JAR=<SERVER-JAR-URL> --name minecraft-server wimdevgroup/minecraft:universal
```

- **MEMORY**: (Optional) Setze die Menge an RAM, die der Minecraft-Server verwenden soll (Standard: 2G).
- **JAR**: Ändere die URL zu der benötigten Minecraft-Server-JAR.

### Umgebungsvariablen

| Variable | Beschreibung                               | Standardwert  |
|----------|-------------------------------------------|----------------|
| MEMORY   | Maximaler und minimaler Speicher (z. B. 2G) | 2G             |
| JAR      | URL zur Minecraft-Server-JAR              | -              |

### Expose Ports

- **25565**: Standardport für Minecraft-Server.

### Support

Wenn du Fragen oder Probleme hast, kontaktiere mich bitte über [info@wimwenigerkind.com](mailto:info@wimwenigerkind.com) oder den Docker Hub-Support.
