#!/bin/bash

MOL=$1

cat << EOF > tleap.in
source leaprc.protein.ff15ipq
$MOL = sequence { ACE ALA $MOL ALA NME }
savepdb $MOL ${MOL}_tet.pdb
quit
EOF

tleap -f tleap.in
