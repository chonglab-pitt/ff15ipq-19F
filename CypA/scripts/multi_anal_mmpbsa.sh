#!/bin/bash
# analyze multiple (5) replicates of each system

# load MMGBSA modules
source /ihome/crc/build/amber/amber18_x64/amber18/amber.sh

SYSTEMS=(wt w4f w5f w6f w7f) 
#SYSTEMS=(wt) 
OUT_ROOT=1us_noion
PDB=3k0n
FF="ipq"

export DO_PARALLEL="mpirun -np 20"

cd $FF

# go to target directory
for SYS in ${SYSTEMS[@]} ; do
    cd $SYS &&
    echo "RUNNING SYSTEM : $SYS"

    # make the 5 replicate sub-directories
    for V in {00..04..1} ; do
        echo "GENERATING REPLICA V$V"
        # go to sub-directory
        mkdir -p v$V/$OUT_ROOT/mmpbsa
        cd v$V/$OUT_ROOT/mmpbsa

        # make the vac file if needed
        if [ ! -f ${PDB}_${SYS}_vac.inpcrd ] ; then
            LP="    source leaprc.protein.ff15ipq \n"
            LP="$LP loadoff ../../../../../19F_FF15IPQ_V03_IPQ_ADJ.lib \n"
            LP="$LP loadAmberParams ../../../../../19F_FF15IPQ_FIT_V01.frcmod \n"
            LP="$LP pdb = loadpdb ../../${PDB}_${SYS}_leap.pdb \n"
            # select the correct radii for the calculation method (IGB=2)
            LP="$LP set default PBRadii mbondi2 \n"
            LP="$LP saveamberparm pdb ${PDB}_${SYS}_vac.prmtop ${PDB}_${SYS}_vac.inpcrd \n"
            LP="$LP quit"
            echo -e "$LP" > leap.in
            tleap -f leap.in > leap.out
        fi

        IN="    Input file for running PB and GB \n"
        IN="$IN &general \n"
        # run every 2 ns for 200ns-1000ns, skipping initial equilibrating prod
        IN="$IN    startframe=200000, endframe=1000000, interval=2000 \n"
        IN="$IN    keep_files=0, verbose=1, netcdf=1 \n"
        IN="$IN / \n" 
        IN="$IN &pb \n"
        # inp=1 is original SA non-polar solvation calc
        # inp=2 (default) is updated with seperate terms for cavity and vdw dispersions
        IN="$IN    inp=1 \n"
        IN="$IN    istrng=0.0, radiopt=0 \n"
        IN="$IN / \n"
        # decompose the contributions of only residue 121
        IN="$IN &decomp \n"
        # idecomp=1 adds 1-4 EEL and 1-4 VDW to internal
        # idecomp=2 adds them to overall EEL and VDW terms
        IN="$IN   idecomp=1, print_res='120-122' \n"
        # 1 - DELTA energy, total, sidechain, and backbone contributions (0 = total only)
        IN="$IN   dec_verbose=1, \n"
        IN="$IN /"

        echo -e "$IN" > mmpbsa.in

        $DO_PARALLEL \
        $AMBERHOME/bin/MMPBSA.py.MPI -O -i mmpbsa.in -o MMPBSA_RESULTS_INP1.dat -eo MMPBSA_ENERGY_OUT_INP1.dat -do MMPBSA_DECOMP_RESULTS_INP1.dat -deo MMPBSA_DECOMP_ENERGY_OUT_INP1.dat -cp ${PDB}_${SYS}_vac.prmtop -y ../../??_prod_dry.nc > progress.log 2>&1
        
        cd ../../../
    done

    cd ..
    echo "FINISHED RUNNING SYSTEM : $SYS"
done
