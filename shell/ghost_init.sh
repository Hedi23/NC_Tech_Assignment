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
    sudo apt-get update && sudo apt-get upgrade -y

    # Install Nginx
    sudo apt-get install -y nginx 

    # Increase the server_names_hash_bucket_size to 128 in order to accept long domain names
    echo "server_names_hash_bucket_size 128;" | sudo tee /etc/nginx/conf.d/server_names_hash_bucket_size.conf

    # Add the NodeSource APT repository for Node 12
    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash

    # Install Node.js && npm
    sudo apt-get install -y nodejs
    sudo npm install npm@latest -g

    # Install Ghost-CLI
    sudo npm install ghost-cli@latest -g

    # Give permission to ubuntu user, create directory 
    sudo chown -R ubuntu:ubuntu /var/www/
    sudo -u ubuntu mkdir -p /var/www/blog && cd /var/www/blog

    sudo chown -R ubuntu:ubuntu /home/ssm-user/

    # Install Ghost, cannot be run via root (user data default)
    sudo -u ubuntu ghost install \
        # --url       "${URL}" \
        # --admin-url "${ADMIN_URL}" \
        --url       "http://${LB_HOSTNAME}" \
        --admin-url "http://${LB_HOSTNAME}" \
        --db        "mysql" \
        --dbhost    "${DB_HOSTNAME}" \
        --dbuser    "${DB_USERNAME}" \
        --dbpass    "${DB_PASSWORD}" \
        --dbname    "${DB_NAME}" \
        --process systemd \
        --no-prompt