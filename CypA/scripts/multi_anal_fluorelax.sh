#!/bin/bash
# analyze multiple (5) replicates of each system

SYSTEMS=(w4f w5f w6f w7f) 
#SYSTEMS=(w4f) 
OUT_ROOT=1us_noion
PDB=3k0n
FF="ipq"

cd $FF

# go to target directory
for SYS in ${SYSTEMS[@]} ; do
    cd $SYS &&
    echo "RUNNING SYSTEM : $SYS"

    # make the 5 replicate sub-directories
    for V in {00..04..1} ; do
        echo "GENERATING REPLICA V$V"
        # go to sub-directory
        cd v$V
        mkdir $OUT_ROOT

        python /bgfs/lchong/dty7/19F_ff15ipq/CypA/fluorelax/fluorelax/fluorelax.py -p ../${PDB}_${SYS}_dry_noion.prmtop -c 07_prod_dry.nc 08_prod_dry.nc --step 1000 -o ${OUT_ROOT}/19F_R1_R2_800ns.dat --sys $SYS
        
        cd ..
    done

    cd ..
    echo "FINISHED RUNNING SYSTEM : $SYS"
done
