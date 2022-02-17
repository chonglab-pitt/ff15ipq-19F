### Various directories with different parameter fitting specifications

* 4sigtol is fitting the standard 1000 conformations of all res classes
    * this is the best fit
    * no improper torsions are fit, not needed
        * later on, if unable to validate, could try hybrid frcmod with default improper torsions

* gen2 was an attempt to resample minima with 0.01 kcal/mol energy convergence criterion conformations additionally
    * this didn't help too much, some were worse, only W6F was better in terms of RMSE

* after some testing since the spring constants and angle parameters in the frcmod file were not feasible to use in conf gen v01, it was determined that a few adjustments needed to be made.
    * the original frcmod file was adjusted (19F_FF15IPQ_V00_ADJ.frcmod) to angle and spring constant values that made more sense for tetrahedral angles (109.5) specifically for the FTF angles.
    * Then a new set of conformations were generated using these adjusted parameters (gen2_adj)
    * Then in order to get better RMSE: sigtol was set to 3 sigma and arstcpl was set to 10 = best results
        * Spring constant and angle values are now reasonable but still a bit high
