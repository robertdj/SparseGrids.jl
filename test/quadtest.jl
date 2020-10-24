using SparseGrids
using FastGaussQuadrature
using LinearAlgebra
using Test

# Moments of exp(-x^2)
function gaussmoment(m::Int)
	if isodd(m)
		return 0.0
	elseif iseven(m)
		m2 = div(m, 2)
		return prod(1:2:m-1) * sqrt(pi) / 2^m2
	end
end

# Moments of exp(-|x|^2)
function gaussmoment(P::Vector{Int})
	I = 1.0
	for d in 1:length(P)
		I *= gaussmoment(P[d])
	end

	return I 
end

# Like gaussmoment, but with quadrature rule
function gaussquad(P::Vector, nodes, weights)
	# Evaluate integrand
	F = map(x -> x.^P, nodes)
	I = map(prod, F)

	# Evaluate quadrature sum
	Q = dot(I, weights)

	return Q
end


# ------------------------------------------------------------
# Test quadrature for various dimensions and orders

# Dimension and order
D = 3
order = 4

# Moments to test
vecs = [collect(0:order) for d in 1:D]
P = combvec(vecs)
indices_of_all_even_powers = map(p -> all(map(iseven, p)), P)
even_powers = P[indices_of_all_even_powers]

M = length(P)

for generator in [FastGaussQuadrature.gausshermite, kpn]
	# Quadrature points and weights
	N, W = sparsegrid(D, order, generator)

	# Maximum degree for which the generator gives correct results
	generator == kpn ? max_degree = D * order : max_degree = 2*order - 1

	for curP in even_powers
		I = gaussmoment(curP) 
		Q = gaussquad(curP, N, W)

		# Expected test result depends on the total degree
		if sum(curP) <= max_degree
			@test I ≈ Q
		else
			@test abs(I - Q) > 1e-3
		end
	end
end
