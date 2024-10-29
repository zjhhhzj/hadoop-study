start-hbase.sh 

#停止 RegionServer 进程
#停止 Active HMaster 进程
#停止 Hbase
hbase-daemon.sh stop regionserver
hbase-daemon.sh stop master
stop-hbase.sh

hbase-daemon.sh start regionserver

slf4j-reload4j-1.7.36.jar 
log4j-slf4j-impl-2.17.2.jar 
cp  $HBASE_HOME/lib/client-facing-thirdparty/log4j-slf4j-impl-2.17.2.jar $HBASE_HOME/lib/client-facing-thirdparty/log4j-slf4j-impl-2.17.2.jar.bk
rm -rf $HBASE_HOME/lib/client-facing-thirdparty/log4j-slf4j-impl-2.17.2.jar


#测试
#进入 HBase Shell
hbase shell
#查看状态
status
#创建表,这里 'test' 是表名,'cf' 是列族名。
create 'test', 'cf'
#插入数据,这条命令将在表 'test' 的 row1 行、列 'cf:a' 中插入值 'value1'。
put 'test', 'row1', 'cf:a', 'value1'
#读取数据,这将获取表 'test' 中 row1 行的所有数据。
get 'test', 'row1'
#扫描表中的所有数据：
scan 'test'
#从表中删除一行数据：
delete 'test', 'row1', 'cf:a'
#删除一个表之前需要先禁用它：
disable 'test'
drop 'test'

#使用 HBase Web UI
Master UI: http://master:60010
RegionServer UI: http://<regionserver-host>:16030

#删除 HDFS 上的 HBase 数据
hdfs dfs -rm -r /hbase 
#删除 ZooKeeper 上的 HBase 数据
zkCli.sh -server slave1:2181
deleteall /hbase




