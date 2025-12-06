#! /bin/bash

# ensure user is 
if [[ $(id -u) -ne 0 ]]; then
    echo -e "\e[1;31mERROR: This script must be run as root!\e[0m"

    exit
fi

# install requirements
chmod u+x req.sh
chmod u+x change_port.sh
bash ./req.sh

# continue setup...

# creating developers group
groupadd developers

# creating 3 users

useradd -m devops-admin
useradd developer -G developers
useradd readonly

# creating a password for devops-admin
echo devops-admin:strongpassword | chpasswd
# giving no password access to  to devops-admin
echo "devops-admin ALL=(ALL) NOPASSWD:ALL" > /etc/ers.d/devops-admin
chmod 440 /etc/ers.d/devops-admin


# making directory and giving developers ownership
mkdir /opt/shared
chgrp -R developers /opt/shared

# giving developers rwx permissions on it
chmod 2775 /opt/shared
setfacl -m g:developers:rwx /opt/shared

# starting and enabling services
systemctl enable --now nginx docker 


# change ssh port to 2222

bash change_port.sh 2222


# ufw settings

ufw default allow outgoing 
ufw default deny incoming
ufw deny 22
ufw allow 2222
systemctl enable --now ufw
