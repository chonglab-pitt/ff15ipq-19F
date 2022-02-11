#!/bin/bash
# copy.sh

SYSTEMS=(w4f w5f w6f w7f wt)
SOURCE=/bgfs/lchong/dty7/19F_ff15ipq/CypA

for SYS in ${SYSTEMS[@]} ; do
    cd $SYS
    for VER in {0..4} ; do
        cd v0$VER
        rm -r 1us_w_ion 200ns 200ns-nocl
        cd ..
    done
    cd ..
done
