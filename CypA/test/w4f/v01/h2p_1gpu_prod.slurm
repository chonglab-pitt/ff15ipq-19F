#!/bin/bash
#SBATCH --job-name=3k0n_w4f_PROD_v01
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=1 
#SBATCH --cluster=gpu 
#SBATCH --gres=gpu:1
#SBATCH --partition=gtx1080 
#SBATCH --time=144:00:00 
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_prod.out 
#SBATCH --error=slurm_prod.err 

# load appropriate modules.  First purge all modules then load in intel (a prereq for loading in amber) and then amber 
module purge
module load intel/2017.3.196
module load amber/18

# echo commands to stdout
set -x

# Executable
SANDER=pmemd.cuda

# Amber input files and output name
INP=06_prod.in
TOP=3k0n_w4f_solv.prmtop
CRD=05_eq3.rst
OUT=06_prod

$SANDER  -O     -i   $INP   -p   $TOP   -c   $CRD   -r   $OUT.rst \
        -o   $OUT.out   -e   $OUT.ene   -v   $OUT.vel   -inf $OUT.nfo   -x   $OUT.nc &&

# make cpptraj input file
echo "parm 3k0n_w4f_solv.prmtop"                            > cpptraj.in
echo "trajin 06_prod.nc"                                    >> cpptraj.in
echo "autoimage"                                            >> cpptraj.in
echo "strip :WAT,Cl- parmout 3k0n_w4f_dry.prmtop"           >> cpptraj.in
echo "trajout 06_prod-dry.nc"                               >> cpptraj.in
echo "go"                                                   >> cpptraj.in
echo "quit"                                                 >> cpptraj.in

# run cpptraj to strip water
cpptraj -i cpptraj.in > cpptraj.out

# remove solvated nc file
if [ -f "06_prod-dry.nc" ] ; then
    rm 06_prod.nc &&
    mv 06_prod-dry.nc 06_prod.nc
fi

