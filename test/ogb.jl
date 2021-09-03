@testset "ogb" begin
    @test GraphMLDatasets.num_tasks(OGBNProteins) == 112
    @test GraphMLDatasets.num_tasks(OGBNProducts) == 1
    @test GraphMLDatasets.num_tasks(OGBNArxiv) == 1
    @test GraphMLDatasets.num_tasks(OGBNMag) == 1
    @test GraphMLDatasets.num_tasks(OGBNPapers100M) == 1

    @test GraphMLDatasets.num_classes(OGBNProteins) == 2
    @test GraphMLDatasets.num_classes(OGBNProducts) == 47
    @test GraphMLDatasets.num_classes(OGBNArxiv) == 40
    @test GraphMLDatasets.num_classes(OGBNMag) == 349
    @test GraphMLDatasets.num_classes(OGBNPapers100M) == 172
    
    @test GraphMLDatasets.eval_metric(OGBNProteins) == "ROCAUC"
    @test GraphMLDatasets.eval_metric(OGBNProducts) == "Accuracy"
    @test GraphMLDatasets.eval_metric(OGBNArxiv) == "Accuracy"
    @test GraphMLDatasets.eval_metric(OGBNMag) == "Accuracy"
    @test GraphMLDatasets.eval_metric(OGBNPapers100M) == "Accuracy"
    
    @test GraphMLDatasets.task_type(OGBNProteins) == "binary classification"
    @test GraphMLDatasets.task_type(OGBNProducts) == "multiclass classification"
    @test GraphMLDatasets.task_type(OGBNArxiv) == "multiclass classification"
    @test GraphMLDatasets.task_type(OGBNMag) == "multiclass classification"
    @test GraphMLDatasets.task_type(OGBNPapers100M) == "multiclass classification"

    @test length(train_indices(OGBNProteins())) == 86619
    @test length(valid_indices(OGBNProteins())) == 21236
    @test length(test_indices(OGBNProteins())) == 24679

    graph = graphdata(OGBNProteins())
    @test graph isa SimpleGraph{Int32}
    @test nv(graph) == 132534
    @test ne(graph) == 39561252

    ef = edge_features(OGBNProteins())
    @test ef isa Matrix{Float32}
    @test size(ef) == (ne(graph), 8)

    nl = node_labels(OGBNProteins())
    @test nl isa Matrix{UInt16}
    @test size(nl) == (nv(graph), GraphMLDatasets.num_tasks(OGBNProteins))
end
