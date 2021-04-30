#!/bin/bash
#--------------------------
# Function Decription:
#       1：在gitlab项目中，DESTINATION变量下创建变量FOLDERNAME中的文件夹
#       2: 删除gitlab项目中通过1创建的空文件夹
#history:
# 
#Author:liyingcai
#--------------------------

ALLDIR=`ls`
CUR_DIR=`pwd`
PRPJ_DIR="."
DESTINATION="" 
FOLDERNAME="
    Touch"

#写错，或者已创建但是需要删除的文件（夹）
#FILETO_DElETE=$FOLDERNAME 这个删除上面所有文件夹
FILETO_DElETE="Touch" #这个列表中的会单独删除

COPY_FOLDER="Touch"
function CreateFolder()
{
    for i_dir in $ALLDIR
    do
        if [ -d $PRPJ_DIR/$i_dir/$DESTINATION ];then
            #echo "$PRPJ_DIR/$i_dir/$DESTINATION does not exist,create it? y,n"
            #read yn
            #if [ $yn == "y" ];then
                #mkdir $PRPJ_DIR/$i_dir/$DESTINATION
            #else
                #:
        
        
            cd $PRPJ_DIR/$i_dir/$DESTINATION/
            for i in $FOLDERNAME
            do            
                if [ ! -d $i ];then   
                    mkdir -p $i
                    echo "create $PRPJ_DIR/$i_dir/$DESTINATION/$i"
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
    for i_dir in $ALLDIR
    do
     
        if [ -d $PRPJ_DIR/$i_dir/$DESTINATION ];then
            cd $PRPJ_DIR/$i_dir/$DESTINATION/
            for i in $FILETO_DElETE
            do
            #] && [ `ls -A $i`=="" ] 
                if [[ -d $i && `ls -A $i`=="" ]];then
                    rmdir $i
                    if [ $? -eq 0 ];then
                        echo -e "delete $PRPJ_DIR/$i_dir/$DESTINATION/$i"
                    else
                        echo "delete it by force,,y or n?"
                        read forcey
                        if [ $forcey == 'y' ];then
                        rm -rf $i
                        fi 
                    fi
                elif [ ! -d $i ];then
                    echo -e "$PRPJ_DIR/$i_dir/$DESTINATION/$i does not exist"
                else
                    echo "$PRPJ_DIR/$i_dir/$DESTINATION/$i not empty"
                fi
            done
            echo -e "\n"
            cd $CUR_DIR
            
        fi
    done
    
}
function CopyFolder()
{
    
    PackAllFOLDER=`ls`
    for i in $PackAllFOLDER
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
    PackAllFOLDER=`ls`
    for i in $PackAllFOLDER
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
    PackAllFOLDER=`ls`
    for i in $PackAllFOLDER
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
        echo "  q: exit"
        read opt
        case $opt in
         1) CreateFolder ;;
         2) CleanFolder ;;
         3) CopyFolder ;;
         4) PackAllReplace ;;
         5) GitAddFolder ;;
         q) exit ;;
         *);;
        esac
    done
}


MenuFolder

