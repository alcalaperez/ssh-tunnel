FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache openssh-client autossh

# Create entrypoint script
RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo 'ssh -o StrictHostKeyChecking=no -p "$SSH_PORT" -i /ssh/"$SSH_PUB_KEY_FILE" -L 0.0.0.0:3000:localhost:$REMOTE_PORT $SSH_USER@$REMOTE_HOST -N' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Expose local 3000 port
EXPOSE 3000

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]