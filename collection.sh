#/bin/bash

cur_path=/opt/monitor/oracle
vartime=`date -d yesterday '+%Y-%m-%d'`
filename="localhost_access_logtime."$vartime".txt"
echo $filename
#filepaths=$0
collection_path=$cur_path"/"$vartime"/collection/"
mkdir -p $collection_path
result_path=$cur_path"/"$vartime"/result/"
mkdir -p $result_path
result_log=$result_path"result.log"
file_paths=(root@10.10.22.71:/opt/resin/resin-video-api4-server-live/log/access.log root@10.10.22.71:/opt/resin/resin-video-api4-server-live/log/access.log root@10.10.22.71:/opt/resin/resin-video-api4-server-live/log/access.log)
for log in ${file_paths[@]}
do
   scp -r $log $collection_path
   cat  $collection_path/* >>  $result_log
   rm -rf $collection_path/* 
done






