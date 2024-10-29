#创建hdfs路径并设置权限
hdfs dfs -mkdir -p /spark-logs
hdfs dfs -chmod 1777 /spark-logs

#启动Spark：
$SPARK_HOME/sbin/start-master.sh
$SPARK_HOME/sbin/start-slave.sh spark://master:7077
#停止Spark：
$SPARK_HOME/sbin/stop-worker.sh
$SPARK_HOME/sbin/stop-master.sh

#暂时Standalone模式
#检查 Spark Master Web UI：
master:8080
#使用 spark-shell 连接到 Spark Master
$SPARK_HOME/bin/spark-shell --master spark://master:7077

