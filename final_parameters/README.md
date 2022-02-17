### The final set of ff15ipq fluorinated amino acid force field parameter files

To use these files for your fluorinated protein, first make sure that the atom names follow AMBER ff15ipq formatting. Then, for the fluorinated variant, update the residue name to the 3-letter-code and the respective fluorine atom name shown below.

![19F_atom_types](../docs/19F_ipq_structures_atom_types.pdf "19F atom types")

Use these files with the following tleap input:
``` 
source leaprc.protein.ff15ipq
source leaprc.water.spce
loadoff ff15ipq-19F.lib
loadAmberParams frcmod.ff15ipq-19F
mol = loadpdb PDB_NAME_HERE.pdb
solvateoct mol SPCBOX 12.0
saveamberparm mol PDB_solv.prmtop PDB_solv.inpcrd
quit
```

