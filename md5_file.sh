#! /bin/bash

DATE=`date +%Y%m%d`
PKG_NAME=$1

function md5_file(){
    for file in `ls $1`
    do
        if [ -d $1"/"$file ] 
        then
            md5_file $1"/"$file
        else
            echo $1"/"$file >>/home/update/fl.log
        fi
    done
}


if [ -d "/home/update/gs" ]
then
    cd /home/update/ && mv gs gs_${DATE} && unzip -oq ${PKG_NAME}
else
    cd /home/update/ && unzip -oq ${PKG_NAME}
fi
cd /home/update/ && echo > /home/update/fl.log && md5_file gs
echo > /home/update/ret.log
for mfile in `cat /home/update/fl.log`;
do
   s_md5=`md5sum /home/update/${mfile}|awk '{print $1}'`
   t_md5=`md5sum /home/demo/${mfile}|awk '{print $1}'`
   if [ "$s_md5" = "$t_md5" ]
   then
       #echo -e "/home/mrdTomcat/update/${mfile} is \033[32m OK \033[0m !" //绿色输出
       echo "/home/update/${mfile} is OK !">>/home/update/ret.log
   else
       #echo -e "/home/mrdTomcat/update/${mfile} is \033[31m Failure \033[0m !" //红色输出
       echo "/home/update/${mfile} is Failure !">>/home/update/ret.log
   fi
done
ret_code=`grep 'Failure' /home/update/ret.log`
if [ "$ret_code" ]
then
    echo 1
else
    echo 0
fi
