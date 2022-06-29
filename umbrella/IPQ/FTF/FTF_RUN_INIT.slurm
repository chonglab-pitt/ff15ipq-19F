#!/bin/bash
#SBATCH --job-name=FTF_IPQ_US_INIT
#SBATCH --cluster=smp
#SBATCH --partition=smp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=16g
#SBATCH --time=2:00:00  
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_init.out
#SBATCH --error=slurm_init.err

# load AMBER and prereqs
source ~/.setup.sh

# echo commands to stdout
set -x 

# run init script
bash ../../scripts/0.init_struct_mpi.sh FTF 4

# gives stats of job, wall time, etc.
crc-job-stats.py 
