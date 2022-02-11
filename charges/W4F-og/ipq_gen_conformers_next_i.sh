#!/bin/bash
# pipeline for ipq style charge derivation for fluorinated amino acids

######################################################################
# set variables
PDB=W4F
ITERATION=v02

export DO_PARALLEL="mpirun -np 8 pmemd.MPI"
######################################################################

function progress_check {
echo "Check files/output so far. Do you wish to continue?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done
}

function stage1_file_setup {
### stage 1: generate 20 conformations of target molecule
### directory and file setup

mkdir -v $ITERATION
cp -v ${PDB}.pdb $ITERATION
cd $ITERATION

# edit pdb file: get rid of connecting lines, change HETATOM to ATOM
sed -i '/CONECT/d' ${PDB}.pdb
sed -i 's/HETATM/ATOM  /g' ${PDB}.pdb

# save new pdb file of PDB_solo
cat ${PDB}.pdb | grep ${PDB} > ${PDB}_solo.pdb

echo "dir: $ITERATION prepped."
progress_check
cd ../
}


function mol2_frcmod_gen {
cd $ITERATION
# run antechamber to gen mol2 prep/lib file
antechamber \
    -i ${PDB}_solo.pdb      `# input pdb file` \
    -fi pdb                 `# input file format` \
    -o ${PDB}.mol2          `# output mol2 file(tleap compatible)` \
    -fo mol2                `# output file format` \
    -c bcc                  `# charge method = AM1-BCC` \
    -nc 0                   `# net charge` \
    -s 2                    `# verbose output option` \
    -m 1                    `# multiplicity (2S+1)` \
    -at amber               `# atomtype: amber formatting` \
    -pf y &&                `# remove intermediate files`

# for W4F, first N atom is of atom type DU and should be N
# the terminal C should not be CZ atom type
sed -i 's/DU  /N   /' ${PDB}.mol2 &&
sed -i 's/CZ  /C   /' ${PDB}.mol2 &&

echo "${PDB}.mol2 file generated."
echo "Check atom types in mol2 file: should match ff15ipq lib file -AT."
progress_check

# shouldn't need frcmod file if atom types are correct
# run parmchk2 to generate frcmod parameter file from mol2 file
#parmchk2 \
#    -i ${PDB}.mol2          `# input file` \
#    -f mol2                 `# input file formatting` \
#    -o ${PDB}.frcmod        `# output frcmod file` \
#    -p $AMBERHOME/dat/leap/parm/parm15ipq_10.3.dat
#
#echo "${PDB}.frcmod file generated."
#progress_check

cd ../
}


function lib_pdb_vacuo_gen {
cd $ITERATION
# generate tleap input file for solo AA lib file
#cat << EOF > tleap_lib.in
#source leaprc.protein.ff15ipq
#loadAmberParams ${PDB}.frcmod
#${PDB} = loadmol2 ${PDB}.mol2
#check ${PDB}
#saveOff ${PDB} ${PDB}.lib
#quit
#EOF

# tleap input for capped dipeptide vacuo files
cat << EOF > tleap_vacuo.in
source leaprc.protein.ff15ipq
loadoff ${PDB}.lib
${PDB} = loadpdb ${PDB}.pdb
check ${PDB}
set ${PDB} box {32.006 32.006 32.006}
saveAmberParm ${PDB} ${PDB}_V.top ${PDB}_V.crd
savepdb ${PDB} ${PDB}_V.pdb
quit
EOF

#tleap -f tleap_lib.in > tleap_lib.out
#echo "${PDB} lib file generated, connections may need to be manually fixed."
#progress_check
tleap -f tleap_vacuo.in > tleap_vacuo.out
echo "in vacuo top/crd/pdb files generated for ${PDB} dipeptide."
progress_check
cd ../
}


function in_vacuo_min {
cd $ITERATION

# unrestrained in vacuo 2000 step minimization (500 SD)
pmemd -O -i ../amber/2_min.in -o 2_min.out \
-p ${PDB}_V.top -c ${PDB}_V.crd -r ${PDB}_V.rst &&

echo "in vacuo min finished."
progress_check
cd ../ 
}


function gen_confs_mdgx {
cd $ITERATION
# TODO: add iat/phipsi var for gridsample
# generate mdgx input file for generation of 20 conformations
cat<<EOF > gen_confs.mdgx
&files
  -p ../${PDB}_V.top
  -c ../${PDB}_V.rst
  -o GenConformers.out
&end

&configs
  GridSample @5 @7 @9  @29  { -180.0 180.0 }   Krst 32.0 fbhw 30.0
  GridSample @7 @9 @29 @31  { -180.0 180.0 }   Krst 32.0 fbhw 30.0
  combine 1 2
  count 20
  verbose 1

  write   'pdb', 'inpcrd'
  outbase 'Conf', 'Conf'
  outsuff 'pdb', 'crd'
&end 
EOF

# store mdgx conformations in GenConformers directory
mkdir GenConformers
cd GenConformers
mdgx -i ../gen_confs.mdgx

echo "20 ${PDB} conformers generated in mdgx"
progress_check
cd ../../
}


function solv_equil_confs {
cd $ITERATION/GenConformers
# for each conformation,
for CONF in {1..20}; do
    # make and go into subdirectory
    mkdir Conf${CONF}
    mv Conf${CONF}.pdb Conf${CONF}
    mv Conf${CONF}.crd Conf${CONF}
    cd Conf${CONF}

    # write tleap file for solvation of vacuo structures
    COMMAND="source leaprc.protein.ff15ipq \n"
    COMMAND="${COMMAND}loadoff ../../${PDB}.lib \n"
    COMMAND="${COMMAND}loadamberparams ../../${PDB}.frcmod \n"
    COMMAND="${COMMAND}source leaprc.water.spceb \n"
    COMMAND="${COMMAND}${PDB} = loadPdb Conf${CONF}.pdb \n"
    COMMAND="${COMMAND}solvateoct ${PDB} SPCBOX 12.0 \n"
    COMMAND="${COMMAND}saveAmberParm ${PDB} Conf${CONF}.top Conf${CONF}.crd \n"
    COMMAND="${COMMAND}quit"
    echo -e ${COMMAND} > tleap_solv.in
    tleap -f tleap_solv.in > tleap_solv.out

    # restrained 2000 step minimization (500 SD)
    $DO_PARALLEL -O -i ../../../amber/6.1_min.in -o 6.1_min.out \
        -p Conf${CONF}.top -c Conf${CONF}.crd -r 6.1_min.rst -ref Conf${CONF}.crd &&
    echo ${CONF}.min finished

    # 20 ps restrained NVT equilibration using Langevin thermostat
    $DO_PARALLEL -O -i ../../../amber/6.2_eq1.in -o 6.2_eq1.out \
        -p Conf${CONF}.top -c 6.1_min.rst -r 6.2_eq1.rst -ref 6.1_min.rst &&
    echo ${CONF}.eq1 finished

    # 100 ps restrained NPT equilibration using Langevin thermostat and MC barostat
    $DO_PARALLEL -O -i ../../../amber/6.3_eq2.in -o 6.3_eq2.out \
        -p Conf${CONF}.top -c 6.2_eq1.rst -r 6.3_eq2.rst -ref 6.2_eq1.rst &&
    echo ${CONF}.eq2 finished

    cd ../
done

echo "Done solvating and equilibrating ${PDB} conformations."
#progress_check
cd ../../
}

#stage1_file_setup

#mol2_frcmod_gen

#lib_pdb_vacuo_gen

#in_vacuo_min

gen_confs_mdgx

# for this step: run batch file
#solv_equil_confs



