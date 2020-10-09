using SparseGrids
using Test

@testset "combvec" begin
    @testset "Two 2D vectors" begin
        a1 = [[1; 3], [2; 4]]
        a = combvec(a1)

        @test a == [[1; 2], [3; 2], [1; 4], [3; 4]]
    end


    @testset "A 2D vector and two 1D vectors" begin
        a1 = [[1; 2], [3], [4]]
        a = combvec(a1)

        @test a == [[1; 3; 4], [2; 3; 4]]
    end
end

