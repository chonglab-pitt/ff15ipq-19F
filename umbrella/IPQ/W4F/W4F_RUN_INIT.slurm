#!/bin/bash
#SBATCH --job-name=W4F_IPQ_US_INIT
#SBATCH --cluster=invest
#SBATCH --partition=lchong
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=16g
#SBATCH --time=12:00:00  
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_init.out
#SBATCH --error=slurm_init.err

# load AMBER and prereqs
source ~/.setup.sh

# echo commands to stdout
set -x 

# run init script
bash ../../scripts/0.init_struct_mpi.sh W4F 8

# gives stats of job, wall time, etc.
crc-job-stats.py 
