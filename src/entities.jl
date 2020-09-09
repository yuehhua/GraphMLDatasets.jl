entities_init() = register(DataDep(
    "Entities",
    """
    The relational entities networks "AIFB", "MUTAG", "BGS" and "AM" from
    the `"Modeling Relational Data with Graph Convolutional Networks"
    <https://arxiv.org/abs/1703.06103>`_ paper.
    Training and test splits are given by node indices.
    """,
    "https://s3.us-east-2.amazonaws.com/dgl.ai/dataset/{}.tgz",
    "";
    post_fetch_method=preprocess_entities,
))

function preprocess_entities(local_path)
    for dataset in PLANETOID_DATASETS
        graph_file = @datadep_str "Entities/ind.$(dataset).graph"
        trainX_file = @datadep_str "Entities/ind.$(dataset).x"
        trainy_file = @datadep_str "Entities/ind.$(dataset).y"
        testX_file = @datadep_str "Entities/ind.$(dataset).tx"
        testy_file = @datadep_str "Entities/ind.$(dataset).ty"

        train_X = read_data(trainX_file)
        train_y = read_data(trainy_file)
        test_X = read_data(testX_file)
        test_y = read_data(testy_file)
        graph = read_graph(graph_file)

        trainfile = replace(graph_file, "ind.$(dataset).graph"=>"$(dataset).train.jld2")
        testfile = replace(graph_file, "ind.$(dataset).graph"=>"$(dataset).test.jld2")
        @save trainfile graph train_X train_y
        @save testfile graph test_X test_y
    end
end

struct Entities <:Dataset
end

function traindata(ent::Entities)
    file = @datadep_str "Entities/$(pla.dataset).train.jld2"
    @load file graph train_X train_y
    graph, train_X, train_y
end

function testdata(ent::Entities)
    file = @datadep_str "Entities/$(pla.dataset).test.jld2"
    @load file graph test_X test_y
    graph, test_X, test_y
end