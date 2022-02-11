#!/bin/bash
# REsP fitting using grid_output files from all conformations

PDB=W4F
ITERATION=v01

# Note: adjust equivalencies per residue type
# also adjust for missing conformations
# v01 is missing conf 9 and 10
# v01 is missing conf 1

cd $ITERATION/GenConformers

cat << EOF > resp.in
&files
  -p    ../${PDB}_solo.top
  -o    fit.out
&end

&fitq
  ipolq  Conf1/grid_output.vacu     Conf1/grid_output.solv      ../${PDB}_V.top  1.0
  ipolq  Conf2/grid_output.vacu     Conf2/grid_output.solv      ../${PDB}_V.top  1.0
  ipolq  Conf3/grid_output.vacu     Conf3/grid_output.solv      ../${PDB}_V.top  1.0
  ipolq  Conf4/grid_output.vacu     Conf4/grid_output.solv      ../${PDB}_V.top  1.0
  ipolq  Conf5/grid_output.vacu     Conf5/grid_output.solv      ../${PDB}_V.top  1.0
  ipolq  Conf6/grid_output.vacu     Conf6/grid_output.solv      ../${PDB}_V.top  1.0
  ipolq  Conf7/grid_output.vacu     Conf7/grid_output.solv      ../${PDB}_V.top  1.0
  ipolq  Conf8/grid_output.vacu     Conf8/grid_output.solv      ../${PDB}_V.top  1.0
  ipolq  Conf11/grid_output.vacu    Conf11/grid_output.solv     ../${PDB}_V.top  1.0
  ipolq  Conf12/grid_output.vacu    Conf12/grid_output.solv     ../${PDB}_V.top  1.0
  ipolq  Conf13/grid_output.vacu    Conf13/grid_output.solv     ../${PDB}_V.top  1.0
  ipolq  Conf14/grid_output.vacu    Conf14/grid_output.solv     ../${PDB}_V.top  1.0
  ipolq  Conf15/grid_output.vacu    Conf15/grid_output.solv     ../${PDB}_V.top  1.0
  ipolq  Conf16/grid_output.vacu    Conf16/grid_output.solv     ../${PDB}_V.top  1.0
  ipolq  Conf17/grid_output.vacu    Conf17/grid_output.solv     ../${PDB}_V.top  1.0
  ipolq  Conf18/grid_output.vacu    Conf18/grid_output.solv     ../${PDB}_V.top  1.0
  ipolq  Conf19/grid_output.vacu    Conf19/grid_output.solv     ../${PDB}_V.top  1.0
  ipolq  Conf20/grid_output.vacu    Conf20/grid_output.solv     ../${PDB}_V.top  1.0

  % General conditions for the REsP
  pnrg          0.0
  flim          0.39
  nfpt          3750
  MaxMemory     5GB

  % Equivalencies on atoms go here
  equalq    '@H1,H2,H3'
  equalq    '@HH31,HH32,HH33'
  equalq    '@HB2,HB3'
  minq      '!@H='
&end
EOF


mdgx -i resp.in

