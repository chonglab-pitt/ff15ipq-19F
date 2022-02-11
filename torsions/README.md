## Directory for bonded parameter optimization
* For each iteration:
    * For each res class:
        * 1000 conformations were generated about the phi*psi torsions
        * Each conformation was subject to SPE calculations
            * MP2/cc-pVTZ
        * Resulting energies were fit to optimize the MM PES to the QM PES

### Results
* Total of 2 iterations were ran
* PARMCHK:
    * 19F_FF15IPQ_V00.frcmod = original parmchk values
    * 19F_FF15IPQ_V00_ADJ.frcmod = original parmchk values with parameter adjustments to be more physically accurate
        * e.g. instead of 0 deg angle, 109.5 for SP3 and 120 for SP2
* Iteration 1:
    * First fitting was good but the spring constants and angle values were too extreme
        * Extreme parameters made multiple conformations such as W4F and FTF fail to generate conformations
        * 19F_FF15IPQ_FIT_V00.frcmod
    * A second generation was ran where only the conformations undersampled were recalculated
        * A final fitting of both the original 1000 + additional confs was carried out
        * This time used the V00_ADJ parameters as the original fitting values
        * Results looked okay, but W4F still has a high RMSE (>2 kcal/mol)
        * 19F_FF15IPQ_FIT_V00_GEN2
    * Fits were redone because umbrella sampling restraints were erroneous
        * For GEN2: used V00_ADJ frcmod parameters as original
            * Also used 1 arstcpl and 0.05 arst to keep angle values consistent with V00_ADJ values
        * 19F_FF15IPQ_FIT_V00_GEN2_REST
* Iteration 2:
    * Ran the same protocol with GEN1 and GEN2: both were able to see W4F RMSE <2 kcal/mol results
    * The GEN2 parameters were a better fit, but less physically consistent than GEN1
        * 19F_FF15IPQ_FIT_V01_GEN2.frcmod
    * Fits were redone because umbrella sampling restraints were erroneous
        * For both GEN1 and GEN2: used new V00_GEN2 frcmod parameters as original
            * Also used 1 arstcpl and 0.05 arst to keep angle values consistent with V00_ADJ values
        * 19F_FF15IPQ_FIT_V01_GEN2_REST.frcmod = not bad
    * Actually; the V01_GEN2_REST parameters were not good (RMSE) compared to regular V01 (GEN1)
        * 19F_FF15IPQ_FIT_V01.frcmod = FINAL PARAMETER SET
