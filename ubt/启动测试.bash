wget https://archive.apache.org/dist/hive/hive-4.0.1/apache-hive-4.0.1-bin.tar.gz


hdfs namenode -format -force

start-all.sh 

hadoop jar /usr/local/hadoop3.3.6/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar pi 10 10

root@master:/home/zj# jps
17856 NameNode
18196 SecondaryNameNode
18889 Jps
18430 ResourceManager


root@slave1:/usr/local/hadoop3.3.6/logs# jps
10785 DataNode
11169 Jps
10986 NodeManager

#初始化
hive --service metastore 
#启动
hive --service hiveserver2 
beeline -u jdbc:hive2://localhost:10000 -n root -p 123456


cd /usr/local/spark4.0.0/sbin/
./start-all.sh
./start-history-server.sh

./stop-all.sh
./stop-history-server.sh

root@master:/usr/local/spark3.3.4/sbin# jps
23360 ResourceManager
22805 NameNode
23130 SecondaryNameNode
23787 Master
23886 HistoryServer
23951 Jps

root@slave1:/usr/local/hadoop3.3.6/logs# jps
12976 Worker
13058 Jps
12482 DataNode
12726 NodeManager
