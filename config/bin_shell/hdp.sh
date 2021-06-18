#!/bin/bash
# Hadoop Cluster Start Script
if [ $# -lt 1 ]
then
    echo "No Args Input! USAGE: hdp.sh {start|stop}"
    exit ;
fi
case $1 in
"start")
        echo " =================== START hadoop ==================="

        echo " --------------- START hdfs ---------------"
        ssh hadoop102 "/opt/module/hadoop-3.1.3/sbin/start-dfs.sh"
        echo " --------------- START yarn ---------------"
        ssh hadoop103 "/opt/module/hadoop-3.1.3/sbin/start-yarn.sh"
        echo " --------------- START historyserver ---------------"
        ssh hadoop102 "/opt/module/hadoop-3.1.3/bin/mapred --daemon start historyserver"
;;
"stop")
        echo " =================== STOP hadoop ==================="

        echo " --------------- STOP historyserver ---------------"
        ssh hadoop102 "/opt/module/hadoop-3.1.3/bin/mapred --daemon stop historyserver"
        echo " --------------- STOP yarn ---------------"
        ssh hadoop103 "/opt/module/hadoop-3.1.3/sbin/stop-yarn.sh"
        echo " --------------- STOP hdfs ---------------"
        ssh hadoop102 "/opt/module/hadoop-3.1.3/sbin/stop-dfs.sh"
;;
*)
    echo "Input Args Error! USAGE: hdp.sh {start|stop}"
;;
esac
