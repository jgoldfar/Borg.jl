#!/bin/bash
`julia -e 'print(joinpath(Pkg.dir("Borg"), "deps", "src", "borg-moea", "frontend"))'` -n 10 -v 11 -o 2 -c 0 -e 0.01,0.01 -l 0,... -u 1,... -- julia 01-dtlz2-ext.jl

# Output is of the form
# var1 ... var11 obj1 obj2 (this is not clear from the documentation)
