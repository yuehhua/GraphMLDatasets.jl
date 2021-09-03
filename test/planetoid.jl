@testset "planetoid" begin
    graph = graphdata(Planetoid(), :cora)
    @test typeof(graph) == SimpleGraph{UInt32}
    @test nv(graph) == 2708
    @test ne(graph) == 5275

    train_X, train_y = traindata(Planetoid(), :cora)
    @test typeof(train_X) == SparseMatrixCSC{Float32,Int64}
    @test size(train_X) == (1433, 140)
    @test typeof(train_y) == SparseMatrixCSC{Int32,Int64}
    @test size(train_y) == (7, 140)

    test_X, test_y = testdata(Planetoid(), :cora)
    @test typeof(test_X) == SparseMatrixCSC{Float32,Int64}
    @test size(test_X) == (1433, 1000)
    @test typeof(test_y) == SparseMatrixCSC{Int32,Int64}
    @test size(test_y) == (7, 1000)

    all_X, all_y = alldata(Planetoid(), :cora)
    @test typeof(all_X) == SparseMatrixCSC{Float32,Int64}
    @test size(all_X) == (1433, 1708)
    @test typeof(all_y) == SparseMatrixCSC{Int32,Int64}
    @test size(all_y) == (7, 1708)

    g, train_X, train_y, test_X, test_y, all_X, all_y = rawdata(Planetoid(), :cora)
    # @test g isa DataStructures.DefaultDict
    @test train_X isa SparseMatrixCSC{Float32,Int64}
    @test train_y isa SparseMatrixCSC{Int32,Int64}
    @test test_X isa SparseMatrixCSC{Float32,Int64}
    @test test_y isa SparseMatrixCSC{Int32,Int64}
    @test all_X isa SparseMatrixCSC{Float32,Int64}
    @test all_y isa SparseMatrixCSC{Int32,Int64}

    meta = metadata(Planetoid(), :cora)
    @test meta.graph.num_V == nv(graph)
    @test meta.graph.num_E == ne(graph)
end
