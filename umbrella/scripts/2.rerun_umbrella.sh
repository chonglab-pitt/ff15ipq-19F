#!/bin/bash
# RUN AS: $ bash scripts/2.rerun_umbrella.sh
# resubmission for windows that did not run or failed

NODES=1
CPUS=24
FF="IPQ"

#RES_CLASSES=(W4F W5F W6F W7F Y3F YDF F4F)
RES_CLASSES=(W6F)

cd ${FF} &&

for RES in ${RES_CLASSES[@]} ; do

    cd $RES &&
    
    # set RES_CLASS dependent phi psi angle definitions
    if [ $RES = "W4F" ] || [ $RES = "W5F" ] || [ $RES = "W6F" ] || [ $RES = "W7F" ] ; then
        PHI_IAT="15,17,19,39"
        PSI_IAT="17,19,39,41"
    elif [ $RES = "Y3F" ] || [ $RES = "YDF" ] ; then
        PHI_IAT="15,17,19,36"
        PSI_IAT="17,19,36,38"
    elif [ $RES = "F4F" ] ; then
        PHI_IAT="15,17,19,35"
        PSI_IAT="17,19,35,37"
    elif [ $RES = "FTF" ] ; then
        PHI_IAT="15,17,19,38"
        PSI_IAT="17,19,38,40"
    fi
    
    # run umbrella sampling 
    SLURM=${RES}_RERUN_US.slurm
    echo "#!/bin/bash" > $SLURM
    echo "#SBATCH --job-name=RE_${RES}_${FF}_US" >> $SLURM
    echo "#SBATCH --cluster=smp" >> $SLURM
    echo "#SBATCH --partition=smp" >> $SLURM
    echo "#SBATCH --nodes=${NODES}" >> $SLURM
    echo "#SBATCH --ntasks-per-node=${CPUS}" >> $SLURM
    echo "#SBATCH --mem=16g" >> $SLURM
    echo "#SBATCH --time=72:00:00  " >> $SLURM
    echo "#SBATCH --mail-user=dty7@pitt.edu" >> $SLURM
    echo "#SBATCH --mail-type=END,FAIL" >> $SLURM
    echo "#SBATCH --output=slurm_us_rerun.out" >> $SLURM
    echo "#SBATCH --error=slurm_us_rerun.err" >> $SLURM
    
    # load AMBER and prereqs
    echo "source ~/.setup.sh" >> $SLURM
    echo "source /ihome/lchong/dty7/bgfs-dty7/19F_ff15ipq/umbrella/scripts/gen_window_fun.sh" >> $SLURM
    # echo commands to stdout
    #echo "set -x " >> $SLURM
    
    echo "NJOB=0" >> $SLURM
    echo "RERUN=0" >> $SLURM
    
    echo "for PHI in {-175..0175..10} ; do" >> $SLURM
    echo "    for PSI in {-175..0175..10} ; do" >> $SLURM
    echo "        cd /bgfs/lchong/dty7/19F_ff15ipq/umbrella/${FF}/${RES}/CONFS/${RES}_\${PHI}_\${PSI} &&" >> $SLURM

    # check to see if already ran and skip if so
    echo "        if [[ -f 06_prod.out && \"\$(tail -1 06_prod.out)\" == \"|  Total wall time:\"* ]] ; then" >> $SLURM
    echo "            #echo PROD FILE ALREADY FINISHED FOR ${RES} : \${PHI}_\${PSI}" >> $SLURM
    echo "            continue" >> $SLURM
    echo "        elif [[ ! -f 06_prod.out || \"\$(tail -1 06_prod.out)\" != \"|  Total wall time:\"* ]] ; then" >> $SLURM
    echo "            echo PROD FILE ERROR FOR ${RES} : RERUNNING \${PHI}_\${PSI}" >> $SLURM
    echo "            # no leading zeros for PHI and PSI integer inputs: prevents 085 and 095 errors" >> $SLURM
    echo "            gen_window ${RES} \$(bc <<< \"\$PHI + 0\") ${PHI_IAT} \$(bc <<< \"\$PSI + 0\") ${PSI_IAT} &" >> $SLURM
    echo "            let RERUN++" >> $SLURM
    echo "            let NJOB+=1" >> $SLURM
    echo "            if [ \${NJOB} -eq ${CPUS} ] ; then" >> $SLURM
    echo "                NJOB=0" >> $SLURM
    echo "                wait" >> $SLURM
    echo "            fi" >> $SLURM
    echo "        fi" >> $SLURM

    echo "    done" >> $SLURM
    echo "done" >> $SLURM
    
    # finish any unevenly ran jobs: this can cause slurm to return failure
    echo "wait" >> $SLURM
    
    echo "echo OVERALL: RERAN \$RERUN WINDOWS" >> $SLURM

    # gives stats of job, wall time, etc.
    echo "crc-job-stats.py " >> $SLURM
     
    ### RUN SLURM SCRIPT
    #sbatch $SLURM
    echo -e "FINISHED UMBRELLA SAMPLING RESUBMISSION FOR $RES \n"
    
    cd ..
done

