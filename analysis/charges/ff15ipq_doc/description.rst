Description of FF14IPQ and Related System Configurations
========================================================
00
--
ff14ipq

01
--
ff14ipq
X -N2-CA-N2 dihedral of ff14ipq replaced with that of ff12SB

02
--
ff14ipq
ff14ipq radii used for all interactions (LJEDITS removed, radii changed)
X -N2-CA-N2 dihedral of ff14ipq replaced with that of ff12SB

03
--
ff14ipq 
ff99 radii used for all interactions (LJEDITs removed)
X -N2-CA-N2 dihedral of ff14ipq replaced with that of ff12SB

04
--
ff14ipq
Additional LJEDITs to OD/O3 N2/NL/NA, such that they interact using the ff14ipq
  radii (the same as their interaction with water) rather than the ff99 radii
X -N2-CA-N2 dihedral of ff14ipq replaced with that of ff12SB

05
--
Duplication of 04 performed to ensure that discrepancy in GPU efficiency does
  not influence results
BAMACT only

06
--
ff14ipq
Additional LJEDITs to OD/O3 N2/NL/NA, such that they interact using the ff14ipq
  radii (the same as their interaction with water) rather than the ff99 radii
Additional LJEDITS to OD/O3 HW such that they interact with LJ sites on the
  hydrogens of water, which normally do not have LJ sites
Additional LJEDITS to OD/O3/OW H, increasing the radius of H as it interacts
  with these oxygens
X -N2-CA-N2 dihedral of ff14ipq replaced with that of ff12SB

07
--
ff14ipq
Additional LJEDITs to OD/O3 N2/NL/NA, such that they interact using the ff14ipq
  radii (the same as their interaction with water) rather than the ff99 radii
Additional LJEDITS to OD/O3/OW H, increasing the radius of H as it interacts
  with these oxygens
X -N2-CA-N2 dihedral of ff14ipq replaced with that of ff12SB

08
--
ff14ipq
Additional LJEDITs to OD/O3 N2/NL/NA, such that they interact using the ff14ipq
  radii (the same as their interaction with water) rather than the ff99 radii
Additional LJEDITS to OD/O3 HW such that they interact with LJ sites on the
  hydrogens of water, which normally do not have LJ sites
X -N2-CA-N2 dihedral of ff14ipq replaced with that of ff12SB

09
--
ff14ipq
ff99 radii used for all interactions (LJEDITs removed)
Additional LJEDITS to OD/O3 HW such that they interact with LJ sites on the
  hydrogens of water, which normally do not have LJ sites
Additional LJEDITS to OD/O3/OW H, increasing the radius of H as it interacts
  with these oxygens
X -N2-CA-N2 dihedral of ff14ipq replaced with that of ff12SB

10
--
ff14ipq
ff99 radii used for all interactions (LJEDITs removed)
Additional LJEDITS to OD/O3 HW such that they interact with LJ sites on the
  hydrogens of water, which normally do not have LJ sites
X -N2-CA-N2 dihedral of ff14ipq replaced with that of ff12SB

11
--
ff14ipq
ff99 radii used for all interactions (LJEDITs removed)
Additional LJEDITS to OD/O3/OW H, increasing the radius of H as it interacts
  with these oxygens
X -N2-CA-N2 dihedral of ff14ipq replaced with that of ff12SB

12
--
ff14ipq
ff99 radii used for all interactions (LJEDITs removed)
Sigma of H increased to 1.5
X -N2-CA-N2 dihedral of ff14ipq replaced with that of ff12SB

13
--
ff14ipq
ff99 radii used for all interactions (LJEDITs removed)
Sigma of H increased to 1.375
X -N2-CA-N2 dihedral of ff14ipq replaced with that of ff12SB

14
--
ff14ipq
ff99 radii used for all interactions (LJEDITs removed)
Sigma of H increased to 1.250
X -N2-CA-N2 dihedral of ff14ipq replaced with that of ff12SB

15
--
ff14ipq
ff99 radii used for all interactions (LJEDITs removed)
Sigma of H increased to 1.125
X -N2-CA-N2 dihedral of ff14ipq replaced with that of ff12SB

Description of FF15IPQ System Configurations
============================================

00
--
ff14ipq q
ff15ipq vdw
ff14ipq torsions excluding H -N2-CA-N2

01
--
ff15ipq q
ff15ipq vdw
ff14ipq torsions excluding H -N2-CA-N2

02
--
ff15ipq q
ff15ipq vdw
ff15ipq torsions iteration 0
CYM and LYN types changed

03
--
ff15ipq q
ff15ipq vdw
ff15ipq torsions iteration 1
