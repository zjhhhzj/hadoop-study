#hadoop3.4.1
#spark4.0.0
#scala2.13.12
#hive4.0.1

sed -i '/^export.*/d' ~/.bashrc

cat <<EOL >> ~/.bashrc
export JAVA_HOME=/usr/local/jdk8
export PATH=\$JAVA_HOME/bin:\$PATH

export SCALA_VERSION=2.13.12
export SCALA_HOME=/usr/local/scala
export PATH=\$PATH:\$SCALA_HOME/bin

export HADOOP_VERSION=3.4.1
export HADOOP_HOME=/usr/local/hadoop\$HADOOP_VERSION
export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop
export HADOOP_MAPRED_HOME=\$HADOOP_HOME
export HADOOP_COMMON_HOME=\$HADOOP_HOME
export HADOOP_HDFS_HOME=\$HADOOP_HOME
export YARN_HOME=\$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native
export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin

export SPARK_VERSION=3.3.4
export SPARK_HOME=/usr/local/spark\$SPARK_VERSION
export PYSPARK_PYTHON=python3
export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin

export HIVE_VERSION=3.1.3
export HIVE_HOME=/usr/local/hive\$HIVE_VERSION
export PATH=\$PATH:\$HIVE_HOME/bin
EOL
source ~/.bashrc

cd $HADOOP_HOME/etc/hadoop
files=("hadoop-env.sh" "yarn-env.sh" "mapred-env.sh")
content=$(cat <<EOL
export HADOOP_OS_TYPE=\${HADOOP_OS_TYPE:-\$(uname -s)}
export JAVA_HOME=/usr/local/jdk8
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

echo "环境变量设置完成"
