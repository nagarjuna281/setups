#!/bin/bash

# STEP-1: INSTALL JAVA 17
sudo apt update
sudo apt install openjdk-17-jdk wget -y

# STEP-2: DOWNLOAD AND EXTRACT TOMCAT 9
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.104/bin/apache-tomcat-9.0.104.tar.gz
tar -zxvf apache-tomcat-9.0.104.tar.gz

# STEP-3: CONFIGURE tomcat-users.xml
sed -i '56  a\<role rolename="manager-gui"/>' apache-tomcat-9.0.104/conf/tomcat-users.xml
sed -i '57  a\<role rolename="manager-script"/>' apache-tomcat-9.0.104/conf/tomcat-users.xml
sed -i '58  a\<user username="tomcat" password="admin@123" roles="manager-gui, manager-script"/>' apache-tomcat-9.0.104/conf/tomcat-users.xml
sed -i '59  a\</tomcat-users>' apache-tomcat-9.0.104/conf/tomcat-users.xml
sed -i '56d' apache-tomcat-9.0.104/conf/tomcat-users.xml

# STEP-4: REMOVE RESTRICTIONS FROM MANAGER APP
sed -i '21d' apache-tomcat-9.0.104/webapps/manager/META-INF/context.xml
sed -i '22d' apache-tomcat-9.0.104/webapps/manager/META-INF/context.xml

# STEP-5: START TOMCAT
sh apache-tomcat-9.0.104/bin/startup.sh
