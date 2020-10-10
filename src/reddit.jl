reddit_init() = register(DataDep(
    "Reddit",
    """
    The Reddit dataset from the `"Inductive Representation Learning on
    Large Graphs" <https://arxiv.org/abs/1706.02216>`_ paper, containing
    Reddit posts belonging to different communities.
    """,
    "https://data.dgl.ai/dataset/reddit.zip",
    "9a16353c28f8ddd07148fc5ac9b57b818d7911ea0fbe9052d66d49fc32b372bf";
    post_fetch_method=preprocess_reddit,
))

function preprocess_reddit(local_path)
    unzip_zip(local_path)

    graph_file = datadep"Reddit/reddit_graph.npz"
    data_file = datadep"Reddit/reddit_data.npz"

    py"""
    import numpy as np
    import scipy.sparse as sp
    graph = np.load($graph_file, allow_pickle=True)
    data = np.load($data_file, allow_pickle=True)
    """

    graph = sparse(Vector(py"graph['row']") .+ 1,
                   Vector(py"graph['col']") .+ 1,
                   Vector{Int32}(py"graph['data']"))
    X = Matrix{Float32}(py"data['feature']")
    y = Vector{Int32}(py"data['label']")
    ids = Vector{Int32}(py"data['node_ids']")
    types = Vector{Int32}(py"data['node_types']")
    raw = Dict(:graph=>graph, :X=>X, :y=>y, :ids=>ids, :types=>types)

    sg = to_simplegraph(graph)
    all_X = Matrix(X')
    all_y = Matrix{UInt16}(y')
    meta = (graph=(num_V=nv(sg), num_E=ne(sg)),
            all=(features_dim=size(all_X), labels_dim=size(all_y))
            )

    graphfile = replace(local_path, "reddit.zip"=>"reddit.graph.jld2")
    allfile = replace(local_path, "reddit.zip"=>"reddit.all.jld2")
    rawfile = replace(local_path, "reddit.zip"=>"reddit.raw.jld2")
    metadatafile = replace(local_path, "reddit.zip"=>"reddit.metadata.jld2")

    @save graphfile sg
    @save allfile all_X all_y
    @save rawfile raw
    @save metadatafile meta
end

struct Reddit <: Dataset
end

function graphdata(::Reddit)
    file = datadep"Reddit/reddit.graph.jld2"
    @load file sg
    sg
end

function alldata(::Reddit)
    file = datadep"Reddit/reddit.all.jld2"
    @load file all_X all_y
    all_X, all_y
end

function rawdata(::Reddit)
    file = datadep"Reddit/reddit.raw.jld2"
    @load file raw
    raw
end

function metadata(::Reddit)
    file = datadep"Reddit/reddit.metadata.jld2"
    @load file meta
    meta
end
