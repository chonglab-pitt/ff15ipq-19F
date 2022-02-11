#!/bin/bash

SYSTEMS=(W4F W5F W6F W7F Y3F YDF F4F FTF)

for SYS in ${SYSTEMS[@]} ; do

    scp dty7@h2p.crc.pitt.edu:/bgfs/lchong/dty7/19F_ff15ipq/umbrella/IPQ/$SYS/${SYS}_tet.pdb .

done
