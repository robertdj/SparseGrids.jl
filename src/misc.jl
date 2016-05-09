@doc """
	voronoiarea(x::Vector, y::Vector; args...) -> Vector

Compute the area of each Voronoi cell of the generators `(x[i],y[i])` in the vectors `x` and `y`.

The optional arguments are passed to `deldir`.
"""->
function voronoiarea(x::Vector, y::Vector; args...)
	summary = deldirwrapper(x,y; args...)[3]

	return summary[:,7]
end

@doc """
	delaunayedges(D::DelDir) -> (Vector, Vector)

Collect the Delaunay edges in vectors that are ready to be plotted.
"""->
function delaunayedges(D::DelDir)
	x1 = D.delsgs[:x1]
	y1 = D.delsgs[:y1]
	x2 = D.delsgs[:x2]
	y2 = D.delsgs[:y2]

	Ndel = size(D.delsgs,1)
	x = Array{Float64}(3*Ndel)
	y = similar(x)
	
	nx = 0
	for n = 1:Ndel
		x[nx+=1] = x1[n]
		y[nx] = y1[n]

		x[nx+=1] = x2[n]
		y[nx] = y2[n]

		x[nx+=1] = NaN
		y[nx] = NaN
	end

	return x, y
end

@doc """
	voronoiedges(D::DelDir) -> (Vector, Vector)

Collect the Voronoi edges in vectors that are ready to be plotted.
"""->
function voronoiedges(D::DelDir)
	x1 = D.vorsgs[:x1]
	y1 = D.vorsgs[:y1]
	x2 = D.vorsgs[:x2]
	y2 = D.vorsgs[:y2]

	Nvor = size(D.vorsgs,1)
	x = Array{Float64}(3*Nvor)
	y = similar(x)
	
	nx = 0
	for n = 1:Nvor
		x[nx+=1] = x1[n]
		y[nx] = y1[n]

		x[nx+=1] = x2[n]
		y[nx] = y2[n]

		x[nx+=1] = NaN
		y[nx] = NaN
	end

	return x, y
end

