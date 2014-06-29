#/bin/bash

cur_path=/opt/monitor/oracle

vartime=`date -d yesterday '+%Y-%m-%d'`
result_path=$cur_path"/"$vartime"/result/"
result_log=$result_path"result.log"

classify_path=$result_path"classify"
bustranser_log=$classify_path"bus_transfer.log"
busname_log=$classify_path"busname.log"
stationname_log=$classify_path"stationname.log"
station_log=$classify_path"station.log"
near_log=$classify_path"near.log"
line_log=$classify_path"line.log"
walk_log=$classify_path"walk.log"
test_log=$classify_path"api.log"

cat $result_log|grep '?abilityuri=bus/simple' > $bustransfer_log
cat $result_log|grep 'abilityuri=sisserver'|grep 'busName=' > $busname_log
cat $result_log|grep 'abilityuri=sisserver'|grep 'stationName=' > $stationname_log
cat $result_log|grep 'station?' > $station_log
cat $result_log|grep 'station/near?' > $near_log
cat $result_log|grep 'line/near?' > $line_log
cat $result_log|grep 'walk?' > $walk_log
cat $result_log|grep 'api_key'>$test_log

sqlplus=/usr/lib/oracle/11.2/client64/bin/sqlplus
username=SYSTEM
password=123456
serverid=appdb
data_temp=$cur_path/data.temp
replace_temp=$cur_path/replace.temp
sql_temp=$cur_path/sql.temp

$cur_path/city.sh $sqlplus $bustranser_log $curl_path $username $password $serverid $vartime "name" $data_temp $replace_temp $sql_temp
