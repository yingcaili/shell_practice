#!/bin/bash

function DeleteUser()
{
    ECHO_OPT='-e'
    echo $ECHO_OPT "user you need to delete:\c"
    read delusername
    echo $ECHO_OPT "delete all files?,y or n:\c"
    read answer
    if [ ${answer}=='y' -o ${answer}='Y'];then
        userdel -r ${delusername}
    else
        userdel ${delusername}
    fi
}

DeleteUser