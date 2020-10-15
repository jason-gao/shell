#!/bin/bash

# https://www.cnblogs.com/qq931399960/p/11679682.html

netstat -na | grep ESTABLISHED | awk '{print $5}'| awk -F ":" '{print $1}'| sort | uniq -c
