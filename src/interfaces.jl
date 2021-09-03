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
    edge_features,
    node_labels


function check_precondition(::Planetoid, dataset::Symbol)
    @assert dataset in subdatasets(Planetoid) "`dataset` should be one of citeseer, cora, pubmed."
end

function check_precondition(::Entities, dataset::Symbol)
    @assert dataset in subdatasets(Entities) "`dataset` should be one of :aifb, :am, :mutag, :bgs."
end



traindata(::Dataset) = throw(ArgumentError("Training set not defined."))

function traindata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    filename = @datadep_str "Planetoid/$(dataset).train.jld2"
    return JLD2.load(filename, "train_X", "train_y")
end

# traindata(cora::Cora) = JLD2.load(datadep"Cora/cora.train.jld2", "graph", "train_X", "train_y")

traindata(::PPI) = JLD2.load(datadep"PPI/ppi.train.jld2", "graph", "X", "y", "ids")

# function traindata(ent::Entities, dataset::Symbol)
#     check_precondition(ent, dataset)
#     return JLD2.load(@datadep_str "Entities/$(dataset).train.jld2", "graph", "train_X", "train_y")
# end



train_indices(::OGBNProteins) = JLD2.load(datadep"OGBN-Proteins/indices.jld2", "train_indices")



validdata(::Dataset) = throw(ArgumentError("Validation set not defined."))
validdata(::PPI) = JLD2.load(datadep"PPI/ppi.valid.jld2", "graph", "X", "y", "ids")



valid_indices(::OGBNProteins) = JLD2.load(datadep"OGBN-Proteins/indices.jld2", "valid_indices")



testdata(::Dataset) = throw(ArgumentError("Testing set not defined."))

function testdata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    filename = @datadep_str "Planetoid/$(dataset).test.jld2"
    return JLD2.load(filename, "test_X", "test_y")
end

# testdata(::Cora) = load(datadep"Cora/cora.test.jld2", :graph, "test_X", "test_y")
testdata(::PPI) = JLD2.load(datadep"PPI/ppi.test.jld2", "graph", "X", "y", "ids")

# function testdata(ent::Entities, dataset::Symbol)
#     check_precondition(ent, dataset)
#     return JLD2.load(@datadep_str "Entities/$(dataset).test.jld2", "graph", "test_X", "test_y")
# end



test_indices(::OGBNProteins) = JLD2.load(datadep"OGBN-Proteins/indices.jld2", "test_indices")



function graphdata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    filename = @datadep_str "Planetoid/$(dataset).graph.jld2"
    return JLD2.load(filename, "sg")
end

graphdata(::Cora) = JLD2.load(datadep"Cora/cora.graph.jld2", "sg")
graphdata(::Reddit) = JLD2.load(datadep"Reddit/reddit.graph.jld2", "sg")
graphdata(::OGBNProteins) = JLD2.load(datadep"OGBN-Proteins/graph.jld2", "sg")



function alldata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    filename = @datadep_str "Planetoid/$(dataset).all.jld2"
    return JLD2.load(filename, "all_X", "all_y")
end

alldata(::Cora) = JLD2.load(datadep"Cora/cora.all.jld2", "all_X", "all_y")
alldata(::Reddit) = JLD2.load(datadep"Reddit/reddit.all.jld2", "all_X", "all_y")



function rawdata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    filename = @datadep_str "Planetoid/$(dataset).raw.jld2"
    return JLD2.load(filename,
        "graph", "train_X", "train_y", "test_X", "test_y", "all_X", "all_y")
end

rawdata(::Cora) = JLD2.load(datadep"Cora/cora.raw.jld2", "graph", "all_X", "all_y")
rawdata(::Reddit) = JLD2.load(datadep"Reddit/reddit.raw.jld2", "graph", "X", "y", "ids", "types")
rawdata(::QM7b) = JLD2.load(datadep"QM7b/qm7b.raw.jld2", "names", "X", "T")



function metadata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    filename = @datadep_str "Planetoid/$(dataset).metadata.jld2"
    return JLD2.load(filename, "meta")
end

metadata(::Cora) = JLD2.load(datadep"Cora/cora.metadata.jld2", "meta")
metadata(::Reddit) = JLD2.load(datadep"Reddit/reddit.metadata.jld2", "meta")



edge_features(d::Dataset) = throw(ArgumentError("No existing edge features for $d."))
edge_features(::OGBNProteins) = JLD2.load(datadep"OGBN-Proteins/edge_feat.jld2", "edge_feat")



node_labels(d::Dataset) = throw(ArgumentError("No existing node labels for $d."))
node_labels(::OGBNProteins) = JLD2.load(datadep"OGBN-Proteins/node_label.jld2", "node_label")
