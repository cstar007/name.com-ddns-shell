之前一直用花生壳的免费DDNS，但是最近一周不知道为啥，服务老是抽风，dns更新速度明显下降，甚至达到1-2天。于是研究了一下，发现name.com最近发布了v4版本的api，看了文档以后，果断写了个脚本，一旦ip变更，新dns可以马上更新，消耗时间无限接近0。。。于是ddns更新时间只基于计划任务的间隔时间了。。。
使用此脚本的前提：
1.域名必须是由name.com购买的，并且生成一个生产的Token。
2.登陆账户必须没有开启二次验证，否则api会提示错误：Accout has Namesafe enabled. （注意这里account拼写还是错的。。已发ticket给name.com）。
3.路由上需要安装curl和ca-certificates和ca-bundle,以便解析https。
4.首次需要手动添加一次域名，以便获取ID号码，例如为www.examle.com添加第一个dns记录：

curl -u 'YOUR_USER_NAME:YOUR_API_TOKEN' 'https://api.name.com/v4/domains/example.com/records' -X POST --data '{"host":"www","type":"A","answer":"YOUR_IP","ttl":300}'


从返回的json里面记录下id，json格式为：

