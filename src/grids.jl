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
		# TODO: This is necessary in order to get the right unique elements
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


# Computation of sparse grid nodes and the associated weights
# from collection of one-dimensional nodes and weights

function smolyak( order::Int, nodes::Array{Any, 1}, weights::Array{Any, 1} )
end


# ------------------------------------------------------------ 
# To correctly reduce "overlapping" nodes the middle node in and 
# uneven number must be exactly zero

function symmetrize!( nodes::Vector )
	N = length(nodes)

	if isodd(N)
		midpoint = div( N-1, 2 )
		nodes[ midpoint+1 ] = 0.0
	else
		midpoint = div( N, 2 )
	end

	for n = 1:midpoint
		nodes[n] = -nodes[N+1-n]
	end

	display(n)
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

# Numerate the columns in a matrix according to the first time it appears
# and count the number of occurences
function uniquecolidx(A::Matrix)
	N = size(A, 2)
	idx = [1:N]
	count = ones(Int, N)

	for n = 2:N
		col = A[:,n]

		for nn = 1:n-1
			if col == A[:,nn]
				@inbounds idx[n] = nn
				@inbounds count[nn] += 1
			end
		end
	end

	return idx, count
end


# Find unique nodes and add the weights of the identical nodes
function uniquenodes(nodes::Matrix, weights::Vector)
	idx, count = uniquecolidx(nodes)

	# Find the unique column indices
	uidx = unique(idx)
	N = length(uidx)
	D = size(nodes, 1)

	# Initialize output
	unodes = Array( eltype(nodes), D, N )
	uweights = zeros( eltype(weights), N )

	M = length(weights)
	cur = 1
	for m = 1:M
		# If the current index in the original nodes has appeared before
		# we leave out the node and add the weight
		if m == idx[m]
			@inbounds unodes[:,cur] = nodes[:,m]
			@inbounds uweights[cur] += weights[m]

			cur += 1
		else
			uweights[ idx[m] ] += weights[m]
		end
	end

	return unodes, uweights
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

