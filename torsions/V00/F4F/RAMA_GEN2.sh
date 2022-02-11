#!/bin/bash
echo "#F4F V00 PHI PSI Angles" > rama_gen2.dat
for i in {1..1000}; do
  if [ ! -f GEN2_CONFS/Conf${i}.pdb ] ; then
    continue
  fi
  COMMAND="           parm F4F_V.top \n"
  COMMAND="${COMMAND} trajin GEN2_CONFS/Conf${i}.pdb \n"
  COMMAND="${COMMAND} dihedral phi @5 @7 @9  @25 out phipsi.dat \n"
  COMMAND="${COMMAND} dihedral psi @7 @9 @25  @27 out phipsi.dat \n"
  COMMAND="${COMMAND} go"
  echo -e ${COMMAND} | cpptraj >> cpp_rama_gen2.out
  cat phipsi.dat | tail -n +2 >> rama_gen2.dat
done

python ../../scripts/plot_rama.py

rm phipsi.dat
