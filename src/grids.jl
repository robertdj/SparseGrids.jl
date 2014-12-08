# Computation of sparse grid nodes and the associated weights
# D : Dimension of integrant
# k : Order of quadrature rule

function smolyak( D::Int, order::Int )
	# Final nodes and weights in D dimensions
	nodes = Array(Float64, D, 0)
	weights = Array(Float64, 0)

	# Compute univariate nodes and weights
	nodes1D = cell(order)
	weights1D = similar(nodes1D)

	# TODO: Make it possible to use other schemes than Gauss-Hermite
	# Check quadgk
	for k = 1:order
		nodes1D[k], weights1D[k] = gausshermite( k )

		symmetrize!( nodes1D[k] )
	end

	nodes, weights = smolyak( D, nodes1D, weights1D )

	return nodes, weights
end


# Computation of sparse grid nodes and the associated weights
# from collection of one-dimensional nodes and weights

function smolyak( D::Int, nodes1D::Array{Any,1}, weights1D::Array{Any,1} )
	order = length( nodes1D )

	# Final nodes and weights in D dimensions
	nodes = Array(Float64, D, 0)
	weights = Array(Float64, 0)

	mink = max(0, order-D)
	maxk = order - 1

	# Temporary nodes and weights for 1 dimension
	N = cell(D)
	W = cell(D)

	for k = mink:maxk
		alpha = listNdq(D, D+k)
		nalpha = size(alpha, 2)

		for n = 1:nalpha
			# The nodes and weights for this alpha mixture
			for d = 1:D
				N[d] = nodes1D[ alpha[d,n] ]
				W[d] = weights1D[ alpha[d,n] ]
			end

			# Compute all the possible combinations of D-dimensional nodes
			combN = combvec(N)

			# Compute the associated weights
			cw = combvec(W)
			combW = (-1)^(maxk-k) * binomial(D-1, D+k-order) * prod(cw, 1)

			# Save nodes and weights
			nodes = [nodes combN]
			weights = [weights ; vec(combW)]
		end
	end

	# Remove redundant nodes
	unodes, uweights = uniquenodes(nodes, weights)

	return unodes, uweights
end


# ------------------------------------------------------------ 
# To correctly reduce "overlapping" nodes the middle node in an
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

# Copy of Base.sortcols that also returns the permutation indices

function sortcolsidx(A::AbstractMatrix; kws...)
    r = 1:size(A,1)
    cols = [ sub(A,r,i) for i=1:size(A,2) ]
    p = sortperm(cols; kws..., order=Base.Order.Lexicographic)

    return A[:,p], p
end


# Find unique nodes and sum the weights of the identical nodes

function uniquenodes(nodes::Matrix, weights::Vector)
	# Sort nodes and weights according to nodes
	sortnodes, P = sortcolsidx(nodes)
	weights = weights[P]

	D, N = size(nodes)

	keep = [1]
	lastkeep = 1

	for n = 2:N
		if sortnodes[:,n] == sortnodes[:,n-1]
			weights[lastkeep] += weights[n]
		else
			lastkeep = n
			push!(keep, n)
		end
	end

	# Keep unique nodes
	unodes = sortnodes[:, keep]
	uweights = weights[keep]

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

