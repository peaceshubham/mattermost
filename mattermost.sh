#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo dnf install -y curl wget

##postgres installation
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm 
sudo dnf -qy module disable postgresql
sudo dnf install -y postgresql14-server
sudo dnf install -y postgresql14-contrib
sudo /usr/pgsql-14/bin/postgresql-14-setup initdb
sudo systemctl start postgresql-14
sudo systemctl enable postgresql-14

##setting up user and db##



##mattermost installation##
cd /tmp ; wget https://releases.mattermost.com/7.2.0/mattermost-7.2.0-linux-amd64.tar.gz

tar -xvzf matter*.gz
sudo mv mattermost /opt
sudo mkdir /opt/mattermost/data

##setting up user##
sudo useradd --system --user-group mattermost
sudo chown -R mattermost:mattermost /opt/mattermost
sudo chmod -R g+w /opt/mattermost
sudo restorecon -R /opt/mattermost

##autostart file##
sudo touch /etc/systemd/system/mattermost.service
printf "[Unit]
Description=Mattermost
After=syslog.target network.target postgresql.service

[Service]
Type=notify
WorkingDirectory=/opt/mattermost
User=mattermost
ExecStart=/opt/mattermost/bin/mattermost
PIDFile=/var/spool/mattermost/pid/master.pid
TimeoutStartSec=3600
KillMode=mixed
LimitNOFILE=49152

[Install]
WantedBy=multi-user.target

" > /etc/systemd/system/mattermost.service


##enablling##
sudo chmod 774 /etc/systemd/system/mattermost.service
sudo systemctl daemon-reload
sudo systemctl enable mattermost.service
#sudo systemctl start mattermost.service
