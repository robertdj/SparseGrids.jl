using SparseGrids
using Base.Test

# Moments of exp(-x^2)
function gaussmoment(m::Int)
	@assert m >= 0

	if isodd(m)
		return 0.0
	elseif iseven(m)
		m2 = div(m,2)
		return prod( 1:2:m-1 ) * sqrt(pi) / 2^m2
	end
end

# Moments of exp(-|x|^2)
function gaussmoment( P::Vector{Int} )
	I = 1.0
	for d = 1:length(P)
		I *= gaussmoment(P[d])
	end

	return I 
end

# Like gaussmoment, but with quadrature rule
function gaussquad( P::Vector, nodes::Matrix, weights::Vector )
	# Evaluate integrand
	F = broadcast( ^, nodes, P )
	I = vec(prod(F,1))

	# Evaluate quadrature sum
	Q = dot( I, weights )

	return Q
end


# ------------------------------------------------------------
# Test quadrature for various dimensions and orders
# Note: It is not interesting to test uneven moments for Gauss-Hermite

# Dimension and order
D = 3
order = 4

# Moments to test
vecs = Vector{Vector{Int}}(D)
for d in 1:D
	vecs[d] = [0:order;]
end
P = combvec( vecs )

M = size(P, 2)

for generator = [FastGaussQuadrature.gausshermite, kpn]
	# Quadrature points and weights
	N, W = sparsegrid( D, order, generator )

	# Maximum degree for which the generator gives correct results
	generator == FastGaussQuadrature.gausshermite ?  max_degree = 2*order-1 : max_degree = D*order

	for m = 1:M
		# Test if all moments are even
		curP = P[:,m]

		if all(map(iseven, curP))
			I = gaussmoment(curP) 
			Q = gaussquad(curP, N, W)

			# Expected test result depends on the total degree
			if sum(curP) <= max_degree
				@test_approx_eq I Q
			else
				@test abs(I - Q) > 1e-3
			end
		end
	end
end

