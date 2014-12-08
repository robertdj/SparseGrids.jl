module SparseGrid

import FastGaussQuadrature: gausshermite
import Iterators: collect, product

include("grids.jl")

# package code goes here
export
	smolyak,
	tensorgrid,
	listNdq,
	combvec,
	symmetrize!

end # module
