#初始化Metastore
schematool -dbType mysql -initSchema

#准备环境
start-all.sh
hive --service metastore
hive --service hiveserver2 #前台
nohup hive --service hiveserver2 2>&1 &   #后台

#检测
ps -ef | grep hiveserver2
netstat -anp | grep 10000

#启动1
hive
!connect jdbc:hive2://master:10000 root 123456
#启动2
beeline --verbose=true -u jdbc:hive2://master:10000 -n root


