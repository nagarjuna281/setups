#!/bin/bash
set -e

# Variables
NEXUS_USER="nexus"
NEXUS_INSTALL_DIR="/opt/nexus"
NEXUS_DATA_DIR="/opt/sonatype-work"
NEXUS_URL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"
SERVICE_FILE="/etc/systemd/system/nexus.service"

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  # Please run this script as root or with sudo.
  exit 1
fi

# Updating packages...
apt update && apt upgrade -y

# Installing Java and wget...
apt install -y openjdk-11-jdk wget

# Creating nexus user if it doesn't exist...
if ! id -u $NEXUS_USER >/dev/null 2>&1; then
  adduser --system --no-create-home --group $NEXUS_USER
fi

# Downloading Nexus...
cd /opt
wget -q --show-progress $NEXUS_URL -O nexus.tar.gz

# Extracting Nexus...
tar -xzf nexus.tar.gz
rm nexus.tar.gz
mv nexus-3* nexus

# Setting ownership...
chown -R $NEXUS_USER:$NEXUS_USER $NEXUS_INSTALL_DIR
chown -R $NEXUS_USER:$NEXUS_USER $NEXUS_DATA_DIR || mkdir -p $NEXUS_DATA_DIR && chown -R $NEXUS_USER:$NEXUS_USER $NEXUS_DATA_DIR

# Configuring Nexus user...
echo "run_as_user=\"$NEXUS_USER\"" > $NEXUS_INSTALL_DIR/bin/nexus.rc

# Creating systemd service file...
cat > $SERVICE_FILE <<EOF
[Unit]
Description=Sonatype Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=$NEXUS_USER
Group=$NEXUS_USER
ExecStart=$NEXUS_INSTALL_DIR/bin/nexus start
ExecStop=$NEXUS_INSTALL_DIR/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

# Reloading systemd daemon...
systemctl daemon-reload

# Enabling Nexus service to start on boot...
systemctl enable nexus

# Starting Nexus service...
systemctl start nexus

# Waiting 30 seconds for Nexus to start...
sleep 30

# Checking Nexus service status...
systemctl status nexus --no-pager

# Opening port 8081 if ufw is active...
if command -v ufw >/dev/null 2>&1; then
  ufw allow 8081/tcp || true
  ufw reload || true
fi

# Setup complete!
# Access Nexus at: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8081
# Initial admin password:
cat $NEXUS_DATA_DIR/nexus3/admin.password
# Login with 'admin' and change password.
