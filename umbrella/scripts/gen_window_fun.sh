#!/bin/bash
# function to source and run umbrella sampling window
# also creates solvated prod nc file and strips water
# gen_window_fun.sh

# function to make disang files and run restrained equil and prod
gen_window () {
    # usage: gen_window $1 $2 $3 $4 $5
    # required input arguments:
        # 1: target tetrapeptide string:    e.g. "ALA"
        tet="${1}"
        # 2: dihedral 1 - theta int (°):    e.g. 15  
        phi="${2}"
        # 3: dihedral 1 - iat str:          e.g. "15,17,22,19"
        phi_iat="${3}"
        # 4: dihedral 2 - theta int (°):    e.g. 15  
        psi="${4}"
        # 5: dihedral 2 - iat str:          e.g. "22,19,30,32"
        psi_iat="${5}"

    # set default force constant
    force="8.0"
    # set PMEMD version
    PMEMD=$AMBERHOME/bin/pmemd
    # set var for phi r1 and r4
    phi_r1="$((${phi}-180))"
    phi_r4="$((${phi}+180))"
    # set var for psi r1 and r4
    psi_r1="$((${psi}-180))"
    psi_r4="$((${psi}+180))"

    printf "start creation disang and restrained equil / prod files\n"
    printf "dihedral restraint 1 = ${phi}\n"
    printf "dihedral restraint 2 = ${psi}\n"

    # make equil disang file with both angle gradual restraints
    echo "&rst"                                                     > 05_eq3.disang
    echo "  iat=${phi_iat},"                                        >> 05_eq3.disang
    echo "  ifvari=1,"                                              >> 05_eq3.disang
    echo "  nstep1=0,"                                              >> 05_eq3.disang
    echo "  r1=0, r2=180, r3=180, r4=360,"                          >> 05_eq3.disang
    echo "  rk2=${force}, rk3=${force},"                            >> 05_eq3.disang
    echo "  nstep2=50000,"                                          >> 05_eq3.disang
    echo "  r1a=${phi_r1}, r2a=${phi}, r3a=${phi}, r4a=${phi_r4},"  >> 05_eq3.disang
    echo "  rk2a=${force}, rk3a=${force},"                          >> 05_eq3.disang
    echo "&end"                                                     >> 05_eq3.disang
    echo "&rst"                                                     >> 05_eq3.disang
    echo "  iat=${psi_iat},"                                        >> 05_eq3.disang
    echo "  ifvari=1,"                                              >> 05_eq3.disang
    echo "  nstep1=500001,"                                         >> 05_eq3.disang
    echo "  r1=0, r2=180, r3=180, r4=360,"                          >> 05_eq3.disang
    echo "  rk2=${force}, rk3=${force},"                            >> 05_eq3.disang
    echo "  nstep2=100000,"                                         >> 05_eq3.disang
    echo "  r1a=${psi_r1}, r2a=${psi}, r3a=${psi}, r4a=${psi_r4},"  >> 05_eq3.disang
    echo "  rk2a=${force}, rk3a=${force},"                          >> 05_eq3.disang
    echo "&end"                                                     >> 05_eq3.disang

    # make prod disang file with angle restraints
    echo "&rst"                                                     > 06_prod.disang
    echo " iat=${phi_iat},"                                         >> 06_prod.disang
    echo " r1=${phi_r1}, r2=${phi}, r3=${phi}, r4=${phi_r4},"       >> 06_prod.disang
    echo " rk2=${force}, rk3=${force},"                             >> 06_prod.disang
    echo "&end"                                                     >> 06_prod.disang
    echo "&rst"                                                     >> 06_prod.disang
    echo " iat=${psi_iat},"                                         >> 06_prod.disang
    echo " r1=${psi_r1}, r2=${psi}, r3=${psi}, r4=${psi_r4},"       >> 06_prod.disang
    echo " rk2=${force}, rk3=${force}"                              >> 06_prod.disang
    echo "&end"                                                     >> 06_prod.disang

    # make 200 ps restrained equil
    echo "200 ps NPT equilbration"                                  > 05_eq3.in
    echo "Langevin thermostat, MC barostat, and restraints"         >> 05_eq3.in
    echo "&cntrl"                                                   >> 05_eq3.in  
    echo "  irest     = 1,"                                         >> 05_eq3.in
    echo "  ntx       = 5,"                                         >> 05_eq3.in 
    echo "  ig        = -1,"                                        >> 05_eq3.in
    echo "  dt        = 0.002,"                                     >> 05_eq3.in
    echo "  nstlim    = 100000,"                                    >> 05_eq3.in
    echo "  nscm      = 500,"                                       >> 05_eq3.in
    echo "  ntr       = 0,"                                         >> 05_eq3.in
    echo "  nmropt    = 1,"                                         >> 05_eq3.in
    echo "  ntb       = 2,"                                         >> 05_eq3.in
    echo "  ntp       = 1,"                                         >> 05_eq3.in
    echo "  barostat  = 2,"                                         >> 05_eq3.in
    echo "  pres0     = 1.0,"                                       >> 05_eq3.in
    echo "  mcbarint  = 100,"                                       >> 05_eq3.in
    echo "  comp      = 44.6,"                                      >> 05_eq3.in
    echo "  taup      = 1.0,"                                       >> 05_eq3.in
    echo "  ntt       = 3,"                                         >> 05_eq3.in
    echo "  temp0     = 298.0,"                                     >> 05_eq3.in
    echo "  gamma_ln  = 1.0,"                                       >> 05_eq3.in
    echo "  ntf       = 2,"                                         >> 05_eq3.in
    echo "  ntc       = 2,"                                         >> 05_eq3.in
    echo "  cut       = 10.0,"                                      >> 05_eq3.in
    echo "  ntpr      = 500,"                                       >> 05_eq3.in
    echo "  ntxo      = 2,"                                         >> 05_eq3.in
    echo "  ntwr      = 100000,"                                    >> 05_eq3.in
    echo "  ioutfm    = 1,"                                         >> 05_eq3.in
    echo "  iwrap     = 1,"                                         >> 05_eq3.in
    echo "&end"                                                     >> 05_eq3.in
    echo "&wt"                                                      >> 05_eq3.in
    echo "  type      = 'REST',"                                    >> 05_eq3.in
    echo "  value1    = 1.0,"                                       >> 05_eq3.in
    echo "&end"                                                     >> 05_eq3.in
    echo "&wt"                                                      >> 05_eq3.in
    echo "  type      = 'DUMPFREQ',"                                >> 05_eq3.in
    echo "  istep1    = 500,"                                       >> 05_eq3.in
    echo "&end"                                                     >> 05_eq3.in
    echo "&wt"                                                      >> 05_eq3.in
    echo "  type      = 'END',"                                     >> 05_eq3.in
    echo "&end"                                                     >> 05_eq3.in
    echo "DISANG      = 05_eq3.disang"                              >> 05_eq3.in 
    echo "DUMPAVE     = 05_eq3.dat"                                 >> 05_eq3.in

    # make prod files for phi/psi target angle
    echo "2 ns NPT production"                                      > 06_prod.in
    echo "Langevin thermostat, MC barostat, and restraints"         >> 06_prod.in
    echo "&cntrl"                                                   >> 06_prod.in
    echo "  irest     = 1,"                                         >> 06_prod.in
    echo "  ntx       = 5,"                                         >> 06_prod.in
    echo "  ig        = -1,"                                        >> 06_prod.in
    echo "  dt        = 0.002,"                                     >> 06_prod.in
    echo "  nstlim    = 1000000,"                                   >> 06_prod.in
    echo "  nscm      = 500,"                                       >> 06_prod.in
    echo "  ntr       = 0,"                                         >> 06_prod.in
    echo "  nmropt    = 1,"                                         >> 06_prod.in
    echo "  ntb       = 2,"                                         >> 06_prod.in
    echo "  ntp       = 1,"                                         >> 06_prod.in
    echo "  barostat  = 2,"                                         >> 06_prod.in
    echo "  pres0     = 1.0,"                                       >> 06_prod.in
    echo "  mcbarint  = 100,"                                       >> 06_prod.in
    echo "  comp      = 44.6,"                                      >> 06_prod.in
    echo "  taup      = 1.0,"                                       >> 06_prod.in
    echo "  ntt       = 3,"                                         >> 06_prod.in
    echo "  temp0     = 298.0,"                                     >> 06_prod.in
    echo "  gamma_ln  = 1.0,"                                       >> 06_prod.in
    echo "  ntf       = 2,"                                         >> 06_prod.in
    echo "  ntc       = 2,"                                         >> 06_prod.in
    echo "  cut       = 10.0,"                                      >> 06_prod.in
    echo "  ntpr      = 100,"                                       >> 06_prod.in
    echo "  ntxo      = 2,"                                         >> 06_prod.in
    echo "  ntwr      = 500000,"                                    >> 06_prod.in
    echo "  ioutfm    = 1,"                                         >> 06_prod.in
    echo "  ntwx      = 100,"                                       >> 06_prod.in
    echo "  iwrap     = 1,"                                         >> 06_prod.in
    echo "&end"                                                     >> 06_prod.in
    echo "&wt"                                                      >> 06_prod.in
    echo "  type      = 'REST',"                                    >> 06_prod.in
    echo "  value1    = 1.0,"                                       >> 06_prod.in
    echo "&end"                                                     >> 06_prod.in
    echo "&wt"                                                      >> 06_prod.in
    echo "  type      = 'DUMPFREQ',"                                >> 06_prod.in
    echo "  istep1    = 100,"                                       >> 06_prod.in
    echo "&end"                                                     >> 06_prod.in
    echo "&wt"                                                      >> 06_prod.in
    echo "  type      = 'END',"                                     >> 06_prod.in
    echo "&end"                                                     >> 06_prod.in
    echo "DISANG      = 06_prod.disang"                             >> 06_prod.in
    echo "DUMPAVE     = 06_prod.dat"                                >> 06_prod.in

    printf "done creation disang and restrained equil / prod files\n"

    # restrained equilibration
    printf "start restrained equil\n"
    $PMEMD -O \
        -i 05_eq3.in \
        -o 05_eq3.out \
        -p ../../${tet}_tet.prmtop \
        -c ../../04_eq2.rst \
        -r 05_eq3.rst \
        -inf 05_eq3.nfo
    printf "done restrained equil\n"

    # restrained production
    printf "start restrained prod\n"
    $PMEMD -O \
        -i 06_prod.in \
        -o 06_prod.out \
        -p ../../${tet}_tet.prmtop \
        -c 05_eq3.rst \
        -r 06_prod.rst \
        -inf 06_prod.nfo \
        -x 06_prod.nc
    printf "done restrained prod\n"

    # make cpptraj input file
    echo "parm ../../${tet}_tet.prmtop"                         > cpptraj.in
    echo "trajin 06_prod.nc"                                    >> cpptraj.in
    echo "autoimage"                                            >> cpptraj.in
    echo "strip :WAT"                                           >> cpptraj.in
    echo "trajout 06_prod_dry.nc"                               >> cpptraj.in
    echo "go"                                                   >> cpptraj.in
    echo "quit"                                                 >> cpptraj.in

    # run cpptraj to strip water
    cpptraj -i cpptraj.in > cpptraj.out

    # remove solvated nc file
    if [ -f "06_prod_dry.nc" ] ; then
        rm 06_prod.nc &&
        mv 06_prod_dry.nc 06_prod.nc
    fi
}

