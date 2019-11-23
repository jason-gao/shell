#!/bin/bash

#mac os

echo `pwd`

echo $(dirname $(pwd))

echo $0

echo $(dirname $0)

ABSPATH=$(cd "$(dirname "$0")"; pwd) && echo $ABSPATH



#if [[ $(echo $0 | awk '/^\//') == $0 ]]; then
#    ABSPATH2=$(dirname $0)
#else
#    ABSPATH2=$PWD/$(dirname $0)
#fi
#
#echo $ABSPATH2