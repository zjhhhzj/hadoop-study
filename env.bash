#选择hadoop环境
#hadoop_versions=($hadoop_version 3.1.4 3.3.6)
#read -p "请输入 Hadoop 版本: " hadoop_version
#
#found_hadoop_version=false
#for version in "${hadoop_versions[@]}"; do
#  if [[ "$version" == "$hadoop_version" ]]; then
#    found_hadoop_version=true
#    break
#  fi
#done
#
#if [[ "$found_hadoop_version" == false ]]; then
#  echo "hadoop版本不匹配！"
#  exit 1
#fi

#清理~/.bashrc
sed -i '/^export.*/d' ~/.bashrc
#配置~/.bashrc
cat <<EOL >> ~/.bashrc
export JAVA_HOME=/usr/local/jdk1.8
export PATH=\$PATH:\$JAVA_HOME/bin
export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar

export CATALINA_HOME=/usr/local/tomcat9
export PATH=\$PATH:\$CATALINA_HOME/bin

export HADOOP_HOME=/usr/local/hadoop3.3.6
export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin

export ZOOKEEPER_HOME=/usr/local/zookeeper3.8.4
export PATH=\$PATH:\$ZOOKEEPER_HOME/bin

export HIVE_HOME=/usr/local/hive4.0.1
export PATH=\$PATH:\$HIVE_HOME/bin

export HBASE_HOME=/usr/local/hbase3.0.0
export PATH=\$PATH:\$HBASE_HOME/bin

export SPARK_HOME=/usr/local/spark3.5.3
export PATH=\$PATH:\$SPARK_HOME/bin
EOL

#默认3.3.6
hadoop_version=3.3.6

#配置yum源
sudo wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
#注意清华源已停用

#清理后生成缓存
yum clean all
yum makecache
sudo yum update -y

#解决Java依赖问题
sudo yum install java-1.8.0-openjdk-devel -y


#群集时间同步
yum install -y ntpdate
ntpdate ntp5.aliyun.com

# 安装 expect,talent
sudo yum install expect -y

echo '系统环境变量设置完成'


cd /usr/local/hadoop$hadoop_version/etc/hadoop
files=("hadoop-env.sh" "yarn-env.sh" "mapred-env.sh")
content=$(cat <<EOL
export HADOOP_OS_TYPE=\${HADOOP_OS_TYPE:-\$(uname -s)}
export JAVA_HOME=/usr/local/jdk1.8
export HDFS_JOURNALNODE_USER=root
export HDFS_ZKFC_USER=root
export HDFS_ZKFC_USER=root
export HDFS_JOURNALNODE_USER=root
export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root
export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root
EOL
)
for file in "${files[@]}"; do
    echo "$content" > "$file"
done

echo "hadoop$hadoop_version 环境变量设置完成"


