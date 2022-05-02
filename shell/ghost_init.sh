#!/bin/bash -xe
DB_NAME=${DB_NAME}
DB_HOSTNAME=${DB_HOSTNAME}
DB_USERNAME=${DB_USERNAME}
DB_PASSWORD=${DB_PASSWORD}
URL=${URL}
ADMIN_URL=${ADMIN_URL}
LB_HOSTNAME=${LB_HOSTNAME}

# Send the output to the console logs and at /var/log/user-data.log
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

    # Update packages
    apt-get update && sudo apt-get upgrade -y

    # Install Nginx
    apt-get install -y nginx 

    # Add the NodeSource APT repository for Node 12
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash

    # Install Node.js && npm
    apt-get install -y nodejs
    npm install npm@latest -g

    # Install Ghost-CLI
    npm install ghost-cli@latest -g

    # Give permission to ubuntu user, create directory 
    chown -R ubuntu:ubuntu /var/www/
    sudo -u ubuntu mkdir -p /var/www/blog && cd /var/www/blog

    # Install Ghost, cannot be run via root (user data default)
    sudo -u ubuntu ghost install \
        --url       "${URL}" \
        --admin-url "${ADMIN_URL}" \
        --db        "mysql" \
        --dbhost    "${DB_HOSTNAME}" \
        --dbuser    "${DB_USERNAME}" \
        --dbpass    "${DB_PASSWORD}" \
        --dbname    "${DB_NAME}" \
        --process systemd \
        --no-prompt 
