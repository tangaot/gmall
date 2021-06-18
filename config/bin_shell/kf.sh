
#!/bin/bash
#Kafka Cluster
if [ $# -lt 1 ]
then
	echo "Input Args Error!!! USAGE: kf.sh {start|stop}"
	exit;
fi

case $1 in
"start"){
    for i in hadoop102 hadoop103 hadoop104
    do
        echo " --------START $i Kafka-------"
        ssh $i "/opt/module/kafka-2.4.1/bin/kafka-server-start.sh -daemon /opt/module/kafka-2.4.1/config/server.properties "
    done
};;
"stop"){
    for i in hadoop102 hadoop103 hadoop104
    do
        echo " --------STOP $i Kafka-------"
        ssh $i "/opt/module/kafka-2.4.1/bin/kafka-server-stop.sh stop"
    done
};;
esac
