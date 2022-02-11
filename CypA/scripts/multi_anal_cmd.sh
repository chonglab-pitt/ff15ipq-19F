#!/bin/bash
# analyze multiple (5) replicates of each system

SYSTEMS=(w4f w5f w6f w7f wt)
#SYSTEMS=(w4f w5f w6f w7f)
#SYSTEMS=(w4f)
#SYSTEMS=(wt)
# for iRED: no need for wt
#SYSTEMS=(w5f w6f w7f)
OUT_ROOT=1us_noion
PDB=3k0n
FF="ipq"
IRED_V=1816 # starting at W4F CE3
#IRED_V=1814 # W5F

CPPTRAJ=cpptraj.MPI
export DO_PARALLEL="mpirun -np 8"

cd $FF

# go to target directory
for SYS in ${SYSTEMS[@]} ; do
    cd $SYS &&
    echo "RUNNING SYSTEM : $SYS"

    # make the 5 replicate sub-directories
    for V in {00..04..1} ; do
        echo "GENERATING REPLICA V$V"
        # go to sub-directory
        cd v$V
        mkdir $OUT_ROOT

#        # Commands 00: Strip water and/or ions
#        C00="     parm ${PDB}_${SYS}_solv.prmtop \n"
#        C00="$C00 trajin 06_prod.nc \n"
#        C00="$C00 strip :WAT \n"
##        C00="$C00 trajout ${PDB}_${SYS}_w_ion.pdb pdb \n"
#        C00="$C00 trajout 06_prod_w_ion.nc \n"
#        echo -e "$C00" | $CPPTRAJ \
#         > >(tee $OUT_ROOT/cpptraj_0.out) \
#        2> >(tee $OUT_ROOT/cpptraj_0.err >&2)

        # Commands 0: Load in topology and trajectory
        #if [ -f "${PDB}_${SYS}_dry_noion.prmtop" ] ; then
        #    C0="    parm ${PDB}_${SYS}_dry_noion.prmtop \n"
        #else
        #    C0="    parm ${PDB}_${SYS}_dry.prmtop \n"
        #fi 
        C0="    parm ../${PDB}_${SYS}_dry_noion.prmtop \n"
        #C0="    parm ../${PDB}_${SYS}_dry.prmtop \n"
        # no water but retains ions
        C0="$C0 trajin 06_prod_dry.nc 1 last 1000 \n" 
        C0="$C0 trajin 07_prod_dry.nc 1 last 1000 \n" 
        C0="$C0 trajin 08_prod_dry.nc 1 last 1000 \n" 
        C0="$C0 reference ${PDB}_${SYS}_leap.pdb :* [REF] \n"
        # multiple refs: ml_wt_q2v, 19F_ml_q2v, 3k0n, 3k0m 
#        C0="$C0 reference ../../../cypa_xtals/ml_wt_q2v_cypa_leap.pdb :* [MLWT] \n"
#        C0="$C0 reference ../../../cypa_xtals/${SYS}_q2v_cypa_leap.pdb :* [ML19F] \n"
        C0="$C0 reference ../../../cypa_xtals/3k0n_cypa_leap.pdb :* [3K0N] \n"
#        C0="$C0 reference ../../../cypa_xtals/3k0m_cypa_leap.pdb :* [3K0M] \n"

        C0="$C0 reference ../../../cypa_xtals/3k0o_cypa_leap.pdb :* [3K0O] \n"
#        C0="$C0 reference ../../../cypa_xtals/3k0p_cypa_leap.pdb :* [3K0P] \n"
        
        # Commands 1: Dihedrals, radius of gyration, RMSD, DSSP
#        C1="    multidihedral dihedral_trp121 phi psi resrange 121-121"
#        C1="$C1               out $OUT_ROOT/dihedral_trp121.dat \n"
        # chi angle
#        C1="    multidihedral dihedral_trp121 chip resrange 121-121"
#        C1="$C1               out $OUT_ROOT/dihedral_chi_trp121.dat \n"
        # chi1 and chi2 angles
#        C1="    multidihedral dihtype chi1:N:CA:CB:CG dihtype chi2:CA:CB:CG:CD1 resrange 121-121"
#        C1="$C1               out $OUT_ROOT/dihedral_chi1_2_trp121.dat \n"
#        C1="$C1 rms heavyRMSD :1-165&!@H= out $OUT_ROOT/rmsd_1-165_heavy.dat ref [REF] mass time 1 \n"
#        C1="$C1 rms bbRMSD :1-165@CA,C,O,N out $OUT_ROOT/rmsd_1-165_bb.dat ref [REF] mass time 1 \n"

        # rmsd of sidechains from Fraser 2009
        C1="    rms fit_bb :1-165@CA,C,O,N ref [3K0N] mass \n"
        #C1="$C1 rms key_sc :99,98,113,61,55&!@CA,C,O,N,H nofit out $OUT_ROOT/rmsd_key_sc.dat ref [REF] mass time 1 \n"
        #C1="$C1 rms phe_sc :PHE&!@CA,C,O,N,H nofit out $OUT_ROOT/rmsd_phe_sc.dat ref [REF] mass time 1 \n"
        #C1="$C1 rms phe113 :113&!@CA,C,O,N,H nofit out $OUT_ROOT/rmsd_phe113.dat ref [REF] mass time 1 \n"
        C1="$C1 rms phe113_3k0n :113&!@CA,C,O,N,H nofit out $OUT_ROOT/rmsd_phe113_3k0n.dat ref [3K0N] mass time 1 \n"
        C1="$C1 rms fit_bb_3k0o :1-165@CA,C,O,N ref [3K0O] mass \n"
        C1="$C1 rms phe113_3k0o :113&!@CA,C,O,N,H nofit out $OUT_ROOT/rmsd_phe113_3k0o.dat ref [3K0O] mass time 1 \n"

        # calc phi and psi torsions of all residues
        #C1="    multidihedral phi resrange 1-165 out $OUT_ROOT/dihedral_phi_1-165.dat \n"
        #C1="$C1 multidihedral psi resrange 1-165 out $OUT_ROOT/dihedral_psi_1-165.dat \n"

        # calc individual energy terms
        #if [ $SYS != "wt" ] ; then
        #    C1="$C1 energy 121_19F_NE1 :121@F*,NE1 out $OUT_ROOT/energy_121_19F_NE1.dat \n"
        #fi
        #C1="    energy 121_res :121 out $OUT_ROOT/energy_121_res.dat \n"

        # pairwise non-bonded interaction energies (vdW + elec)
#        if [ $SYS == "wt" ] ; then
            # pairwise non-bonded for WT TRP H atoms
            #C1="    pairwise pw_nb_121 :121 out $OUT_ROOT/nb_121_total.dat"
            #C1="$C1 eout $OUT_ROOT/nb_121_all.dat \n"
#            C1="    pairwise pw_nb_121_F_NE1 :121@F*,NE1 out $OUT_ROOT/nb_121_F_NE1.dat \n"
#        else
            #C1="    pairwise pw_nb_121 :121 out $OUT_ROOT/nb_121_total.dat"
            #C1="$C1 eout $OUT_ROOT/nb_121_all.dat \n"
#            C1="    pairwise pw_nb_121_F_NE1 :121@F*,NE1 out $OUT_ROOT/nb_121_F_NE1.dat \n"
#        fi

        # RMSD of TRP121 heavy after fit to bb  
#        C1="    rms bbRMSD_wt_ref :1-165@CA,C,O,N out $OUT_ROOT/rmsd_bb_wt_ref.dat ref [REF] mass \n"
#        C1="$C1 rms res121RMSD_wt_ref :121&!@H=,F nofit out $OUT_ROOT/rmsd_121_wt_ref.dat ref [REF] mass time 1 \n"
#
#        C1="    rms bbRMSD_mlwt_ref :1-165@CA,C,O,N out $OUT_ROOT/rmsd_bb_mlwt_ref.dat ref [MLWT] mass \n"
#        C1="$C1 rms res121RMSD_mlwt_ref :121&!@H=,F nofit out $OUT_ROOT/rmsd_121_mlwt_ref.dat ref [MLWT] mass time 1 \n"
#
#        C1="$C1 rms bbRMSD_ml19f_ref :1-165@CA,C,O,N out $OUT_ROOT/rmsd_bb_ml19f_ref.dat ref [ML19F] mass \n"
#        C1="$C1 rms res121RMSD_ml19f_ref :121&!@H=,F nofit out $OUT_ROOT/rmsd_121_ml19f_ref.dat ref [ML19F] mass time 1 \n"
#
#        C1="$C1 rms bbRMSD_3k0n_ref :1-165@CA,C,O,N out $OUT_ROOT/rmsd_bb_3k0n_ref.dat ref [3K0N] mass \n"
#        C1="$C1 rms res121RMSD_3k0n_ref :121&!@H=,F nofit out $OUT_ROOT/rmsd_121_3k0n_ref.dat ref [3K0N] mass time 1 \n"
#
#        C1="$C1 rms bbRMSD_3k0m_ref :1-165@CA,C,O,N out $OUT_ROOT/rmsd_bb_3k0m_ref.dat ref [3K0M] mass \n"
#        C1="$C1 rms res121RMSD_3k0m_ref :121&!@H=,F nofit out $OUT_ROOT/rmsd_121_3k0m_ref.dat ref [3K0M] mass time 1 \n"

#
#        if [ $SYS == "wt" ] ; then
#            # COM for 4 TRP WT H positions : prob can use a loop of H atom ids
#            C1="$C1 distance 4F_to_BB_CO @1819,1820 @1817 out $OUT_ROOT/dist_4F_to_BB_CO.dat \n"
#            C1="$C1 distance 5F_to_BB_CO @1819,1820 @1815 out $OUT_ROOT/dist_5F_to_BB_CO.dat \n"
#            C1="$C1 distance 6F_to_BB_CO @1819,1820 @1813 out $OUT_ROOT/dist_6F_to_BB_CO.dat \n"
#            C1="$C1 distance 7F_to_BB_CO @1819,1820 @1811 out $OUT_ROOT/dist_7F_to_BB_CO.dat \n"
#        else
#            # COM between C=O and 19F
#            C1="$C1 distance F_to_BB_CO @1819,1820 @$(($IRED_V + 1)) out $OUT_ROOT/dist_F_to_BB_CO.dat \n"
#        fi

        #C1="$C1 radgyr :1-165"
        #C1="$C1        out $OUT_ROOT/radgyr.dat \n"

#        C1="    rms rms_3K0N_1-165_BB :1-165@CA,C,O,N ref [REF] mass"
#        C1="$C1     perres    perresmask @CA,C,O,N"
#        C1="$C1     perresout $OUT_ROOT/rmsd_3K0N_1-165_BB_perres.dat"
#        C1="$C1     perresavg $OUT_ROOT/rmsd_3K0N_1-165_BB_perres_avg.dat"
#        C1="$C1     out       $OUT_ROOT/rmsd_3K0N_1-165_BB.dat \n"

         C1="$C1  rms rms_3K0N_1-165_SC :1-165 ref [REF] mass"
         C1="$C1     perres    perresmask &!@CA,C,O,N,H"
         C1="$C1     perresout $OUT_ROOT/rmsd_3K0N_1-165_SC_perres.dat"
         C1="$C1     perresavg $OUT_ROOT/rmsd_3K0N_1-165_SC_perres_avg.dat \n"

#        C1="$C1 secstruct ss :*"
#        C1="$C1           out       $OUT_ROOT/ss.dat"
#        C1="$C1           sumout    $OUT_ROOT/ss_sum.dat"
#        C1="$C1           assignout $OUT_ROOT/ss_assign.dat \n"

        echo -e "${C0}${C1}run" > $OUT_ROOT/cpp_c0c1.in
        $DO_PARALLEL \
        $CPPTRAJ -i $OUT_ROOT/cpp_c0c1.in > $OUT_ROOT/cpp_c0c1.out
        
#        echo -e "$C0$C1" | $CPPTRAJ \
#         > >(tee $OUT_ROOT/cpptraj_1.out) \
#        2> >(tee $OUT_ROOT/cpptraj_1.err >&2)

#        # Commands 4: iRED
#        C4=""
#        C4="$C4 vector CF @${IRED_V} ired @$(($IRED_V + 1)) \n"
#        C4="$C4 matrix ired name ired_matrix order 2 \n"
#        C4="$C4 analyze matrix ired_matrix name ired_vectors"
#        C4="$C4         vecs 1"
#        C4="$C4         out $OUT_ROOT/ired_vectors.dat \n"
#        
#        C4="$C4 ired relax freq 600 NHdist 1.41 order 2 norm"
#        C4="$C4      tstep 1 tcorr 41000" # 5 * 8.2ns tc of 19F CypA
#        C4="$C4      modes ired_vectors"
#        C4="$C4      out            $OUT_ROOT/ired_${CUTOFF}_corr.dat"
#        C4="$C4      noefile        $OUT_ROOT/ired_${CUTOFF}_relax.dat"
#        C4="$C4      orderparamfile $OUT_ROOT/ired_${CUTOFF}_order.dat \n"
#        
#        echo -e "$C0$C4" | $CPPTRAJ \
#         > >(tee $OUT_ROOT/cpptraj_4.out) \
#        2> >(tee $OUT_ROOT/cpptraj_4.err >&2)

        
        cd ..
    done
    let "IRED_V-=2"
    cd ..
    echo "FINISHED RUNNING SYSTEM : $SYS"
done
