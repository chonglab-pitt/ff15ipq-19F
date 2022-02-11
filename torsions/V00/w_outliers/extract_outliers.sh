#!/bin/bash
# extract_outliers.sh
# extract the outlier conformations at 4 sigma for each residue and remove

RES_CLASSES=(W4F W5F W6F W7F Y3F YDF F4F FTF)
OUT=w_outliers/FIT_V00.out

RES_NUM=0


for RES in ${RES_CLASSES[@]} ; do 

    echo "RUNNING: $RES"
    OUTLIERS=0

    for LINE in $(grep "$RES/concat_coords.cdf" $OUT | awk '{print $3}') ; do
        re='^[0-9]+$'
        if [[ "$LINE" =~ $re ]] ; then 
            echo $LINE
            let "OUTLIERS++"
        fi
    done

    echo "$OUTLIERS outliers for $RES"

done
