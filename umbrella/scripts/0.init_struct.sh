#!/bin/bash
# run as: $ bash scripts/0.init_struct.sh
# generate initial relaxed structure
# takes 1 argument: $1 = RES_ID e.g. W4F 

LIB=19F_FF15IPQ_V03_IPQ_ADJ.lib
FRCMOD=19F_FF15IPQ_FIT_V01.frcmod
RES=$1

# 1) make directory for each res class and create solvated top and crd files
cat << EOF > tleap.in
source leaprc.protein.ff15ipq
source leaprc.water.spce
loadoff ../../$LIB
loadAmberParams ../../$FRCMOD
${RES} = sequence { ACE ALA ${RES} ALA NME }
check ${RES}
saveAmberParm ${RES} ${RES}_tet_dry.prmtop ${RES}_tet_dry.inpcrd
solvateoct ${RES} SPCBOX 10.0
saveAmberParm ${RES} ${RES}_tet.prmtop ${RES}_tet.inpcrd
savepdb ${RES} ${RES}_tet.pdb
quit
EOF

tleap -f tleap.in > tleap.out &&
echo -e "\nFinished creating $RES tetrapeptide file."

printf "\nstart creation of unrestrained min / equil files\n"

# make min file for phi/psi target angle
echo "10000 step unrestrained minimization
&cntrl
  imin      = 1,
  irest     = 0,
  ntx       = 1,
  ntmin     = 1,
  maxcyc    = 10000,
  ncyc      = 500,
  ntr       = 0,
  ntb       = 1,
  ntf       = 1,
  ntc       = 1,
  cut       = 10.0,
  ntpr      = 1,
  ntxo      = 2,
  ntwr      = 10000,
  ioutfm    = 1,
  ntwx      = 10000,
  iwrap     = 1,
&end" > 02_min.in

# make equi files for phi/psi target angle
# 20ps equi with 0.002ps(2fs) dt * 10000 steps = 20ps
echo "20 ps unrestrained NVT equilibration using Langevin thermostat
&cntrl
  irest     = 0,
  ntx       = 1,
  ig        = -1,
  dt        = 0.002,
  nstlim    = 10000,
  nscm      = 500,
  ntr       = 0,
  ntb       = 1,
  ntp       = 0,
  ntt       = 3,
  tempi     = 298.0,
  temp0     = 298.0,
  gamma_ln  = 1.0,
  ntf       = 2,
  ntc       = 2,
  cut       = 10.0,
  ntpr      = 500,
  ntxo      = 2,
  ntwr      = 10000,
  ioutfm    = 1,
  ntwx      = 500,
  iwrap     = 1,
&end" > 03_eq1.in

# make second equil file
echo "1 ns unrestrained NPT equilibration using Langevin thermostat and MC barostat
&cntrl
  irest     = 1,
  ntx       = 5,
  ig        = -1,
  dt        = 0.002,
  nstlim    = 500000,
  nscm      = 500,
  ntr       = 0,
  ntb       = 2,
  ntp       = 1,
  barostat  = 2,
  pres0     = 1.0,
  mcbarint  = 100,
  comp      = 44.6,
  taup      = 1.0,
  ntt       = 3,
  temp0     = 298.0,
  gamma_ln  = 1.0,
  ntf       = 2,
  ntc       = 2,
  cut       = 10.0,
  ntpr      = 500,
  ntxo      = 2,
  ntwr      = 500000,
  ioutfm    = 1,
  ntwx      = 500,
  iwrap     = 1,
&end" > 04_eq2.in

printf "\ndone creation unrestrained min / equil files\n\n"

# unrestrained minimization
printf "\nstart 10000 step unrestrained min\n\n"
        $AMBERHOME/bin/pmemd -O \
		-i 02_min.in -o 02_min.out -p ${RES}_tet.prmtop -c ${RES}_tet.inpcrd -r 02_min.rst
printf "\ndone 10000 unrestrained min\n\n"

# unrestrained NVT equilibration
printf "\nstart 20ps unrestrained equil 1 (NVT)\n\n"
        $AMBERHOME/bin/pmemd -O \
		-i 03_eq1.in -o 03_eq1.out -p ${RES}_tet.prmtop -c 02_min.rst -r 03_eq1.rst
printf "\ndone 20ps unrestrained equil 1 (NVT)\n\n"

# unrestrained NPT equilibration
printf "\nstart 1ns unrestrained equil 2 (NPT)\n\n"
        $AMBERHOME/bin/pmemd -O \
		-i 04_eq2.in -o 04_eq2.out -p ${RES}_tet.prmtop -c 03_eq1.rst -r 04_eq2.rst
printf "\ndone 1ns unrestrained equil 2 (NPT)\n\n"

