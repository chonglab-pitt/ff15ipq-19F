#!/bin/bash

ITER=$1

cat << EOF > tleap.in 
source leaprc.protein.ff15ipq
loadoff ../19F_FF15IPQ_${ITER}.lib
loadAmberParams ../19F_FF15IPQ_V00.frcmod
W4F = sequence { W4F }
check W4F
saveAmberParm W4F W4F_${ITER}.top W4F_${ITER}.crd
savepdb W4F W4F_${ITER}.pdb
quit
EOF

tleap -f tleap.in
