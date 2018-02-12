#!/bin/sh

#-------------------------------------------
# 每天获取自己想要的域名-长度6位以内、并且第二个字母是元音的.com域名
# regex='^([a-z]{1,1})([a|e|i|o|u]{1,1})([a-z]{1,4})\.com(.+)'
# sedo.com
# pool.com
# 下载pool.com删除的域名，正则匹配出符合自己需求的域名
# sh getDeleteDomains.sh
# 6位纯数字的regex=’^([0-9]{1,6})\.com(.+)’
#-------------------------------------------

dir="/usr/local/src"
if [[ ! -d "$dir" ]];then
    mkdir "$dir"
fi
if [[ $? -ne 0 ]];then
    echo " make dir $dir fail"
    exit
fi
cd $dir
wget -c http://www.pool.com/Downloads/PoolDeletingDomainsList.zip
if [[ $? -eq 0 ]];then
yum install -y unzip zip
unzip $dir"/PoolDeletingDomainsList.zip"

regex='^([a-z]{1,1})([a|e|i|o|u]{1,1})([a-z]{1,4})\.com(.+)'
#regex='^([0-9]{1,6})\.com(.+)'
while read -r line
do
    if [[ $line =~ $regex ]];then
        echo $line
    fi

done < $dir"/PoolDeletingDomainsList.txt"

else
    echo "download file fail"
fi