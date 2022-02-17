#!/bin/bash
# cut_out_conf.sh
# remove conformations in RES_CLASS dir that are < || > 10% of the AVG SPE 

# first get the average SPE value for the RES
COUNT=0
SUM=0

# go through each line of energies.dat file
while IFS= read -r line; do

    # skip non-spe lines
    if [[ "$line" = "%"* ]] || [[ "$line" = "" ]]; then
        continue
    fi

    let "COUNT+=1"
    SUM=$(echo "$SUM + $line" | bc -l)    

done < "energies.dat"

# get lower and higher 10% values from the avg
AVG=$(echo "$SUM / $COUNT" | bc -l)
TENP=$(echo "$AVG * 0.1" | bc -l)
LOW=$(echo "$AVG + $TENP" | bc -l)
HIGH=$(echo "$AVG - $TENP" | bc -l)

mkdir CONFS_CUT

echo "LOW = $LOW , HIGH = $HIGH"

for CONF in {1..10}; do

    NUM=$(grep "FINAL SINGLE POINT" CONFS_OOUT/Conf${CONF}.oout | awk {'print $5'})
    echo "NUM = $NUM"

    if ! [[ $CONF < $NUM ]]; then
        #mv CONFS_OOUT/Conf${CONF}.oout CONFS_CUT
        echo "$NUM > LOW: $LOW"
        echo "Conf${CONF}.oout was removed."
    elif ! [[ $CONF > $NUM ]]; then
        #mv CONFS_OOUT/Conf${CONF}.oout CONFS_CUT
        echo "$NUM < HIGH: $HIGH"
        echo "Conf${CONF}.oout was removed."
    else
        echo "No removal."
    fi

done


# rerun extract energies script with updated CONFS_OOUT dir

