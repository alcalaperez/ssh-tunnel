# ssh-tunnel

SSH tunnel on docker

Access a remote service in a remote machine using a simple docker container. It will ssh into the remote host and listen on a remote port where you will have a service running.

```
--------------------------------------------------------------------------

               		             
+-------------------------+		    +------------------------+	
|          LOCAL    	  |		    |        REMOTE	     |
|         MACHINE     	  |		    |	      HOST           |
|   +----------------+	  |		    |   +-----------------+  |
|   |  proxy-tunnel  |	  |		    |   | |    REMOTE     |  |
|   |	container    |======== SSH ==========>  | |   SERVICE     |  |
|   +----------------+	  |	            |   | +---------------+  |
|			  |		    |	| REMOTE PORT	  |  |
|			  |		    |	+-----------------+  |
+-------------------------+		    +------------------------+
				    FIREWALL (SSH_PORT Open)

--------------------------------------------------------------------------
```

This is a docker compose example to proxy a MariaDB instance running on the remote VM on the default port 3306:

```
services:
  proxy-tunnel:
    image: ghcr.io/alcalaperez/ssh-tunnel:main
    container_name: mariadb-ssh-tunnel
    ports:
      - "3000:3000"
    environment:
      - SSH_USER=yoursshuser
      - SSH_PRIVATE_KEY_FILE=id_rsa
      - REMOTE_HOST=192.168.1.10
      - SSH_PORT=22
      - REMOTE_PORT=3306
    restart: always
    volumes:
      - /home/youruser/.ssh:/ssh
    healthcheck:
      test: ["CMD", "nc", "-z", "127.0.0.1", "3000"]
      interval: 30s
      timeout: 10s
      retries: 3
```

| Parameter     | Description   |
| ------------- | ------------- |
| SSH_USER 		| This will be the user to login via SSH.  |
| SSH_PRIVATE_KEY_FILE   | Specify the private key file name. It will be combined with the volume, for the previous example, /home/youruser/.ssh/id_rsa |
| REMOTE_HOST   | Remote IP or DNS for the server to access |
| SSH_PORT      | Port used to SSH |
| REMOTE_PORT   | Port of the service you want to access and listen to |

The volume has to point to the folder where you have your public key stored.
