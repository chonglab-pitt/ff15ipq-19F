#!/bin/bash
# check that all 19F residues finished grid file generation successfully


RES_CLASSES=(W4F W5F W6F W7F Y3F YDF F4F FTF)
#RES_CLASSES=(W4F W5F W6F W7F Y3F YDF)
#RES_CLASSES=(W4F YDF)
ITER=v03

FAIL=0

for RES in ${RES_CLASSES[@]} ; do
    for CONF in {1..20} ; do
        VACU_OUT=$(tail -1 $RES/$ITER/GenConformers/Conf$CONF/qm_output.vacu)
        SOLV_OUT=$(tail -1 $RES/$ITER/GenConformers/Conf$CONF/qm_output.solv)
        if [[ "$VACU_OUT" == "TOTAL RUN TIME:"* && "$SOLV_OUT" == "TOTAL RUN TIME:"* ]] ; then
            echo "For RES = $RES : CONF = $CONF - RUN COMPLETED SUCCESSFULLY"
        else
            echo "WARNING: For RES = $RES : CONF = $CONF - RUN NOT COMPLETED SUCCESSFULLY"
            let "FAIL++"
        fi
    done
done 

echo "TOTAL FAILED CONFS = $FAIL"
