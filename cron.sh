#!/bin/sh
#################################
##fun: crontab cmd-permit script
##version:1.0
##date by:2012.11.06
#################################


source /etc/profile;
source ~/.bash_profile;

etime=`date +%Y%m%d-%H%M%S`

if [ "$1" = "-r" ] ; then
    echo "Error , no permit"
    exit 2

elif [ "$1" = "-l" ] ; then
    /usr/bin/crontab -l
    exit 0
elif [ "$1" = "--help" ] ; then
    /usr/bin/crontab --help

elif [ "$1" = "-e" ] ; then
    mkdir -p ~/.cronbak
    /usr/bin/crontab -l > ~/.cronbak/cronbak.$etime.a
    /usr/bin/crontab -e
    /usr/bin/crontab -l > ~/.cronbak/cronbak.$etime.b
else

   echo "Error, no permit ,please connect administrator"
   exit 2

fi
