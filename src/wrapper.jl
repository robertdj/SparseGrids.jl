const libdeldir = "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/deldir/libs/deldir.so"
#= const libdeldir = expanduser("~/R/x86_64-pc-linux-gnu-library/3.0/deldir/libs/deldir.so") =#

# TODO: A `show` command for this type?
type DelDir
	delsgs::DataFrame
	vorsgs::DataFrame
	summary::DataFrame
end

type DelDirRaw
	delsgs::Matrix{Float64}
	vorsgs::Matrix{Float64}
	summary::Matrix{Float64}
end

@doc """
	remove_duplicates(x::Vector, y::Vector)

Remove duplicate tuples `(x[i],y[i])` from the vectors `x` and `y`.
"""->
function remove_duplicates(x::Vector, y::Vector)
	points = [x y]
	unique_points = unique(points, 1)

	return unique_points[:,1], unique_points[:,2]
end

@doc """
	initialize()

Set up input for the deldir Fortran routine
"""->
macro initialize()
	esc(quote
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

		@allocate
	end)
end

@doc """
	allocate()

Allocate input to be modified by the deldir Fortran routine
"""->
macro allocate()
	esc(quote
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
	end)
end

@doc """
	error_handling()

Handle errors from the deldir Fortran routine
"""->
macro error_handling()
	esc(quote
		if nerror[] == 4
			madj = ceil(Int32, 1.2*madj)
			tadj = (madj+1)*(ntot+4)
			ndel = max( ndel, div(madj*(madj+1),2) )
			tdel = 6*ndel[]
			ndir = ndel
			tdir = 8*ndir[]
			@allocate
		elseif nerror[] == 14 || nerror[] == 15
			ndel = ceil(Int32, 1.2*ndel)
			tdel = 6*ndel[]
			ndir = ndel
			tdir = 8*ndir[]
			@allocate
		#= elseif nerror[] < 0 =#
		#= 	break =#
		#= else =#
		elseif nerror[] > 1
			error("From `deldir` Fortran, nerror = ", nerror[])
		end
	end)
end

@doc """
	finalize()

Process output from the deldir Fortran routine
"""->
macro finalize()
	esc(quote
		# TODO: slice instead of reshape?
		delsgs = reshape(delsgs, 6, div(tdel,6))'
		dirsgs = reshape(dirsgs, 8, div(tdir,8))'
		delsum = reshape(delsum, npd, 4)
		dirsum = reshape(dirsum, npd, 3)
		#= allsum = [delsum delsum[:,4]/sum(delsum[:,4]) dirsum dirsum[:,3]/sum(dirsum[:,3])] =#
		allsum = [delsum dirsum]

	end)
end

@doc """
	rawdeldir(x::Vector{Float64}, y::Vector{Float64}; ...)

Wrapper for the Fortran code that returns the output rather undigested.
Only intended for in-package calls!
"""->
function rawdeldir(x::Vector{Float64}, y::Vector{Float64}; 
	rw::Vector=[0.0;1.0;0.0;1.0], epsilon::Float64=1e-9)

	@assert length(x) == length(y) "Coordinate vectors must be of equal length"
	@assert epsilon >= eps(Float64)
	@assert minimum(x) >= rw[1] && maximum(x) <= rw[2] && minimum(y) >= rw[3] && 
	maximum(y) <= rw[4] "Boundary window is too small"

	@initialize

	# Call Fortran routine
	while nerror[] >= 1
		ccall( (:master_, libdeldir), Void,
		(Ref{Float64}, Ref{Float64}, Ref{Int32}, Ref{Float64}, Ref{Int32},
		Ref{Int32}, Ref{Int32}, Ref{Int32}, Ref{Int32}, Ref{Float64}, Ref{Float64}, 
		Ref{Int32}, Ref{Float64}, Ref{Float64}, Ref{Int32}, Ref{Float64}, 
		Ref{Float64}, Ref{Int32}, Ref{Float64}, Ref{Int32}),
		X, Y, sort, float(rw), npd, 
		ntot, nadj, madj, ind, tx, ty, 
		ilist, epsilon, delsgs, ndel, delsum, 
		dirsgs, ndir, dirsum, nerror
		)

		@error_handling
	end

	@finalize

	return DelDirRaw( delsgs[1:ndel[],:], dirsgs[1:ndir[],:], allsum )
end

@doc """
	deldir(x::Vector, y::Vector; ...)

Compute the Delaunay triangulation and Voronoi tesselation of the 2D points with x-coordinates `x` and y-coordinates `y`.

Optional arguments are

- `rw`: Boundary rectangle specified as a vector with `[xmin, xmax, ymin, ymax]`.
By default, `rw` is the unit rectangle.
- `epsilon`: A value of epsilon used in testing whether a quantity is zeros, mainly in the context of whether points are collinear.
If anomalous errors arise, it is possible that these may averted by adjusting the value of `epsilon` upward or downward.
By default, `epsilon = 1e-9`.

The output is a struct with three `DataFrame`s:

###### `delsgs`
- The `x1`, `y1`, `x2` & `y2` entires are the coordinates of the points joined by an edge of a Delaunay triangle.
- The `ind1` and `ind2` entries are the indices of the two points which are joined.

###### `vorsgs`
- The `x1`, `y1`, `x2` & `y2` entires are the coordinates of the endpoints of one the edges of a Voronoi cell.
- The `ind1` and `ind2` entries are the indices of the two points, in the set being triangulated, which are separated by that edge
- The `bp1` entry indicates whether the first endpoint of the corresponding edge of a Voronoi cell is a boundary point (a point on the boundary of the rectangular window). 
Likewise for the `bp2` entry and the second endpoint of the edge.

###### `summary`
- The `x` and `y` entries of each row are the coordinates of the points in the set being triangulated.
- The `ntri` entry are the number of Delaunay triangles emanating from the point.
- The `del_area` entry is `1/3` of the total area of all the Delaunay triangles emanating from the point.
- The `n_tside` entry is the number of sides — within the rectangular window — of the Voronoi cell surrounding the point.
- The `nbpt` entry is the number of points in which the Voronoi cell intersects the boundary of the rectangular window.
- The `vor_area` entry is the area of the Voronoi cell surrounding the point.
"""->
function deldir(x::Vector{Float64}, y::Vector{Float64}; args...)
	raw = rawdeldir(x,y; args...)

	delsgs = DataFrame()
	delsgs[:x1] = raw.delsgs[:,1]
	delsgs[:y1] = raw.delsgs[:,2]
	delsgs[:x2] = raw.delsgs[:,3]
	delsgs[:y2] = raw.delsgs[:,4]
	delsgs[:ind1] = round(Int64,raw.delsgs[:,5])
	delsgs[:ind2] = round(Int64,raw.delsgs[:,6])

	vorsgs = DataFrame()
	vorsgs[:x1] = raw.vorsgs[:,1]
	vorsgs[:y1] = raw.vorsgs[:,2]
	vorsgs[:x2] = raw.vorsgs[:,3]
	vorsgs[:y2] = raw.vorsgs[:,4]
	vorsgs[:ind1] = round(Int64,raw.vorsgs[:,5])
	vorsgs[:ind2] = round(Int64,raw.vorsgs[:,6])
	vorsgs[:bp1] = raw.vorsgs[:,7] .== 1
	vorsgs[:bp2] = raw.vorsgs[:,8] .== 1

	summary = DataFrame()
	summary[:x] = raw.summary[:,1]
	summary[:y] = raw.summary[:,2]
	summary[:ntri] = round(Int64,raw.summary[:,3])
	summary[:del_area] = raw.summary[:,4]
	summary[:n_tside] = round(Int64,raw.summary[:,5])
	summary[:nbpt] = round(Int64,raw.summary[:,6])
	summary[:vor_area] = raw.summary[:,7]

	return DelDir( delsgs, vorsgs, summary )
end
