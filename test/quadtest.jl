# Moments of exp(-|x|^2)
function ghmoment( P::Vector )
	P = float(P)
	D = length(P)

	I = 1.0

	for d = 1:D
		Id = quadgk( x -> x.^P[d] .* exp(-x.^2), -Inf, Inf )
		I *= Id[1]
	end

	return I 
end

function normquad( P::Vector, nodes::Matrix, weights::Vector )
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

# Quadrature points and weights
N, W = smolyak( D, order )

# Moments to test
vecs = repmat( Any[[0:order]], D )
P = combvec( vecs )

M = size(P, 2)
for m = 1:M
	# Test if all moments are even
	curP = P[:,m]

	if all(map(iseven, curP))
		#@show curP

		# Expected test result depends on the total degree
		I = ghmoment(curP) 
		Q = normquad(curP, N, W)

		if sum(curP) <= 2*order-1
			@test_approx_eq I Q
		else
			@test abs(I - Q) > 1e-3
		end
	end
end

