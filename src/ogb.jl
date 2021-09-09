# Dataset metadata

num_tasks(::Type{OGBNProteins}) = 112
num_tasks(::Type{OGBNProducts}) = 1
num_tasks(::Type{OGBNArxiv}) = 1
num_tasks(::Type{OGBNMag}) = 1
num_tasks(::Type{OGBNPapers100M}) = 1

num_classes(::Type{OGBNProteins}) = 2
num_classes(::Type{OGBNProducts}) = 47
num_classes(::Type{OGBNArxiv}) = 40
num_classes(::Type{OGBNMag}) = 349
num_classes(::Type{OGBNPapers100M}) = 172

eval_metric(::Type{OGBNProteins}) = "ROCAUC"
eval_metric(::Type{OGBNProducts}) = "Accuracy"
eval_metric(::Type{OGBNArxiv}) = "Accuracy"
eval_metric(::Type{OGBNMag}) = "Accuracy"
eval_metric(::Type{OGBNPapers100M}) = "Accuracy"

task_type(::Type{OGBNProteins}) = "binary classification"
task_type(::Type{OGBNProducts}) = "multiclass classification"
task_type(::Type{OGBNArxiv}) = "multiclass classification"
task_type(::Type{OGBNMag}) = "multiclass classification"
task_type(::Type{OGBNPapers100M}) = "multiclass classification"

feature_dim(dataset::Type{<:OGBDataset}, kind::Symbol) = feature_dim(dataset, Val(kind))
feature_dim(dataset::Type{<:OGBDataset}, ::Val{<:Any}) = throw(ArgumentError("not existing such kind of feature dim."))
feature_dim(::Type{OGBNProteins}, ::Val{:edge}) = 8

split_prefix(::Type{OGBNProteins}) = "species"
split_prefix(::Type{OGBNProducts}) = "sales_ranking"
split_prefix(::Type{OGBNArxiv}) = "time"
split_prefix(::Type{OGBNMag}) = "time"
split_prefix(::Type{OGBNPapers100M}) = "time"

# read indices

function read_indices(obg::Type{<:OGBDataset}, reader, dir::String)
    prefix = joinpath(dir, "split", split_prefix(obg))
    train_indices = read_train_indices(reader, prefix)
    valid_indices = read_valid_indices(reader, prefix)
    test_indices = read_test_indices(reader, prefix)
    return train_indices, valid_indices, test_indices
end

function read_train_indices(reader, dir::String)
    filename = joinpath(dir, "train.csv.gz")
    header = [:index]
    df = read_zipfile(reader, filename, header)
    df.index .+= 1
    return df.index
end

function read_valid_indices(reader, dir::String)
    filename = joinpath(dir, "valid.csv.gz")
    header = [:index]
    df = read_zipfile(reader, filename, header)
    df.index .+= 1
    return df.index
end

function read_test_indices(reader, dir::String)
    filename = joinpath(dir, "test.csv.gz")
    header = [:index]
    df = read_zipfile(reader, filename, header)
    df.index .+= 1
    return df.index
end


# read graph and metadata

function read_graph(reader, dir::String)
    V = read_num_node(reader, dir)
    E = read_num_edge(reader, dir)
    edges = read_edges(reader, dir)
    return V, E, edges
end

function read_num_node(reader, dir::String)
    filename = joinpath(dir, "num-node-list.csv.gz")
    header = [:number]
    df = read_zipfile(reader, filename, header)
    return df.number[1]
end

function read_num_edge(reader, dir::String)
    filename = joinpath(dir, "num-edge-list.csv.gz")
    header = [:number]
    df = read_zipfile(reader, filename, header)
    return df.number[1]
end

function read_edges(reader, dir::String)
    filename = joinpath(dir, "edge.csv.gz")
    header = [:node1, :node2]
    df = read_zipfile(reader, filename, header)
    df.node1 .+= 1
    df.node2 .+= 1
    return df
end


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
