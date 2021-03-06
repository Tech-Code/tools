#!/bin/bash
#######################
#need linux sqlplus
#
#######################

sqlplus=/usr/lib/oracle/11.2/client64/bin/sqlplus
log_path=/opt/monitor/oracle/area.txt
base_path=/opt/monitor/oracle/
username=SYSTEM
password=123456
serverid=appdb
data_temp=$base_path"data.temp"
replace_temp=$base_path"replace.temp"
sql_temp=$base_path"sql.temp"

echo `date +'%H:%m:%S'`"statistics result:"$data_temp
cat $log_path|awk -F "," '{print $1" "$2" "$3" "$4" "$5" "$6" "$7" "$8}'> $data_temp



echo `date +'%H:%m:%S'`"statistics temp:"$replace_temp
cat $data_temp|awk '{print "INSERT INTO bus_area values(a_sequence.nextval,"$2",|"$3"|,"$4","$5","$6","$7","$8","$1");"}'> $replace_temp


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

