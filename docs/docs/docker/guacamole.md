[Guacamole](https://hub.docker.com/r/oznu/guacamole) installation on Docker

## Install Guacamole

### Run the Installation Script

    docker run -d -p 8080:8080 -v /guacamole:/config --name Guacamole oznu/guacamole

## Login

Open the web UI using IP:Port

### Default credentials

- Username: guacadmin
- Password: guacadmin

![Login Page](../images/guacamole-login-page.png)

### Change default password

Go to Settings --> Users --> New User --> Edit New User --> paste new credentials and set all permissions to true --> Save and logout --> login with new credentials and delet the old User

## New connection

Go to Setting --> Connections --> click on New Connection --> paste credentials --> and save

![New Connection Page](../images/guacamole-newconnection-page.png)

### Add an SSH Connection

- Name: SSH Connection
- Protocol: SSH
- Hostname: Server-IP
- Port: Default SSH PORT 22
- Username: Server SSH Username
- Password: Server SSH Password
