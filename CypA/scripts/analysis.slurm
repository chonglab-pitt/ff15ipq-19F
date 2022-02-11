#!/bin/bash
#SBATCH --job-name=cypa_multi_cmd_anal
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=20
#SBATCH --cluster=invest
#SBATCH --partition=lchong
#SBATCH --mem=16g
#SBATCH --time=23:59:59 
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_out/anal.out 
#SBATCH --error=slurm_out/anal.err 

# load appropriate modules.  First purge all modules then load in intel (a prereq for loading in amber) and then amber 
module purge
module load intel/2017.3.196
module load amber/18

# echo commands to stdout
set -x

bash scripts/multi_anal_mmpbsa.sh
