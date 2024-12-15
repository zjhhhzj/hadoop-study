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

hadoop_version=3.3.6

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
        <value>hdfs://mycluster</value>
    </property>
    <property>
        <name>ha.zookeeper.quorum</name>
        <value>slave1:2181,slave2:2181,slave3:2181</value>
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
        <name>dfs.ha.automatic-failover.enabled</name>
        <value>true</value>
    </property>
    <property>
        <name>dfs.nameservices</name>
        <value>mycluster</value>
    </property>
    <property>
        <name>dfs.ha.namenodes.mycluster</name>
        <value>nn1,nn2</value>
    </property>
    <property>
        <name>dfs.namenode.rpc-address.mycluster.nn1</name>
        <value>master:8020</value>
    </property>
    <property>
        <name>dfs.namenode.rpc-address.mycluster.nn2</name>
        <value>master2:8020</value>
    </property>
    <property>
        <name>dfs.namenode.http-address.mycluster.nn1</name>
        <value>master:50070</value>
    </property>
    <property>
        <name>dfs.namenode.http-address.mycluster.nn2</name>
        <value>master2:50070</value>
    </property>
    <property>
        <name>dfs.namenode.shared.edits.dir</name>
        <value>qjournal://slave1:8485;slave2:8485;slave3:8485/mycluster</value>
    </property>
    <property>
        <name>dfs.client.failover.proxy.provider.mycluster</name>
        <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
    </property>

    <property>
        <name>dfs.ha.fencing.methods</name>
        <value>sshfence</value>
    </property>
    <property>
        <name>dfs.ha.fencing.ssh.private-key-files</name>
        <value>/root/.ssh/id_rsa</value>
    </property>
    <property>
        <name>dfs.ha.fencing.ssh.connect-timeout</name>
        <value>30000</value> <!-- 30 seconds -->
    </property>

    <property>
        <name>dfs.replication</name>
        <value>3</value>
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
        <name>yarn.resourcemanager.ha.enabled</name>
        <value>true</value>
    </property>
    <property>
        <name>yarn.resourcemanager.cluster-id</name>
        <value>mycluster</value>
    </property>
    <property>
        <name>yarn.resourcemanager.ha.rm-ids</name>
        <value>rm1,rm2</value>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname.rm1</name>
        <value>master</value>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname.rm2</name>
        <value>master2</value>
    </property>
    <property>
        <name>yarn.resourcemanager.webapp.address.rm1</name>
        <value>master:8088</value>
    </property>
    <property>
        <name>yarn.resourcemanager.webapp.address.rm2</name>
        <value>master2:8088</value>
    </property>
    <property>
        <name>yarn.resourcemanager.zk-address</name>
        <value>slave1:2181,slave2:2181,slave3:2181</value>
    </property>
    <property>
        <name>yarn.resourcemanager.recovery.enabled</name>
        <value>true</value>
    </property>
    <property>
        <name>yarn.resourcemanager.store.class</name>
        <value>org.apache.hadoop.yarn.server.resourcemanager.recovery.ZKRMStateStore</value>
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

    <name>yarn.application.classpath</name>
    <value>
        /usr/local/hadoop3.3.6/etc/*,
        /usr/local/hadoop3.3.6/etc/hadoop/*,
        /usr/local/hadoop3.3.6/lib/*,
        /usr/local/hadoop3.3.6/share/hadoop/common/*,
        /usr/local/hadoop3.3.6/share/hadoop/common/lib/*,
        /usr/local/hadoop3.3.6/share/hadoop/mapreduce/*,
        /usr/local/hadoop3.3.6/share/hadoop/mapreduce/lib/*,
        /usr/local/hadoop3.3.6/share/hadoop/hdfs/*,
        /usr/local/hadoop3.3.6/share/hadoop/hdfs/lib/*,
        /usr/local/hadoop3.3.6/share/hadoop/yarn/*,
        /usr/local/hadoop3.3.6/share/hadoop/yarn/lib/*,
        /usr/local/hbase3.0.0/lib/*,
        /usr/local/hive4.0.1/lib/*
    </value>
</configuration>
EOL
echo "yarn-site.xml 配置完成。"

cat <<EOL > slaves
slave1
slave2
slave3
EOL

cat <<EOL > workers
slave1
slave2
slave3
EOL

echo "slaves or workers 配置完成。"

######################################################################################################################################################
cd /usr/local/hbase3.0.0/conf
cat <<EOL > hbase-site.xml
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
      <name>hbase.cluster.distributed</name>
      <value>true</value>
    </property>
    <property>
      <name>hbase.tmp.dir</name>
      <value>/usr/local/hbase3.0.0/tmp</value>
    </property>
    <property>
        <name>hbase.unsafe.stream.capability.enforce</name>
        <value>false</value>
        <!--不检查安全的数据流功能支持,可能带来数据损坏或安全风险,但可以提高与旧版本客户端或服务端的兼容性-->
    </property>

    <property>
      <name>hbase.zookeeper.quorum</name>
      <value>slave1,slave2,slave3</value>
    </property>
    <property>
      <name>hbase.zookeeper.property.clientPort</name>
      <value>2181</value>
    </property>

    <property>
      <name>hbase.rootdir</name>
      <value>hdfs://mycluster/hbase</value>
    </property>
    <property>
      <name>dfs.nameservices</name>
      <value>mycluster</value>
    </property>
    <property>
      <name>dfs.ha.namenodes.mycluster</name>
      <value>nn1,nn2</value>
    </property>
    <property>
      <name>dfs.namenode.rpc-address.mycluster.nn1</name>
      <value>master:8020</value>
    </property>
    <property>
      <name>dfs.namenode.rpc-address.mycluster.nn2</name>
      <value>master2:8020</value>
    </property>
    <property>
      <name>hbase.master.port</name>
      <value>16000</value>
    </property>
        <property>
      <name>hbase.regionserver.port</name>
      <value>61000</value>
    </property>

    <property>
      <name>hbase.regionserver.pid.file</name>
      <value>/tmp/hbase-root-regionserver.pid</value>
    </property>

    <!--hbase的web页面-->
    <property>
      <name>hbase.master.info.port</name>
      <value>60010</value>
    </property>
</configuration>
EOL

cat <<EOL > hbase-env.sh
export JAVA_HOME=/usr/local/jdk1.8
#设置 HBase 的类路径,使其包含 Hadoop 配置文件的路径,以便 HBase 在分布式模式下能够找到 Hadoop 的相关配置
export HBASE_CLASSPATH=/usr/local/hadoop3.3.6/conf 
#设置hbase不使用自身带的zookeeper
export HBASE_MANAGES_ZK=flase
#设置hbase不使用hadoop的依赖和类库
export HBASE_DISABLE_HADOOP_CLASSPATH_LOOKUP=true
EOL

cat <<EOL > regionservers
slave1
slave2
slave3
EOL

#cp $HADOOP_HOME/etc/hadoop/hdfs-site.xml /usr/local/hbase3.0.0/conf
#cp $HADOOP_HOME/etc/hadoop/core-site.xml /usr/local/hbase3.0.0/conf

echo "Hbase配置完成。"

######################################################################################################################################################
cd /usr/local/hive4.0.1/conf

#将Hive安装目录中conf下的  hive-log4j.properties.template    重命名
cp  hive-log4j2.properties.template  hive-log4j2.properties
sed -i 's|^property.hive.log.dir.*|property.hive.log.dir= /usr/local/hive4.0.1/logs|' hive-log4j2.properties

echo "Hive配置完成。"

######################################################################################################################################################
cd /usr/local/spark3.5.3/conf

cp /usr/local/hive4.0.1/conf/hive-site.xml  /usr/local/spark3.5.3/conf/
cp /usr/local/hadoop3.3.6/etc/hadoop/core-site.xml  /usr/local/spark3.5.3/conf/
cp /usr/local/hadoop3.3.6/etc/hadoop/hdfs-site.xml  /usr/local/spark3.5.3/conf/

cat <<EOL > spark-env.sh
export SPARK_MASTER_HOST=master
export SPARK_MASTER_PORT=7077
export HADOOP_CONF_DIR=/usr/local/hadoop3.3.6/etc/hadoop
EOL

cat <<EOL >spark-defaults.conf
spark.master                     spark://master:7077
spark.eventLog.enabled           true
spark.eventLog.dir               hdfs://mycluster/spark-logs
spark.history.fs.logDirectory    hdfs://mycluster/spark-logs
EOL

cat <<EOL > workers
slave1
slave2
slave3
EOL

echo "Spark配置完成。"
