#!/bin/bash
#--------------------自动打包脚本，基于Windows-BashShell--------------------
#   Attention:
#       :
#   Usage: 
#       1:在当前目录鼠标右键选择打开git bash, 输入 sh packall.sh
#       2:将打开方式设置为Git for Windows，可以直接双击运行。
#
#   Description:
#       针对服务器变化导致原host key警告，删除know_hosts

#
#   history:
#    2021.04.27: initial version
#
#
#   Author:liyingcai
#--------------------------------------------

echo "**********Cleaning known_hosts**********"
rm ~/.ssh/known_hosts
if [ $? -eq 0 ];then
    echo "**********Clean Done**********"
else
    echo "**********Clean Error**********"
fi
read n