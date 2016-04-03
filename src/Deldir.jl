module Deldir

using DataFrames
#= import Winston: plot, oplot, xlim, ylim =#

const libdeldir = joinpath(dirname(@__FILE__), "..", "deps", "deldir.so")

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
