const libdeldir = "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/deldir/libs/deldir.so"
#= const libdeldir = expanduser("~/R/x86_64-pc-linux-gnu-library/3.0/deldir/libs/deldir.so") =#

@doc """
	deldir(x::Vector, y::Vector; ...)

Compute the Delaunay triangulation and Voronoi tesselation of the 2D
points with x-coordinates `x` and y-coordinates ´y´.

Optional arguments are

- `sort`: 
- `rw`:
- `epsilon`:
"""->
function deldir(x::Vector{Float64}, y::Vector{Float64}; 
	sort::Int64=1, rw::Vector{Float64}=[0.0;1.0;0.0;1.0], epsilon::Float64=1e-9)
	# TODO: rw depends on data

	@assert (num_points = length(x)) == length(y) "Coordinate vectors must be of equal length"
	@assert epsilon >= eps(Float64)

	# Dummy points
	num_dum_points = 0
	npd = num_points + num_dum_points

	# The total number of points
	ntot = npd + 4

	X = [zeros(4); x; zeros(4)]
	Y = [zeros(4); y; zeros(4)]

	# Set up fixed dimensioning constants
	ntdel = 4*npd
	ntdir = 3*npd

	# Set up dimensioning constants which might need to be increased
	madj = max( 20, ceil(Int32,3*sqrt(ntot)) )
	tadj = (madj+1)*(ntot+4)
	ndel = Int32( madj*(madj+1)/2 )
	tdel = 6*ndel
	ndir = ndel
	tdir = 8*ndir

	nadj   = zeros(Int32, tadj)
	ind    = zeros(Int32, npd)
	tx     = zeros(Float64, npd)
	ty     = zeros(Float64, npd)
	ilist  = zeros(Int32, npd)
	delsgs = zeros(Float64, tdel)
	delsum = zeros(Float64, ntdel)
	dirsgs = zeros(Float64, tdir)
	dirsum = zeros(Float64, ntdir)
	nerror = Int32[1]

	ccall( (:master_, libdeldir), Void,
	(Ref{Float64}, Ref{Float64}, Ref{Int32}, Ref{Float64}, Ref{Int32},
	Ref{Int32}, Ref{Int32}, Ref{Int32}, Ref{Int32}, Ref{Float64}, Ref{Float64}, 
	Ref{Int32}, Ref{Float64}, Ref{Float64}, Ref{Int32}, Ref{Float64}, 
	Ref{Float64}, Ref{Int32}, Ref{Float64}, Ref{Int32}),
	X, Y, sort, rw, npd, 
	ntot, nadj, madj, ind, tx, ty, 
	ilist, epsilon, delsgs, ndel, delsum, 
	dirsgs, ndir, dirsum, nerror
	)

	return nerror
end

