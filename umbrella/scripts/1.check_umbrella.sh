#!/bin/bash
# RUN AS: $ bash scripts/1.check_umbrella.sh
# check success of US for each RES_CLASS

FF="IPQ" # later add options for charmm36 (CM36)

#RES_CLASSES=(W4F W5F W6F W7F Y3F YDF F4F FTF)
RES_CLASSES=(W4F)

cd ${FF} &&

COMP=0
INCOMP=0
NOSTART=0
echo "$(date) : BEGIN SKIP LOG" 

for RES in ${RES_CLASSES[@]} ; do
    cd $RES &&

    for PHI in {-175..0175..10} ; do
        for PSI in {-175..0175..10} ; do

            DIR=/bgfs/lchong/dty7/19F_ff15ipq/umbrella/${FF}/${RES}/CONFS/${RES}_${PHI}_${PSI}        
        
            if [[ -f "${DIR}/06_prod.out" ]] ; then
                WIN_PROD=$(tail -1 ${DIR}/06_prod.out)
                if [[ "$WIN_PROD" == "|  Total wall time:"* ]] ; then
                    #echo "FOR RES = $RES : WINDOW = ${PHI}_${PSI} : RUN COMPLETED"
                    let "COMP++"
                else
                    #echo "FOR RES = $RES : WINDOW = ${PHI}_${PSI} : RUN INCOMPLETE"
                    let "INCOMP++"
                fi
            elif [[ ! -f "${DIR}/06_prod.out" ]] ; then
                #echo "FOR RES = $RES : WINDOW = ${PHI}_${PSI} : RUN NEVER STARTED"
                let "NOSTART++"
            fi
        done
    done

    echo -e "\nTOTAL COMPLETED CONFORMATIONS FOR ${RES} = ${COMP} OUT OF 1296"
    COMP=0
    echo -e "TOTAL INCOMPETED CONFORMATIONS FOR ${RES} = ${INCOMP} OUT OF 1296"
    INCOMP=0
    echo -e "TOTAL CONFORMATIONS THAT DID NOT RUN FOR ${RES} = ${NOSTART} OUT OF 1296\n"
    NOSTART=0

    cd ..
done


