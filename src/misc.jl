@doc """
	l2dist(x1, y1, x2, y2)

The `l2` distance between `(x1,y1)` and `(x2,y2)`.
"""->
function l2dist(x1::Real, y1::Real, x2::Real, y2::Real)
	l2squared = (x1-x2)^2 + (y1-y2)^2
	return sqrt( l2squared )
end

@doc """
	voronoiarea(x::Vector, y::Vector; args...) -> Vector

Compute the area of each Voronoi cell of the generators `(x[i],y[i])` in the vectors `x` and `y`.

The optional arguments are passed to `deldir`.
"""->
function voronoiarea(x::Vector, y::Vector; args...)
	raw = rawdeldir(x,y; args...)

	return raw.summary[:,7]
end
