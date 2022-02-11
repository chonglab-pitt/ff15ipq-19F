#!/bin/bash

# TRP
PHI_IAT="5,7,9,29"
PSI_IAT="7,9,29,31"
PHI=15
PSI=15

source ~/.setup.sh
source ../../scripts/gen_window_fun.sh

mkdir CONFS
mkdir -p CONFS/${PHI}_${PSI}
cd CONFS/${PHI}_${PSI}

# RES PHI PHIIAT PSI PSIIAT
gen_window W4F $PHI $PHI_IAT $PSI $PSI_IAT
