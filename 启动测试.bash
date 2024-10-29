###zookeeper
zkServer.sh start
zkServer.sh restart
zkServer.sh status
#端口占用情况
netstat -tuln | grep 2181

hdfs --daemon start journalnode //slave运行
hdfs namenode -format 

hdfs zkfc -formatZK
zkCli.sh -server slave1:2181
ls /hadoop-ha

hdfs --daemon start namenode //master1
hdfs namenode -bootstrapStandby //master2

start-all.sh 
hdfs dfsadmin -safemode  get 
hdfs dfsadmin -safemode enter 
hdfs dfsadmin -safemode  leave 
hadoop jar /usr/local/hadoop3.3.6/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar pi 10 10


hdfs haadmin -transitionToActive nn1
hdfs haadmin -getServiceState nn1


start-all.sh
[root@master zj]# jps
2993 NameNode
3777 ResourceManager
4817 DFSZKFailoverController
5330 Jps

[root@slave1 zj]# jps
3088 NodeManager
2849 DataNode
2963 JournalNode
3269 QuorumPeerMain
3533 Jps
