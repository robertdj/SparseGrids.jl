using SparseGrids
using Test

@testset "Unique nodes" begin
    @testset "All nodes are unique" begin
        nodes = [[0;], [1;]]
        weights = [1, 1]

        un, uw = SparseGrids.uniquenodes(nodes, weights)

        @test un == nodes
        @test uw == weights
    end

    @testset "Two identical nodes with summed weights" begin
        nodes = [[0;], [0;]]
        weights = [1, 1]

        un, uw = SparseGrids.uniquenodes(nodes, weights)

        @test un == [nodes[1]]
        @test uw == [sum(weights)]
    end
end

