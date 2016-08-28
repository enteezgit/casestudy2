#!/bin/bash

kclwt=`knife client list | grep websrvTEST`
if [ $kclwt == 'websrvTEST' ]
    then
    knife client delete websrvTEST -y 
    fi


kclwt=`knife node list | grep websrvTEST`
if [ $kclwt == 'websrvTEST' ]
    then
    knife node delete websrvTEST -y
    fi
