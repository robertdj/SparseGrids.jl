module Deldir

using DataFrames

const libdeldir = joinpath(dirname(@__FILE__), "..", "deps", "deldir.so")

export
	# Type
	DelDir,

	# Functions
	deldir,
	voronoiarea,
	edges

include("wrapper.jl")
include("misc.jl")

end # module
