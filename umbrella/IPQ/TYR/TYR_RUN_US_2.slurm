#!/bin/bash
#SBATCH --job-name=2of3_TYR_IPQ_US
#SBATCH --cluster=smp
#SBATCH --partition=smp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --mem=16g
#SBATCH --time=120:00:00  
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_us_2.out
#SBATCH --error=slurm_us_2.err
source ~/.setup.sh
source /ihome/lchong/dty7/bgfs-dty7/19F_ff15ipq/umbrella/scripts/gen_window_fun.sh
set -x 
NJOB=0
for PHI in {-055..0055..10} ; do
    for PSI in {-175..0175..10} ; do
        mkdir -p /bgfs/lchong/dty7/19F_ff15ipq/umbrella/IPQ/TYR/CONFS/TYR_${PHI}_${PSI}
        cd /bgfs/lchong/dty7/19F_ff15ipq/umbrella/IPQ/TYR/CONFS/TYR_${PHI}_${PSI} &&
        gen_window TYR $(bc <<< "$PHI + 0") 15,17,19,36 $(bc <<< "$PSI + 0") 17,19,36,38 &
        let NJOB+=1
        if [ ${NJOB} -eq 24 ] ; then
            NJOB=0
            wait
        fi
    done
done
wait
crc-job-stats.py 
