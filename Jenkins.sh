# Update package list
apt update

# Install Java 17
apt install openjdk-17-jdk -y

# Add Jenkins repository key
mkdir -p /etc/apt/keyrings
wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add Jenkins repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list

# Update package list again (to include Jenkins repo)
apt update

# Install Jenkins
apt install jenkins -y

# Start Jenkins
systemctl start jenkins

# Enable Jenkins to start on boot
systemctl enable jenkins

# Restart Jenkins (optional, but ensures it's running with the latest config)
systemctl restart jenkins

# Check Jenkins status
systemctl status jenkins
