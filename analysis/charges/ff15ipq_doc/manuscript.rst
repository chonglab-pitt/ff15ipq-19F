Over the past 15 years there have been considerable improvements in the accuracy of fixed-charge force fields.
(Beachamp, Shaw, etc.)
However, there is growing recognition that there are issues in the nonbonded interactions, spanning
from small model systems to the behavior of unfolded proteins.
Different groups hae tried various pointed corrections to address this,
Other have tried refitting the parameters of specific amino acid side chains (CHARMM22*),
or combining parameters from different force fields for different amino acid residues (latest Shaw).

We previously set out to address this problem by introducing a rigorous method of deriving atomic charges
and van der Waals radii, accounting for ... (2013)
This was later extended to derivation of torsion parameters
However, during torsion fitting we found that these increased radii made the fitting of torsion
parameters difficult
Here we elucidate several issues with our prior protocol and
attempt an alternative solution to fit lennard-jones radii,
while extending the dataset used to fit torsion parameters.
The result is a more robust and accurate force field.
