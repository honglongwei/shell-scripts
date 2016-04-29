#!/bin/bash

Redis_bin_server=/usr/local/redis/bin/redis-server
Redis_bin_cli=/usr/local/redis/bin/redis-cli
Redis_conf=/data/redis$1/$1.conf
port=$1

source /etc/init.d/functions
redis_start() {
        
        rm -rf /data/redis$port/$port.rdb

        if $($Redis_bin_server $Redis_conf)
        then
                pid=`ps aux |grep redis-server |grep $port| grep -v grep |awk '{print $2}'`
                echo -n "Port:$port redis is running, pid:$pid"
                success
                echo
        else
                echo -n "Port:$port redis is running!"
                failure
                echo
            fi
}

redis_stop() {
#	pid=`ps aux |grep redis-server |grep $port| grep -v grep |awk '{print $2}'`
#        if kill -9 $pid
	if $($Redis_bin_cli -p $port shutdown)
        then
                echo -n "Port:$port redis is stopped!"
                success
                echo
        else
                echo -n "Port:$port redis is stopped!"
                failure
                echo
            fi
}

redis_restart(){
        redis_stop
        sleep 1
        redis_start
}

redis_usage() {
        echo -e "Usage: $0 {port} {start,stop,restart}"
        exit 1
}

case "$2" in
  start) redis_start ;;
  stop)  redis_stop  ;;
  restart) redis_restart ;;
  *)     redis_usage ;;
esac
