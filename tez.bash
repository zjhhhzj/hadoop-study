cd /usr/local/hadoop3.3.6/etc/hadoop
vim tez-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
        <property>
		<name>tez.lib.uris</name>
		<value>/user/tez/tez.tar.gz</value> <!-- 这里指向hdfs上的tez.tar.gz包 -->
	</property>
</configuration>

修改mapred-site.xml 文件：
<property>
        <name>mapreduce.framework.name</name>
        <value>yarn-tez</value>
</property>

hadoop_env.sh
TEZ_CONF_DIR=/opt/modules/hadoop-2.7.3/etc/hadoop/tez-site.xml
TEZ_JARS=/opt/modules/tez-0.9.1
export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:${TEZ_CONF_DIR}:${TEZ_JARS}/*:${TEZ_JARS}/lib/*

hdfs dfs -mkdir /user/tez
hdfs dfs -put /usr/local/tez0.10.4/share/tez.tar.gz /user/tez/