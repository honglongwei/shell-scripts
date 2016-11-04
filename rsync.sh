#!/bin/bash
#
#
export RSYNC_PASSWORD='123456'
IP=`cat /etc/iplist|awk '{print $2}'|awk -F. '{print $3"_"$4}'`
GID='1001'
DATE=`date -d "1 day ago"  +%Y%m%d`
DATE1=`date -d "1 day ago"  +%F`
DATE2=`date -d "8 day ago"  +%Y%m%d`
DATE3=`date -d "8 day ago"  +%F`
if (echo $IP |egrep -q "[0-9]{1,3}\_[0-9]{1,3}")
then
    for i in {1..5}
    do
                cd  /home/log/
                ls |grep "$DATE1" |grep -v "tgz"|grep -v ".txt"|xargs tar zcf  ceshi.$DATE1.tgz
                md5sum  ceshi.$DATE1.tgz >> logs$DATE.md5        
                /usr/bin/rsync -avRrztog --port=1966 --timeout=30 --bwlimit=3120  ceshi.$DATE1.tgz  root@1.1.1.1::ceshi/${GID}_$IP/
                /usr/bin/rsync -avRrztog --port=1966 --timeout=30 --bwlimit=3120   logs$DATE.md5  root@1.1.1.1::ceshi/${GID}_$IP/
                rm -rf zhyx_1001_tj.$DATE3.tgz
                rm -rf logs$DATE2.md5
                [ $? -eq 0 ] && break
                [ $i -eq 5 ] && echo "[ceshi] 同步日志出现问题,请登陆服务器 检查$0 脚本！ " >>/var/log/check.log
    sleep 10
    done
else
    echo "[ceshi]  同步日志IP获取出现问题,请登陆服务器 检查$0 脚本！ " >>/var/log/check.log
fi
exit 0
