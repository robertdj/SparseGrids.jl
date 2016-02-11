module Deldir

using DataFrames

const libdeldir = joinpath(Pkg.dir("Deldir"), "deps", "deldir.so")

export
	# Type
	DelDir,
	# Functions
	deldir,
	voronoiarea,
	voronoiedges,
	delaunayedges

include("wrapper.jl")
include("misc.jl")

end # module
