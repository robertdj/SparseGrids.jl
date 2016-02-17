module SparseGrids

import FastGaussQuadrature: gausshermite
import Iterators: collect, product

include("grids.jl")
include("nested.jl")

# package code goes here
export
	sparsegrid,
	tensorgrid,
	listNdq,
	combvec,
	symmetrize!,
	kpn

end # module

