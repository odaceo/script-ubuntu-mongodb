#!/bin/bash

# Init variables
Version="3.2"

# Import the public key used by the package management system
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

# Add the MongoDB repository details
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/${Version} multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-${Version}.list

# Update your local package index
sudo apt-get update

# Install the MongoDB packages
sudo apt-get install -y mongodb-org

# Create systemd service file
cat <<EOF | sudo tee /lib/systemd/system/mongodb.service
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target
Documentation=https://docs.mongodb.org/manual

[Service]
User=mongodb
Group=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target
EOF

# Start MongoDB when the system starts
sudo systemctl enable mongodb

# Start MongoDB
sudo systemctl start mongodb

# Verify that MongoDB has started successfully
sudo systemctl status mongodb
