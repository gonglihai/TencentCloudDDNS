# Tencent Cloud DDNS 腾讯云反域名解析脚本
## 使用说明
将 ddns.sh 中`SecretId`、`SecretKey`、`domain`、`recordId`、`subDomain`、`oldIPFile`共6个参数替换成你自己的,使用定时任务(crontab)定时执行.
```
#赋予权限
chmod +x ./ddns.sh

#编辑定时任务
crontab -e 

#在crontab配置中添加表达式(每5分钟执行一次)
*/5 * * * * /root/ddns/ddns.sh >> /root/ddns/ddns.log
```
