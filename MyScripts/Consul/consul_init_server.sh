#!/bin/bash

#Automation script for installing and configuring Conslul server by VZlatkov a.k.a. - Xerxes
#v1.0.1



###     Updates and upgrades the OS so all dependencies are available   ###
apt -y update
apt -y upgrade

###     Installs Consul         ###
apt -y install consul

###     Tests if the conf file exists   ###

if [ -f /etc/systemd/system/consul.service = $FILE ]; #Checks if the file exists
        then continue #If exists - skips the "if" statement
        else #If it doesn't exist - creates the path and file
                mkdir /etc/systemd/system
                touch /etc/systemd/system/consul.service
fi

###     This is a consul.conf template in a HEREDOC     ###
nl="ExecStart=/usr/bin/consul agent -server \ \n        -advertise=IP \ \n      -bind=IP \ \n        -data-dir=/var/lib/consul \ \n        -bootstrap \ \n        -config-dir=/etc/consul.d\n"

(
cat > /etc/systemd/system/consul.service <<EOF
[Unit]
Description=Consul Service Discovery Agent
Documentation=https://www.consul.io/
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=consul
Group=consul
$(printf "%b" "$nl")

ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5
Restart=on-failure
SyslogIdentifier=consul

[Install]
EOF
)

###     Now we have to find which is the instance's public IP and substitute the "IP" strings in the consul.conf        ###
apt -y install dnsutills #Makes sure "dig" exists
IP=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1) #Assigns the public IP of the machine to a variable so we can use it

###     Those substitute the two "IP" strings with the OG IP    ###
sed -i "s/IP/$IP/" /etc/systemd/system/consul.service
sed -i "s/IP/$IP/" /etc/systemd/system/consul.service

systemctl daemon-reload
sleep 2
systemctl enable consul
sleep 2
systemctl start consul
sleep 2
systemctl restart consul
sleep 2
consul members
                                                                            
