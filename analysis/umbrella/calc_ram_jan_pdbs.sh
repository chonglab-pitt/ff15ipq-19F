#!/bin/bash
# use cpptraj to calculate the phi, psi, chi1, and chi2
# dihedral angles of an set of pdb files

systems=(w4f w5f w6f w7f y3f ydf f4f ftf)

cd 19F_pdbs

# run cpptraj phi/psi/chi1/chi2 calc
for SYS in ${systems[@]} ; do

    # loop through all files (pdbs) in directory
    for FILE in $SYS/* ; do
        C0="    parm $FILE \n"
        C0="$C0 trajin $FILE \n"
        C0="$C0 multidihedral phi psi resrange 121-121 out phipsi_cypa_w4f.dat \n"
        C0="$C0 multidihedral dihtype chi1:N:CA:CB:CG dihtype chi2:CA:CB:CG:CD1 "
        C0="$C0     resrange 121-121 out chi1chi2_cypa_w4f.dat \n"
        C0="$C0 run \n quit"
    done

done