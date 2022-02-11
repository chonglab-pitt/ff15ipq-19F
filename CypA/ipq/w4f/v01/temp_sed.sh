#!/bin/bash
# temp_sed.sh
# replace 3k0n_w4f in the std sim scripts dir with target PDB
# 1 arg = pdb system prefix     :   e.g. 2kod_wt

PDB=$1

# apply globally to all files in current directory
sed -i "s/3k0n_w4f/${PDB}/g" *

