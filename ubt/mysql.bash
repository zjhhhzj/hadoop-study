wget https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-j_8.4.0-1ubuntu24.04_all.deb
mkdir tmp_deb
dpkg-deb -x mysql-connector-j_8.4.0-1ubuntu24.04_all.deb tmp_deb/
cp tmp_deb/usr/share/java/mysql-connector-j-8.4.0.jar /usr/local/hive3/lib
cp tmp_deb/usr/share/java/mysql-connector-j-8.4.0.jar /usr/local/spark3.3.4/jars/