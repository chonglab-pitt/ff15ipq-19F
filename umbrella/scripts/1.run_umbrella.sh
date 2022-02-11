#!/bin/bash
# RUN AS: $ bash scripts/1.run_umbrella.sh
# generate conformations and calculate SPE of each RES_CLASS

NODES=1
CPUS=24
FF="IPQ"

#RES_CLASSES=(W5F W6F W7F Y3F YDF F4F FTF)
RES_CLASSES=(TRP TYR PHE)

cd ${FF} &&

for RES in ${RES_CLASSES[@]} ; do

    cd $RES &&
    
    # set RES_CLASS dependent phi psi angle definitions
    if [ $RES = "W4F" ] || [ $RES = "W5F" ] || [ $RES = "W6F" ] || [ $RES = "W7F" ] || [ $RES = "TRP" ] ; then
        PHI_IAT="15,17,19,39"
        PSI_IAT="17,19,39,41"
    elif [ $RES = "Y3F" ] || [ $RES = "YDF" ] || [ $RES = "TYR" ] ; then
        PHI_IAT="15,17,19,36"
        PSI_IAT="17,19,36,38"
    elif [ $RES = "F4F" ] || [ $RES = "PHE" ] ; then
        PHI_IAT="15,17,19,35"
        PSI_IAT="17,19,35,37"
    elif [ $RES = "FTF" ] ; then
        PHI_IAT="15,17,19,38"
        PSI_IAT="17,19,38,40"
    fi
    
    mkdir CONFS
    
    for I in {1..3} ; do 
        # run umbrella sampling 
        SLURM=${RES}_RUN_US_${I}.slurm
        echo "#!/bin/bash" > $SLURM
        echo "#SBATCH --job-name=${I}of3_${RES}_${FF}_US" >> $SLURM
        echo "#SBATCH --cluster=smp" >> $SLURM
        echo "#SBATCH --partition=smp" >> $SLURM
        echo "#SBATCH --nodes=${NODES}" >> $SLURM
        echo "#SBATCH --ntasks-per-node=${CPUS}" >> $SLURM
        echo "#SBATCH --mem=16g" >> $SLURM
        echo "#SBATCH --time=120:00:00  " >> $SLURM
        echo "#SBATCH --mail-user=dty7@pitt.edu" >> $SLURM
        echo "#SBATCH --mail-type=END,FAIL" >> $SLURM
        echo "#SBATCH --output=slurm_us_${I}.out" >> $SLURM
        echo "#SBATCH --error=slurm_us_${I}.err" >> $SLURM
        
        # load AMBER and prereqs
        echo "source ~/.setup.sh" >> $SLURM
        echo "source /ihome/lchong/dty7/bgfs-dty7/19F_ff15ipq/umbrella/scripts/gen_window_fun.sh" >> $SLURM
        # echo commands to stdout
        echo "set -x " >> $SLURM
        
        echo "NJOB=0" >> $SLURM
        
        # PHI 1/3
        if [ $I -eq 1 ] ; then
            echo "for PHI in {-175..-065..10} ; do" >> $SLURM
            echo "    for PSI in {-175..0175..10} ; do" >> $SLURM
        # PHI 2/3
        elif [ $I -eq 2 ] ; then
            echo "for PHI in {-055..0055..10} ; do" >> $SLURM
            echo "    for PSI in {-175..0175..10} ; do" >> $SLURM
        # PHI 3/3
        elif [ $I -eq 3 ] ; then
            echo "for PHI in {0065..0175..10} ; do" >> $SLURM
            echo "    for PSI in {-175..0175..10} ; do" >> $SLURM
        fi
        
        echo "        mkdir -p /bgfs/lchong/dty7/19F_ff15ipq/umbrella/${FF}/${RES}/CONFS/${RES}_\${PHI}_\${PSI}" >> $SLURM
        echo "        cd /bgfs/lchong/dty7/19F_ff15ipq/umbrella/${FF}/${RES}/CONFS/${RES}_\${PHI}_\${PSI} &&" >> $SLURM
        echo "        gen_window ${RES} \$(bc <<< \"\$PHI + 0\") ${PHI_IAT} \$(bc <<< \"\$PSI + 0\") ${PSI_IAT} &" >> $SLURM
        echo "        let "NJOB+=1"" >> $SLURM
        echo "        if [ \${NJOB} -eq ${CPUS} ] ; then" >> $SLURM
        echo "            NJOB=0" >> $SLURM
        echo "            wait" >> $SLURM
        echo "        fi" >> $SLURM
        echo "    done" >> $SLURM
        echo "done" >> $SLURM
        
        # finish any unevenly ran jobs: this can cause slurm to return failure
        echo "wait" >> $SLURM
        
        # gives stats of job, wall time, etc.
        echo "crc-job-stats.py " >> $SLURM
         
        ### RUN SLURM SCRIPT
        sbatch $SLURM
        echo -e "FINISHED UMBRELLA SAMPLING SUBMISSION ${I}/3 FOR $RES \n"
    
    done
    cd ..
done

