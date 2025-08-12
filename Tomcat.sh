# 1. Update and install Java 17 and wget
apt update
apt install openjdk-17-jdk wget -y

# 2. Download Tomcat 9.0.108
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.108/bin/apache-tomcat-9.0.108.tar.gz

# 3. Extract Tomcat
tar -xzf apache-tomcat-9.0.108.tar.gz

# 4. Give execute permissions to scripts
chmod +x apache-tomcat-9.0.108/bin/*.sh

# 5. Configure manager user and roles in tomcat-users.xml
sed -i '56  a\<role rolename="manager-gui"/>' apache-tomcat-9.0.108/conf/tomcat-users.xml
sed -i '57  a\<role rolename="manager-script"/>' apache-tomcat-9.0.108/conf/tomcat-users.xml
sed -i '58  a\<user username="tomcat" password="admin@123" roles="manager-gui,manager-script"/>' apache-tomcat-9.0.108/conf/tomcat-users.xml
sed -i '59  a\</tomcat-users>' apache-tomcat-9.0.108/conf/tomcat-users.xml
sed -i '56d' apache-tomcat-9.0.108/conf/tomcat-users.xml

# 6. Allow remote access to the manager app
sed -i '21d' apache-tomcat-9.0.108/webapps/manager/META-INF/context.xml
sed -i '22d' apache-tomcat-9.0.108/webapps/manager/META-INF/context.xml

# 7. Start Tomcat
sh apache-tomcat-9.0.108/bin/startup.sh
