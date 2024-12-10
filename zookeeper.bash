cd /usr/local/zookeeper3.8.4/conf
rm -rf zoo.cfg
cp zoo_sample.cfg zoo.cfg
sed -i '/^dataDir=/c\dataDir=/usr/local/zookeeper3.8.4/data' zoo.cfg
cat <<EOF >> zoo.cfg
server.1=slave1:2888:3888
server.2=slave2:2888:3888
server.3=slave3:2888:3888
EOF

cd /usr/local/zookeeper3.8.4/
mkdir -p data
echo '1' > data/myid

#cat /usr/local/zookeeper3.8.4/data/myid
#cat /usr/local/zookeeper3.8.4/conf/zoo.cfg

