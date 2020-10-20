使用此脚本的前提：
1.域名必须是由name.com购买的，并且生成一个生产的Token。
2.登陆账户必须没有开启二次验证，否则api会提示错误：Accout has Namesafe enabled. （注意这里account拼写还是错的。。已发ticket给name.com）。
3.路由上需要安装curl和ca-certificates和ca-bundle,以便解析https。
4.首次需要手动添加一次域名，以便获取ID号码，例如为www.examle.com添加第一个dns记录：
```
curl -u 'YOUR_USER_NAME:YOUR_API_TOKEN' 'https://api.name.com/v4/domains/example.com/records' -X POST --data '{"host":"www","type":"A","answer":"YOUR_IP","ttl":300}'
```

从返回的json里面记录下id，json格式为：
```
{
    "id": 12345,
    "domainName": "example.org",
    "host": "www",
    "fqdn": "www.example.org",
    "type": "A",
    "answer": "10.0.0.1",
    "ttl": 300
}
```
此id要写入脚本。

后续就可以通过如下脚本更新dns了。
脚本如下：

```
#!/bin/sh

USER="YOUR_USER_NAME"
TOKEN="YOUR_API_TOKEN"
ID="YOUR_URL_ID"
HOST="www"
DOMAIN="example.com"
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
```
crontab添加定时任务
```
*/1 * * * * /root/ddns.sh #每分钟执行一次，注意脚本路径
```
