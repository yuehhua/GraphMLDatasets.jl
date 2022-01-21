@testset "ogb" begin
    @test GraphMLDatasets.num_tasks(OGBNProteins) == 112
    @test GraphMLDatasets.num_tasks(OGBNProducts) == 1
    @test GraphMLDatasets.num_tasks(OGBNArxiv) == 1
    @test_skip GraphMLDatasets.num_tasks(OGBNMag) == 1
    @test GraphMLDatasets.num_tasks(OGBNPapers100M) == 1

    @test GraphMLDatasets.num_classes(OGBNProteins) == 2
    @test GraphMLDatasets.num_classes(OGBNProducts) == 47
    @test GraphMLDatasets.num_classes(OGBNArxiv) == 40
    @test_skip GraphMLDatasets.num_classes(OGBNMag) == 349
    @test GraphMLDatasets.num_classes(OGBNPapers100M) == 172
    
    @test GraphMLDatasets.eval_metric(OGBNProteins) == "ROCAUC"
    @test GraphMLDatasets.eval_metric(OGBNProducts) == "Accuracy"
    @test GraphMLDatasets.eval_metric(OGBNArxiv) == "Accuracy"
    @test_skip GraphMLDatasets.eval_metric(OGBNMag) == "Accuracy"
    @test GraphMLDatasets.eval_metric(OGBNPapers100M) == "Accuracy"
    
    @test GraphMLDatasets.task_type(OGBNProteins) == "binary classification"
    @test GraphMLDatasets.task_type(OGBNProducts) == "multiclass classification"
    @test GraphMLDatasets.task_type(OGBNArxiv) == "multiclass classification"
    @test_skip GraphMLDatasets.task_type(OGBNMag) == "multiclass classification"
    @test GraphMLDatasets.task_type(OGBNPapers100M) == "multiclass classification"

    @testset "OGBNProteins" begin
        @test length(train_indices(OGBNProteins())) == 86619
        @test length(valid_indices(OGBNProteins())) == 21236
        @test length(test_indices(OGBNProteins())) == 24679

        graph = graphdata(OGBNProteins())
        @test graph isa SimpleGraph{Int32}
        @test nv(graph) == 132534
        @test ne(graph) == 39561252

        ef = edge_features(OGBNProteins())
        @test ef isa Matrix{Float32}
        @test size(ef) == (ne(graph), GraphMLDatasets.feature_dim(OGBNProteins, :edge))

        nl = node_labels(OGBNProteins())
        @test nl isa Matrix{UInt16}
        @test size(nl) == (nv(graph), GraphMLDatasets.num_tasks(OGBNProteins))
    end

    @testset "OGBNProducts" begin
        @test length(train_indices(OGBNProducts())) == 196615
        @test length(valid_indices(OGBNProducts())) == 39323
        @test length(test_indices(OGBNProducts())) == 2213091

        graph = graphdata(OGBNProducts())
        @test graph isa SimpleGraph{Int32}
        @test nv(graph) == 2449029
        @test ne(graph) == 61859140

        nf = node_features(OGBNProducts())
        @test nf isa Matrix{Float32}
        @test size(nf) == (nv(graph), GraphMLDatasets.feature_dim(OGBNProducts, :node))

        nl = node_labels(OGBNProducts())
        @test nl isa Matrix{UInt16}
        @test size(nl) == (nv(graph), GraphMLDatasets.num_tasks(OGBNProducts))
    end

    @testset "OGBNArxiv" begin
        @test length(train_indices(OGBNArxiv())) == 90941
        @test length(valid_indices(OGBNArxiv())) == 29799
        @test length(test_indices(OGBNArxiv())) == 48603

        graph = graphdata(OGBNArxiv())
        @test graph isa SimpleDiGraph{Int32}
        @test nv(graph) == 169343
        @test ne(graph) == 1166243

        nf = node_features(OGBNArxiv())
        @test nf isa Matrix{Float32}
        @test size(nf) == (nv(graph), GraphMLDatasets.feature_dim(OGBNArxiv, :node))

        nl = node_labels(OGBNArxiv())
        @test nl isa Matrix{UInt16}
        @test size(nl) == (nv(graph), GraphMLDatasets.num_tasks(OGBNArxiv))
    end

    @testset "OGBNMag" begin
        @test_skip length(train_indices(OGBNMag())) == 629571
        @test_skip length(valid_indices(OGBNMag())) == 64879
        @test_skip length(test_indices(OGBNMag())) == 41939

        # graph = graphdata(OGBNMag())
        @test_skip graph isa MetaDiGraph{Int32}
        @test_skip nv(graph) == 1939743
        @test_skip ne(graph) == 21111007

        # nf = node_features(OGBNMag())
        @test_skip nf isa Matrix{Float32}
        @test_skip size(nf) == (nv(graph), GraphMLDatasets.feature_dim(OGBNMag, :node))

        # nl = node_labels(OGBNMag())
        @test_skip nl isa Matrix{UInt16}
        @test_skip size(nl) == (nv(graph), GraphMLDatasets.num_tasks(OGBNMag))
    end

    @testset "OGBNPapers100M" begin

    end

    @testset "OGBLCollab" begin
        graph = graphdata(OGBLCollab())
        @test graph isa SimpleGraph{Int32}
        @test nv(graph) == 235868
        @test ne(graph) == 967632

        nf = node_features(OGBLCollab())
        @test nf isa Matrix{Float32}
        @test size(nf) == (nv(graph), GraphMLDatasets.feature_dim(OGBLCollab, :node))
    end
end
