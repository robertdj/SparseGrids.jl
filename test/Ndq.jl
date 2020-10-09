using SparseGrids
using Test

@testset "N_q^D" begin
    @testset "Only one element with D == q" begin
        ndq = listNdq(3, 3)

        @test ndq == [ones(Int, 3)]
    end


    @testset "Split a dice" begin
        ndq = listNdq(2, 6)

        @test ndq == [[5, 1], [4, 2], [3, 3], [2, 4], [1, 5]]
    end
end

