# Dataset metadata

num_tasks(::Type{OGBNProteins}) = 112
num_tasks(::Type{OGBNProducts}) = 1
num_tasks(::Type{OGBNArxiv}) = 1
# num_tasks(::Type{OGBNMag}) = 1
num_tasks(::Type{OGBNPapers100M}) = 1

num_classes(::Type{OGBNProteins}) = 2
num_classes(::Type{OGBNProducts}) = 47
num_classes(::Type{OGBNArxiv}) = 40
# num_classes(::Type{OGBNMag}) = 349
num_classes(::Type{OGBNPapers100M}) = 172

eval_metric(::Type{OGBNProteins}) = "ROCAUC"
eval_metric(::Type{OGBNProducts}) = "Accuracy"
eval_metric(::Type{OGBNArxiv}) = "Accuracy"
# eval_metric(::Type{OGBNMag}) = "Accuracy"
eval_metric(::Type{OGBNPapers100M}) = "Accuracy"
eval_metric(::Type{OGBLPPA}) = "hits@100"
eval_metric(::Type{OGBLCollab}) = "hits@50"
eval_metric(::Type{OGBLDDI}) = "hits@20"
eval_metric(::Type{OGBLCitation2}) = "mrr"
eval_metric(::Type{OGBLWikiKG2}) = "mrr"
eval_metric(::Type{OGBLBioKG}) = "	mrr"

task_type(::Type{OGBNProteins}) = "binary classification"
task_type(::Type{OGBNProducts}) = "multiclass classification"
task_type(::Type{OGBNArxiv}) = "multiclass classification"
# task_type(::Type{OGBNMag}) = "multiclass classification"
task_type(::Type{OGBNPapers100M}) = "multiclass classification"
task_type(::Type{OGBLPPA}) = "link prediction"
task_type(::Type{OGBLCollab}) = "link prediction"
task_type(::Type{OGBLDDI}) = "link prediction"
task_type(::Type{OGBLCitation2}) = "link prediction"
task_type(::Type{OGBLWikiKG2}) = "KG completion"
task_type(::Type{OGBLBioKG}) = "KG completion"

feature_dim(dataset::Type{<:OGBDataset}, kind::Symbol) = feature_dim(dataset, Val(kind))
feature_dim(dataset::Type{<:OGBDataset}, ::Val{<:Any}) = throw(ArgumentError("not existing such kind of feature dim."))
feature_dim(::Type{OGBNProteins}, ::Val{:edge}) = 8
feature_dim(::Type{OGBNProducts}, ::Val{:node}) = 100
feature_dim(::Type{OGBNArxiv}, ::Val{:node}) = 128
# feature_dim(::Type{OGBNMag}, ::Val{:node}) = 128
feature_dim(::Type{OGBLCollab}, ::Val{:node}) = 128

split_prefix(::Type{OGBNProteins}) = "species"
split_prefix(::Type{OGBNProducts}) = "sales_ranking"
split_prefix(::Type{OGBNArxiv}) = "time"
# split_prefix(::Type{OGBNMag}) = "time/paper"
split_prefix(::Type{OGBNPapers100M}) = "time"
split_prefix(::Type{OGBLPPA}) = "throughput"
split_prefix(::Type{OGBLCollab}) = "time"
split_prefix(::Type{OGBLDDI}) = "target"
split_prefix(::Type{OGBLCitation2}) = "time"
split_prefix(::Type{OGBLWikiKG2}) = "time"
split_prefix(::Type{OGBLBioKG}) = "random"


# read indices

function read_indices(obg::Type{<:OGBDataset}, reader, dir::String)
    prefix = joinpath(dir, "split", split_prefix(obg))
    train_indices = read_train_indices(reader, prefix)
    valid_indices = read_valid_indices(reader, prefix)
    test_indices = read_test_indices(reader, prefix)
    return train_indices, valid_indices, test_indices
end

function read_train_indices(reader, dir::String)
    prefix = joinpath(dir, "train")
    file = filter(x -> startswith(x.name, prefix), reader.files)[1]
    if endswith(file.name, "csv.gz")
        df = read_csv_gz(file, [:index])
        df.index .+= 1
        return df.index
    elseif endswith(file.name, "pt")
        return read_torch_pickle(file)
    end
end

function read_valid_indices(reader, dir::String)
    prefix = joinpath(dir, "valid")
    file = filter(x -> startswith(x.name, prefix), reader.files)[1]
    if endswith(file.name, "csv.gz")
        df = read_csv_gz(file, [:index])
        df.index .+= 1
        return df.index
    elseif endswith(file.name, "pt")
        return read_torch_pickle(file)
    end
end

function read_test_indices(reader, dir::String)
    prefix = joinpath(dir, "test")
    file = filter(x -> startswith(x.name, prefix), reader.files)[1]
    if endswith(file.name, "csv.gz")
        df = read_csv_gz(file, [:index])
        df.index .+= 1
        return df.index
    elseif endswith(file.name, "pt")
        return read_torch_pickle(file)
    end
end


# read graph and metadata

function read_graph(reader, dir::String)
    V = read_num_node(reader, dir)
    E = read_num_edge(reader, dir)
    edges = read_edges(reader, dir)
    return V, E, edges
end

function read_weighted_graph(reader, dir::String)
    V = read_num_node(reader, dir)
    E = read_num_edge(reader, dir)
    edges = read_edges(reader, dir)
    weights = read_edge_weights(reader, dir)
    edges = hcat(edges, weights)
    return V, E, edges
end

function read_num_node(reader, dir::String)
    filename = joinpath(dir, "num-node-list.csv.gz")
    df = read_zipfile(reader, filename, [:number])
    return df.number[1]
end

function read_num_edge(reader, dir::String)
    filename = joinpath(dir, "num-edge-list.csv.gz")
    df = read_zipfile(reader, filename, [:number])
    return df.number[1]
end

function read_edges(reader, dir::String)
    filename = joinpath(dir, "edge.csv.gz")
    df = read_zipfile(reader, filename, [:node1, :node2])
    df.node1 .+= 1
    df.node2 .+= 1
    return df
end

function read_edge_weights(reader, dir::String)
    filename = joinpath(dir, "edge_weight.csv.gz")
    df = read_zipfile(reader, filename, [:weight])
    return df
end

function read_node_year(reader, dir::String)
    filename = joinpath(dir, "node_year.csv.gz")
    df = read_zipfile(reader, filename, [:year])
    return df.year[1]
end

# function read_heterogeneous_graph(reader, dir::String)
#     Ns = read_num_node_dict(reader, dir)
#     g = MetaDiGraph{Int32,Float32}(sum(values(Ns)))

#     offset = calculate_offset(Ns)
#     set_node_prop!(g, Ns, offset)

#     # add edges and props for heterogeneous graphs
#     triplets = read_triplets(reader, dir)
#     for trip in triplets
#         relation = triplet_to_dir(trip)
#         dir2 = joinpath(dir, "relations", relation)
#         E = read_num_edge(reader, dir2)
#         reltype = read_edge_reltype(reader, dir2)
#         edges = read_edges(reader, dir2)
#         for i in 1:E
#             src = edges.node1[i] + offset[trip.src]
#             dst = edges.node2[i] + offset[trip.dst]
#             props = Dict(:reltype => reltype[i], :relation => trip.relation)
#             add_edge!(g, src, dst, props)
#         end
#     end
#     return g
# end

# function read_triplets(reader, dir::String)
#     filename = joinpath(dir, "triplet-type-list.csv.gz")
#     header = [:src, :relation, :dst]
#     df = read_zipfile(reader, filename, header)
#     triplets = [(src=r.src, relation=r.relation, dst=r.dst) for r in eachrow(df)]
#     return triplets
# end

# triplet_to_dir(trip::NamedTuple) = "$(trip.src)___$(trip.relation)___$(trip.dst)"

# function read_num_node_dict(reader, dir::String)
#     filename = joinpath(dir, "num-node-dict.csv.gz")
#     header = 1
#     df = read_zipfile(reader, filename, header)
#     return OrderedDict(n => df[1,n] for n in names(df))
# end

# function read_edge_reltype(reader, dir::String)
#     filename = joinpath(dir, "edge_reltype.csv.gz")
#     header = [:reltype]
#     df = read_zipfile(reader, filename, header)
#     return df.reltype
# end

# function calculate_offset(d::OrderedDict)
#     acc = 0
#     offset = OrderedDict{String,Int32}()
#     for (ent, n) in d
#         offset[ent] = acc
#         acc += n
#     end
#     return offset
# end

# function set_node_prop!(g::MetaDiGraph, Ns, offset)
#     for (ent, n) in Ns
#         ofs = offset[ent]
#         for i in 1:n
#             node = i + ofs
#             set_prop!(g, node, :entity, ent)
#         end
#     end
#     return g
# end


# read features and labels

function read_labels(dataset::Type{<:OGBDataset}, reader, dir::String, csv_prefix::String)
    filename = joinpath(dir, csv_prefix * "-label.csv.gz")
    header = false
    df = read_zipfile(reader, filename, header)
    return Matrix{UInt16}(df)
end

function read_features(dataset::Type{<:OGBDataset}, reader, dir::String, csv_prefix::String)
    filename = joinpath(dir, csv_prefix * "-feat.csv.gz")
    header = false
    df = read_zipfile(reader, filename, header)
    return Matrix{Float32}(df)
end
