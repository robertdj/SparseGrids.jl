using SparseGrids
using Test

@testset "Unique nodes" begin
    @testset "All nodes are different" begin
        nodes = [[0;], [1;]]
        weights = [1; 1]

        un, uw = SparseGrids.uniquenodes(nodes, weights)

        @test un == nodes
        @test uw == weights
    end

    @testset "Two identical nodes" begin
        nodes = [[0;], [0;]]
        weights = [1; 1]

        un, uw = SparseGrids.uniquenodes(nodes, weights)

        @test un == unique(nodes)
        @test uw == [sum(weights)]
    end

    @testset "Two of three nodes identical" begin
        nodes = [[0;], [1;], [0;]]
        weights = [1, 2, 3]

        un, uw = SparseGrids.uniquenodes(nodes, weights)

        @test un == [[0;], [1;]]
        @test uw == [4; 2]
    end
end

