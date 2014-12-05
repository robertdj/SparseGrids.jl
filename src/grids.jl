# Computation of sparse grid nodes and the associated weights
# D : Dimension of integrant
# k : Order of quadrature rule

function smolyak( D::Int, order::Int )
	# Final nodes and weights in D dimensions
	nodes = Array(Float64, D, 0)
	weights = Array(Float64, 0)

	mink = order
	maxk = order + D - 1

	# Compute univariate nodes and weights
	nodes1D = cell(order)
	weights1D = similar(nodes1D)

	# TODO: Make it possible to use other schemes than Gauss-Hermite
	for k = 1:order
		nodes1D[k], weights1D[k] = gausshermite( k )

		# For odd k the middle node is zero
		if isodd(k)
			nodes1D[k][ (k+1)/2 ] = 0
		end
	end

	# Temporary nodes and weights for 1 dimension
	N = cell(D)
	W = cell(D)

	for k = mink:maxk
		alpha = listNdq(D, k)
		nalpha = size(alpha, 2)

		for n = 1:nalpha
			# Necessary univariate nodes and weights
			for d = 1:D
				N[d] = nodes1D[ alpha[d,n] ]
				W[d] = weights1D[ alpha[d,n] ]
			end

			# Compute all the possible combinations of D-dimensional nodes
			combN = combvec(N)

			# Compute the associated weights
			cw = combvec(W)
			combW = (-1)^(maxk-k) * binomial(D-1, k-order) * prod(cw, 1)

			# Save nodes and weights
			nodes = [nodes combN]
			weights = [weights ; combW[:]]
		end
	end

	return nodes, weights
end


# ------------------------------------------------------------ 

# Find elements in the set N^D_q = { i \in N^D : sum(i) = q }
# The algorithm and the formula for computing the number of elements in this 
# set is found in the thesis mentioned in the README

function listNdq( D::Int, q::Int )
	if q < D
		error("listNdq: q must be larger than D")
	end

	M = binomial(q-1, D-1)
	L = ones(Int, D, M)

	k = ones(Int, D)
	maxk = q - D + 1
	khat = maxk*ones(Int, D)

	p = 1
	count = 0

	while k[D] < maxk
		k[p] += 1

		if k[p] > khat[p]
			k[p] = 1
			p += 1
		else
			for i = 1:p-1
				khat[i] = khat[p] - k[p] + 1
			end

			k[1] = khat[1]
			p = 1

			count += 1
			L[:,count] = k
		end
	end

	return L
end


# Counterpart of Matlab's combvec: 
# Creates all combinations of vectors. These are passed as a cell of vectors
# Uses the Iterators package
function combvec( vecs::Array{Any} )
	# Construct all Cartesian combinations of elements in vec as tuples
	P = collect(product( vecs... ))

	D = length(P[1])
	N = length(P)
	T = eltype( P[1] )
	y = Array( T, D, N )

	for n = 1:N
		y[:,n] = [P[n]...]
	end

	return y
end


# ------------------------------------------------------------ 
# Compute tensor product grid

function tensorgrid( N::Vector, W::Vector, D::Int )
	NN = repeat( Any[N], outer=[D 1] )
	WW = repeat( Any[W], outer=[D 1] )

	tensorN = combvec( NN )
	tensorW = vec(prod( combvec(WW), 1 ))

	return tensorN, tensorW
end


# TODO: Make it possible to use other schemes than Gauss-Hermite
function tensorgrid( D::Int, order::Int )
	N, W = gausshermite(order)

	tensorN, tensorW = tensorgrid(N, W, D)

	return tensorN, tensorW
end

