# hadoop-study
### 版本:
  hadoop-3.3.6  
  jdk-1.8  
  zookeeper-3.8.4  
  hbase-3.0.0  
  hive-4.0.0  

  选择以下链接**下载**  
  https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz  
  https://www.oracle.com/cn/java/technologies/javase/javase8-archive-downloads.html （需要自己创建账号）  
  https://dlcdn.apache.org/zookeeper/zookeeper-3.8.4/apache-zookeeper-3.8.4-bin.tar.gz  
  https://dlcdn.apache.org/hbase/3.0.0-beta-1/hbase-3.0.0-beta-1-bin.tar.gz  
  https://dlcdn.apache.org/hive/hive-4.0.1/apache-hive-4.0.1-bin.tar.gz  

### 第一步：  
  下载centos7，在VMware上安装，开启共享文件夹选项（取名为share，目录在/mnt/hgfs/share下）  

### 第二步：  
  运行put.bash，将基本文件上传  

### 第三步：    
  运行env.bash，配置基本环境，下载依赖包，必要软件  

### 第四步：  
  运行mysql.bash，安装mysql，默认密码为123456

### 第五步：  
  运行xml.bash，配置Hadoop，Hbase，Hive，Spark的配置文件

### 第六步：  
  复制master节点，有master，master2，slave1，slave2，slave3五个服务器，复制好后在每个节点运行对应的网络初始化bash文件

### 第七步： 
  在slave1，slave2，slave3中运行zookeeper.bash，注意echo '1' > data/myid中的1根据slave后面编号变化为1，2，3。

### 第八步： 
  在启动测试.bash中进行测试  
  每个zookeeper节点运行zkServer.sh start  
  用zkServer.sh status检查  
  成功后每个zookeeper节点运行hdfs --daemon start journalnode  
  在master上进行初始化hdfs namenode -format ，hdfs zkfc -formatZK  
  在master2上备份hdfs namenode -bootstrapStandby 
  可以根据zkCli.sh -server slave1:2181 》ls /hadoop-ha进行检测  
  准备启动hdfs等 start-all.sh   
  测试hadoop jar /usr/local/hadoop3.3.6/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar pi 10 10
  
### 第九步： 
  根据hive.bash，hbase.bash，spark.bash文档配置好hive，hbase，spark

### 总结
  还是要多看看官方文档，一部分的错误记录在log.txt上，tomcat还没完善，但是应该可以基本使用，spark也是暂时Standalone模式，等以后学校课程有要求再研究吧

  
