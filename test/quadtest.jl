using SparseGrids
import FastGaussQuadrature: gausshermite
using LinearAlgebra
using Test

# Moments of exp(-x^2)
function gaussmoment(m::Int)
	if isodd(m)
		return 0.0
	elseif iseven(m)
		m_half = div(m, 2)
		return prod(1:2:m - 1) * sqrt(pi) / 2^m_half
	end
end

# Moments of exp(-|x|^2)
function gaussmoment(P::Vector{Int})
	mapreduce(gaussmoment, *, P)
end

# Like gaussmoment, but with quadrature rule
function gaussquad(P, nodes, weights)
	# Evaluate integrand
	F = map(x -> x.^P, nodes)
	I = map(prod, F)

	# Evaluate quadrature sum
	Q = dot(I, weights)

	return Q
end


# ------------------------------------------------------------
# Test quadrature for various dimensions and orders

@testset "Test quadrature rules" begin
    dim = 3
    order = 4

	# Moments to test
    vecs = [collect(0:order) for d in 1:dim]
    all_powers = combvec(vecs)
    indices_with_all_even_powers = map(p -> all(map(iseven, p)), all_powers)
    even_powers = all_powers[indices_with_all_even_powers]

    @testset "Quadrature rule $generator" for generator in [gausshermite, kpn]
        N, W = sparsegrid(dim, order, generator)
        Ntensor, Wtensor = tensorgrid(dim, order, generator)
        
        # Maximum degree for which the generator gives correct results
        generator == kpn ? max_degree = dim * order : max_degree = 2 * order - 1
        
		@testset "Gaussian moments $powers" for powers in even_powers
        	I = gaussmoment(powers) 
        	sparse_quadrature = gaussquad(powers, N, W)
        
        	# Expected test result depends on the total degree
        	if sum(powers) <= max_degree
        		@test I ≈ sparse_quadrature
        	else
        		@test abs(I - sparse_quadrature) > 1e-3
        	end

        	tensor_quadrature = gaussquad(powers, Ntensor, Wtensor)
        	@test I ≈ tensor_quadrature
        end
    end
end
