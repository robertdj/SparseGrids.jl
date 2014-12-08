using Base.Test

# Exact computation of moments of the standard normal distribution
function normmoment( P::Int )
	if P == 0
		return 1.0
	elseif isodd(P)
		return 0.0
	else
		return float(prod( [1:2:P-1] ))
	end

end

# Exact computation of moments of the multidimensional standard normal distribution
# P : Vector of moments for each dimension
function normmoment( P::Vector{Int} )
	D = length(P)
	M = 1

	for d = 1:D
		I = normmoment( P[d] )
		M *= I[1]
	end

	return M

end
