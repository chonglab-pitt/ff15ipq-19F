#!/bin/bash
#SBATCH --job-name=W4F_IPQ_US
#SBATCH --cluster=smp
#SBATCH --partition=smp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --mem=16g
#SBATCH --time=144:00:00  
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_us.out
#SBATCH --error=slurm_us.err

# load AMBER and prereqs
source ~/.setup.sh
source /ihome/lchong/dty7/bgfs-dty7/19F_ff15ipq/umbrella/scripts/gen_window_fun.sh

# echo commands to stdout
set -x 

NJOB=0
for PHI in {005..175..10} ; do
    for PSI in {005..175..10} ; do
        mkdir -p /bgfs/lchong/dty7/19F_ff15ipq/umbrella/IPQ/W4F/CONFS/${PHI}_${PSI}
        cd /bgfs/lchong/dty7/19F_ff15ipq/umbrella/IPQ/W4F/CONFS/${PHI}_${PSI} &&

        gen_window W4F ${PHI} 5,7,9,29 ${PSI} 7,9,29,31 & 
        let "NJOB+=1"
        if [ ${NJOB} -eq 24 ] ; then
            NJOB=0
            wait
        fi

    done
done

# finish any unevenly ran jobs
if [[ 0 != 0 ]] ; then
    wait
fi

# gives stats of job, wall time, etc.
crc-job-stats.py 
