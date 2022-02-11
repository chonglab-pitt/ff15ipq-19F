#!/bin/bash
# written by DTY on 25Jan2022 | last updated by DTY on 25Jan2022
# isolate a frame of the MD trajectory and output as a pdb file

# set up a frame pdb directory
mkdir frame_pdbs

systems=(w7f)
frame=150 # ns

for SYS in ${systems[@]}; do
    for VER in {00..04}; do

        C0="    parm $SYS/v$VER/3k0n_${SYS}_dry_noion.prmtop \n"
        C0="$C0 trajin $SYS/v$VER/06_prod_dry.nc ${frame}000 ${frame}000 1 \n"
        C0="$C0 autoimage \n"
        C0="$C0 rms fit :1-165@CA,C,O,N \n"
        C0="$C0 trajout frame_pdbs/3k0n_${SYS}_v${VER}_${frame}ns.pdb pdb \n"
        C0="$C0 run"

        echo -e $C0 > frame_pdbs/iso_frame.cpp
        cpptraj -i frame_pdbs/iso_frame.cpp 

    done
done 
