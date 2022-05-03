#!/bin/bash -xe
DB_NAME=${DB_NAME}
DB_HOSTNAME=${DB_HOSTNAME}
DB_USERNAME=${DB_USERNAME}
DB_PASSWORD=${DB_PASSWORD}
URL=${URL}
ADMIN_URL=${ADMIN_URL}
LB_HOSTNAME=${LB_HOSTNAME}

# # Send the output to the console logs and at /var/log/user-data.log
# exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

#     # Add User for Ghost Administration
#     sudo adduser hedus
#     sudo usermod -aG sudo hedus
#     su - hedus

#     # Update packages
#     sudo apt-get update && sudo apt-get upgrade -y

#     # Install Nginx
#     sudo apt-get install -y nginx
#     sudo ufw allow 'Nginx Full' 

#     # Increase the server_names_hash_bucket_size to 128 in order to accept long domain names
#     echo "server_names_hash_bucket_size 128;" | sudo tee /etc/nginx/conf.d/server_names_hash_bucket_size.conf

#     # Installing MySQL DB server
#     sudo apt-get purge mysql-server
#     sudo apt-get autoremove
#     sudo apt-get autoclean

#     sudo apt-get update
#     sudo apt-get install mysql-server -y

#     # Add the NodeSource APT repository for Node 12
#     curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash

#     # Install Node.js && npm
#     sudo apt-get install -y nodejs
#     sudo npm install npm@latest -g

#     # Install Ghost-CLI
#     sudo npm install ghost-cli@latest -g


#     # Give permission to user, create directory 
#     sudo mkdir -p /var/www/ghost
#     cd /var/www/ghost
    
#     sudo chown hedus:hedus /var/www/ghost
#     sudo chmod 775 /var/www/ghost

#     mkdir blog.example.com
#     cd blog.example.com

#     # Install Ghost, cannot be run via root (user data default)
#     ghost install \
#         --url       "${URL}" \
#         --db        "mysql" \
#         --dbhost    "${DB_HOSTNAME}" \
#         --dbuser    "${DB_USERNAME}" \
#         --dbpass    "${DB_PASSWORD}" \
#         --dbname    "${DB_NAME}" \
#         --process systemd \
#         --no-prompt


#         ghost install \
#         --url       "http://GhostLoadBalancer-183749644.us-east-1.elb.amazonaws.com/" \
#         --db        "mysql" \
#         --dbhost    "dev-ghostdatabase.cluster-cdiwvzsx3up3.us-east-1.rds.amazonaws.com" \
#         --dbuser    "admin" \
#         --dbpass    "admin123" \
#         --dbname    "GhostDB" \
#         --process systemd \
#         --no-prompt