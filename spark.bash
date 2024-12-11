#创建hdfs路径并设置权限
hdfs dfs -mkdir -p /spark-logs
hdfs dfs -chmod 1777 /spark-logs

#启动Spark：
$SPARK_HOME/sbin/start-master.sh
$SPARK_HOME/sbin/start-slave.sh spark://master:7077
#停止Spark：
$SPARK_HOME/sbin/stop-worker.sh
$SPARK_HOME/sbin/stop-master.sh

#Standalone 模式:
spark-shell 
#YARN 模式:
spark-shell --master yarn
#Spark 配置连接hive 元数据库
hive --service metastore 
spark-shell
spark.sql("show databases").show


#测试
scala> sc.version
res0: String = 3.5.3
scala> spark.range(10).collect()
Array[Long] = Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)


#检查 Spark Master Web UI：
master:8080
#使用 spark-shell 连接到 Spark Master
$SPARK_HOME/bin/spark-shell --master spark://master:7077




