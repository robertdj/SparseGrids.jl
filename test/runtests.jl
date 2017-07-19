using Deldir
using Base.Test

# write your own tests here
N = 100
x = rand(N)
y = rand(N)

A = voronoiarea(x, y)
@test sum(A) ≈ 1

