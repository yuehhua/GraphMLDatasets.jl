const PLANETOID_URL = "https://github.com/kimiyoung/planetoid/raw/master/data"
const PLANETOID_DATASETS = [:citeseer, :cora, :pubmed]
const EXTS = ["allx", "ally", "graph", "test.index", "tx", "ty", "x", "y"]
const DATAURLS = [joinpath(PLANETOID_URL, "ind.$(d).$(ext)") for d in PLANETOID_DATASETS, ext in EXTS]

planetoid_init() = register(DataDep(
    "Planetoid",
    """
    The citation network datasets "Cora", "CiteSeer", "PubMed" from
    "Revisiting Semi-Supervised Learning with Graph Embeddings"
    <https://arxiv.org/abs/1603.08861> paper.
    Nodes represent documents and edges represent citation links.
    """,
    reshape(DATAURLS, :),
    "f52b3d47f5993912d7509b51e8090b6807228c4ba8c7d906f946868005c61c18";
    post_fetch_method=preprocess_planetoid,
))

function preprocess_planetoid(local_path)
    for dataset in PLANETOID_DATASETS
        graph_file = @datadep_str "Planetoid/ind.$(dataset).graph"
        trainX_file = @datadep_str "Planetoid/ind.$(dataset).x"
        trainy_file = @datadep_str "Planetoid/ind.$(dataset).y"
        testX_file = @datadep_str "Planetoid/ind.$(dataset).tx"
        testy_file = @datadep_str "Planetoid/ind.$(dataset).ty"
        allX_file = @datadep_str "Planetoid/ind.$(dataset).allx"
        ally_file = @datadep_str "Planetoid/ind.$(dataset).ally"

        train_X = read_data(trainX_file)
        train_y = read_data(trainy_file)
        test_X = read_data(testX_file)
        test_y = read_data(testy_file)
        all_X = read_data(allX_file)
        all_y = read_data(ally_file)
        graph = read_graph(graph_file)

        num_V = length(graph)
        sg = to_simplegraph(graph, num_V)
        num_E = ne(sg)
        feat_dim = size(all_X, 2)
        label_dim = size(all_y, 2)
        train_X, train_y = sparse(train_X'), sparse(train_y')
        test_X, test_y = sparse(test_X'), sparse(test_y')
        all_X, all_y = sparse(all_X'), sparse(all_y')
        raw = Dict(:graph=>graph, :train_X=>train_X, :train_y=>train_y,
                   :test_X=>test_X, :test_y=>test_y, :all_X=>all_X, :all_y=>all_y)
        meta = (graph=(num_V=num_V, num_E=num_E),
                train=(features_dim=(feat_dim, size(train_X, 2)), labels_dim=(label_dim, size(train_y, 2))),
                test=(features_dim=(feat_dim, size(test_X, 2)), labels_dim=(label_dim, size(test_y, 2))),
                all=(features_dim=(feat_dim, size(all_X, 2)), labels_dim=(label_dim, size(all_y, 2)))
                )

        graphfile = replace(graph_file, "ind.$(dataset).graph"=>"$(dataset).graph.jld2")
        trainfile = replace(graph_file, "ind.$(dataset).graph"=>"$(dataset).train.jld2")
        testfile = replace(graph_file, "ind.$(dataset).graph"=>"$(dataset).test.jld2")
        allfile = replace(graph_file, "ind.$(dataset).graph"=>"$(dataset).all.jld2")
        rawfile = replace(graph_file, "ind.$(dataset).graph"=>"$(dataset).raw.jld2")
        metadatafile = replace(graph_file, "ind.$(dataset).graph"=>"$(dataset).metadata.jld2")

        @save graphfile sg
        @save trainfile train_X train_y
        @save testfile test_X test_y
        @save allfile all_X all_y
        @save rawfile raw
        @save metadatafile meta
    end
end

function read_data(filename)
    py"""
    import pickle
    from scipy.sparse import csr_matrix

    with open($filename,"rb") as f:
        u = pickle._Unpickler(f)
        u.encoding = "latin1"
        data = u.load()

    if type(data) is csr_matrix:
        data = data.toarray()
    """
    return SparseMatrixCSC(Array(py"data"))
end

read_index(filename) = map(x -> parse(Int64, x), readlines(filename))

function read_graph(filename)
    py"""
    import pickle

    with open($filename,"rb") as f:
        u = pickle._Unpickler(f)
        u.encoding = "latin1"
        data = u.load()
    """
    return Dict(py"data")
end

struct Planetoid <: Dataset
    dataset::Symbol

    function Planetoid(ds::Symbol)
        @assert ds in PLANETOID_DATASETS "`dataset` should be one of citeseer, cora, pubmed."
        new(ds)
    end
end


function graphdata(pla::Planetoid)
    file = @datadep_str "Planetoid/$(pla.dataset).graph.jld2"
    @load file sg
    sg
end

function traindata(pla::Planetoid)
    file = @datadep_str "Planetoid/$(pla.dataset).train.jld2"
    @load file train_X train_y
    train_X, train_y
end

function testdata(pla::Planetoid)
    file = @datadep_str "Planetoid/$(pla.dataset).test.jld2"
    @load file test_X test_y
    test_X, test_y
end

function alldata(pla::Planetoid)
    file = @datadep_str "Planetoid/$(pla.dataset).all.jld2"
    @load file all_X all_y
    all_X, all_y
end

function rawdata(pla::Planetoid)
    file = @datadep_str "Planetoid/$(pla.dataset).raw.jld2"
    @load file raw
    raw
end

function metadata(pla::Planetoid)
    file = @datadep_str "Planetoid/$(pla.dataset).metadata.jld2"
    @load file meta
    meta
end
