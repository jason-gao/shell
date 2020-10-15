#!/usr/bin/env bash


#+/- 　"-"可用来指定变量的属性，"+"则是取消变量所设的属性
#-f 　仅显示函数
#r 　将变量设置为只读
#x 　指定的变量会成为环境变量，可供shell以外的程序来使用
#i 　[设置值]可以是数值，字符串或运算式


#数组
declare -a cd='([0]="a" [1]="b" [2]="c")'
echo ${cd[1]} #b

echo ${cd[@]} # a b c

#只读
# ine 11: x: readonly variable
#declare -r x
#x=88
#echo $x


#改变变量属性
declare -i ef
ef=1
echo $ef #1

ef="wf"
echo $ef #0


declare +i ef
ef="wa"
echo $ef #wa

