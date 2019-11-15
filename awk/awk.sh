#!/bin/bash


# awk '{pattern + action}' {filenames}
# pattern 表示 AWK 在数据中查找的内容，而 action 是在找到匹配内容时所执行的一系列命令。
# 花括号（{}）不需要在程序中始终出现，但它们用于根据特定的模式对一系列指令进行分组。
# pattern就是要表示的正则表达式，用斜杠括起来。

#awk语言的最基本功能是在文件或者字符串中基于指定规则浏览和抽取信息，awk抽取信息后，才能进行其他文本操作。完整的awk脚本通常用来格式化文本文件中的信息。

#通常，awk是以文件的一行为处理单位的。awk每接收文件的一行，然后执行相应的命令，来处理文本


# last -n 5
# last -n 5 | awk '{print $1}'
# $0则表示所有域,$1表示第一个域,$n表示第n个域
# 默认域分隔符是"空白键" 或 "[tab]键"

# cat /etc/passwd

# cat /etc/passwd |awk  -F ':'  '{print $1}'

# cat /etc/passwd |awk  -F ':'  '{print $1"\t"$7}'

# cat /etc/passwd |awk  -F ':'  'BEGIN {print "name,shell"}  {print $1","$7} END {print "blue,/bin/nosh"}'