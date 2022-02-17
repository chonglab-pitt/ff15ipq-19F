#!/bin/bash
echo "#W7F V01 PHI PSI Angles" > rama_gen2.dat
for i in {1..1000}; do
  if [ ! -f GEN2_CONFS/Conf${i}.pdb ] ; then
    continue
  fi
  COMMAND="           parm W7F_V.top \n"
  COMMAND="${COMMAND} trajin GEN2_CONFS/Conf${i}.pdb \n"
  COMMAND="${COMMAND} dihedral phi @5 @7 @9  @29 out phipsi.dat \n"
  COMMAND="${COMMAND} dihedral psi @7 @9 @29  @31 out phipsi.dat \n"
  COMMAND="${COMMAND} go"
  echo -e ${COMMAND} | cpptraj >> cpp_rama_gen2.out
  cat phipsi.dat | tail -n +2 >> rama_gen2.dat
done

python ../../scripts/plot_rama.py

rm phipsi.dat
