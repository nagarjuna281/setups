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
sudo mkdir /app && cd /app

# Download the latest Nexus 3 tarball with error handling
sudo wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz || {
    echo "Error: Failed to download Nexus tarball. Check your internet connection or the URL."
    exit 1
}

# Check if the downloaded file exists and is not empty
if [ ! -s nexus.tar.gz ]; then
    echo "Error: Downloaded Nexus tarball is empty or does not exist."
    exit 1
fi

# List directory contents (for debugging)
ll

# Extract the tarball with error handling
sudo tar -xvf nexus.tar.gz || {
    echo "Error: Failed to extract Nexus tarball. The file may be corrupted."
    exit 1
}

# List directory contents again (for debugging)
ll

# Rename the extracted nexus directory
sudo mv nexus-3* nexus

# Create a nexus user
sudo adduser --system --no-create-home --group nexus

# Set ownership of the nexus and sonatype-work directories
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

# Enable the Nexus service to start on boot
sudo systemctl enable nexus.service

# Start the Nexus service
sudo /app/nexus/bin/nexus start

# Check the status of the Nexus service
sudo /app/nexus/bin/nexus status
