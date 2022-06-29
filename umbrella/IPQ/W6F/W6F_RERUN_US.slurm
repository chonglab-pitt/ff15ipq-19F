#!/bin/bash
#SBATCH --job-name=RE_W6F_IPQ_US
#SBATCH --cluster=smp
#SBATCH --partition=smp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=16g
#SBATCH --time=12:00:00  
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_us_rerun.out
#SBATCH --error=slurm_us_rerun.err
source ~/.setup.sh
source /ihome/lchong/dty7/bgfs-dty7/19F_ff15ipq/umbrella/scripts/gen_window_fun.sh
NJOB=0
RERUN=0
for PHI in {-175..0175..10} ; do
    for PSI in {-175..0175..10} ; do
        cd /bgfs/lchong/dty7/19F_ff15ipq/umbrella/IPQ/W6F/CONFS/W6F_${PHI}_${PSI} &&
        if [[ -f 06_prod.out && "$(tail -1 06_prod.out)" == "|  Total wall time:"* ]] ; then
            #echo PROD FILE ALREADY FINISHED FOR W6F : ${PHI}_${PSI}
            continue
        elif [[ ! -f 06_prod.out || "$(tail -1 06_prod.out)" != "|  Total wall time:"* ]] ; then
            echo PROD FILE ERROR FOR W6F : RERUNNING ${PHI}_${PSI}
            # no leading zeros for PHI and PSI integer inputs: prevents 085 and 095 errors
            gen_window W6F $(bc <<< "$PHI + 0") 15,17,19,39 $(bc <<< "$PSI + 0") 17,19,39,41 &
            let RERUN++
            let NJOB+=1
            if [ ${NJOB} -eq 4 ] ; then
                NJOB=0
                wait
            fi
        fi
    done
done
#wait
echo OVERALL: RERAN $RERUN WINDOWS
crc-job-stats.py 
