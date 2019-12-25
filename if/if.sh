#!/bin/bash

# if [[ -n str1 ]]　　　　　　 当串的长度大于0时为真(串非空)
# if [ -z str1 ]　　　　　　　 当串的长度为0时为真(空串)

str="notempty"

if [[ -n "$str" ]]; then
	echo "yes"
else
	echo "no"
fi


str=""

if [[ -z $str ]]; then
	echo "yes"
else
	echo "no"
fi