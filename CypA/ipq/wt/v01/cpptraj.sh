#!/bin/bash
# post-simulation processing with cpptraj

OUTPUT=200ns
PDB=3k0n
REF=3k0n_wt_leap.pdb
mkdir $OUTPUT

# TODO: make into one script with echo >> or $COMMAND 

# combine traj if needed, strip water/ions, dry parm/traj out
cat << EOF > ${OUTPUT}/strip_water.cpp
parm ${PDB}_12A.prmtop
trajin 06_prod.nc 1 last 1
autoimage
strip :WAT,Cl- parmout ${OUTPUT}/${PDB}_${OUTPUT}_dry.prmtop
rms fit @CA,C,O,N
trajout ${OUTPUT}/${PDB}_${OUTPUT}_dry.nc
go
quit
EOF

# calculate rmsd
cat << EOF > ${OUTPUT}/calc.cpp
parm ${PDB}_wt_dry.prmtop
trajin 06_prod_dry.nc 1 last 1000
multidihedral phi resrange 1-165 out ${OUTPUT}/dihedral_phi_1-165.dat
multidihedral psi resrange 1-165 out ${OUTPUT}/dihedral_psi_1-165.dat
run
quit
EOF

# calc rmsf
#cat << EOF > calc_rmsf.cpp
#parm ${PDB}.prmtop
#trajin ${PDB}.nc
#reference ${REF} name <st0>
#rms bbRMSD :1-176@CA,C,O,N out ${OUTPUT}/${PDB}_${OUTPUT}_rms.dat ref <st0> mass time 10
#average crdset avg_crd
#rms ref avg_crd
#atomicfluct out ${OUTPUT}/${PDB}_rmsf.dat @CA,C,O,N byres
#run
#quit
#EOF 

# execute cpptraj commands
CPPTRAJ=cpptraj
#$CPPTRAJ -i $OUTPUT/strip_water.cpp &&
$CPPTRAJ -i $OUTPUT/calc.cpp > $OUTPUT/calc.cpp.out
