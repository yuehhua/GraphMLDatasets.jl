@testset "cora" begin
    graph = graphdata(Cora())
    @test typeof(graph) == SimpleDiGraph{UInt32}
    @test nv(graph) == 19793
    @test ne(graph) == 65311

    all_X, all_y = alldata(Cora())
    @test typeof(all_X) == SparseMatrixCSC{Float32,Int64}
    @test size(all_X) == (8710, 19793)
    @test typeof(all_y) == Matrix{UInt16}
    @test size(all_y) == (1, 19793)

    raw = rawdata(Cora())
    @test typeof(raw[:graph]) == SparseMatrixCSC{Float32,Int64}
    @test typeof(raw[:all_X]) == SparseMatrixCSC{Float32,Int64}
    @test typeof(raw[:all_y]) == Vector{Int64}

    meta = metadata(Cora())
    @test meta.graph.num_V == nv(graph)
    @test meta.graph.num_E == ne(graph)
end
