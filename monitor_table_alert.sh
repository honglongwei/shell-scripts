#!/bin/bash

echo "Monitor_test@163.com
Content-type: text/html;charset=UTF-8
Subject: 测试监控
<table bgcolor=black><tr bgcolor=blue><td>功能</td><td>状态</td></tr>">alert.log
echo "<tr bgcolor=red><td>功能1</td><td> LOG1 </td></tr>">>alert.log
echo "<tr bgcolor=red><td>功能2</td><td> LOG2 </td></tr>">>alert.log
echo "<tr bgcolor=red><td>功能3</td><td> LOG3 </td></tr>">>alert.log
echo "</table>" >>alert.log

log1=`ssh root@1.1.1.1 "cat /var/run/log/alert.log"`
sed -i "s/LOG1/$log1/g" alert.log
if [ "$log1" = "0" ];then
    sed -i "s/red><td>功能1/green><td>功能1/g" alert.log
else
    echo 0
fi


log2=`ssh root@2.2.2.2 "cat /var/run/log/alert.log"`
sed -i "s/LOG2/$log2/g" alert.log
if [ "$log2" = "0" ];then
    sed -i "s/red><td>功能2/green><td>功能2/g" alert.log
else
    echo 0
fi


log3=`ssh root@3.3.3.3 "cat /var/run/log/alert.log"`
sed -i "s/LOG3/$log3/g" alert.log
if [ "$log3" = "0" ];then
    sed -i "s/red><td>功能3/green><td>功能3/g" alert.log
else
    echo 0
fi


if [ "$log1" != "0" ]||[ "$log2" != "0" ]||[ "$log3" != "0" ];then
    cat alert.log | /usr/sbin/sendmail -t test@163.com 
else
    echo 0
fi
