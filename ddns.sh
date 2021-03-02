#!/bin/sh
#重新解析IP函数
updateIP(){
    #SecretId密匙id
    SecretId="SecretId"         #1.替换成你的
    SecretKey="SecretKey"       #2.替换成你的
    #具体操作的类型
    Action="RecordModify"
    #随机整数
    Nonce=`date +%s`
    #加密方式
    SignatureMethod="HmacSHA1"
    #时间戳
    Timestamp=`date +%s`
    #域名
    domain="domain.com"         #3.替换成你的
    #解析记录id
    recordId="recordId"         #4.替换成你的
    #子域名
    subDomain="subDomain"       #5.替换成你的
    #记录类型
    recordType="A"
    #线路名称
    recordLine="默认"
    #请求地址
    requestURL="cns.api.qcloud.com/v2/index.php"
    #请求参数
    parmeterStr="Action=${Action}&Nonce=${Nonce}&SecretId=${SecretId}&SignatureMethod=${SignatureMethod}&Timestamp=${Timestamp}&domain=${domain}&recordId=${recordId}&recordLine=${recordLine}&recordType=${recordType}&subDomain=${subDomain}&value=${newIP}"
    #请求地址和参数，下边加密使用
    requestStr="GET${requestURL}?"${parmeterStr}
    #生成Signature字段(requestStr加密后的sha1,base64)
    Signature=`echo -n ${requestStr} | openssl dgst -hmac ${SecretKey} -sha1 -binary | base64`
    #请求腾讯云云解析api替换ip
    rest=`curl -s -G -d ${parmeterStr} --data-urlencode "Signature=${Signature}" https://${requestURL}`
    grepResult=`echo "${rest}" | grep "\"code\":0"`
    if [[ "${grepResult}" != "" ]]
        then
            echo ",success"
            echo "${newIP}" > ${oldIPFile}
        else
            echo -e ",error,rest:\n${rest}"
    fi
}
#获取新的ip
newIP=`curl -s http://ip.glh.red/`
#老的ip存放位置
oldIPFile="/root/ddns/oldIP.txt"    #6.替换成你的
#获取老的IP
oldIP=`cat ${oldIPFile}`
#如果老的IP与获取的新的IP不一致则请求 腾讯云 更新IP
if [[ "${newIP}" != "" && "${newIP}" != "${oldIP}" ]]
    then
        echo -e "`date`\t\c"
        echo -e "${oldIP} > ${newIP}\c"
        updateIP
fi