#!/bin/bash
#*************************************************
#   BaseTool:
#       安装支持shell的软件 如：https://git-scm.com/downloads
#   Usage:
#       安装git后，双击或者右键-打开方式-使用Git-For-Windows打开
#   Description:
#       把这个脚本和要解压的文件放在同一目录下，不建议有其他文件同时存在
#       解压&&复制产品XX科对应的软件到指定文件夹，只适用于XX科打包的形式
#
#   Author: liyingcai
#   History:
#       2021.02.01:Initial version
#*************************************************

#
#获取要解压的tar.gz文件名字，也可以手动填入如 UNPRESS_FOLDER_NAME=XX-XXXX_V1.2.2.210128
#如下自动获取文件名要保证当前文件夹内只有一个tar.gz文件
UNPRESS_FOLDER_NAME=$(basename  `ls *.tar.gz` .tar.gz)

#代码文件夹名字
CODE_FOLDER_NAME="code"
#校对文件夹名字指定
VERRIFY_FOLDER_NAME="verify"

#ALLHEX和APPHEX文件夹
CONFIG_FOLDER_NAME=${VERRIFY_FOLDER_NAME}
#解压
function Uncompress()
{
    tar -zxvf ${UNPRESS_FOLDER_NAME}.tar.gz #${UNPRESS_FOLDER_NAME}
}


#判断&&生成代码和校对文件夹
function CreateFolder()
{
    if [ ! -d ${CODE_FOLDER_NAME} ];then
        mkdir ${CODE_FOLDER_NAME}
    fi

    if [ ! -d ${VERRIFY_FOLDER_NAME} ];then
        mkdir ${VERRIFY_FOLDER_NAME}
    fi
}
function CopySrc()
{
    ##复制源码到 指定文件夹
    cp ${UNPRESS_FOLDER_NAME}/2_App/2_1_App_Soucecode/*.tar.gz ${CODE_FOLDER_NAME}/
    cd ${CODE_FOLDER_NAME}/ && tar -zxvf *.tar.gz && rm -rf *.tar.gz && cd ..

    cp ${UNPRESS_FOLDER_NAME}/3_FBL/3_1_FBL_Soucecode/*.tar.gz ${CODE_FOLDER_NAME}/
    cd ${CODE_FOLDER_NAME}/ && tar -zxvf *.tar.gz && rm -rf *.tar.gz && cd ..
    cd ${CODE_FOLDER_NAME}/ 
    for i in `ls -d */`
        do
        if [ -f ${i}/HexForFBL/*.hex ];then
            echo "copy app"
            cp ${i}/HexForFBL/*.hex .
        fi
        if [ -f ${i}/HexForAllHex/*.hex ];then
            echo "copy FBL"
            cp ${i}/HexForAllHex/*.hex .
        fi
        done
    cd ..
}
function CreateFile()
{
    cd ${CODE_FOLDER_NAME}/ && touch "编译完成对比OK后点我自动复制文件到${VERRIFY_FOLDER_NAME}-APPHEX和ALLHEX.sh" && `chmod u+x *.sh` && cd ..
    cd ${CODE_FOLDER_NAME}/ 
    echo '#!/bin/bash
    CONFIG_FOLDER_NAME="verify"
    for name in `ls -d */`
        do 
        echo ${name}
            #APPHEX复制
            if [ -f ${name}/HexForFBL/*.hex ];then
                echo "copy app"
                cp ${name}/HexForFBL/*.hex ../${CONFIG_FOLDER_NAME}/AppHex/
                cp ${name}/HexForFBL/*.hex ../${CONFIG_FOLDER_NAME}/AllHex/
            fi
            #FBL HEX复制
            if [ -f ${name}/HexForAllHex/*.hex ];then
                echo "copy FBL"
                cp ${name}/HexForAllHex/*.hex ../${CONFIG_FOLDER_NAME}/AllHex/
            fi
        done
        
        read n
        '> "编译完成对比OK后点我自动复制文件到${VERRIFY_FOLDER_NAME}-APPHEX和ALLHEX.sh"
    cd ..
}

function CopyHexFbl()
{
    #复制烧录和刷新文件到指定文件夹
    cp  ${UNPRESS_FOLDER_NAME}/1_All_Hex_and_Bootload/1_1_All_Hex_and_Bootload/烧录文件/*.hex ${VERRIFY_FOLDER_NAME}/
    cp  ${UNPRESS_FOLDER_NAME}/1_All_Hex_and_Bootload/1_1_All_Hex_and_Bootload/刷新文件/*.bin ${VERRIFY_FOLDER_NAME}/

    #复制Allhex和Apphex到指定文件夹
    cp -rf ${UNPRESS_FOLDER_NAME}/1_All_Hex_and_Bootload/1_2_Config_File/* ${CONFIG_FOLDER_NAME}/
}

function Clean()
{
    # 删除解压生成的文件夹
    rm -rf ${UNPRESS_FOLDER_NAME} 
}
function End()
{
    echo "******************Done，请关闭此窗口*****************"
    #占位语句，起暂停作用
    read n
}

function mainFunction()
{
    Uncompress
    CreateFolder
    CopySrc
    CreateFile
    CopyHexFbl
#需要删除解压生成的文件夹时，将下面一行的#去掉
    #Clean
    End
}


mainFunction