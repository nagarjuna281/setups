#!/bin/bash

# Install Java 17 Amazon Corretto on Ubuntu
wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add -
sudo add-apt-repository 'deb https://apt.corretto.aws stable main'
sudo apt update -y
sudo apt install -y java-17-amazon-corretto-jdk

# Download and extract Tomcat 9.0.107
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.107/bin/apache-tomcat-9.0.107.tar.gz
tar -zxvf apache-tomcat-9.0.107.tar.gz

# Modify tomcat-users.xml
sed -i '56  a\<role rolename="manager-gui"/>' apache-tomcat-9.0.107/conf/tomcat-users.xml
sed -i '57  a\<role rolename="manager-script"/>' apache-tomcat-9.0.107/conf/tomcat-users.xml
sed -i '58  a\<user username="tomcat" password="admin@123" roles="manager-gui, manager-script"/>' apache-tomcat-9.0.107/conf/tomcat-users.xml
sed -i '59  a\</tomcat-users>' apache-tomcat-9.0.107/conf/tomcat-users.xml
sed -i '56d' apache-tomcat-9.0.107/conf/tomcat-users.xml

# Modify context.xml
sed -i '21d' apache-tomcat-9.0.107/webapps/manager/META-INF/context.xml
sed -i '22d'  apache-tomcat-9.0.107/webapps/manager/META-INF/context.xml

# Start Tomcat
sh apache-tomcat-9.0.107/bin/startup.sh
