#!/bin/bash
#--------------------------
# Function Decription:
#       Purpose: 批量操作某个文件夹下的某些文件
#       1：在gitlab项目中，DESTINATION变量下创建变量FOLDERNAME中的文件夹
#       2: 删除gitlab项目中通过1创建的空文件夹
#history:
# 
#Author:liyingcai
#--------------------------

TOPDIR=`ls` #列出当前目录下所有文件，只操作当前目录下的文件夹
CUR_DIR=`pwd` #获取当前所在目录,绝对路径


################创建文件夹所要用到的变量
DESTINATION="Release" #定位到TOPDIR下的DESTINATION文件夹 创建FOLDERNAME
#FOLDERNAME是要创建的文件夹，内容可为多个，以空格分离
FOLDERNAME="
    CustomerReq
    FBL
    Release
    SourceCode
    Touch
    test"
#################################

#########删除文件夹要用到的变量
#写错，或者已创建但是需要删除的文件（夹）
#DELETE_FILE_FOLER=$FOLDERNAME #取$FOLDERNAME会删除$FOLDERNAME所有文件夹
DELETE_FILE_FOLER="testfolder" #定义在这个列表中的会单独删除
DELETE_DESTINATION="Release"
#############################

##########批量复制文件或文件夹到指定文件夹下
COPY_DESTINATION="Release"
COPY_FOLDER="Touch"
COPY_FILE_FOLDER="packall.sh testfolder"
###################


function CreateFolder()
{
    for i_dir in $TOPDIR
    do
        if [ -d $CUR_DIR/$i_dir/$DESTINATION ];then
            #echo "$CUR_DIR/$i_dir/$DESTINATION does not exist,create it? y,n"
            #read yn
            #if [ $yn == "y" ];then
                #mkdir $CUR_DIR/$i_dir/$DESTINATION
            #else
                #:
        
        
            cd $CUR_DIR/$i_dir/$DESTINATION/
            for i in $FOLDERNAME
            do            
                if [ ! -d $i ];then   
                    mkdir -p $i
                    echo "create $CUR_DIR/$i_dir/$DESTINATION/$i"
                fi
            done
            echo -e "\n"
            cd $CUR_DIR

        fi
    done
    
}
#delete folder which is empty
function CleanFolder()
{
    for i_dir in $TOPDIR
    do
     
        if [ -d $CUR_DIR/$i_dir/$DELETE_DESTINATION ];then
            cd $CUR_DIR/$i_dir/$DELETE_DESTINATION/
            for i in $DELETE_FILE_FOLER
            do
                if [[ -d $i && `ls -A $i`=="" ]];then
                    rmdir $i
                    if [ $? -eq 0 ];then
                        echo -e "delete $CUR_DIR/$i_dir/$DELETE_DESTINATION/$i"
                    else
                        echo "directory not empty,delete it by force? y or n?"
                        read forcey
                        if [[ $forcey == 'y' || $forcey == 'Y' ]];then
                        rm -rf $i
                        fi 
                    fi
                elif [ ! -d $i ];then
                    echo -e "$CUR_DIR/$i_dir/$DELETE_DESTINATION/$i does not exist"
                else
                    echo "$CUR_DIR/$i_dir/$DELETE_DESTINATION/$i not empty"
                fi
            done
            echo -e "\n"
            cd $CUR_DIR
            
        fi
    done
    
}
function CopyFileFolder()
{
    for i in $TOPDIR
    do 
    
        if [ -d ./$i/$COPY_DESTINATION/ ];then
            for file_folder in $COPY_FILE_FOLDER
            do
                cp -rf $file_folder  ./$i/$COPY_DESTINATION/ 
                if [ $? -eq 0 ];then
                echo -e "Copy $file_folder to $i/$COPY_DESTINATION/"
                else
                echo "Copy $file_folder error "
                fi
            done
        
        fi
    done
    cd $i 
    # git add . && git ci -m "$COPY_DESTINATION update" && git push  
    cd ..
}
function CopyFolder()
{
    for i in $TOPDIR
    do 
        if [ -d ./$i/Release/ ];then
            cp -rf $COPY_FOLDER  ./$i/$COPY_FOLDER 
            if [ $? -eq 0 ];then
                echo -e "Copy $COPY_FOLDER to $i"
            else
                echo "CopyFolder error "
            fi
        fi
    done
}
function PackAllReplace()
{
    echo -e "replace packall "
    for i in $TOPDIR
    do 
        if [ -d ./$i/Release/ ];then
        cp ./packall.sh  ./$i/Release/packall.sh 
        echo "replace ./$i/Release/packall.sh "
        
        fi
    done
}
function GitAddFolder()
{
    echo -e "GitAddFolder  "
   
    for i in $TOPDIR
    do 
        if [ -d ./$i/Release/ ];then
            cd $i
            `git status .`
            `git add .`
            `git commit -m "add new folder :$COPY_FOLDER"`   
            cd ..
        fi
    done
}
function MenuFolder()
{
    while true
    do
        echo "--------------create basic folder--------------"
        echo "choose following function:"
        echo "  1: create folder"
        echo "  2: delete folder"
        echo "  3: copy folder"
        echo "  4: Replace PackAll "  
        echo "  5: GitAddFolder " 
        echo "  6: Copy file or Folder " 
        echo "  q: exit"
        read opt
        case $opt in
         1) CreateFolder ;;
         2) CleanFolder ;;
         3) CopyFolder ;;
         4) PackAllReplace ;;
         5) GitAddFolder ;;
         6) CopyFileFolder ;;
         q) exit ;;
         *);;
        esac
    done
}


MenuFolder

