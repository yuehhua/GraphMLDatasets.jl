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

    raw = rawdata(Reddit())
    @test typeof(raw[:graph]) == SparseMatrixCSC{Int32,Int64}
    @test typeof(raw[:X]) == Matrix{Float32}
    @test typeof(raw[:y]) == Vector{Int32}
    @test typeof(raw[:ids]) == Vector{Int32}
    @test typeof(raw[:types]) == Vector{UInt8}

    meta = metadata(Reddit())
    @test meta.graph.num_V == nv(graph)
    @test meta.graph.num_E == ne(graph)
end
