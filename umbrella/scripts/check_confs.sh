#!/bin/bash

COMP=0
INCOMP=0
NOSTART=0

#for PROD_OUT in CONFS/*/06_prod.out ; do

RES=FTF
for PHI in {-175..0175..10} ; do
    for PSI in {-175..0175..10}; do
        PROD_OUT=CONFS/${RES}_${PHI}_${PSI}/06_prod.out

        if [[ -f "$PROD_OUT" ]] ; then
            WIN_PROD=$(tail -1 $PROD_OUT)
            if [[ "$WIN_PROD" == "|  Total wall time:"* ]] ; then
                echo "FOR RES WINDOW = $PROD_OUT : RUN COMPLETED"
                let "COMP++"
            else
                echo "FOR RES WINDOW = $PROD_OUT : RUN INCOMPLETE"
                let "INCOMP++"
            fi
        elif [[ ! -f "$PROD_OUT" ]] ; then
            echo "FOR RES WINDOW = $PROD_OUT : RUN NEVER STARTED"
            let "NOSTART++"
        fi
    done
done

echo -e "\nTOTAL COMPLETED CONFORMATIONS = ${COMP}"
COMP=0
echo -e "TOTAL INCOMPETED CONFORMATIONS = ${INCOMP}"
INCOMP=0
echo -e "TOTAL CONFORMATIONS THAT DID NOT RUN = ${NOSTART} \n"
NOSTART=0

