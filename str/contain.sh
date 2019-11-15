#!/bin/bash


s1="abcdefg"
s2="bcd"
result=$(echo $s1 | grep "${s2}")
if [[ "$result" != "" ]]
then
    echo "$s1 include $s2"
else
    echo "$1 not include $s2"
fi


fileName=/home/sss/data/hk

if [[ $fileName =~ hk ]]
then
    echo "$fileName include hk"
else
    echo "not include"
fi


A="helloworld"
B="low"
if [[ $A == *$B* ]]
then
    echo "包含"
else
    echo "不包含"
fi