sudo hostnamectl set-hostname slave2

sudo systemctl disable firewalld

cat <<EOL > /etc/sysconfig/network-scripts/ifcfg-ens33
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="static"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="ens33"
UUID="cf653108-a07b-4dc1-ad1a-ebcb5537f1f3"
DEVICE="ens33"
ONBOOT="yes"
IPADDR="192.168.209.112"
NETMASK="255.255.255.0"
GATEWAY="192.168.209.2"
DNS1="192.168.209.2"
DNS2="114.114.114.114"
EOL
cat <<EOL > /etc/hosts
#127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
#::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.209.101 master
192.168.209.102 master2
192.168.209.111 slave1
192.168.209.112 slave2
192.168.209.113 slave3 
EOL

service network restart

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
