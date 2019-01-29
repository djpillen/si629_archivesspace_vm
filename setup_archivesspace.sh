#!/usr/bin/env bash

# Download and unzip a packaged ArchivesSpace release and corresponding source code
if [ -d "/aspace" ]; then
  rm -rf /aspace
fi
mkdir /aspace
mkdir /aspace/zips
cd /aspace/zips
wget -nv https://github.com/archivesspace/archivesspace/releases/download/v2.5.2/archivesspace-v2.5.2.zip
cd /aspace
unzip /aspace/zips/archivesspace-v2.5.2.zip

# These variables will be used to edit the ArchivesSpace config file to use the correct database URL
DBURL='AppConfig[:db_url] = "jdbc:mysql://localhost:3306/archivesspace?user=as\&password=as123\&useUnicode=true\&characterEncoding=UTF-8"'

# http://archivesspace.github.io/archivesspace/user/running-archivesspace-against-mysql/
cd /aspace/archivesspace/lib
wget -nv http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.47/mysql-connector-java-5.1.47.jar

# Edit the config file to use the MySQL database
# http://stackoverflow.com/questions/14643531/changing-contents-of-a-file-through-shell-script
cd /aspace/archivesspace/config
sed -i "s@#AppConfig\[:db_url\].*@$DBURL@" config.rb

# Make the archivesspace.sh and setup-database.sh scripts executable
cd /aspace/archivesspace/scripts
chmod +x setup-database.sh
cd /aspace/archivesspace
chmod +x archivesspace.sh

# Run the setup database script
scripts/setup-database.sh

# Add ArchivesSpace to system startup and create an ArchivesSpace service
echo "[Unit]
Description=ArchivesSpace
After=network.target

[Service]
Type=forking
RemainAfterExit=yes
ExecStart=/aspace/archivesspace/archivesspace.sh start
ExecStop=/aspace/archivesspace/archivesspace.sh stop

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/archivesspace.service

# Usage: sudo systemctl stop|start archivesspace.service
systemctl start archivesspace.service
systemctl enable archivesspace.service

chown -R vagrant:vagrant /aspace