#!/bin/bash

#### start legend ####
# 计算目录的MD5，用于对比目录文件内容是否变化
# 将目录里的文件MD5生成一个文件，然后对比那个文件的md5
# find /path/to/dir/ -type f -name "*.py" -exec md5sum {} + | awk '{print $1}' | sort | md5sum
# 首先通过find命令找到所有参与md5计算的文件，然后对每个文件计算md5值，然后通过awk输出md5值列，然后再对所有文件的md5做排序，然后再次计算所有文件的md5值
#### end legend #####

# Set environment variables
LANG=""
export LANG

echo ""
echo ""
echo "please put check_file in the same directory?"
echo ""
read -p "are you put the check_file in the right position ? (Y/N): " select_yn
echo ""
echo ""

if [ "$select_yn" == "Y" ] || [ "$select_yn" == "y" ]; then

    echo "start generate data.md5 ..."
    find ./ -type f -print0 | xargs -0 md5sum | sort > ../data.md5
    echo "generate md5 value over"

elif [ "$select_yn" == "N" ] || [ "$select_yn" == "n" ]; then
    echo "stop generate md5 value !"
else
    echo "I don't know what your choice is !!!"
fi

md5sum ../data.md5


# 检测文件是否被篡改
find /sbin -type f | xargs  md5sum > sbin.md5
find /sbin -type f | xargs  md5sum > sbin2.md5
diff sbin.md5 sbin2.md5