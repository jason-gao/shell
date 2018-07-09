#!/bin/bash

url="https://www.xx.com"
HttpCode=$(curl -s -m 10 --connect-timeout 10 -l $url -w %{http_code} -I|awk '{print $2}'|awk 'NR==1{print}')
echo $HttpCode
if [ $HttpCode -eq 302 -o $HttpCode -eq 200 ]; then
    echo "服务正常"
else
    echo "服务无法访问"
fi