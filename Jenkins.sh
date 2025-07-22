#!/bin/bash

# STEP-1: INSTALLING GIT
sudo apt update
sudo apt install git -y

# STEP-2: ADD JENKINS REPOSITORY AND KEY
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# STEP-3: INSTALL JAVA 17 AND JENKINS
sudo apt update
sudo apt install openjdk-17-jdk -y
sudo apt install jenkins -y

# STEP-4: START AND ENABLE JENKINS SERVICE
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins
