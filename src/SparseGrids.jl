module SparseGrids

import FastGaussQuadrature: gausshermite
import Iterators: collect, product

include("grids.jl")

# package code goes here
export
	sparsegrid,
	tensorgrid,
	listNdq,
	combvec,
	symmetrize!

end # module

