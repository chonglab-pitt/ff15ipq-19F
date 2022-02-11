#!/bin/bash
# cluster.sh

echo "parm ../../3k0n_wt_dry.prmtop" > cluster.cpp

echo "trajin ../../06_prod_dry.nc 1 last 10" >> cluster.cpp

echo "
reference ../../3k0n_wt_w_ion.pdb name <st0>
rms RMSD_HEAVY :1-165&!@H= ref <st0> mass

cluster CYPA data RMSD_HEAVY \
 hieragglo epsilon 3 clusters 2 averagelinkage \
 sieve 10 random \
 out cnumvtime.dat \
 summary summary.dat \
 info info.dat \
 cpopvtime cpopvtime.agr normframe \
 repout rep repfmt pdb \
 singlerepout singlerep.nc singlerepfmt netcdf \
 avgout avg avgfmt pdb
run
quit
" >> cluster.cpp


# maybe run cpptraj.MPI with 2-4 np
cpptraj -i cluster.cpp > cluster.out

