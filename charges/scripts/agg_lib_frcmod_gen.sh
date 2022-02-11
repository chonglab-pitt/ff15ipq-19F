#!/bin/bash
# combine lib and frcmod files for individual res classes into aggregate universal file

RES_CLASSES=(W4F W5F W6F W7F Y3F YDF F4F FTF)
ITER=v00
LIB=19F_FF15IPQ.lib
FRCMOD=19F_FF15IPQ.frcmod

for RES in ${RES_CLASSES[@]} ; do
    cat $RES/$ITER/${RES}.lib >> $LIB
    cat $RES/$ITER/${RES}.frcmod >> $FRCMOD
done 
