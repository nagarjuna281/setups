#!/bin/bash

# Update system
apt update -y
apt upgrade -y
# Install Docker
apt install docker.io -y
systemctl enable docker
systemctl start docker
# Install Minikube
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
chmod +x minikube-linux-amd64
mv minikube-linux-amd64 /usr/local/bin/minikube
# Install kubectl
curl -LO https://dl.k8s.io/release/v1.34.0/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl
# Start Minikube
minikube start --driver=docker --force
