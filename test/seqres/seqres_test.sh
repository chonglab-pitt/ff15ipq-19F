#!/bin/bash

SYSTEMS=(F4F FTF Y3F YDF W4F W5F W6F W7F)

for SYS in ${SYSTEMS[@]} ; do

    CMD="     source leaprc.protein.ff15ipq \n"
    CMD="$CMD source leaprc.fluorine.ff15ipq \n"
    CMD="$CMD source leaprc.water.spce \n"
    CMD="$CMD ${SYS} = sequence { ACE ALA ${SYS} ALA NME } \n"
    CMD="$CMD check ${SYS} \n"
    CMD="$CMD savepdb ${SYS} ${SYS}_tet.pdb \n"
    CMD="$CMD quit"

    echo -e $CMD > tleap.in
    tleap -f tleap.in > tleap.out

done
