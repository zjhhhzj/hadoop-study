sudo apt update
sudo apt install -y openjdk-11-jdk ssh pdsh

# 创建安装目录
mkdir -p ~/hadoop
cd ~/hadoop

# 下载 Hadoop 3.3.6
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz

# 解压
tar -xzf hadoop-3.3.6.tar.gz

# Hadoop 环境变量
vim  ~/.bashrc
export HADOOP_HOME=$HOME/hadoop/hadoop-3.3.6
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export HADOOP_YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

source ~/.bashrc

vim $HADOOP_HOME/etc/hadoop/hadoop-env.sh
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64


# 创建安装目录
mkdir -p ~/spark
cd ~/spark
wget https://dlcdn.apache.org/spark/spark-3.5.5/spark-3.5.5-bin-hadoop3.tgz
tar -xzf spark-3.5.5-bin-hadoop3.tgz 

~/.bashrc
# Spark 环境变量
export SPARK_HOME=$HOME/spark/spark-3.5.5-bin-hadoop3
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
export PYSPARK_PYTHON=python3

#配置 Spark 使用 Hadoop
cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh
#添加以下内容：
vim $SPARK_HOME/conf/spark-env.sh
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
export SPARK_DIST_CLASSPATH=$($HADOOP_HOME/bin/hadoop classpath)
source ~/.bashrc

# 验证安装
hadoop version
spark-shell --version




~/hadoop/hadoop-3.3.6/etc/hadoop
cat << EOL > core-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/home/zj/hadoop/tmp</value>
    </property>
</configuration>
EOL

cat << EOL > hdfs-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>/home/zj/hadoop/hdfs/namenode</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/home/zj/hadoop/hdfs/datanode</value>
    </property>
    <property>
        <name>dfs.permissions</name>
        <value>false</value>
    </property>
</configuration>
EOL

cat << EOL > yarn-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services.mapreduce_shuffle.class</name>
        <value>org.apache.hadoop.mapred.ShuffleHandler</value>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>localhost</value>
    </property>
    <property>
        <name>yarn.nodemanager.resource.memory-mb</name>
        <value>4096</value>
            </property>
</configuration>
EOL

cat << EOL >  mapred-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
        <description>MapReduce framework name</description>
    </property>
    <property>
        <name>mapreduce.application.classpath</name>
        <value>$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*</value>
    </property>
</configuration>
EOL

ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
# 设置正确的权限
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

ssh localhost



$HADOOP_HOME/bin/hdfs namenode -format
$HADOOP_HOME/sbin/start-all.sh

hdfs dfs -mkdir -p /spark-history
hdfs dfs -chmod 777 /spark-history
hdfs dfs -ls /


cd $SPARK_HOME/conf/
cat << EOL > spark-defaults.conf
# 默认主节点 URL
spark.master                     yarn

# 应用程序名称
spark.app.name                   zj_spark

# Spark 历史服务器配置
spark.eventLog.enabled           true
spark.eventLog.dir               hdfs://localhost:9000/spark-history
spark.history.fs.logDirectory    hdfs://localhost:9000/spark-history

# 执行器配置
spark.executor.memory            1g
spark.executor.cores             2
spark.executor.instances         2

# 驱动器配置
spark.driver.memory              1g

# Hadoop 集成配置
spark.hadoop.fs.defaultFS        hdfs://localhost:9000

# 序列化配置
spark.serializer                 org.apache.spark.serializer.KryoSerializer
EOL

cat << EOL > spark-env.sh
#!/usr/bin/env bash

# Spark 环境变量
export SPARK_HOME=/home/zj/spark/spark-3.5.5-bin-hadoop3
export HADOOP_HOME=/home/zj/hadoop/hadoop-3.3.6
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
export SPARK_DIST_CLASSPATH=$($HADOOP_HOME/bin/hadoop classpath)

# Java 配置
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Spark 历史服务器配置
export SPARK_HISTORY_OPTS="-Dspark.history.ui.port=18080 -Dspark.history.fs.logDirectory=hdfs:///spark-history"

# Spark 本地目录
export SPARK_LOCAL_DIRS=/home/zj/spark/tmp

# Spark 日志配置
export SPARK_LOG_DIR=/home/zj/spark/logs

# Spark Worker 配置
export SPARK_WORKER_CORES=2
export SPARK_WORKER_MEMORY=2g
export SPARK_WORKER_INSTANCES=1
EOL
cat << EOL > log4j2.properties
# 设置根日志级别为 INFO，并输出到控制台
rootLogger.level = info
rootLogger.appenderRef.stdout.ref = console

# 控制台 appender 配置
appender.console.type = Console
appender.console.name = console
appender.console.layout.type = PatternLayout
appender.console.layout.pattern = %d{yy/MM/dd HH:mm:ss} %p %c{1}: %m%n

# 设置一些包的日志级别
logger.spark.name = org.apache.spark
logger.spark.level = info

logger.hadoop.name = org.apache.hadoop
logger.hadoop.level = info

logger.yarn.name = org.apache.hadoop.yarn
logger.yarn.level = info
EOL

cat << EOL > workers
localhost
EOL




配置完成后，可以通过以下方式验证 Spark 配置：

复制
# 启动 Spark shell 并连接到 YARN
$SPARK_HOME/bin/spark-shell --master yarn

# 查看 Spark 配置
scala> sc.getConf.getAll.foreach(println)




#测试
# 创建目录
hdfs dfs -mkdir -p /spark-test

# 创建文件并写入内容
echo "zjhhh" | hdfs dfs -put - /spark-test/sample.txt

# 验证文件是否创建成功
hdfs dfs -cat /spark-test/sample.txt

#读取 HDFS 上的文件
val data = spark.read.textFile("hdfs:///spark-test/sample.txt")
data.show()

#将结果写回 HDFS
data.write.text("hdfs:///spark-test/output")