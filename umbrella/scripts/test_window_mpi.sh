#!/bin/bash
#SBATCH --job-name=W4F_TEST_US_INIT
#SBATCH --cluster=invest
#SBATCH --partition=lchong
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=16g
#SBATCH --time=24:00:00  
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_init.out
#SBATCH --error=slurm_init.err

# TRP
PHI_IAT="15,17,19,39"
PSI_IAT="17,19,39,41"
PHI=5
PSI=5

source ~/.setup.sh
source ../../scripts/gen_window_fun_mpi.sh

mkdir CONFS
mkdir -p CONFS/${PHI}_${PSI}
cd CONFS/${PHI}_${PSI}

# RES PHI PHIIAT PSI PSIIAT NCPU
gen_window W4F $PHI $PHI_IAT $PSI $PSI_IAT 8
