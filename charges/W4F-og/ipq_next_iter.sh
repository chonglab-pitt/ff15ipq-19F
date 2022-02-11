#!/bin/bash
# set-up next iteration of charge calculation

PDB=W4F
SOURCE=v02
ITERATION=v03

# setup next iteration directory
mkdir $ITERATION
cp -v $SOURCE/{${PDB}_final.lib,${PDB}.pdb,${PDB}.frcmod} $ITERATION

# switch source lib to current iteration lib
cd $ITERATION
mv -v ${PDB}_final.lib ${PDB}.lib

