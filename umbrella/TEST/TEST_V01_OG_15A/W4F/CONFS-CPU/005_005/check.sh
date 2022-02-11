#!/bin/bash

# skip when 06_prod runs for the window are completed
WIN_PROD=$(tail -1 W4F_tet_prod_005_005.out)
if [[ "$WIN_PROD" == "|  Total wall time:"* ]] ; then
    echo "FOR RES = W4F : WINDOW = 005_005 : RUN COMPLETED: SKIPPING"
else
    echo "$WIN_PROD is not correct"
fi

