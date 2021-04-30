#!/bin/bash
##################################################
#   Description:
#       func1: 生成密钥
#       func2: 同步服务器上指定repos_prj项目 
#       func3：建立同一目录下NEWPROJ文件夹，将指定代码拷贝到NEWPROJ/SourceCode下，提交到指定仓库dev分支
#       func4：清理指定repos_prj项目 
#   History:
#    1.0:initial version
#
#
#   Author:yingcaili@foxmail.com
##################################################
#密钥及提交到远程时的用户名和邮箱
user_name="liyingcai"
user_email="liyingcai@xxxx.cn"

#仓库项目，与server_url结合使用，完整URL形如： 
server_url="ssh://git@10.0.88.88:1025/ProjectPub/"  
repos_prj="
    AD-GI25-05
    "
#新创建的项目文件夹名字，自动创建，若已存在则会先删除再创建
new_prj="NEWPROJ"
#这里写要上传到服务器的本地代码文件夹名字，网址，项目下的文件夹及gitignore文件内容
my_origin_prjFolder=""
master_url=""

prj_folders="CustomerReq FBL Release SourceCode"
gitignore_file_content="DefaultBuild\nHexForFBL\n*.mtud"

#克隆远程的分支
SERVER_DEV="dev"
clone_opt="-b $SERVER_DEV"

#输出格式控制
Log_format="********************"
Log_opt="-e"

function PrintLog()
{
    echo $Log_opt " $1 "
}
function PrintProjList()
{
    PrintLog ""  
	PrintLog ""  
    PrintLog  "已输入的项目列表有:"
    i=1
    for proj in $repos_prj
    do 
        PrintLog  "$i : $proj "
        i=`expr $i + 1`
    done
    PrintLog ""
}
function ConfigInfo()
{
    `git config user.name $user_name`
    `git config user.email $user_email`
    `git config --global alias.st status`
    `git config --global alias.ci commit`
    `git config --global alias.lg log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit`
    `git config --global alias.br branch`
}
function GenerateSSH()
{
 ##生成密钥，并配置一些全局可用的常用缩写命令，如下co代替checkout
    if `ssh-keygen -t rsa -C "$user_email"`;then
        PrintLog "  ssh密钥已生成，见~/.ssh/id_rsa.pub目录  "
        cat ~/.ssh/id_rsa.pub
        git config --global alias.co checkout
        git config --global alias.ci commit
        git config --global alias.br branch
        git config --global alias.lg  "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
  
    else
        PrintLog "  ssh密钥生成失败   "
    fi
}
function RegenerateSSH()
{
    if [ -f ~/.ssh/id_rsa.pub ];then
        PrintLog  "  ssh 密钥已存在，确认覆盖？,y or n:\c"
        read opt
        if [ $opt != 'y' ];then
            exit
        fi
    fi
    GenerateSSH
   
}
			
function CheckOut()
{
    PrintProjList
	PrintLog  "  获取远程代码开始   "
	for i in $repos_prj
	do
        if [ -d $i ];then
            cd $i && PrintLog "$i `git pull`" && cd ..
        else 
            PrintLog "  now we are cloning ${server_url}$i  "
            git clone $clone_opt ${server_url}$i 
        fi
        
	done
	PrintLog  "获取远程代码结束"
}
function CreateNewPrj()
{ 
    rm -rf $new_prj
    

    mkdir $new_prj && cd $new_prj && git init
    
    PrintLog   ${gitignore_file_content} >>.gitignore
    for prj_folder in $prj_folders
    do 
        mkdir $prj_folder
        cp .gitignore $prj_folder/
        
    done
    if [ -z $my_origin_prjFolder ];then
        PrintLog "文件夹为空，输入同目录下源码文件夹名称:\c"
        read my_origin_prjFolder
    fi
    
    cp -rf ../$my_origin_prjFolder/* SourceCode/
    git add .
    git commit -m "Initialize proj files"
    
    #创建dev分支与远程关联
    git checkout -b dev
    #PrintLog  "输入你想推送的ssh仓库地址:\c"
    #read master_url
    if [ -z $master_url ];then
        PrintLog "输入远程仓库地址：\c"
        read master_url
    fi
    git remote add origin $master_url
    git push -f -u origin master
    git push -f origin dev:dev
    PrintLog "  done  "
}
function Clean()
{
    for i in $repos_prj
    do 
        PrintLog "  正在清理$i  "
        rm -rf $i
    done 
}
function ReinitHost()
{
    rm -r ~/.ssh/know_hosts
}
function MainFunction()
{
    while :
    do
        PrintProjList
    
        PrintLog "   1: 生成ssh密钥   "
        PrintLog "   2：同步/下载项目   "
        PrintLog "   3: 新建项目   "
        PrintLog "   4: 清理项目   "  
        PrintLog "   q：退出   "  
        PrintLog ""  
        PrintLog  "请选择你需要的命令: \c"  
        read command
        
        case $command in
        1)  RegenerateSSH
        ;;
        2)  CheckOut
        ;;
        3) CreateNewPrj 
        ;;
        4)  Clean
        ;;
        *)  exit
        ;;
        esac
    done
}

MainFunction


