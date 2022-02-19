export
    traindata,
    train_indices,
    validdata,
    valid_indices,
    testdata,
    test_indices,
    graphdata,
    rawdata,
    alldata,
    metadata,
    node_features,
    edge_features,
    node_labels


function check_precondition(::Planetoid, dataset::Symbol)
    @assert dataset in subdatasets(Planetoid) "`dataset` should be one of citeseer, cora, pubmed."
end

function check_precondition(::Entities, dataset::Symbol)
    @assert dataset in subdatasets(Entities) "`dataset` should be one of :aifb, :am, :mutag, :bgs."
end


"""
    traindata(dataset)

Returns training data for `dataset`.
"""
traindata(::Dataset) = throw(ArgumentError("Training set not defined."))

function traindata(pla::Planetoid, dataset::Symbol; padding::Bool=false)
    check_precondition(pla, dataset)
    filename = @datadep_str "Planetoid/$(dataset).train.jld2"
    X, y = JLD2.load(filename, "train_X", "train_y")
    
    if padding
        T = eltype(X)
        idx = train_indices(pla, dataset)
        padded_X = zeros(T, size(X, 1), nv(pla, dataset))
        padded_y = zeros(T, size(y, 1), nv(pla, dataset))
        padded_X[:, idx] .= X
        padded_y[:, idx] .= y
        return padded_X, padded_y
    else
        return X, y
    end
end

# traindata(cora::Cora) = JLD2.load(datadep"Cora/cora.train.jld2", "graph", "train_X", "train_y")

traindata(::PPI) = JLD2.load(datadep"PPI/ppi.train.jld2", "graph", "X", "y", "ids")

# function traindata(ent::Entities, dataset::Symbol)
#     check_precondition(ent, dataset)
#     return JLD2.load(@datadep_str "Entities/$(dataset).train.jld2", "graph", "train_X", "train_y")
# end


"""
    train_indices(dataset)

Returns indices of training data for `dataset`.
"""
function train_indices(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    if dataset == :cora
        return 1:140
    elseif dataset == :citeseer
        return 1:120
    else  # pubmed
        return 1:60
    end
end

train_indices(::OGBNProteins) = JLD2.load(datadep"OGBN-Proteins/indices.jld2", "train_indices")
train_indices(::OGBNProducts) = JLD2.load(datadep"OGBN-Products/indices.jld2", "train_indices")
train_indices(::OGBNArxiv) = JLD2.load(datadep"OGBN-Arxiv/indices.jld2", "train_indices")
# train_indices(::OGBNMag) = JLD2.load(datadep"OGBN-Mag/indices.jld2", "train_indices")


"""
    validdata(dataset)

Returns validation data for `dataset`.
"""
validdata(::Dataset) = throw(ArgumentError("Validation set not defined."))
validdata(::PPI) = JLD2.load(datadep"PPI/ppi.valid.jld2", "graph", "X", "y", "ids")


"""
    valid_indices(dataset)

Returns indices of validation data for `dataset`.
"""
function valid_indices(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    if dataset == :cora
        return 141:640
    elseif dataset == :citeseer
        return 121:520
    else  # pubmed
        return 61:560
    end
end

valid_indices(::OGBNProteins) = JLD2.load(datadep"OGBN-Proteins/indices.jld2", "valid_indices")
valid_indices(::OGBNProducts) = JLD2.load(datadep"OGBN-Products/indices.jld2", "valid_indices")
valid_indices(::OGBNArxiv) = JLD2.load(datadep"OGBN-Arxiv/indices.jld2", "valid_indices")
# valid_indices(::OGBNMag) = JLD2.load(datadep"OGBN-Mag/indices.jld2", "train_indices")


"""
    testdata(dataset)

Returns testing data for `dataset`.
"""
testdata(::Dataset) = throw(ArgumentError("Testing set not defined."))

function testdata(pla::Planetoid, dataset::Symbol; padding::Bool=false)
    check_precondition(pla, dataset)
    filename = @datadep_str "Planetoid/$(dataset).test.jld2"
    X, y = JLD2.load(filename, "test_X", "test_y")

    if padding
        T = eltype(X)
        idx = test_indices(pla, dataset)
        padded_X = zeros(T, size(X, 1), nv(pla, dataset))
        padded_y = zeros(T, size(y, 1), nv(pla, dataset))
        padded_X[:, idx] .= X
        padded_y[:, idx] .= y
        return padded_X, padded_y
    else
        return X, y
    end
end

# testdata(::Cora) = load(datadep"Cora/cora.test.jld2", :graph, "test_X", "test_y")
testdata(::PPI) = JLD2.load(datadep"PPI/ppi.test.jld2", "graph", "X", "y", "ids")

# function testdata(ent::Entities, dataset::Symbol)
#     check_precondition(ent, dataset)
#     return JLD2.load(@datadep_str "Entities/$(dataset).test.jld2", "graph", "test_X", "test_y")
# end


"""
    test_indices(dataset)

Returns indices of testing data for `dataset`.
"""
function test_indices(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    filename = @datadep_str "Planetoid/$(dataset).indices.jld2"
    return JLD2.load(filename, "test_indices")
end

test_indices(::OGBNProteins) = JLD2.load(datadep"OGBN-Proteins/indices.jld2", "test_indices")
test_indices(::OGBNProducts) = JLD2.load(datadep"OGBN-Products/indices.jld2", "test_indices")
test_indices(::OGBNArxiv) = JLD2.load(datadep"OGBN-Arxiv/indices.jld2", "test_indices")
# test_indices(::OGBNMag) = JLD2.load(datadep"OGBN-Mag/indices.jld2", "train_indices")


"""
    graphdata(dataset)

Returns graph for `dataset` in the form of JuliaGraphs objects.
"""
function graphdata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    filename = @datadep_str "Planetoid/$(dataset).graph.jld2"
    return JLD2.load(filename, "sg")
end

graphdata(::Cora) = JLD2.load(datadep"Cora/cora.graph.jld2", "sg")
graphdata(::Reddit) = JLD2.load(datadep"Reddit/reddit.graph.jld2", "sg")
graphdata(::OGBNProteins) = JLD2.load(datadep"OGBN-Proteins/graph.jld2", "sg")
graphdata(::OGBNProducts) = JLD2.load(datadep"OGBN-Products/graph.jld2", "sg")
graphdata(::OGBNArxiv) = JLD2.load(datadep"OGBN-Arxiv/graph.jld2", "sg")
# graphdata(::OGBNMag) = JLD2.load(datadep"OGBN-Mag/graph.jld2", "g")

function Graphs.nv(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    if dataset == :cora
        return 2708
    elseif dataset == :citeseer
        return 3312
    else  # pubmed
        return 19717
    end
end


"""
    alldata(dataset)

Returns the whole dataset for `dataset`.
"""
function alldata(pla::Planetoid, dataset::Symbol; padding::Bool=false)
    check_precondition(pla, dataset)
    filename = @datadep_str "Planetoid/$(dataset).all.jld2"
    X, y = JLD2.load(filename, "all_X", "all_y")
    
    if padding
        T = eltype(X)
        idx = 1:size(X, 2)
        padded_X = zeros(T, size(X, 1), nv(pla, dataset))
        padded_y = zeros(T, size(y, 1), nv(pla, dataset))
        padded_X[:, idx] .= X
        padded_y[:, idx] .= y
        return padded_X, padded_y
    else
        return X, y
    end
end

alldata(::Cora) = JLD2.load(datadep"Cora/cora.all.jld2", "all_X", "all_y")
alldata(::Reddit) = JLD2.load(datadep"Reddit/reddit.all.jld2", "all_X", "all_y")


"""
    rawdata(dataset)

Returns the raw data for `dataset`.
"""
function rawdata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    filename = @datadep_str "Planetoid/$(dataset).raw.jld2"
    return JLD2.load(filename,
        "graph", "train_X", "train_y", "test_X", "test_y", "all_X", "all_y")
end

rawdata(::Cora) = JLD2.load(datadep"Cora/cora.raw.jld2", "graph", "all_X", "all_y")
rawdata(::Reddit) = JLD2.load(datadep"Reddit/reddit.raw.jld2", "graph", "X", "y", "ids", "types")
rawdata(::QM7b) = JLD2.load(datadep"QM7b/qm7b.raw.jld2", "names", "X", "T")


"""
    metadata(dataset)

Returns the auxiliary data about `dataset`.
"""
function metadata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    filename = @datadep_str "Planetoid/$(dataset).metadata.jld2"
    return JLD2.load(filename, "meta")
end

metadata(::Cora) = JLD2.load(datadep"Cora/cora.metadata.jld2", "meta")
metadata(::Reddit) = JLD2.load(datadep"Reddit/reddit.metadata.jld2", "meta")


"""
    edge_features(dataset)

Returns all the edge features for `dataset`.
"""
edge_features(d::Dataset) = throw(ArgumentError("No existing edge features for $d."))
edge_features(::OGBNProteins) = JLD2.load(datadep"OGBN-Proteins/edge_feat.jld2", "edge_feat")


"""
    node_features(dataset)

Returns all the node features for `dataset`.
"""
node_features(d::Dataset) = throw(ArgumentError("No existing node features for $d."))
node_features(::OGBNProducts) = JLD2.load(datadep"OGBN-Products/node_feat.jld2", "node_feat")
node_features(::OGBNArxiv) = JLD2.load(datadep"OGBN-Arxiv/node_feat.jld2", "node_feat")
# node_features(::OGBNMag) = JLD2.load(datadep"OGBN-Mag/node_feat.jld2", "node_feat")


"""
    node_labels(dataset)

Returns all the node labels for `dataset`.
"""
node_labels(d::Dataset) = throw(ArgumentError("No existing node labels for $d."))
node_labels(::OGBNProteins) = JLD2.load(datadep"OGBN-Proteins/node_label.jld2", "node_label")
node_labels(::OGBNProducts) = JLD2.load(datadep"OGBN-Products/node_label.jld2", "node_label")
node_labels(::OGBNArxiv) = JLD2.load(datadep"OGBN-Arxiv/node_label.jld2", "node_label")
# node_labels(::OGBNMag) = JLD2.load(datadep"OGBN-Mag/node_label.jld2", "node_label")
