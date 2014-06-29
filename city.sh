#!/bin/bash
#######################
#need linux sqlplus
#
#######################

#sqlplus=/usr/lib/oracle/11.2/client64/bin/sqlplus
#log_path=/opt/monitor/oracle/zuojiu.txt
#base_path=/opt/monitor/oracle/
#username=SYSTEM
#password=123456
#serverid=appdb
#date=2014-06-28
#servername=poi
#data_temp=$base_path"data.temp"
#replace_temp=$base_path"replace.temp"
#sql_temp=$base_path"sql.temp"

sqlplus=$1
log_path=$2
base_path=$3
username=$4
password=$5
serverid=$6
date=$7
servername=$8
data_temp=$9
replace_temp=$10
sql_temp=$11

echo `date +'%H:%m:%S'`"statistics result:"$data_temp
#cat $log_path|awk '{print $4" "$8"&"}'|awk -F "a_k=|key=" '{print substr($2,1,index($2,"&")-1)" "$1$2}'|awk -F "city=|cityCode=" '{print substr($2,1,index($2,"&")-1)" "$1$2}'|awk '{print substr($3,2,length($3))" "$2" "$1}'|awk '{a[$0]+=1}END{for(i in a){print i" "a[i]}}'|sed -e"s/$/ $servername/g "|awk '{print $1"|"$2"|"$3"|"$4"|"$5}'> $data_temp  
cat localhost_access_logtime.2014-06-12.txt|grep "a_k=\|key="|awk '{print $7"&"}'|awk -F "a_k=|key=" '{print substr($2,1,index($2,"&")-1)" "$1$2}'|awk -F "city=|cityCode=" '{print substr($2,1,index($2,"&")-1)" "$1$2}'|awk '{print $1" "$2}'|awk '{a[$0]+=1}END{for(i in a){print i" "a[i]}}'|sed -e "s/$/ $servername/g" -e "s/$/ $date/g"|awk '{print $1"|"$2"|"$3"|"$4"|"$5}' >$data_temp



echo `date +'%H:%m:%S'`"statistics temp:"$replace_temp


cat $data_temp|while read line
do
  printf $(echo -n $line | sed 's/\\/\\\\/g;s/\(%\)\([0-9a-fA-F][0-9a-fA-F]\)/\\x\2/g')"\n"|awk -F '|' '{print "INSERT INTO analysis_city values(a_sequence.nextval,|"$1"|,|"$5"|,|"$2"|,|"$3"|,|"$4"|);"}'>>$replace_temp 
done

echo `date +'%H:%m:%S'`"statistics table_name:"$sql_temp
cat $replace_temp|while read line
do
        echo ${line//|/\'} >>$sql_temp
done


echo 'exit' >>$sql_temp

echo '1111111111111111111111111111111111111111111111111111111'
exit

echo `date +'%H:%m:%S'`"statistics sqlplus:"
$sqlplus $username/$password@$serverid @$sql_temp

rm -rf $data_temp
rm -rf $replace_temp
rm -rf $sql_temp

echo `date +'%H:%m:%S'`" is done"

