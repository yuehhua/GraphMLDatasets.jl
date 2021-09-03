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
    metadata


function check_precondition(::Planetoid, dataset::Symbol)
    @assert dataset in subdatasets(Planetoid) "`dataset` should be one of citeseer, cora, pubmed."
end

function check_precondition(::Entities, dataset::Symbol)
    @assert dataset in subdatasets(Entities) "`dataset` should be one of :aifb, :am, :mutag, :bgs."
end



traindata(::Dataset) = throw(ArgumentError("Training set not defined."))

function traindata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    return load(@datadep_str "Planetoid/$(dataset).train.jld2", :train_X, :train_y)
end

# traindata(cora::Cora) = load(datadep"Cora/cora.train.jld2", :graph, :train_X, :train_y)

traindata(::PPI) = load(datadep"PPI/ppi.train.jld2", :graph, :X, :y, :ids)

# function traindata(ent::Entities, dataset::Symbol)
#     check_precondition(ent, dataset)
#     return load(@datadep_str "Entities/$(dataset).train.jld2", :graph, :train_X, :train_y)
# end



train_indices(::OGBNProteins) = load(datadep"OGBN-Proteins/train.jld2", :train_indices)



validdata(::Dataset) = throw(ArgumentError("Validation set not defined."))
validdata(::PPI) = load(datadep"PPI/ppi.valid.jld2", :graph, :X, :y, :ids)



valid_indices(::OGBNProteins) = load(datadep"OGBN-Proteins/valid.jld2", :valid_indices)



testdata(::Dataset) = throw(ArgumentError("Testing set not defined."))

function testdata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    return load(@datadep_str "Planetoid/$(dataset).test.jld2", :test_X, :test_y)
end

# testdata(::Cora) = load(datadep"Cora/cora.test.jld2", :graph, :test_X, :test_y)
testdata(::PPI) = load(datadep"PPI/ppi.test.jld2", :graph, :X, :y, :ids)

# function testdata(ent::Entities, dataset::Symbol)
#     check_precondition(ent, dataset)
#     return load(@datadep_str "Entities/$(dataset).test.jld2", :graph, :test_X, :test_y)
# end



test_indices(::OGBNProteins) = load(datadep"OGBN-Proteins/test.jld2", :test_indices)



function graphdata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    return load(@datadep_str "Planetoid/$(dataset).graph.jld2", :sg)
end

graphdata(::Cora) = load(datadep"Cora/cora.graph.jld2", :sg)
graphdata(::Reddit) = load(datadep"Reddit/reddit.graph.jld2", :sg)



function alldata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    return load(@datadep_str "Planetoid/$(dataset).all.jld2", :all_X, :all_y)
end

alldata(::Cora) = load(datadep"Cora/cora.all.jld2", :all_X, :all_y)
alldata(::Reddit) = load(datadep"Reddit/reddit.all.jld2", :all_X, :all_y)



function rawdata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    return load(@datadep_str "Planetoid/$(dataset).raw.jld2", :raw)
end

rawdata(::Cora) = load(datadep"Cora/cora.raw.jld2", :raw)
rawdata(::Reddit) = load(datadep"Reddit/reddit.raw.jld2", :raw)
rawdata(::QM7b) = load(datadep"QM7b/qm7b.raw.jld2", :raw)



function metadata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    return load(@datadep_str "Planetoid/$(dataset).metadata.jld2", :meta)
end

metadata(::Cora) = load(datadep"Cora/cora.metadata.jld2", :meta)
metadata(::Reddit) = load(datadep"Reddit/reddit.metadata.jld2", :meta)
