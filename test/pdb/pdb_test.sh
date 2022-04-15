#!/bin/bash

SYSTEMS=(wt w4f w5f w6f w7f)

for SYS in ${SYSTEMS[@]} ; do

    CMD="     source leaprc.protein.ff15ipq \n"
    CMD="$CMD source leaprc.fluorine.ff15ipq \n"
    CMD="$CMD source leaprc.water.spce \n"
    CMD="$CMD pdb = loadpdb 3k0n_${SYS}_leap.pdb\n"
    #CMD="$CMD check pdb \n"
    CMD="$CMD addions pdb Cl- 0 \n"
    CMD="$CMD solvateoct pdb SPCBOX 12.0 \n"
    CMD="$CMD saveamberparm pdb ${SYS}_solv.prmtop ${SYS}_solv.inpcrd \n"
    CMD="$CMD savepdb pdb ${SYS}_solv.pdb \n"
    CMD="$CMD quit"

    echo -e $CMD > tleap.in
    tleap -f tleap.in > tleap.out

done
