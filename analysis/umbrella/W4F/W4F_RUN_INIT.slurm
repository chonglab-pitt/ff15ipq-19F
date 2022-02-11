#!/bin/bash
#SBATCH --job-name=W4F_IPQ_US
#SBATCH --cluster=smp
#SBATCH --partition=smp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=16g
#SBATCH --time=24:00:00  
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_init.out
#SBATCH --error=slurm_init.err

# load AMBER and prereqs
source ~/.setup.sh

# echo commands to stdout
set -x 

# run init script
bash ../../scripts/0.init_struct.sh W4F

# gives stats of job, wall time, etc.
crc-job-stats.py 
