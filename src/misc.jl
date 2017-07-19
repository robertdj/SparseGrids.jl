"""
voronoiarea(x::Vector, y::Vector, rw) -> Vector

Compute the area of each Voronoi cell of the generators `(x[i],y[i])` in the vectors `x` and `y`.

`rw` is the boundary window.
"""
function voronoiarea(x::Vector, y::Vector, rw::Vector=[0.0;1.0;0.0;1.0])
	summary = deldirwrapper(x, y, rw)[3]

	return summary[:, 7]
end

"""
	edges(D) -> Vector, Vector

Collect the edges of a dataframe in vectors that are ready to be plotted.
"""
function edges(D::DataFrame)
	x1 = D[:x1]
	y1 = D[:y1]
	x2 = D[:x2]
	y2 = D[:y2]

	N = size(D, 1)
	x = Array{Float64}(3*N)
	y = similar(x)
	
	nx = 0
	for n = 1:N
		x[nx+=1] = x1[n]
		y[nx] = y1[n]

		x[nx+=1] = x2[n]
		y[nx] = y2[n]

		x[nx+=1] = NaN
		y[nx] = NaN
	end

	return x, y
end

