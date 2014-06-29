#!/bin/bash
#######################
#need linux sqlplus
#######################

sqlplus=/usr/lib/oracle/11.2/client64/bin/sqlplus
log_path=/opt/monitor/oracle/zuojiu.txt
base_path=/opt/monitor/oracle/
username=SYSTEM
password=123456
serverid=appdb
date=2013-05-01
servername="bus_transfer"
data_temp=$base_path"data.temp"
replace_temp=$base_path"replace.temp"
sql_temp=$base_path"sql.temp"

echo `date +'%H:%m:%S'`"statistics result:"$data_temp


#cat $log_path|awk '{print  substr($4,2,length($4))" "substr($5,1,length($5)-3)":00 "$8}'|awk -F 'a_k=|key=' '{print $1" "$2}'|awk '{print $1" "$2" "$4}'|awk -F '&' '{print $1}'|awk '{a[$0]+=1}END{for(i in a){print i" "a[i]}}' >$data_temp

cat localhost_access_logtime.2014-06-12.txt|grep "a_k=\|key="|awk '{print  substr($4,14,5)":00 "$7"&"}'|awk -F 'a_k=|key=' '{print $1" "$2}'|awk '{print $1" "$3}'|awk -F "&" '{print $1}'|awk '{a[$0]+=1}END{for(i in a){print i" "a[i]}}'|sed -e"s/$/ $date/g" >$data_temp

echo `date +'%H:%m:%S'`"statistics temp:"$replace_temp
cat $data_temp|awk '{print "INSERT INTO analysis_group values(a_sequence.nextval,|"$2"|,|"$4" "$1"|,|"$3"|);"}'>$replace_temp

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

