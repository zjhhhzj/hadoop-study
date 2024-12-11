# 进入centos共享文件夹
cd /mnt/hgfs/share

# 函数：询问用户是否覆盖目录
ask_to_override() {
    while true; do
        read -p "目录 $1 已存在。是否覆盖? [yes/no] " yn
        case $yn in
            [Yy]* ) return 0;; # 如果是yes,返回0,继续执行
            [Nn]* ) echo "跳过 $1 的覆盖操作。"; return 1;; # 如果是no,返回1,跳过当前操作
            * ) echo "请输入 yes 或 no。";;
        esac
    done
}

# 函数：解压并移动文件,带有覆盖检查
extract_and_move() {
    tarfile=$1
    destination=$2
    newname=$3

    final_destination="$destination/$newname"
    if [ -d "$final_destination" ]; then
        if ! ask_to_override "$final_destination"; then
            return # 如果用户选择不覆盖,则跳过当前操作
        fi
        rm -rf "$final_destination"
    fi
    # 解压文件到指定目录
    tar -zxvf "$tarfile" -C "$destination/"
    
    # 获取解压后的目录名称
    extracted_dir=$(tar -tf "$tarfile" | head -1 | cut -f1 -d"/")
    # 移动并重命名解压后的目录
    mv "$destination/$extracted_dir" "$final_destination"
}


extract_and_move "jdk-8u431-linux-x64.tar.gz" "/usr/local/" "jdk1.8"
extract_and_move "apache-zookeeper-3.8.4-bin.tar.gz" "/usr/local/" "zookeeper3.8.4"
extract_and_move "hadoop-3.3.6.tar.gz" "/usr/local/" "hadoop3.3.6"
extract_and_move "apache-hive-4.0.1-bin.tar.gz" "/usr/local/" "hive4.0.1"
extract_and_move "hbase-3.0.0-beta-1-bin.tar.gz" "/usr/local/" "hbase3.0.0"
extract_and_move "apache-tomcat-9.0.96.tar.gz" "/usr/local/" "tomcat9"
extract_and_move "spark-3.5.3-bin-hadoop3.tgz" "/usr/local/" "spark3.5.3"
echo "文件增加操作完成。"

cp /mnt/hgfs/share/mysql-connector-j-* /usr/local/hive4.0.1/lib/
echo "hive增加jdbc包"

cp /mnt/hgfs/share/hive-site.xml /usr/local/hive4.0.1/conf/hive-site.xml
echo "hive-site.xml配置完成"



#解决hive和hadoop包冲突
cd /usr/local/hive4.0.1/lib
cp  log4j-slf4j-impl-2.18.0.jar log4j-slf4j-impl-2.18.0.jar.bk
rm -rf log4j-slf4j-impl-2.18.0.jar


#解决hbase和hadoop包冲突
cp  $HBASE_HOME/lib/client-facing-thirdparty/log4j-slf4j-impl-2.17.2.jar $HBASE_HOME/lib/client-facing-thirdparty/log4j-slf4j-impl-2.17.2.jar.bk
rm -rf $HBASE_HOME/lib/client-facing-thirdparty/log4j-slf4j-impl-2.17.2.jar
