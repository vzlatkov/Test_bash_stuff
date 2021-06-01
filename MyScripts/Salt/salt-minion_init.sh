#!/bin/bash

###This is a script for automatization of the installation and configuration of a Salt Stack minion server. By VZlatkov (a.k.a. Xerxes)
###v1.0.1
### In this version we are going to set the basic installation of the Salt-minion by updating and upgrading the OS and installing the needed dependencies. Then we are going to install the minion server itself.
###v1.0.2
###Since this script is intended to be used as a user data and can not be interactive, this revision is going to make a new interactive script on the machine/EC2 cloud instance that will remain there for further configuration (Connecting to the master, etc.)





###This is the initial dependency installation part of the script
apt -y update
apt -y upgrade
apt -y install python3
apt -y install python3-pip
pip install salt #You first install the Salt Stack, then you configure it as a Master or Slave
# Download key
curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest/salt-archive-keyring.gpg
# Create apt sources list file
echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg] https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest focal main" | sudo tee /etc/apt/sources.list.d/salt.list
apt-get update
apt-get -y install salt-minion

###Start the service
systemctl daemon-reload
systemctl start salt-minion
systemctl restart salt-minion
systemctl status salt-minion

			#####			V.1.0.2   STARTS FROM HERE			#####


###This is a heredoc that would create the new bash script on the instance
(
cat > $HOME/salt_minion_conf.sh<<EOF

read -p "insert the master's hostname `\n`" name
read -p "insert the master's finger `\n`" finger
read -p "insert the master's IP `\n`" mIP
echo "master: $name" >> /etc/salt/minion
echo "master_finger: '$finger'" >> /etc/salt/minion

###Add the master in the /etc/hosts file in order to be able to resolve the master server's name
echo "$mIP $name" >> /etc/hosts
EOF
)
###Make the file Executable
chmod +x $HOME/salt_minion_conf.sh

###Restart the service
systemctl daemon-reload
systemctl restart salt-minion
systemctl status salt-minion
