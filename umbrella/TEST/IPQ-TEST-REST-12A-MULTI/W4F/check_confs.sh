#!/bin/bash

COMP=0
INCOMP=0
NOSTART=0

for PROD_OUT in CONFS/*/W4F_tet_prod_*.out ; do

    if [[ -f "$PROD_OUT" ]] ; then
        WIN_PROD=$(tail -1 $PROD_OUT)
        if [[ "$WIN_PROD" == "|  Total wall time:"* ]] ; then
            echo "FOR RES = W4F : WINDOW = $PROD_OUT : RUN COMPLETED"
            let "COMP++"
        else
            echo "FOR RES = W4F : WINDOW = $PROD_OUT : RUN INCOMPLETE"
            let "INCOMP++"
        fi
    elif [[ ! -f "$PROD_OUT" ]] ; then
        echo "FOR RES = W4F : WINDOW = $PROD_OUT : RUN NEVER STARTED"
        let "NOSTART++"
    fi
done

echo -e "\nTOTAL COMPLETED CONFORMATIONS FOR W4F = ${COMP}"
COMP=0
echo -e "TOTAL INCOMPETED CONFORMATIONS FOR W4F = ${INCOMP}"
INCOMP=0
echo -e "TOTAL CONFORMATIONS THAT DID NOT RUN FOR W4F = ${NOSTART} \n"
NOSTART=0

