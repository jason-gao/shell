#!/bin/bash

. /etc/profile

cat <<EOF


         +++++++++++++++++++++++++++++++++++++++++
         + 简单命令:                             +
         + 01. 删除用户                          +
         +         userdel "Username"            +
         +                                       +
         + 02. 删除用户且删除该用户家目录[慎重]  +
         +         userdel -r "Username"         +
         +                                       +
         + 03. 改普通用户密码                    +
         +         passwd "Username"             +
         +++++++++++++++++++++++++++++++++++++++++




EOF

echo "=========="
read -rp 请输入希望创建的用户: newuser
id $newuser &>/dev/null
ret=$?
	if [[ $ret == 0 ]];then
		echo "用户 $newuser 已存在，强制退出"
		exit 9
	else
		echo "创建检测中..."
	fi
echo ""
sleep 1

case $newuser in
	root|www )
		echo "Warning:"
		echo "禁止创建/修改 $newuser 用户及密码"
		echo ""
		exit 10;;
	* )
		echo "检测用户名正确[注意: 脚本未检测特殊字符]"
		echo 即将创建的用户名: $newuser;;
esac

echo "==========="
sleep 1
read -rp 请输入随机密码需要的salt: salt

echo salt设置为: $salt

echo "==========="
sleep 1
a=`date +%Y:%S:%N:%m:%M:%d:%H:%M:%S%N`_$salt
#echo 原始数据为: $a

passwd_ori=`echo -n $a | md5sum | awk '{print $1}'`
#echo 初始随机结果为: $passwd_ori

passwd=`echo ${passwd_ori:12:21}`
echo 预设密码为: $passwd

echo ""
echo "==========="
sleep 1
echo "开始创建用户及密码......"
useradd $newuser

	echo "如无返回'设置成功'字样，则表示设置密码失败"
	sleep 1
	echo ""
	echo $passwd | passwd --stdin $newuser &>/dev/null && echo 设置成功
	echo ""
