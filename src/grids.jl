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

	mink = max(0, order - D)
	maxk = order - 1
	all_alpha_lists = [listNdq(D, D + k) for k in mink:maxk]

	number_of_nodes = map(x -> sum(prod.(x)), all_alpha_lists) |> sum

	# Final nodes and weights in D dimensions
	nodes = Vector{Vector{Float64}}(undef, 0)
	sizehint!(nodes, number_of_nodes)

	weights = Array{Float64}(undef, 0)
	sizehint!(weights, number_of_nodes)

	for (alpha_idx, k) in enumerate(mink:maxk)
		this_alpha_list = all_alpha_lists[alpha_idx]

		for alpha in this_alpha_list
			# The nodes and weights for this alpha mixture
			N = [nodes1D[index] for index in alpha]
			W = [weights1D[index] for index in alpha]

			# Compute all the possible combinations of D-dimensional nodes
			combN = combvec(N)

			# Compute the associated weights
			cw = combvec(W)
			combW = (-1)^(maxk - k) * binomial(D - 1, D + k - order) * map(prod, cw)

			append!(nodes, combN)
			append!(weights, combW)
		end
	end

	unique_nodes, combined_weights = uniquenodes(nodes, weights)
	return unique_nodes, combined_weights
end


"""
To correctly reduce "overlapping" nodes the middle node in an uneven number must be exactly zero
"""
function symmetrize!(nodes::Vector{Float64})
	N = length(nodes)

	if isodd(N)
		midpoint = div(N - 1, 2)
		nodes[midpoint + 1] = 0.0
	else
		midpoint = div(N, 2)
	end

	for n in 1:midpoint
		nodes[n] = -nodes[N + 1 - n]
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
		error("q must be larger than D")
	end

	M = binomial(q - 1, D - 1)
	L = [ones(Int, D) for _ in 1:M]

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
			for i in 1:p - 1
				khat[i] = khat[p] - k[p] + 1
			end

			k[1] = khat[1]
			p = 1

			count += 1
			copy!(L[count], k)
		end
	end

	return L
end


"""
	combvec(vecs)

Counterpart of Matlab's combvec:
Creates all combinations of vectors in `vecs`, an array of vectors.
"""
function combvec(vecs::Vector{Vector{T}}) where T
	# Construct all Cartesian combinations of elements in vecs
	P = Iterators.product(vecs...)
	y = collect.(vec(collect(P)))
	return y
end


"""
	uniquenodes(nodes, weights)

Find unique nodes and sum the weights of identical nodes
"""
function uniquenodes(nodes, weights)
	# Sort nodes and weights according to nodes
	perm = sortperm(nodes)
	sorted_nodes = nodes[perm]
	perm_weights = weights[perm]

	unique_nodes = similar(nodes, 0)
	N = length(nodes)

	indices_to_keep = [1]
	sizehint!(indices_to_keep, N)
	last_index_to_keep = 1

	for n in 2:N
		if sorted_nodes[last_index_to_keep] == sorted_nodes[n]
			perm_weights[last_index_to_keep] += perm_weights[n]
		else
			last_index_to_keep = n
			push!(indices_to_keep, n)
		end
	end

	unique_nodes = sorted_nodes[indices_to_keep]
	collected_weights = perm_weights[indices_to_keep]

	return unique_nodes, collected_weights
end


# ------------------------------------------------------------
# Compute tensor product grid

"""
	tensorgrid( N::Vector, W::Vector, D::Int )

	Compute tensor grid of `N` nodes and corresponding weights `W` for `D` dimensions.
"""
function tensorgrid(N::Vector, W::Vector, D::Integer)
	NN = repeat([N], outer=[D; 1])
	WW = repeat([W], outer=[D; 1])

	tensorN = combvec(NN[:])
	tensorW = vec(prod(combvec(WW[:]), 1))

	return tensorN, tensorW
end


function tensorgrid(D::Integer, order::Integer, f::Function=gausshermite)
	N, W = f(order)

	tensorN, tensorW = tensorgrid(N, W, D)

	return tensorN, tensorW
end
