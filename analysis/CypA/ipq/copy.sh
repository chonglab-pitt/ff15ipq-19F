#!/bin/bash
# copy.sh

SYSTEMS=(w4f w5f w6f w7f wt)
SOURCE=/bgfs/lchong/dty7/19F_ff15ipq/CypA

for SYS in ${SYSTEMS[@]} ; do
    mkdir $SYS
    cd $SYS
    for VER in {00..04} ; do
        mkdir v$VER

        scp -r dty7@h2p.crc.pitt.edu:$SOURCE/$SYS/v$VER/200ns v$VER
    done
    cd ..
done
