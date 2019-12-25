#!/bin/bash

# -e 　若指令传回值不等于0，则立即退出shell
# -x 　执行指令后，会先显示该指令及所下的参数

# echo 1 && rm non-existent-file && echo 2

#echo 1 \
#  && rm non-existent-file \ # which will fail
#  && echo 2


#set -e
#echo 1
#rm non-existent-file # which will fail
#echo 2


#set -ex
#echo 1
#rm non-existent-file # which will fail
#echo 2

#set -ex
#aaa
#echo 1

