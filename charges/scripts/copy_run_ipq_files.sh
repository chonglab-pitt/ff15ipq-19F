#!/bin/bash
# copy over "master" ipq run scripts to other res classes

MASTER_RES=W4F
#RES_CLASSES=(W4F W5F W6F W7F Y3F YDF F4F FTF)
RES_CLASSES=(Y3F YDF F4F FTF)
#RES_CLASSES=(W4F W5F W6F W7F)
FILES=(0.ipq_gen_conformers_next_iter.sh 1.ipq_gen_conf_equil.slurm 2.ipq_qm_multi_conf_run.sh)
#FILES=(1.ipq_gen_conf_equil.slurm 2.ipq_qm_multi_conf_run.sh)
#FILES=(2.ipq_qm_multi_conf_run.sh)
# note: iat phi and psi angle values will be overrode in step 0

for RES in ${RES_CLASSES[@]} ; do
    if [[ "$RES" == "$MASTER_RES" ]] ; then
        continue
    else
        for FILE in ${FILES[@]} ; do 
            cp -v $MASTER_RES/$FILE $RES
            sed -i "s/$MASTER_RES/$RES/g" $RES/$FILE 
        done
    fi
done 

