#!/bin/bash

# STEP-1: INSTALL JAVA 17
sudo apt update
sudo apt install openjdk-17-jdk wget -y

# STEP-2: DOWNLOAD AND EXTRACT TOMCAT 9 (latest available)
TOMCAT_VERSION=9.0.89
wget https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
tar -zxvf apache-tomcat-${TOMCAT_VERSION}.tar.gz

# STEP-3: CONFIGURE tomcat-users.xml
sed -i '56  a\<role rolename="manager-gui"/>' apache-tomcat-${TOMCAT_VERSION}/conf/tomcat-users.xml
sed -i '57  a\<role rolename="manager-script"/>' apache-tomcat-${TOMCAT_VERSION}/conf/tomcat-users.xml
sed -i '58  a\<user username="tomcat" password="admin@123" roles="manager-gui, manager-script"/>' apache-tomcat-${TOMCAT_VERSION}/conf/tomcat-users.xml
sed -i '59  a\</tomcat-users>' apache-tomcat-${TOMCAT_VERSION}/conf/tomcat-users.xml
sed -i '56d' apache-tomcat-${TOMCAT_VERSION}/conf/tomcat-users.xml

# STEP-4: REMOVE RESTRICTIONS FROM MANAGER APP
sed -i '21d' apache-tomcat-${TOMCAT_VERSION}/webapps/manager/META-INF/context.xml
sed -i '22d' apache-tomcat-${TOMCAT_VERSION}/webapps/manager/META-INF/context.xml

# STEP-5: START TOMCAT
sh apache-tomcat-${TOMCAT_VERSION}/bin/startup.sh
