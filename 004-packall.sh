#!/bin/bash
#--------------------自动打包脚本，基于Windows-BashShell--------------------
#   Attention:
#       当前脚本及代码所在路径中不能出现空格,暂不支持修改为Windows路径格式
#   Usage: 
#       1:在当前目录鼠标右键选择打开git bash, 输入 sh packall.sh
#       2:将打开方式设置为Git for Windows，可以直接双击运行。
#
#   Description:
#       修改如下对应MCU和FBL文件名
#       TARGET_FILE
#       FBL_FILE
#
#       REL_NOTE_FOLDER下放ReleaseNote
#       SourceCode下放MCU源码
#       FBL下放FBL源码
#
#   history:
#    1.0:initial version
#
#
#   Author:liyingcai
#--------------------------------------------


#*-----------必选配置项，前中后不要有空格
#MCU name 例：TARGET_FILE=P2UF01_V1.4.2.201104
TARGET_FILE=

#FBL name 例：FBL_FILE=P2UF01_V1.3.1.201027.f
FBL_FILE=

#*------------可选配置项，慎改
#`pwd`获取linux目录格式：/e/xx/xx/xx
TOP_DIR=`pwd`
REL_NOTE_FOLDER=$TOP_DIR  #releaseNote
SRC_FOLDER=../SourceCode #不支持windows路径格式如，E:\xx\xx\xx\xx
FBL_FOLDER=../FBL     #不支持windows路径格式
PACKFILE_FOLDER=pack  #这里修改时对应的hex生成脚本也要修改。


#default Hex && Bin name
TARGET_PACK=$TARGET_FILE
TARGET_ALLHEX_NAME=$TARGET_FILE
APPL_FILE_NAME=$TARGET_FILE

#log format control
LEFT_SEPRATOR="*************"
RIGHT_SEPRATOR="************"
ECHO_OPT="-e"

#Modify Following code is not allowed unless authorized
function CreateArchive()
{
    echo "unpack HexView tool"
    tar -zxf $PACKFILE_FOLDER.tar.gz
##MCU SRC 
    if [ -d $SRC_FOLDER ];then
        if [  -d $TARGET_FILE ];then
           echo $ECHO_OPT "$LEFT_SEPRATOR $TARGET_FILE exists,exit now $RIGHT_SEPRATOR"
           read n
           exit $n
        else 
            if [ -f $TARGET_FILE.tar.gz ];then
                echo $ECHO_OPT "$LEFT_SEPRATOR error,$TARGET_FILE.tar.gz exists*******$RIGHT_SEPRATOR"
                read n
                exit $n
            else
                mkdir $TARGET_FILE
            fi
            echo $ECHO_OPT "$LEFT_SEPRATOR copy to - $TARGET_FILE $RIGHT_SEPRATOR"
            cp -rf $SRC_FOLDER/* $TARGET_FILE/
            rm -rf $TARGET_FILE/.git $TARGET_FILE/.gitignore
            echo $ECHO_OPT "$LEFT_SEPRATOR copy -$TARGET_FILE done ，compressing now $RIGHT_SEPRATOR"
        fi
        
        if [ ! -f $TARGET_FILE.tar.gz ];then
            tar -zcf $PACKFILE_FOLDER/$TARGET_FILE.tar.gz $TARGET_FILE/
            cp $TARGET_FILE/HexForFBL/Appl.hex $PACKFILE_FOLDER/
            rm -rf $TARGET_FILE/
            echo $ECHO_OPT "$LEFT_SEPRATOR compress done--$TARGET_FILE.tar.gz $RIGHT_SEPRATOR"
        else
            echo $ECHO_OPT "$LEFT_SEPRATOR error,$TARGET_FILE.tar.gz exists*******$RIGHT_SEPRATOR"
            read n
            exit $n
        fi
    else
        echo $ECHO_OPT "$LEFT_SEPRATOR copy error, $SRC_FOLDER does not exist $RIGHT_SEPRATOR"
        read n
        exit $n
    fi
    
##FBL SRC
    if [ -d $FBL_FOLDER ];then
        if [  -d $FBL_FILE ];then
        :
        else
            mkdir $FBL_FILE
            echo $ECHO_OPT "$LEFT_SEPRATOR copy to - $FBL_FILE $RIGHT_SEPRATOR"
            cp -rf $FBL_FOLDER/* $FBL_FILE/
            rm -rf $FBL_FILE/.git $FBL_FILE/.gitignore
            echo $ECHO_OPT "$LEFT_SEPRATOR copy -$FBL_FILE done ，compressing now $RIGHT_SEPRATOR"
        fi
        
        if [ ! -f $FBL_FILE.tar.gz ];then
            tar -zcf $PACKFILE_FOLDER/$FBL_FILE.tar.gz $FBL_FILE/
            cp $FBL_FOLDER/HexForAllHex/Fbl_CC.hex $PACKFILE_FOLDER/
            rm -rf $FBL_FILE/
            echo $ECHO_OPT "$LEFT_SEPRATOR compress done--$FBL_FILE.tar.gz $RIGHT_SEPRATOR"
        else
            echo $ECHO_OPT "$LEFT_SEPRATOR error,$FBL_FILE.tar.gz exists*******$RIGHT_SEPRATOR"
            read n
            exit $n
        fi
    else
        echo $ECHO_OPT "$LEFT_SEPRATOR copy error, $FBL_FOLDER does not exist $RIGHT_SEPRATOR"
        read n
            exit $n
    fi
}
function PackAll()
{
    if [ -d $TARGET_PACK ];then
        rm -rf $TARGET_PACK
    fi
    mkdir $TARGET_PACK
    cp -rf $PACKFILE_FOLDER/1* $PACKFILE_FOLDER/2* $PACKFILE_FOLDER/3* $TARGET_PACK/
##SOURCE 移动到pack中
    mv $PACKFILE_FOLDER/Appl.hex $TARGET_PACK/2_App/2_2_App_hex/
    mv $PACKFILE_FOLDER/$TARGET_FILE.tar.gz  $TARGET_PACK/2_App/2_1_App_Soucecode/
    mv $PACKFILE_FOLDER/Fbl_CC.hex $TARGET_PACK/3_FBL/3_2_FBL_hex/
    mv $PACKFILE_FOLDER/$FBL_FILE.tar.gz $TARGET_PACK/3_FBL/3_1_FBL_Soucecode/

## 调用脚本生成ALLHEX和APPL
    ALLHEX_BOOTLOAD=$TARGET_PACK/1_All_Hex_and_Bootload
    ALLHEX=$ALLHEX_BOOTLOAD/1_2_Config_File/AllHex
    APPHEX=$ALLHEX_BOOTLOAD/1_2_Config_File/AppHex
    
    cp $TARGET_PACK/3_FBL/3_2_FBL_hex/Fbl_CC.hex $TARGET_PACK/2_App/2_2_App_hex/Appl.hex $ALLHEX/
    cp $TARGET_PACK/3_FBL/3_2_FBL_hex/Fbl_CC.hex $TARGET_PACK/2_App/2_2_App_hex/Appl.hex $APPHEX/
    
    #./$ALLHEX_BOOTLOAD/1_2_Config_File/AllHex/AllHexMake.bat
    #./$ALLHEX_BOOTLOAD/1_2_Config_File/ApplHexMake/ApplHexMake.bat
    echo $ECHO_OPT  "$LEFT_SEPRATOR  AllHexMake $RIGHT_SEPRATOR"
    cd $ALLHEX/ && ./AllHexMake.bat &&  cd $TOP_DIR
    echo $ECHO_OPT  "$LEFT_SEPRATOR  ApplHexMake $RIGHT_SEPRATOR"
    #V71BinMaker_01A_1.exe
     #$TARGET_FILE> grep "P2UF01"
    if [[ $TARGET_FILE == P2UF01* ]];then
    cd $APPHEX/ && ./V71BinMaker_01A_1.exe  &&  cd $TOP_DIR
    else
    cd $APPHEX/ && ./ApplHexMake.bat &&  cd $TOP_DIR
    fi
    cp -r $ALLHEX/AllHex.hex $ALLHEX_BOOTLOAD/1_1_All_Hex_and_Bootload/烧录文件/$TARGET_ALLHEX_NAME.hex
     
    if [[ $TARGET_FILE == P2UF01* ]];then
    cp -r $APPHEX/3774100XVC01A.bin $ALLHEX_BOOTLOAD/1_1_All_Hex_and_Bootload/刷新文件/3774100XVC01A.bin
    else
    cp -r $APPHEX/ApplForFbl.bin $ALLHEX_BOOTLOAD/1_1_All_Hex_and_Bootload/刷新文件/$APPL_FILE_NAME.bin
    fi
#cp hex && bin to current directory for self check 
    cp -r $ALLHEX/AllHex.hex $TOP_DIR/$TARGET_ALLHEX_NAME.hex
    if [[ $TARGET_FILE == P2UF01* ]];then
    cp -r $APPHEX/3774100XVC01A.bin $TOP_DIR/3774100XVC01A.bin
    else
    cp -r $APPHEX/ApplForFbl.bin $TOP_DIR/$APPL_FILE_NAME.bin
    fi
##release note移动到pack中
    echo $ECHO_OPT  "$LEFT_SEPRATOR ReleaseNote $RIGHT_SEPRATOR"
    mv $REL_NOTE_FOLDER/*FBL*.xls[x,] $TARGET_PACK/3_FBL/3_3_FBL_Realease_note/
    cp $REL_NOTE_FOLDER/*.xls[x,] $TARGET_PACK/2_App/2_3_App_Realease_note/
    cp $TARGET_PACK/3_FBL/3_3_FBL_Realease_note/* $REL_NOTE_FOLDER/
#压缩
    tar -zcf $TARGET_PACK.tar.gz $TARGET_PACK/
    rm -rf $TARGET_PACK/
    echo $ECHO_OPT  "$LEFT_SEPRATOR Done $RIGHT_SEPRATOR"
}
function varCheck()
{
    if [ -z $TARGET_FILE -o -z $FBL_FILE ];then
        echo "TARGET_FILE or FBL_FILE empty"
        read n
        exit 1
    fi
    echo $ECHO_OPT "*----------- Pack Start ------*"
    if [ ! -f $REL_NOTE_FOLDER/*FBL*.xls[x,] -o ! -d $SRC_FOLDER/  -o  ! -d $FBL_FOLDER/ ];then
        echo "MCU or FBL ReleaseNote，SourceCode file does not exist,continue? y or n"
        read answer
        if [ "$answer" == "n" ];then
            exit 1
        fi
    fi
    
}
#tar -zcf $PACKFILE_FOLDER.tar.gz $PACKFILE_FOLDER/
#rm -rf $PACKFILE_FOLDER/
#ErrClean
varCheck
if [ $? -eq 0 ];then
    CreateArchive
fi
if [ $? -eq 0 ];then
    PackAll
    if [ $? -eq 0 ];then
        echo $ECHO_OPT "*-----------  Pack End ------*" 
        rm -rf $PACKFILE_FOLDER/
        read n
    else
        echo "error occured "
    fi
fi