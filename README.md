# hadoop-study
### 版本:
  hadoop-3.3.6  
  jdk-1.8  
  zookeeper-3.8.4  
  hbase-3.0.0  
  hive-4.0.0  
  spark-3.5.3
  tez-0.10.4
  tomcat-9.0.96(注意10及以上版本不支持jdk8)
  选择以下链接**下载**  
  https://mirrors.huaweicloud.com/centos/7/isos/x86_64/CentOS-7-x86_64-DVD-2207-02.iso (清华源已经不支持)
  https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz  
  https://www.oracle.com/cn/java/technologies/javase/javase8-archive-downloads.html （需要自己创建账号）  
  https://dlcdn.apache.org/zookeeper/zookeeper-3.8.4/apache-zookeeper-3.8.4-bin.tar.gz  
  https://dlcdn.apache.org/hbase/3.0.0-beta-1/hbase-3.0.0-beta-1-bin.tar.gz  
  https://dlcdn.apache.org/hive/hive-4.0.1/apache-hive-4.0.1-bin.tar.gz  
  https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-j-9.0.0.zip(jdbc包解压取出jar包)
  https://dlcdn.apache.org/tez/0.10.4/apache-tez-0.10.4-bin.tar.gz
### 第一步：  
  下载centos7，在VMware上安装，开启共享文件夹选项（取名为share，目录在/mnt/hgfs/share下），我的root密码为zj，按需求更改。

### 第二步：  
  运行put.bash，将基本文件上传  

### 第三步：    
  运行env.bash，配置基本环境，下载依赖包，必要软件  

### 第四步：  
  运行mysql.bash，安装mysql，默认密码为123456

### 第五步：  
  运行xml.bash，配置Hadoop，Hbase，Hive，Spark的配置文件

### 第六步：  
  复制master节点，有master，master2，slave1，slave2，slave3五个服务器，复制好后在每个节点运行对应的网络初始化bash文件，最后每个节点运行ssh.bash文件，完成网络通信(注意root密码)

### 第七步： 
  在slave1，slave2，slave3中运行zookeeper.bash，注意echo '1' > data/myid中的1根据slave后面编号变化为1，2，3。

### 第八步： 
  在启动测试.bash中进行测试  
  每个zookeeper节点运行zkServer.sh start  
  用zkServer.sh status检查  
  成功后每个zookeeper节点运行hdfs --daemon start journalnode  

  在master上进行初始化
  hdfs namenode -format
  hdfs zkfc -formatZK  
  启动master的namenode节点  
  hadoop-daemon.sh start namenode
  在master2上备份
  hdfs namenode -bootstrapStandby 

  可以根据
  zkCli.sh -server slave1:2181 
  》ls /hadoop-ha进行检测  
  
  准备启动hdfs等 start-all.sh   
  测试hadoop jar /usr/local/hadoop3.3.6/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar pi 10 10
  
### 第九步： 
  根据hive.bash，hbase.bash，spark.bash文档配置好hive，hbase，spark

### 总结
  还是要多看看官方文档，一部分的错误记录在log.txt上，tomcat还没完善，但是应该可以基本使用，spark也是暂时Standalone模式，等以后学校课程有要求再研究吧
  至于tez，本来想在hive上配置，但感觉是虚拟机配置给低了，mr就凑合着用吧

  
