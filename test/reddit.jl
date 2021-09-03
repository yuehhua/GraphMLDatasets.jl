@testset "reddit" begin
    graph = graphdata(Reddit())
    @test typeof(graph) == SimpleGraph{UInt32}
    @test nv(graph) == 232965
    @test ne(graph) == 57307946

    all_X, all_y = alldata(Reddit())
    @test typeof(all_X) == Matrix{Float32}
    @test size(all_X) == (602, 232965)
    @test typeof(all_y) == Matrix{UInt16}
    @test size(all_y) == (1, 232965)

    g, X, y, ids, types = rawdata(Reddit())
    @test g isa SparseMatrixCSC{Int64,Int64}
    @test X isa Matrix{Float32}
    @test y isa Vector{Int32}
    @test ids isa Vector{Int32}
    @test types isa Vector{UInt8}

    meta = metadata(Reddit())
    @test meta.graph.num_V == nv(graph)
    @test meta.graph.num_E == ne(graph)
end
