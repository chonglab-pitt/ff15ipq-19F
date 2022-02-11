#!/bin/bash
# multi_set_and_run.sh
# set up and run multiple (5) replicates of each system for 200ns

#SYSTEMS=(wt w4f w5f w6f w7f)
SYSTEMS=(w4f)
FF="ipq"
mkdir $FF
cd $FF &&

# go to target directory
for SYS in ${SYSTEMS[@]} ; do
    mkdir $SYS
    cd $SYS
    echo "RUNNING SYSTEM : $SYS"

    # make the 5 replicate sub-directories
    for V in {05..05..1} ; do
        echo "GENERATING REPLICA V$V"
        # set up sub-directory
        mkdir v$V
        cp -v ../../ipq/$SYS/3k0n_${SYS}_leap.pdb v$V
        cp ../../std_sim_scripts/* v$V

        cd v$V
        # formatting
        bash temp_sed.sh 3k0n_$SYS v$V
        # make the inital parm and crd files
        tleap -f tleap.in > tleap.out
        # submit the prep run, which submits the prod after finishing
        #sbatch prep_mpi.slurm
        cd ..
    done

    echo "FINISHED SYSTEM : $SYS"
    cd ..
done        

