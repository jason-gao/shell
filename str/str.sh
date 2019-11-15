#!/bin/bash

file=/dir1/dir2/dir3/my.file.txt

echo ${file#*/} #删掉第一个 / 及其左边的字符串   dir1/dir2/dir3/my.file.txt

echo ${file##*/} # 删掉最后一个 /  及其左边的字符串：my.file.txt

echo ${file#*.}  # 删掉第一个 .  及其左边的字符串：file.txt

echo ${file##*.} #删掉最后一个 .  及其左边的字符串：txt

echo ${file%/*} #删掉最后一个  /  及其右边的字符串：/dir1/dir2/dir3

echo ${file%%/*} #删掉第一个 /  及其右边的字符串：(空值)

echo ${file%.*} #删掉最后一个  .  及其右边的字符串：/dir1/dir2/dir3/my.file

echo ${file%%.*} #删掉第一个  .   及其右边的字符串：/dir1/dir2/dir3/my


# 是 去掉左边（键盘上#在 $ 的左边）
#%是去掉右边（键盘上% 在$ 的右边）
#单一符号是最小匹配；两个符号是最大匹配
echo ${file:0:5} #提取最左边的 5 个字节：/dir1
echo ${file:5:5} #提取第 5 个字节右边的连续5个字节：/dir2
#也可以对变量值里的字符串作替换：
echo ${file/dir/path} #将第一个dir 替换为path：/path1/dir2/dir3/my.file.txt
echo ${file//dir/path} #将全部dir 替换为 path：/path1/path2/path3/my.file.txt


PHP_EXTENSIONS=pdo_mysql,mysqli,mbstring,gd,curl,opcache,memcached,redis,sockets
EXTENSIONS=",${PHP_EXTENSIONS},"
echo ${EXTENSIONS##*,sockets,*}