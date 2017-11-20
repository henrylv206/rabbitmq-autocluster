#!/bin/sh

set -e

# add debug
[[ -n "$DEBUG" ]] && set -x

etcdhost=`nslookup $ETCD_HOST 172.30.0.1 | tail -n 1 | grep 172 | cut -d ' ' -f 3`                                                            
while [ -z "$etcdhost" ]                                                                                                                    
do                                                                                                                                          
  echo "etcdhost is null"   
  sleep 1  
  etcdhost=`nslookup $ETCD_HOST 172.30.0.1 | tail -n 1 | grep 172 | cut -d ' ' -f 3`                                                           
done                                                                                                                                        
                                                                                                                                            
echo etcdhost: $etcdhost                                                                                                                    
export ETCD_HOST=$etcdhost

# allow the container to be started with `--user`
if [ "$1" = 'rabbitmq-server' -a "$(id -u)" = '0' ]; then
	chown -R rabbitmq:rabbitmq ${HOME}
	exec su-exec rabbitmq "$0" "$@"
fi

exec "$@"
