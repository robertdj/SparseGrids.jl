"""
	sparsegrid( D::Int, k::Int, f::Function=gausshermite; sym::Bool=true )

Computation of sparse grid nodes and the associated weights

- `D` : Dimension of integrant
- `k` : Order of quadrature rule
- `f` : Function generating 1D nodes and weights -- in that order -- for an integer input
- `sym` : Boolean variable determining if the nodes should be symmetrized

If the nodes are supposed to be symmetric (as those in the Gauss-Hermite rule),
they should be so in order to correctly identify multiply occuring nodes in the
union of sparse sets
"""
function sparsegrid(D::Integer, order::Integer, f::Function=gausshermite; sym::Bool=true)
	# Final nodes and weights in D dimensions
	nodes = Array{Float64}(undef, D, 0)
	weights = Array{Float64}(undef, 0)

	# Compute univariate nodes and weights
	nodes1D = Vector{Vector{Float64}}(undef, order)
	weights1D = similar(nodes1D)

	for k in 1:order
		nodes1D[k], weights1D[k] = f(k)

		if sym
			symmetrize!(nodes1D[k])
		end
	end

	nodes, weights = sparsegrid(D, nodes1D, weights1D)

	return nodes, weights
end


# Computation of sparse grid nodes and the associated weights
# from collection of one-dimensional nodes and weights

function sparsegrid(D::Integer, nodes1D::Vector{Vector{Float64}}, weights1D::Vector{Vector{Float64}})
	order = length(nodes1D)

	# Final nodes and weights in D dimensions
	nodes = Array{Float64}(undef, D, 0)
	weights = Array{Float64}(undef, 0)

	mink = max(0, order-D)
	maxk = order - 1

	# Temporary nodes and weights for 1 dimension
	N = Vector{Vector{Float64}}(undef, D)
	W = similar(N)

	for k in mink:maxk
		alpha = listNdq(D, D+k)
		nalpha = size(alpha, 2)

		for n in 1:nalpha
			# The nodes and weights for this alpha mixture
			for d in 1:D
				N[d] = nodes1D[ alpha[d,n] ]
				W[d] = weights1D[ alpha[d,n] ]
			end

			# Compute all the possible combinations of D-dimensional nodes
			combN = combvec(N)

			# Compute the associated weights
			cw = combvec(W)
			combW = (-1)^(maxk-k) * binomial(D-1, D+k-order) * prod(cw, dims = 1)

			# Save nodes and weights
			nodes = hcat(nodes, combN)
			weights = vcat(weights, vec(combW))
		end
	end

	# Remove redundant nodes
	unodes, uweights = uniquenodes(nodes, weights)

	return unodes, uweights
end


# ------------------------------------------------------------
# To correctly reduce "overlapping" nodes the middle node in an
# uneven number must be exactly zero

function symmetrize!(nodes::Vector{Float64})
	N = length(nodes)

	if isodd(N)
		midpoint = div( N-1, 2 )
		nodes[ midpoint+1 ] = 0.0
	else
		midpoint = div( N, 2 )
	end

	for n in 1:midpoint
		nodes[n] = -nodes[N+1-n]
	end
end


# ------------------------------------------------------------
# N^D_q = \{ i \in N^D : sum(i) = q \}

"""
	listNdq(D::Int, q::Int)

Find elements in the set 
```math
N_q^D = {i in N^D : sum(i) = q}
```

The algorithm and the formula for computing the number of elements in this set is found in the thesis mentioned in the README
"""
function listNdq(D::Integer, q::Integer)
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
			for i in 1:p-1
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


"""
	combvec( vecs::Array{Any} ) -> Matrix

Counterpart of Matlab's combvec:
Creates all combinations of vectors in `vecs`, an array of vectors.
"""
function combvec(vecs::Vector{Vector{T}}) where T
	# Construct all Cartesian combinations of elements in vec as tuples
	P = Iterators.product(vecs...)

	D = length(vecs)
	N = length(P)::Int64
	y = Array{T}(undef, D,N)

	n = 0
	for p in P
		y[:, n+=1] = [p...]
	end

	return y
end


# ------------------------------------------------------------

# Copy of Base.Sort.sortcols that also returns the permutation indices
function sortcolsidx(A::AbstractMatrix; kws...)
    inds = indices(A,2)
    T = Base.Sort.slicetypeof(A, :, inds)
    cols = similar(Vector{T}, indices(A, 2))
    for i in inds
        cols[i] = view(A, :, i)
    end
    p = sortperm(cols; kws..., order=Base.Order.Lexicographic)

    return A[:,p], p
end


"""
	uniquenodes(nodes::Matrix, weights::Vector)

Find unique nodes and sum the weights of the identical nodes
"""
function uniquenodes(nodes::AbstractMatrix, weights::AbstractVector)
	# Sort nodes and weights according to nodes
	sortnodes, P = sortcolsidx(nodes)
	weights = weights[P]

	D, N = size(nodes)

	keep = [1]
	lastkeep = 1

	for n in 2:N
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

"""
	tensorgrid( N::Vector, W::Vector, D::Int )

	Compute tensor grid of `N` nodes and corresponding weights `W` for `D` dimensions.
"""
function tensorgrid(N::Vector, W::Vector, D::Integer)
	NN = repeat( [N], outer=[D; 1] )
	WW = repeat( [W], outer=[D; 1] )

	tensorN = combvec(NN[:])
	tensorW = vec(prod( combvec(WW[:]), 1 ))

	return tensorN, tensorW
end


function tensorgrid(D::Integer, order::Integer, f::Function=gausshermite)
	N, W = f(order)

	tensorN, tensorW = tensorgrid(N, W, D)

	return tensorN, tensorW
end

