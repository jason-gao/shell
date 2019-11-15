#!/bin/bash

for i  in "$*"
do
	echo "参数值 = $i"
done


echo "----------------------"

for j  in "$@"
do
	echo "参数值 = $j"
done


echo "------------------------"

sum=0
for k in "$@"
do
	sum=$[$sum+$k]
done
echo "参数和=$sum"

echo "---------------------"

sum=0
for((i=1;i<=100;i++))
do
	sum=$[$sum+$i]
done
echo "1到100的和=$sum"
echo "----------------------"



#for n in `seq 3`;do
#    touch `openssl rand -hex 10 | cut -c 1-10`_oldchang.html
#done

#for file in `ls`;do
#    mv  $file ${file//_*/}_oldduan.HTML
#done


for i in {1..5}
do
echo $(expr $i \* 3 + 1);
done

echo "-------------------------"

var=(arg1 arg2 arg3)
for i in ${var[@]};
do
	echo $i
done


# sh testForvar.sh 6 8 10
