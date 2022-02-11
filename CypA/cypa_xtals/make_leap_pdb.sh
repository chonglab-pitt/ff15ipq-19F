#!/bin/bash
# 03Nov2021 by DTY, last updated on 09Nov2021 by DTY
# make leap compatible pdb files

source /ihome/crc/build/amber/amber18_x64/amber18/amber.sh

#systems=(w4f w5f w6f w7f)
#systems=(ml_wt 3k0n 3k0m)
systems=(3k0o 3k0p)

for sys in ${systems[@]} ; do

    # convert pdb, remove xtal waters (-d) and reduce and protonate (--reduce)
    #pdb4amber -i ${sys^^}_cypa_amb.pdb -o ${sys}_cypa_leap.pdb -d --reduce --add-missing-atoms
    pdb4amber -i ${sys}_cypa_amb.pdb -o ${sys}_cypa_leap.pdb -d --reduce --add-missing-atoms

done
