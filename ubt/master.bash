#!/bin/bash

sudo hostnamectl set-hostname master
sudo ufw disable

sudo rm -rf /etc/netplan/90*
cat <<EOL > /etc/netplan/50-cloud-init.yaml
network:
  version: 2
  ethernets:
    ens33:
      dhcp4: no
      addresses:
      - "192.168.182.201/24"
      routes:
        - to: 0.0.0.0/0
          via: 192.168.182.2
      nameservers:
        addresses:
        - 8.8.8.8
        - 114.114.114.114
EOL

cat <<EOL > /etc/hosts
127.0.0.1 localhost
192.168.182.201 master
192.168.182.202 slave1
192.168.182.203 slave2
# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOL

sudo netplan apply


apt install expect -y


/usr/bin/expect <<EOF
spawn ssh-keygen -t rsa
expect {
    "Enter file in which to save the key*" {
        send "\r"
        exp_continue
    }
    "Overwrite (y/n)?" {
        send "y\r"
        exp_continue
    }
    "Enter passphrase (empty for no passphrase):" {
        send "\r"
        exp_continue
    }
    "Enter same passphrase again:" {
        send "\r"
    }
}
expect eof
EOF

cat << EOL >> /etc/ssh/sshd_config
PermitRootLogin yes
PasswordAuthentication yes
EOL

sudo systemctl restart ssh
