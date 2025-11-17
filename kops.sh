#! /bin/bash

# Install kubectl (latest stable release)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl

# Install kops (latest release)
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
mv kops /usr/local/bin/kops

# Create S3 bucket for kops state store
aws s3api create-bucket --bucket arjun.k8s.local --region us-east-1
aws s3api put-bucket-versioning --bucket arjun.k8s.local --region us-east-1 --versioning-configuration Status=Enabled

# Export state store environment variable
export KOPS_STATE_STORE=s3://arjun.k8s.local

# Create Kubernetes cluster
kops create cluster \
  --name arjun.k8s.local \
  --zones us-east-1a \
  --master-count=1 \
  --master-size t2.large \
  --master-volume-size=30 \
  --node-count=3 \
  --node-size t2.medium \
  --node-volume-size=20

# Apply cluster configuration
kops update cluster --name arjun.k8s.local --yes --admin
