#!/bin/bash

# Copyright Odaceo 2016
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
