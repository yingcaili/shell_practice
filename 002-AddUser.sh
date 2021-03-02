#!/bin/bash
###################################
#    Description:
#        create a new user who logs in using a generated sshkey
#
#
#
#
#
###################################
ECHO_OPT='-e'
echo $ECHO_OPT "New user name:\c"
read newusername
groupname=${newusername}
pathbak="/home/liyingcai/sshkey-bk/${newusername}"


function AddUserInfo()
{
    if [ `cat /etc/group | grep "${groupname}"` =="" ];then
        groupadd ${groupname}
    fi
    useradd -m -s "/bin/bash"  ${newusername} -g ${groupname} 
}
function AddSSHKey()
{
    cd /home/${newusername}
    ssh-keygen -t rsa -f /home/$newusername/id_rsa 
    touch authorized_keys
    cat id_rsa.pub >>authorized_keys
    chmod 600 authorized_keys
    mkdir .ssh
    chmod 700 .ssh
    mv authorized_keys .ssh/

    chown -R ${newusername}:${groupname} .ssh/
}
function Bak_SSHKey()
{
    key_folder="key_`date`"
    if [ ! -d ${pathbak}/ ];then
        mkdir -p ${pathbak}/
        chown -R ${newusername}:${groupname} ${pathbak}/
    fi
    if [ ! -d ${key_folder} ];then
        mkdir ${key_folder}
    fi
    cp id_rsa id_rsa.pub ${pathbak}/${key_folder}
}

function MainFunction()
{
    AddUserInfo
    AddSSHKey
    Bak_SSHKey
}

MainFunction
function Menu()
{
    while true
    do
        echo "--------------create basic folder--------------"
        echo "choose following function:"
        echo "  1: create folder"
        echo "  2: delete folder"
        echo "  q: exit"
        read opt
        case $opt in
         1) CreateFolder ;;
         2) CleanFolder ;;
         q) exit ;;
         *);;
        esac
    done
}