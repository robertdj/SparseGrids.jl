module deldir

using DataFrames

const libdeldir = joinpath(Pkg.dir("deldir"), "deps", "deldir.so")

include("wrapper.jl")
include("misc.jl")

export
	# Types
	DelDir,
	# Functions
	deldir

end # module
