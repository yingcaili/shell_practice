#!/bin/bash
#--------------------创建项目工程结构，基于Windows-BashShell--------------------
#   Attention:
#       当前脚本及代码所在路径中不能出现空格,暂不支持修改为Windows路径格式
#   Usage: 
#       1:修改PROJECT_NAME 为要设置的项目名称
#       2:将打开方式设置为Git for Windows，可以直接双击运行。
#         或者 在当前目录鼠标右键选择打开git bash, 输入 sh 文件名.sh
#
#   Description:
#       此脚本创建PROJECT_NAME，并在其下Folders的文件夹，并且生成gitignore文件
#   
#   history:
#    20210413:initial version  
#
#
#   Author:liyingcai
#--------------------------------------------

PROJECT_NAME=ssss
Folders="
CustomerReq
FBL
Release
SourceCode
"

IGNORE_CONTENT="SourceCode/DefaultBuild
SourceCode/HexForFBL
SourceCode/*.mtud
FBL/*.mtud"

TOP=`pwd`
function EchoControl()
{
    echo "$1"
}
function CreateGitignore()
{
    EchoControl "Create Gitignore"
#这里创建gitignore文件，并向其中写入内容
    touch $PROJECT_NAME/.gitignore && echo $IGNORE_CONTENT>>$PROJECT_NAME/.gitignore
    for folder in $Folders
    do 
        cp $PROJECT_NAME/.gitignore $PROJECT_NAME/$folder/.gitignore
    done
}
function CreateFolder()
{
    EchoControl "Create ProjFolder"
    if [ ! -d $PROJECT_NAME ];then
        mkdir $PROJECT_NAME 
    else
        EchoControl "$PROJECT_NAME,exit now"
        exit
    fi
    
    cd $PROJECT_NAME
    for folder in $Folders
    do       
        if [ ! -d $folder ];then
            mkdir $folder 
        else
            EchoControl "$folder already exists"
        fi
    done
    cd $TOP
}
function VarValidCheck()
{
    if [[ -z $PROJECT_NAME || -z $Folders ]];then
        EchoControl "PROJECT_NAME or Folders empty ,press any key to exit"
        read n
        exit -1
    fi
}
VarValidCheck
if [ $? -eq -1 ];then
    exit
fi
CreateFolder
CreateGitignore
EchoControl "**************** Done*******************"
read n