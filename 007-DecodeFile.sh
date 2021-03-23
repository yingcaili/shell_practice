#!/bin/bash
#****************************
#
#    Attention:
#       为防错误，文件名中不允许有空格
#
#
#****************************

#这里根据需要添加文件类型

ALLFILES=`ls *.xls[x]`
ALLFILES+=`ls *.doc[x]`



function Decodefiles()
{
    for spfile in $ALLFILES
    do
        echo -e "\n***************Dealing with ${spfile}***************"
        sed -i '1i\ ' $spfile 
        sed -i '1d' $spfile
        echo -e "***************Done with ${spfile}***************\n"    
    done
}


#根据需要选择调用
if [ ! -z "$ALLFILES" ];then
Decodefiles
fi
echo -e "\n\n\nAll Finished,Please close the window"
read n 

