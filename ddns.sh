#!/bin/sh

USER="minshunqiang@163.com"
TOKEN="ead87a0c3e07b953c95fbbe767475ead9436dbfb"
ID="185551671"
HOST="sz"
DOMAIN="20120714.xyz"
URL=${HOST}.${DOMAIN}
IP=`ping ${URL} -c 1 |awk 'NR==2 {print $4}' |awk -F ':' '{print $1}'`
#如果安装了dig也可以这样
#IP=`dig ${DOMAIN} @114.114.114.114 | awk -F "[ ]+" '/IN/{print $1}' | awk 'NR==2 {print $5}'`
echo "Ip of ${URL} is ${IP}"
LIP=`curl ip.sb`
echo "Local Ip is ---${LIP}---"

if [ "${LIP}" = "${IP}" ]; then
   exit
fi

echo "start ddns refresh"
if [ x"${LIP}" != x ]; then
   curl -u ''""${USER}""':'""${TOKEN}""'' 'https://api.name.com/v4/domains/'""${DOMAIN}""'/records/'""${ID}""'' -X PUT --data '{"host":"'""${HOST}""'","type":"A","answer":"'""${LIP}""'","ttl":300}'
   echo ${LIP} > /tmp/ddnsResult
fi
