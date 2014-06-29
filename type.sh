#!/bin/bash
#######################
#need linux sqlplus
#######################

sqlplus=/usr/lib/oracle/11.2/client64/bin/sqlplus
log_path=/opt/monitor/oracle/localhost_access_logtime.2014-06-12.txt
base_path=/opt/monitor/oracle/
username=SYSTEM
password=123456
serverid=appdb
date=2014-06-11
servername="bus_transfer"
data_temp=$base_path"data.temp"
replace_temp=$base_path"replace.temp"
sql_temp=$base_path"sql.temp"

echo `date +'%H:%m:%S'`"statistics result:"$data_temp

#cat $log_path|awk '{print $4" "$8"&"}'|awk -F "a_k=|key=" '{print substr($2,1,index($2,"&")-1)" "$1$2}'|awk '{print substr($2,2,length($2))" "$1}'|sed -e"s/$/ $servername/g " >$data_temp
cat $log_path|awk '{print $7"&"}'|awk -F "a_k=|key=" '{print substr($2,1,index($2,"&")-1)}'|sed -e '/^$/d'|awk '{a[$0]+=1}END{for(i in a ){print i" "a[i]}}'|sed -e"s/$/ $servername/g" -e"s/$/ $date/g"|awk '{print $1" "$2" "$3" "$4}'>$data_temp 

echo `date +'%H:%m:%S'`"statistics temp:"$replace_temp
cat $data_temp|awk '{print "INSERT INTO analysis_type values(a_sequence.nextval,|"$1"|,|"$4"|,|"$3"|,|"$2"|);"}'>$replace_temp

echo `date +'%H:%m:%S'`"statistics table_name:"$sql_temp
cat $replace_temp|while read line
do
        echo ${line//|/\'} >>$sql_temp
done

echo 'exit' >>$sql_temp

echo `date +'%H:%m:%S'`"statistics sqlplus:"
$sqlplus $username/$password@$serverid @$sql_temp

rm -rf $data_temp
rm -rf $replace_temp
rm -rf $sql_temp

echo `date +'%H:%m:%S'`" is done"

