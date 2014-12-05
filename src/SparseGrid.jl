module SparseGrid.jl

import FastGaussQuadrature: gausshermite
import Iterators: collect

include("grids.jl")

# package code goes here
export
	smolyak,
	tensorgrid,
	listNdq,
	combvec

end # module
