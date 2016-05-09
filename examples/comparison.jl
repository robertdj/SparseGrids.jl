import VoronoiCells: voronoiarea
import Deldir: voronoiarea

# Number of generators: Deldir does not go all the way
Nsmall = [1000; 2000:2000:30_000]
Nbig = [40_000:10_000:100_000]
N = vcat(Nsmall, Nbig)

VCtime = Array{Float64}( length(N) )
Dtime = similar(VCtime)
fill!(Dtime, NaN)

# Simulation window
W = [0.0 ; 10.0 ; 0.0 ; 10.0]

idx = 0
for n in N
	println(n)

	x = W[1] + W[2]*rand(n)
	y = W[3] + W[4]*rand(n)

	idx += 1
	VCtime[idx] = @elapsed VoronoiCells.voronoiarea(x, y; rw=W)
	if idx <= length(Nsmall)
		Dtime[idx] = @elapsed Deldir.voronoiarea(x, y; rw=W)
	end
end


# ------------------------------------------------------------

using Winston

x = N / 1000
plot( x, Dtime, "*" )
oplot( x, VCtime, "r." )

xlabel("number of points in 1000s")
ylabel("time in seconds")
legend(["Deldir"; "VoronoiCells"], (0.6,0.9))

savefig("comparison.png")

