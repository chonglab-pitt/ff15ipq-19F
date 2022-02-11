#!/bin/bash

PDBs=(1a43_leap.pdb 1a43_min.pdb m01_2kod_leap.pdb 2kod_min.pdb 1A80_renum.pdb CM_robetta_M1_renum.pdb CM_1a43_m1.pdb)
V1=(1 75)
V2=(39)

echo "Using V1 = ${V1[@]} and V2 = ${V2[@]}:" >> result.txt

#----------------------------------------------#
for PDB in ${PDBs[@]} ; do
cat << EOF > calc_c2.cpp
parm $PDB
trajin $PDB 
# original def that works well with 2KOD
#vector D1 :46-49@CA,C,O,N :37-40@CA,C,O,N 
#vector D2 :134-137@CA,C,O,N :125-128@CA,C,O,N
# updated vectors to account for kink in helix 9 on Xtal 1A43
#vector D1 :41-44@CA,C,O,N :36-39@CA,C,O,N 
#vector D2 :129-132@CA,C,O,N :124-127@CA,C,O,N

# rep res pos with var
#vector D1 :${V1[0]}-${V1[1]}@CA,C,O,N :${V2[0]}-${V2[1]}@CA,C,O,N 
#vector D2 :$(( ${V1[0]} + 88 ))-$(( ${V1[1]} + 88 ))@CA,C,O,N :$(( ${V2[0]} + 88 ))-$(( ${V2[1]} + 88 ))@CA,C,O,N 
vector D1 :${V1[0]}-${V1[1]}@CA,C,O,N :${V2[0]}@CA,C,O,N 
vector D2 :$(( ${V1[0]} + 88 ))-$(( ${V1[1]} + 88 ))@CA,C,O,N :$(( ${V2[0]} + 88 ))@CA,C,O,N 

vectormath vec1 D1 vec2 D2 out ${PDB}_c2_angle.dat name C2_Angle dotangle
go
quit
EOF

cpptraj -i calc_c2.cpp
done
#----------------------------------------------#

for PDB in ${PDBs[@]} ; do
    c2=$(awk '{print $2}' ${PDB}_c2_angle.dat)
    echo "$PDB : $c2" >> result.txt
    rm ${PDB}_c2_angle.dat
done

echo -e "\n\n" >> result.txt
