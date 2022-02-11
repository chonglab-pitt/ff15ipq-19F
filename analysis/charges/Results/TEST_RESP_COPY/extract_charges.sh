#!/bin/bash

RES_CLASSES=(W4F W5F W6F W7F Y3F YDF F4F FTF)
LIB=19F_FF15IPQ_V00.lib

RES_NUM=0

echo ${RES_CLASSES[$RES_NUM]}
for LINE in $(grep "131072" $LIB | awk '{print $8}') ; do
    echo $LINE    
#    if [[ "$LINE" =~ ^[a-z]+$ ]] ; then 
#        continue
#    elif [[ "$LINE" == "c3x" ]] ; then
#        let "RES_NUM++"
#        echo ${RES_CLASSES[$RES_NUM]}
#    else
#        echo $LINE
#        echo $LINE >> ${LIB}.txt
#    fi
done
