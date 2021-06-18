#!/bin/bash
#Cluster log generation script

for i in hadoop102;
do
	echo "############## $i ###############"
	ssh $i "cd /opt/module/db_log/; java -jar gmall2020-mock-db-2021-01-22.jar > /dev/null 2>&1 &"
done

