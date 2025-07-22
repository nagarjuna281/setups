#!/bin/bash

# Update the system
sudo apt update -y

# Install required packages
sudo apt install wget -y

# Install Java 17 Amazon Corretto on Ubuntu
wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add -
sudo add-apt-repository 'deb https://apt.corretto.aws stable main'
sudo apt update -y
sudo apt install -y java-17-amazon-corretto-jdk

# Create /app directory and navigate to it
sudo mkdir -p /app && cd /app

# Download the latest Nexus 3 tarball
sudo wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz

# Extract the tarball
sudo tar -xvf nexus.tar.gz

# Rename the extracted nexus directory (assuming it starts with nexus-3)
sudo mv nexus-3* nexus

# Create a nexus user
sudo adduser --system --no-create-home --group nexus

# Set ownership of nexus and sonatype-work directories
sudo chown -R nexus:nexus /app/nexus
sudo chown -R nexus:nexus /app/sonatype-work

# Configure nexus.rc to run as the nexus user
echo 'run_as_user="nexus"' | sudo tee /app/nexus/bin/nexus.rc

# Create the systemd service file for Nexus
sudo tee /etc/systemd/system/nexus.service > /dev/null <<EOF
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable the Nexus service to start on boot (equivalent to chkconfig nexus on)
sudo systemctl enable nexus.service

# Start the Nexus service
sudo /app/nexus/bin/nexus start

# Check the status of the Nexus service (corrected typo from 'neus' to 'nexus')
sudo /app/nexus/bin/nexus status
