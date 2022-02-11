#!/bin/bash
# run as: $ bash scripts/0.submit_init.sh

FF="IPQ"
#RES_CLASSES=(W5F W6F W7F Y3F YDF F4F FTF)
RES_CLASSES=(TRP TYR PHE)

mkdir ${FF}
cd ${FF} &&

###############################################################################
#######################       BEGIN LOOP         ##############################
###############################################################################
for RES in ${RES_CLASSES[@]} ; do

mkdir ${RES}
cd ${RES} &&

# optionally use mpi version with 0.init_struct_mpi.sh and NCPU arg
NCPU=4

# submit initial structure gen for one res class
cat << EOF > ${RES}_RUN_INIT.slurm
#!/bin/bash
#SBATCH --job-name=${RES}_${FF}_US_INIT
#SBATCH --cluster=smp
#SBATCH --partition=smp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=$NCPU
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
bash ../../scripts/0.init_struct_mpi.sh $RES $NCPU

# gives stats of job, wall time, etc.
crc-job-stats.py 
EOF
 
sbatch ${RES}_RUN_INIT.slurm
echo -e "FINISHED INIT STRUCT SUBMISSION FOR $RES \n"
cd ..

done

###############################################################################
#######################        END LOOP          ##############################
###############################################################################
