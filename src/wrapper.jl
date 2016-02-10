const libdeldir = "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/deldir/libs/deldir.so"
#= const libdeldir = expanduser("~/R/x86_64-pc-linux-gnu-library/3.0/deldir/libs/deldir.so") =#

type DelDir
end

type DelDirRaw
	delsgs::Matrix{Float64}
	dirsgs::Matrix{Float64}
	summary::Matrix{Float64}
end

@doc """
	remove_duplicates(x::Vector, y::Vector)

Remove the duplicate tuples `(x[i],y[i])` from the vectors `x` and `y`.
"""->
function remove_duplicates(x::Vector, y::Vector)
	points = [x y]
	unique_points = unique(points, 1)

	return unique_points[:,1], unique_points[:,2]
end

@doc """
	deldir(x::Vector, y::Vector; ...)

Compute the Delaunay triangulation and Voronoi tesselation of the 2D
points with x-coordinates `x` and y-coordinates `y`.

Optional arguments are

- `rw`: Boundary rectangle specified as a vector with `[xmin, xmax, ymin, ymax]`.
By default, `rw` is the unit rectangle.
- `epsilon`: A value of epsilon used in testing whether a quantity is zeros, mainly in the context of whether points are collinear. 
If anomalous errors arise, it is possible that these may averted by adjusting the value of `epsilon` upward or downward.
By default, `epsilon = 1e-9`.
"""->
function deldir(x::Vector{Float64}, y::Vector{Float64}; 
	rw::Vector=[0.0;1.0;0.0;1.0], epsilon::Float64=1e-9)

	@assert length(x) == length(y) "Coordinate vectors must be of equal length"
	@assert epsilon >= eps(Float64)
	@assert minimum(x) >= rw[1] && maximum(x) <= rw[2] && minimum(y) >= rw[3] && 
	maximum(y) <= rw[4] "Boundary window is too small"

	# According to the documentation in the R package: 
	# "'sort' would get used only in a de-bugging process"
	# Therefore it is not an argument to this function
	sort = 1

	x, y = remove_duplicates(x,y)
	num_points = length(x)

	# Dummy points: Ignored!
	ndm = 0
	npd = num_points + ndm

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
	ndel = Int32[ madj*(madj+1)/2 ]
	tdel = 6*ndel[]
	ndir = ndel
	tdir = 8*ndir[]

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

	# Call Fortran routine
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

	# TODO: slice instead of reshape?
	delsgs = reshape(delsgs, 6, div(tdel,6))'
	dirsgs = reshape(dirsgs, 8, div(tdir,8))'
	delsum = reshape(delsum, npd, 4)
	dirsum = reshape(dirsum, npd, 3)
	#= allsum = [delsum delsum[:,4]/sum(delsum[:,4]) dirsum dirsum[:,3]/sum(dirsum[:,3])] =#
	allsum = [delsum dirsum]

	return DelDirRaw( delsgs[1:ndel[],:], dirsgs[1:ndir[],:], allsum )
end

