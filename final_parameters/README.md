### The final set of ff15ipq fluorinated amino acid force field parameter files

To use these files for your fluorinated protein, first make sure that the atom names follow AMBER ff15ipq formatting conventions. Then, for the fluorinated variant, update the residue name to the 3-letter-code and the respective fluorine atom name shown below.

<p align="center">
   <img src="../docs/19F_ipq_structures_atom_types.png" alt="19F_atom_types" width="500">
</p>

Using your now AMBER formatted coorindate file (e.g. PDB) you can run a variation of following tleap input:
In this example, the input pdb file is solvated using a 12 <span>&#8491;</span> truncated octahedral SPC/E<sub>b</sub> water box (note that the ff15ipq force field was parametarized in the context of this water model).
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

You now have solvated parameter and coordinate files ready to use for running dynamics!

If you'd like, you can also use these parameter files to generate a custom peptide, also using tleap, where ${RES} is the three-letter-code from the figure shown above:
```
source leaprc.protein.ff15ipq
source leaprc.water.spce
loadoff ff15ipq-19F.lib
loadAmberParams frcmod.ff15ipq-19F
${RES} = sequence { ACE ALA ${RES} ALA NME }
check ${RES}
savepdb ${RES} ${RES}_tet.pdb
quit
```

As an example, the output pdb file if ${RES}=W4F looks like this:
```
ATOM      1  H1  ACE     1       2.000   1.000  -0.000  1.00  0.00
ATOM      2  CH3 ACE     1       2.000   2.090   0.000  1.00  0.00
ATOM      3  H2  ACE     1       1.486   2.454   0.890  1.00  0.00
ATOM      4  H3  ACE     1       1.486   2.454  -0.890  1.00  0.00
ATOM      5  C   ACE     1       3.427   2.641  -0.000  1.00  0.00
ATOM      6  O   ACE     1       4.391   1.877  -0.000  1.00  0.00
ATOM      7  N   ALA     2       3.555   3.970  -0.000  1.00  0.00
ATOM      8  H   ALA     2       2.735   4.558  -0.000  1.00  0.00
ATOM      9  CA  ALA     2       4.878   4.562  -0.000  1.00  0.00
ATOM     10  HA  ALA     2       5.420   4.241   0.890  1.00  0.00
ATOM     11  CB  ALA     2       5.670   4.136  -1.232  1.00  0.00
ATOM     12  HB1 ALA     2       5.144   4.458  -2.131  1.00  0.00
ATOM     13  HB2 ALA     2       6.658   4.595  -1.206  1.00  0.00
ATOM     14  HB3 ALA     2       5.774   3.052  -1.241  1.00  0.00
ATOM     15  C   ALA     2       4.798   6.081   0.000  1.00  0.00
ATOM     16  O   ALA     2       3.708   6.649   0.000  1.00  0.00
ATOM     17  N   W4F     3       5.981   6.700   0.000  1.00  0.00
ATOM     18  H   W4F     3       6.835   6.162  -0.000  1.00  0.00
ATOM     19  CA  W4F     3       6.032   8.148   0.000  1.00  0.00
ATOM     20  HA  W4F     3       5.531   8.530  -0.890  1.00  0.00
ATOM     21  CB  W4F     3       5.340   8.722   1.232  1.00  0.00
ATOM     22  HB2 W4F     3       4.296   8.410   1.241  1.00  0.00
ATOM     23  HB3 W4F     3       5.835   8.356   2.131  1.00  0.00
ATOM     24  CG  W4F     3       5.342  10.229   1.321  1.00  0.00
ATOM     25  CD1 W4F     3       4.806  10.980   2.293  1.00  0.00
ATOM     26  HD1 W4F     3       4.304  10.504   3.135  1.00  0.00
ATOM     27  NE1 W4F     3       5.053  12.347   1.950  1.00  0.00
ATOM     28  HE1 W4F     3       4.767  13.148   2.493  1.00  0.00
ATOM     29  CE2 W4F     3       5.709  12.389   0.817  1.00  0.00
ATOM     30  CZ2 W4F     3       6.151  13.520   0.120  1.00  0.00
ATOM     31  HZ2 W4F     3       5.956  14.516   0.517  1.00  0.00
ATOM     32  CH2 W4F     3       6.829  13.276  -1.069  1.00  0.00
ATOM     33  HH2 W4F     3       7.203  14.110  -1.664  1.00  0.00
ATOM     34  CZ3 W4F     3       7.037  12.016  -1.505  1.00  0.00
ATOM     35  HZ3 W4F     3       7.571  11.844  -2.440  1.00  0.00
ATOM     36  CE3 W4F     3       6.582  10.891  -0.786  1.00  0.00
ATOM     37  FE3 W4F     3       6.791   9.763  -1.216  1.00  0.00
ATOM     38  CD2 W4F     3       5.899  11.137   0.412  1.00  0.00
ATOM     39  C   W4F     3       7.471   8.646   0.000  1.00  0.00
ATOM     40  O   W4F     3       8.406   7.849   0.000  1.00  0.00
ATOM     41  N   ALA     4       7.599   9.975   0.000  1.00  0.00
ATOM     42  H   ALA     4       6.779  10.563   0.000  1.00  0.00
ATOM     43  CA  ALA     4       8.922  10.566   0.000  1.00  0.00
ATOM     44  HA  ALA     4       9.464  10.245   0.890  1.00  0.00
ATOM     45  CB  ALA     4       9.713  10.141  -1.232  1.00  0.00
ATOM     46  HB1 ALA     4       9.188  10.463  -2.131  1.00  0.00
ATOM     47  HB2 ALA     4      10.702  10.599  -1.206  1.00  0.00
ATOM     48  HB3 ALA     4       9.817   9.055  -1.241  1.00  0.00
ATOM     49  C   ALA     4       8.843  12.086   0.000  1.00  0.00
ATOM     50  O   ALA     4       7.753  12.654   0.000  1.00  0.00
ATOM     51  N   NME     5      10.026  12.704   0.000  1.00  0.00
ATOM     52  H   NME     5      10.880  12.165   0.000  1.00  0.00
ATOM     53  CH3 NME     5      10.135  14.149   0.000  1.00  0.00
ATOM     54 HH31 NME     5       9.138  14.589   0.000  1.00  0.00
ATOM     55 HH32 NME     5      10.675  14.473   0.890  1.00  0.00
ATOM     56 HH33 NME     5      10.675  14.473  -0.890  1.00  0.00
TER   
END
```

I hope this mini-tutorial is helpful, if you have any questions about these instructions you can contact me at dty7@pitt.edu. 
