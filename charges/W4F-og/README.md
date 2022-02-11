## Iterations of charge derivations for 4-fluoro Trp (W4F)

* V00 = initial attempt, conformations 5 and 10 failed on mdgx dynamics step before ORCA QM calc
    * For all other conformations, memory was insufficient to run ORCA but grid output files were still generated
    * For a comparison, REsP fitting was carried out, even though ORCA grid gen runs failed
        * These new and orig charge values are ridiculous: do not use
    * Note: These conformations were generated without in vacuo minimization
        * Albeit 2 failed MM, all others ran MM successfully without high T fluctuations

* v01 = next attempt, additional in vacuo minimization step added before mdgx conformer gen
    * Conformations 9 and 10 failed MM with similar errors to v00 failures
    * Many conformations such as 1,7,11, and others had high T MM artefact
        * instead of 300K, >1000K, with subsequent increase in energy
    * REsP was carried out, leaving out Conf9+10, but including high T MM Confs
    * New charges from IPolQ(pert) column of fit.out were used to replace previous charges in W4F.lib
        * Created new file W4F_final.lib
            * Note: this file has updated atom types that are now consistent with ff15ipq lib
                * also updated residue type value to "p" for protein instead of "?" for unknown
                * This should eliminate the need for an frcmod file, which has issues with amber -AT anyway
                * Thus, for the next iteration, don't use frcmod, just lib, test this first.

* v02 = using charges from v01, new conformation were generated and equil, then grid gen and REsP fitting
    * No conformations failed, although high temp was still prevalent for some
    * I realized that I need to make an edit: the qm grid gen step was using CONF.crd instead of 6.2_eq2.rst
        * Essentially, I was using coordinates that were solvated but had not undergone restrained min or eq (2)
    * I could use the lib file from v02, and still needed frcmod file but only for 19F parameters
        * However, I got some warnings in tleap since my charges didn't equate to 0
        * This is likely since the charges were generated for the whole dipeptide
            * Next iteration, may need to only consider residue of interest instead of whole dipeptide
    * Accidentally deleted Conf1/grid_output.solv

* v03 = next iteration using final charges from v02
    * This has another correction: using just the residue of interest (W4F) instead of entire dipeptide in solute flag
        * So instead of solute ':1-3', using solute ':1' : this fix non-zero charge sums
