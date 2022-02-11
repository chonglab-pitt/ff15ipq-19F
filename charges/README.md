## Directory for ipq partial charge calculations
* total of 4 iterations were ran
    * each res class = 20 conformations about phi/psi
    * vac and solv phase charge calculations were ran for each conf
        * MP2/cc-pVTZ
* multiple versions for the final iteration (V03):
    * TETH was an attempt to tether the charges to previous values, similar to KTD code
        * this was insignificant, decided not to use them
    * EQ_FTF is the final and best charge set to be used
        * Other sets do not have equalq set on the fluoro-methyl group of FTF
    * VAC was made using the EQ_FTF output dataset
        * Vacuum phase charges were taken from resp fitting output
    * IPQ_ADJ is the EQ_FTF charge set with a few adjustments
        * changed the res class ordering to alphabetical
        * updated atom types to match original naming scheme
            * eg. W4F: F4W -> FE3
        * this is the final ipq charge set that was used for subsequent validation!
    * VAC_ADJ is the VAC charge set with adjustments
        * changed the res class ordering to alphabetical
        * updated atom types to match original naming scheme
            * eg. W4F: F4W -> FE3
        * this charge set was used with the torsion fitting step
        
