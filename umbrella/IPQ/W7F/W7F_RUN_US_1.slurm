#!/bin/bash
#SBATCH --job-name=1of3_W7F_IPQ_US
#SBATCH --cluster=smp
#SBATCH --partition=smp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --mem=16g
#SBATCH --time=96:00:00  
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_us_1.out
#SBATCH --error=slurm_us_1.err
source ~/.setup.sh
source /ihome/lchong/dty7/bgfs-dty7/19F_ff15ipq/umbrella/scripts/gen_window_fun.sh
set -x 
NJOB=0
for PHI in {-175..-065..10} ; do
    for PSI in {-175..0175..10} ; do
        mkdir -p /bgfs/lchong/dty7/19F_ff15ipq/umbrella/IPQ/W7F/CONFS/W7F_${PHI}_${PSI}
        cd /bgfs/lchong/dty7/19F_ff15ipq/umbrella/IPQ/W7F/CONFS/W7F_${PHI}_${PSI} &&
        gen_window W7F ${PHI} 15,17,19,39 ${PSI} 17,19,39,41 & 
        let NJOB+=1
        if [ ${NJOB} -eq 24 ] ; then
            NJOB=0
            wait
        fi
    done
done
wait
crc-job-stats.py 
