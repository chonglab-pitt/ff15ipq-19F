### The final set of ff15ipq fluorinated amino acid force field parameter files

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

