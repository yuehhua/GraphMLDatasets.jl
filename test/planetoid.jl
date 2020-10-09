@testset "planetoid" begin
    graph = graphdata(Planetoid(:cora))
    @test typeof(graph) == SimpleGraph{Int64}
    @test nv(graph) == 2708
    @test ne(graph) == 5275

    train_X, train_y = traindata(Planetoid(:cora))
    @test typeof(train_X) == SparseMatrixCSC{Float32,Int64}
    @test size(train_X) == (1433, 140)
    @test typeof(train_y) == SparseMatrixCSC{Int32,Int64}
    @test size(train_y) == (7, 140)

    test_X, test_y = testdata(Planetoid(:cora))
    @test typeof(test_X) == SparseMatrixCSC{Float32,Int64}
    @test size(test_X) == (1433, 1000)
    @test typeof(test_y) == SparseMatrixCSC{Int32,Int64}
    @test size(test_y) == (7, 1000)

    all_X, all_y = alldata(Planetoid(:cora))
    @test typeof(all_X) == SparseMatrixCSC{Float32,Int64}
    @test size(all_X) == (1433, 1708)
    @test typeof(all_y) == SparseMatrixCSC{Int32,Int64}
    @test size(all_y) == (7, 1708)

    raw = rawdata(Planetoid(:cora))
    @test typeof(raw[:graph]) == Dict{Any,Any}
    @test typeof(raw[:train_X]) == SparseMatrixCSC{Float32,Int64}
    @test typeof(raw[:train_y]) == SparseMatrixCSC{Int32,Int64}
    @test typeof(raw[:test_X]) == SparseMatrixCSC{Float32,Int64}
    @test typeof(raw[:test_y]) == SparseMatrixCSC{Int32,Int64}
    @test typeof(raw[:all_X]) == SparseMatrixCSC{Float32,Int64}
    @test typeof(raw[:all_y]) == SparseMatrixCSC{Int32,Int64}

    meta = metadata(Planetoid(:cora))
    @test meta.graph.num_V == nv(graph)
    @test meta.graph.num_E == ne(graph)
end
