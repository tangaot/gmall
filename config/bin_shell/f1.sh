#! /bin/bash
#Log collection Flume start-stop script

if [ $# -lt 1 ]
then
	echo"Input Args Error!!! Usage: f1.sh {start|stop}"
	exit;
fi

case $1 in
"start"){
        for i in hadoop102 hadoop103
        do
                echo " --------START $i collect flume-------"
                ssh $i "nohup /opt/module/flume-1.9.0/bin/flume-ng agent --conf-file /opt/module/flume-1.9.0/conf/file-flume-kafka.conf --name a1 -Dflume.root.logger=INFO,LOGFILE >/opt/module/flume-1.9.0/log1.txt 2>&1  &"
        done
};;	
"stop"){
        for i in hadoop102 hadoop103
        do
                echo " --------STOP $i collect flume-------"
                ssh $i "ps -ef | grep file-flume-kafka | grep -v grep |awk  '{print \$2}' | xargs -n1 kill -9 "
        done

};;
esac




