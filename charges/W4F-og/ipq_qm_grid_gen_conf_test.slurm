#!/bin/bash
#SBATCH --job-name=c5-ipq-mdgx-grid-gen-8cpu-hmem-noscr
#SBATCH --cluster=smp
#SBATCH --partition=smp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=120g
#SBATCH --time=47:59:59  
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=job_logs/slurm_8CPU_hmem_noscr_conf5.out
#SBATCH --error=job_logs/slurm_8CPU_hmem_noscr_conf5.err

##############################################################
##### ipq charge derivation: QM and grid file generation #####
##############################################################

# load appropriate modules, first purge all modules 
# then load in intel (a prereq for loading in amber) and then amber 
module purge
module load intel/2017.3.196
module load amber/18

# load required QM modules
# the default versions from ATB and on H2P natively are
# gcc-5.4.0/openmpi/1.6.5 and orca/3.0.3
#module load openmpi/3.1.4
#module load orca/4.2.0

# echo commands to stdout
set -x 

# how many cores for each mdgx process
CPU=8
export DO_PARALLEL="mpirun -np ${CPU}"

# go to GenConformers dir
cd v00/GenConformers


# eventually put this in loop for all conformations
# for now, move to 1 directory
CONF=5
cd Conf${CONF}-test

# contingent step to delete old files
if [ -f "ipolq.out" ]; then
    rm -v ipolq.out
fi
if [ -f "mdcrd" ]; then
    rm -v mdcrd
fi
# delete files from old run
if [ -f "restrt" ]; then
    rm -v restrt
    rm -v qm* 
    rm -v *_output*
    rm -rv scratch
fi
# if needed: make dir to use during QM
if [ ! -d scratch ]; then
    mkdir -v scratch
fi


# write ipq qm mdgx input file
cat << EOF > ipq_qm_mp2_grid_gen.mdgx
&files
  -p Conf${CONF}.top
  -c Conf${CONF}.crd
  -o ipolq.out
&end

&cntrl
  imin      = 0
  irest     = 0
  dt        = 0.002
  nstlim    = 250000
  ntp       = 0
  ntt       = 3
  tempi     = 298.0
  temp0     = 298.0
  gamma_ln  = 1.0
  rigidbond = 1
  rigidwat  = 1
  es_cutoff     = 10.0
  vdw_cutoff    = 10.0
  ntpr      = 500
  ntwr      = 250000
  ntwx      = 500
  iwrap     = 1,
&end

&ipolq
  solute    = ':1-3'
  ntqs      = 1000
  nqframe   = 200
  nsteqlim  = 50000
  nblock    = 4
  verbose   = 1
  modq      = ':WAT & @H1'   0.5173
  modq      = ':WAT & @H2'   0.5173
  modq      = ':WAT & @O'   -1.0346
  nqshell   = 3
  nqphpt    = 100
  qshellx   = 2.0
  qshell1   = 5.0
  qshell2   = 5.5
  qshell3   = 6.0
  minqwt    = 0.01
  nvshell   = 3
  nvphpt    = 20
  vhsell1   = 0.3
  vshell2   = 0.5
  vshell3   = 0.7
  qmprog    = 'orca'
  prepqm    = "PATH=/ihome/crc/install/gcc-5.4.0/openmpi/1.6.5/bin:\$PATH"
  prepqm    = "LD_LIBRARY_PATH=/ihome/crc/install/gcc-5.4.0/openmpi/1.6.5/lib:\$LD_LIBRARY_PATH"
  qmpath    = '/ihome/crc/build/orca/3.0.3/orca'
  uvpath    = '/ihome/crc/build/orca/3.0.3/orca_vpot'
  maxcore   = 80000
  qmlev     = MP2
  basis     = cc-pvTZ
  unx       = 121
  uny       = 121
  unz       = 121
  uhx       = 0.2
  uhy       = 0.2
  uhz       = 0.2
  qmcomm    = qm_input
  qmresult  = qm_output
  rqminp    = 1
  rqmchk    = 1
  rqmout    = 1
  rcloud    = 1
  grid      = grid_output
  ptqfi     = srfp_output
  verbose   = 1
&end
EOF

# run mdgx on one conformation
$DO_PARALLEL mdgx.MPI -i ipq_qm_mp2_grid_gen.mdgx

# gives stats of job, wall time, etc.
crc-job-stats.py 

