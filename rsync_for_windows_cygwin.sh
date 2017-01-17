#!/bin/sh
# init environment
zuhao="1111"
today=`date -d "1 days ago" +%Y-%m-%d`
old=`date -d "4 days ago" +%Y-%m-%d`
today_2=`date -d "1 days ago" +%Y%m%d`
oneweekago=`date -d "2 days ago" +%Y%m%d`
onehourago=`date +%Y%m%d%H -d  '-1 hours'`
old_2=`date -d "4 days ago" +%Y%m%d`
logdir="/cygdrive/d/Log_bak"
export RSYNC_PASSWORD='123456'
gslog="/cygdrive/d/${zuhao}/Log"
xialogdir=`/usr/bin/find ${gslog} -name "${zuhao}*" -type d|awk -F/ '{print $NF}'`

function move_log()
{
	cd $gslog || ( echo "change to $gslog dir failed!" && exit 1)
        [ -d $logdir/${today_2} ] || ( mkdir -p $logdir/${today_2}  &&  echo "mkdir $logdir/${today_2} success" && exit 1)
	/usr/bin/find . -mindepth 3 -maxdepth 3 -name "*${today}*" -type f -exec cp -rf --parents {} $logdir/${today_2} \; > /dev/null
	IsOK "cp TJ_log"
	/usr/bin/find . -mindepth 3 -maxdepth 3 -name "*${old}*" -type f -exec rm -rf {} \; > /dev/null
	IsOK "rm old_TJ_log"
	/usr/bin/find . -name "*${today_2}*" -type f -exec mv {} $logdir/${today_2} \; > /dev/null
	IsOK "mv game_log"
}

function game_Log_back()
{
	#### game_log_back #####
        zip_dir="$logdir/${today_2}/"
	echo "[$today] start to gzip and generate md5file."
        cd $zip_dir || ( echo "change to $zip_dir dir failed!"  && exit 1 ) 
        /usr/bin/tar -zcvf ${zuhao}_fullbacklog_${today}.tgz * --exclude=*.tgz --exclude=*.md5
        IsOK "tar Full_log files"
        /usr/bin/rsync -aSvH --timeout=20 --bwlimit=30240 --port=1966 ${zuhao}_fullbacklog_${today}.tgz ceshi@1.1.1.1::ceshi/Log/${zuhao}/ || echo "rsync herolog failed!"
	cd $logdir
	rm -rf ${oneweekago}
	IsOK "rm oneweekago_log"
}

function backup_log()
{
        area=$1
	###### Tongji log############
        dest_dir="$logdir/${today_2}/$area/log"
	echo "[$today] start to gzip and generate md5file."
        cd $dest_dir || ( echo "change to $dest_dir dir failed!"  && exit 1 ) 
	if [ $? == 0 ];then
        /usr/bin/tar -zcvf ../xj5_${area}_${today}.tgz  *
        IsOK "tar TJ_log files"
	cd ..
	md5sum xj5_${area}_${today}.tgz  > logs${today_2}.md5
	rm -rf $dest_dir/*
	fi
}

function IsOK()
{
        msg="$1"
        if [ $? == 0 ];then
                echo "[$today] $msg OK"
        else
                echo "[$today] $msg failed"  &&  exit 1
        fi
}

function get_ex_ip()
{
        ex_ip=`ipconfig|grep -i ipv4|awk 'NR==2{print $NF}'`
        ip=`echo $ex_ip|awk -F'.' '{print $3"_"$4}'`
        echo $ip
}

function rsync_logfile()
{
        ip=$(get_ex_ip)
        file=$1
        area=$2
        /usr/bin/rsync -aSvH --timeout=20 --bwlimit=30240 --port=1966 $logdir/${today_2}/$area/${file} root@1.1.1.1::ceshi/${zuhao}_${ip}_${area}/ || echo "rsync herolog failed!"
        IsOK "rsync $file"
}

move_log
game_Log_back
for i in ${xialogdir}
do
echo $i
backup_log $i
rsync_logfile    xj5_${i}_${today}.tgz $i
rsync_logfile    logs${today_2}.md5 $i
done
