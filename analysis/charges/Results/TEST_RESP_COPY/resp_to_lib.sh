#!/bin/bash
# resp_to_lib.sh
# copy calculated resp charges from resp.out file to a new lib file

RESP=19F_FITQ_RESP_v01.out
LIB_OG=19F_FF15IPQ_V00.lib
LIB_NEW=19F_FF15IPQ_V01_TEST.lib

RES_CLASSES=(W4F W5F W6F W7F Y3F YDF F4F FTF)

# isolate the first system in RESP OUT
awk '{print $5}' $RESP > AWK
# get line numbers
grep -n "Delta" AWK.txt 


# need to put extra space for non-negative values
# copy from N to O to exclude ACE/NME
# or take the col and extract after line X and before line Y


# create new lib file and overwrite previous charge values

