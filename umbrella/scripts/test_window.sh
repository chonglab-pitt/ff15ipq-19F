#!/bin/bash

# TRP
PHI_IAT="15,17,19,39"
PSI_IAT="17,19,39,41"
PHI=5
PSI=5

source ~/.setup.sh
source ../../scripts/gen_window_fun.sh

mkdir CONFS
mkdir -p CONFS/${PHI}_${PSI}
cd CONFS/${PHI}_${PSI}

# RES PHI PHIIAT PSI PSIIAT
gen_window W4F $PHI $PHI_IAT $PSI $PSI_IAT
