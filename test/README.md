## Test: sourcing of ff15ipq-19F parameters from tleap

* Eventually, instead of the individual frcmod and lib files presented in `../final_parameters`, it will be possible to directly source the fluorinated amino acid parameters along with the ff15ipq force field.
* This is a test of this functionality.
    * seqres is generating de-novo peptides using the ff15ipq-19F parameters
    * pdb is loading in a pdb file and using the ff15ipq-19F parameters
* These tests were ran after adding the frcmod/library/cmd files to `$AMBERHOME` manually.

### In tleap:
```
> source leaprc.protein.ff15ipq
> source leaprc.fluorine.ff15ipq
...
# add remainder of tleap parameters here
...
```

