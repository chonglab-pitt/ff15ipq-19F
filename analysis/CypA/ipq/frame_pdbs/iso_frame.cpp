parm w7f/v04/3k0n_w7f_dry_noion.prmtop 
 trajin w7f/v04/06_prod_dry.nc 150000 150000 1 
 autoimage 
 rms fit :1-165@CA,C,O,N 
 trajout frame_pdbs/3k0n_w7f_v04_150ns.pdb pdb 
 run
