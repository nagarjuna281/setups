#!/bin/bash
set -e

NEXUS_USER="nexus"
NEXUS_INSTALL_DIR="/opt/nexus"
NEXUS_DATA_DIR="/opt/sonatype-work"
NEXUS_URL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"
SERVICE_FILE="/etc/systemd/system/nexus.service"

# Update packages
apt update && apt upgrade -y

# Install Java and wget
apt install -y openjdk-11-jdk wget

# Create nexus user
if ! id -u $NEXUS_USER >/dev/null 2>&1; then
  adduser --system --no-create-home --group $NEXUS_USER
fi

# Download Nexus
cd /opt
wget -q --show-progress $NEXUS_URL -O nexus.tar.gz

# Extract Nexus
tar -xzf nexus.tar.gz
rm nexus.tar.gz
mv nexus-3* nexus

# Set ownership
chown -R $NEXUS_USER:$NEXUS_USER $NEXUS_INSTALL_DIR
chown -R $NEXUS_USER:$NEXUS_USER $NEXUS_DATA_DIR

# Configure Nexus user
echo "run_as_user=\"$NEXUS_USER\"" > $NEXUS_INSTALL_DIR/bin/nexus.rc

# Create systemd service
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

# Reload systemd and enable Nexus
systemctl daemon-reload
systemctl enable nexus
systemctl start nexus

# Wait for Nexus to start
sleep 30

# Nexus status:
systemctl status nexus --no-pager

# Open port 8081 if ufw active
if command -v ufw >/dev/null 2>&1; then
  ufw allow 8081/tcp || true
  ufw reload || true
fi

# Setup complete!
# Access Nexus at: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8081
# Initial admin password:
cat $NEXUS_DATA_DIR/nexus3/admin.password
# Login with 'admin' and change password.
