#!/bin/bash
#######################
#need linux sqlplus
#
#######################

sqlplus=/usr/lib/oracle/11.2/client64/bin/sqlplus
log_path=/opt/monitor/oracle/access.log
base_path=/opt/monitor/oracle/
username=test
password=test
serverid=appdb
data_temp=$base_path"data.temp"
replace_temp=$base_path"replace.temp"
sql_temp=$base_path"sql.temp"

echo `date +'%H:%m:%S'`"statistics result:"$data_temp
cat $log_path|awk '{print  substr($4,0,length($4)-3)" "$7}'|awk -F 'api_key=' '{print $1" "$2}'|awk '{print $1" "$3}'|awk -F '&' '{print $1}'|sort|awk '{a[$0]+=1}END{for(i in a){print i" "a[i]}}'> $data_temp

echo `date +'%H:%m:%S'`"statistics temp:"$replace_temp
cat $data_temp|awk '{print "INSERT INTO a_group values(a_sequence.nextval,|"$1"|,|"$2"|,|"$3"|);"}'>$replace_temp


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

