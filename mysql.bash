wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
for package in $(rpm -qa | grep mysql); do
  sudo rpm -e $package
done
sudo rpm -Uvh mysql57-community-release-el7-11.noarch.rpm
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum install mysql-community-server -y
sudo systemctl start mysqld
sudo systemctl enable mysqld

#查看密码并登录
sudo grep 'temporary password' /var/log/mysqld.log | sed 's/.*: //' | xargs -I {} sh -c 'mysql -u root -p"$1" < /dev/tty' sh {}
set global validate_password_policy=LOW;
set global validate_password_length=6;
ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';
grant all privileges on *.* to 'root'@'%' identified by '123456';
FLUSH PRIVILEGES;
EXIT;
