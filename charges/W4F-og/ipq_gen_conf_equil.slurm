#!/bin/bash
#SBATCH --job-name=solv_min_equil_20_conf
#SBATCH --cluster=smp
#SBATCH --partition=smp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=16g
#SBATCH --time=23:59:59  
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=job_logs/slurm_equil.out
#SBATCH --error=job_logs/slurm_equil.err

# load appropriate modules, first purge all modules 
# then load in intel (a prereq for loading in amber) and then amber 
module purge
module load intel/2017.3.196
module load amber/18

# echo commands to stdout
set -x 

# import functions from gen conformers
source ipq_gen_conformers.sh

# run solv + equil conformations funct
solv_equil_confs
