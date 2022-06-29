#!/bin/bash
#SBATCH --job-name=3of3_W4F_IPQ_US
#SBATCH --cluster=smp
#SBATCH --partition=smp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --mem=16g
#SBATCH --time=144:00:00  
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_us_3.out
#SBATCH --error=slurm_us_3.err

# load AMBER and prereqs
source ~/.setup.sh
source /ihome/lchong/dty7/bgfs-dty7/19F_ff15ipq/umbrella/scripts/gen_window_fun.sh

# echo commands to stdout
set -x 

NJOB=0

### 1/3 OF PHI
#for PHI in {-175..-065..10} ; do
#    for PSI in {-175..0175..10} ; do

### 2/3 OF PHI
#for PHI in {-055..0055..10} ; do
#    for PSI in {-175..0175..10} ; do

### 3/3 OF PHI
for PHI in {0065..0175..10} ; do
    for PSI in {-175..0175..10} ; do

### ALL OF PHI (CHECK)
#for PHI in {-175..0175..10} ; do
#    for PSI in {-175..0175..10} ; do

        mkdir -p /bgfs/lchong/dty7/19F_ff15ipq/umbrella/IPQ/W4F/CONFS/W4F_${PHI}_${PSI}
        cd /bgfs/lchong/dty7/19F_ff15ipq/umbrella/IPQ/W4F/CONFS/W4F_${PHI}_${PSI} &&

        gen_window W4F ${PHI} 15,17,19,39 ${PSI} 17,19,39,41 & 

        let "NJOB+=1"
        if [ ${NJOB} -eq 24 ] ; then
            NJOB=0
            wait
        fi

    done
done

# finish any unevenly ran jobs: this can cause slurm to return failure
wait

# gives stats of job, wall time, etc.
crc-job-stats.py 
