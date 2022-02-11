#!/bin/bash
# temp_sed.sh
# replace 3k0n_w4f and v04 in the std sim scripts dir with target PDB

# Parameters
# ----------
# arg 1 = pdb system prefix         :   e.g. 2kod_wt
# arg 2 = version of the replicate  :   e.g. v00

PDB=$1
v04=$2

# apply globally to all files in current directory
sed -i "s/3k0n_w4f/${PDB}/g" *
sed -i "s/v04/${VER}/" * 
