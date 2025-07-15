rm -rf t.bash
vim t.bash
bash t.bash

#read -p "请输入 Hadoop 版本: " hadoop_version
#hadoop_versions=(2.9.2 3.1.4 3.3.6)
#found_hadoop_version=false
#for version in "${hadoop_versions[@]}"; do
#  if [[ "$version" == "$hadoop_version" ]]; then
#    echo "$version ok"
#    found_hadoop_version=true
#    break
#  fi
#done
#if [[ "$found_hadoop_version" == false ]]; then
#  echo "hadoop版本不匹配！"
#  exit 1
#fi

hadoop_version=3.4.1

cd /usr/local/hadoop$hadoop_version/etc/hadoop

function remove_configuration_section() {
  # 检查文件是否存在
  if [ ! -f "$1" ]; then
    echo "Error: File '$1' not found."
    exit 1
  fi

  # 查找 <configuration> 标签的位置并删除其后的所有内容,包括 <configuration> 标签本身
  sed -i '/<configuration>/,$d' "$1"

  echo "Configuration section removed successfully from '$1'."
}


remove_configuration_section "core-site.xml"
remove_configuration_section "hdfs-site.xml"
remove_configuration_section "mapred-site.xml"
remove_configuration_section "yarn-site.xml"

cat <<EOL > core-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://master:8020</value>
    </property>

    <!-- 允许用root用户登录hive -->
    <property>
        <name>hadoop.proxyuser.root.hosts</name>
        <value>*</value>
    </property>
    <property>
        <name>hadoop.proxyuser.root.groups</name>
        <value>*</value>
    </property>

</configuration>
EOL
echo "core-site.xml 配置完成。"

cat <<EOF > hdfs-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
    <property>
        <name>dfs.replication</name>
        <value>3</value>
    </property>
     <!-- NameNode RPC 绑定地址 -->
    <property>
        <name>dfs.namenode.rpc-bind-host</name>
        <value>0.0.0.0</value>
    </property>
    
    <!-- NameNode HTTP 绑定地址 -->
    <property>
        <name>dfs.namenode.http-bind-host</name>
        <value>0.0.0.0</value>
    </property>
    
    <!-- 可选：明确指定 NameNode RPC 地址 -->
    <property>
        <name>dfs.namenode.rpc-address</name>
        <value>master:8020</value>
    </property>
</configuration>
EOF
echo "hdfs-site.xml 配置完成。"

cat <<EOL > mapred-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.jobhistory.address</name>
        <value>master:10020</value>
    </property>
    <property>
        <name>mapreduce.jobhistory.webapp.address</name>
        <value>master:19888</value>
    </property>
</configuration>
EOL
echo "mapred-site.xml 配置完成。"

cat <<EOL > yarn-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>master</value>
    </property>

    <property>
      <name>yarn.nodemanager.env-whitelist</name>
      <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_HOME,PATH,LANG,TZ,HADOOP_MAPRED_HOME</value>
    </property>

    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services.mapreduce_shuffle.class</name>
        <value>org.apache.hadoop.mapred.ShuffleHandler</value>
    </property>

    <property>
        <name>yarn.application.classpath</name>
        <value>
            /usr/local/hadoop3.4.1/etc/hadoop/,
            /usr/local/hadoop3.4.1/lib/*,
            /usr/local/hadoop3.4.1/share/hadoop/common/*,
            /usr/local/hadoop3.4.1/share/hadoop/common/lib/*,
            /usr/local/hadoop3.4.1/share/hadoop/mapreduce/*,
            /usr/local/hadoop3.4.1/share/hadoop/mapreduce/lib/*,
            /usr/local/hadoop3.4.1/share/hadoop/hdfs/*,
            /usr/local/hadoop3.4.1/share/hadoop/hdfs/lib/*,
            /usr/local/hadoop3.4.1/share/hadoop/yarn/*,
            /usr/local/hadoop3.4.1/share/hadoop/yarn/lib/*,
            /usr/local/hive3.1.3/lib/*
        </value>
    </property>
</configuration>
EOL
echo "yarn-site.xml 配置完成。"

cat <<EOL > slaves
slave1
slave2
EOL

cat <<EOL > workers
slave1
slave2
EOL

echo "slaves or workers 配置完成。"


######################################################################################################################################################
cd /usr/local/hive3.1.3/conf

cat <<EOL > hive-env.sh
export HADOOP_HOME=/usr/local/hadoop3.4.1
EOL

cat <<EOL >hive-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
   <name>hive.exec.scratchdir</name>
   <value>hdfs://master:8020/user/hive/tmp</value>
  </property>
  <property>
   <name>hive.metastore.warehouse.dir</name>
   <value>hdfs://master:8020/user/hive/warehouse</value>
  </property>
  <property>
   <name>hive.querylog.location</name>
   <value>hdfs://master:8020/user/hive/log</value>
  </property>
  <property>
   <name>hive.metastore.uris</name>
   <value>thrift://master:9083</value>
  </property>

  <property>
   <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:mysql://master:3306/hive?createDatabaseIfNotExist=true&amp;characterEncoding=UTF-8&amp;useSSL=false&amp;allowPublicKeyRetrieval=true</value>
  </property>
  <property>
   <name>javax.jdo.option.ConnectionDriverName</name>
   <value>com.mysql.cj.jdbc.Driver</value>
  </property>
  <property>
   <name>javax.jdo.option.ConnectionUserName</name>
   <value>root</value>
  </property>
  <property>
   <name>javax.jdo.option.ConnectionPassword</name>
<value>123456</value>
  </property>
 <property>
  <name>hive.metastore.schema.verification</name>
  <value>false</value>
 </property>
<property>
  <name>datanucleus.schema.autoCreateAll</name>
  <value>true</value>
 </property>
</configuration>
EOL

rm -rf /usr/local/hive3.1.3/lib/guava*
cp /usr/local/hadoop3.4.1/share/hadoop/common/lib/guava-27.0-jre.jar /usr/local/hive3.1.3/lib/

echo "Hive配置完成。"

######################################################################################################################################################
cd /usr/local/spark4.0.0/conf

cp /usr/local/hive3.1.3/conf/hive-site.xml  /usr/local/spark4.0.0/conf/
scp /usr/local/hive3.1.3/conf/hive-site.xml  root@slave2:/usr/local/spark4.0.0/conf/

mv log4j2.properties.template log4j2.properties
cp /usr/local/hadoop3.4.1/etc/hadoop/core-site.xml  /usr/local/spark4.0.0/conf/
cp /usr/local/hadoop3.4.1/etc/hadoop/hdfs-site.xml  /usr/local/spark4.0.0/conf/

cat <<EOL > spark-env.sh
export SPARK_MASTER_HOST=master
export SPARK_MASTER_PORT=7077
export HADOOP_CONF_DIR=/usr/local/hadoop3.4.1/etc/hadoop
export JAVA_HOME=/usr/local/jdk8
export SPARK_WORKER_MEMORY=1g
export SPARK_WORKER_CORES=1
export SPARK_EXECUTOR_MEMORY=1g
export SPARK_EXECUTOR_CORES=1
export SPARK_WORKER_INSTANCES=1
export SPARK_CLASSPATH=/usr/local/spark4.0.0/jars/mysql-connector-j-8.4.0.jar
EOL

cat <<EOL >spark-defaults.conf
spark.master                     spark://master:7077
spark.eventLog.enabled           true
spark.eventLog.dir               hdfs://master:8020/spark-logs
spark.history.fs.logDirectory    hdfs://master:8020/spark-logs
EOL

cat <<EOL > workers
slave1
slave2
EOL

echo "Spark配置完成。"
