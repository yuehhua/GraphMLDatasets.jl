function check_precondition(::Planetoid, dataset::Symbol)
    @assert dataset in subdatasets(Planetoid) "`dataset` should be one of citeseer, cora, pubmed."
end

function check_precondition(::Entities, dataset::Symbol)
    @assert dataset in subdatasets(Entities) "`dataset` should be one of :aifb, :am, :mutag, :bgs."
end



traindata(::Dataset) = throw(ArgumentError("Undefined dataset."))

function traindata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    file = @datadep_str "Planetoid/$(dataset).train.jld2"
    @load file train_X train_y
    train_X, train_y
end

# function traindata(cora::Cora)
#     file = datadep"Cora/cora.train.jld2"
#     @load file graph train_X train_y
#     graph, train_X, train_y
# end

function traindata(::PPI)
    file = datadep"PPI/ppi.train.jld2"
    @load file graph X y ids
    graph, X, y, ids
end

# function traindata(ent::Entities, dataset::Symbol)
#     check_precondition(ent, dataset)
#     file = @datadep_str "Entities/$(dataset).train.jld2"
#     @load file graph train_X train_y
#     graph, train_X, train_y
# end



validdata(::Dataset) = throw(ArgumentError("Undefined dataset."))

function validdata(::PPI)
    file = datadep"PPI/ppi.valid.jld2"
    @load file graph X y ids
    graph, X, y, ids
end



testdata(::Dataset) = throw(ArgumentError("Undefined dataset."))

function testdata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    file = @datadep_str "Planetoid/$(dataset).test.jld2"
    @load file test_X test_y
    test_X, test_y
end

# function testdata(dataset::Symbol)
#     file = datadep"Cora/cora.test.jld2"
#     @load file graph test_X test_y
#     graph, test_X, test_y
# end

function testdata(::PPI)
    file = datadep"PPI/ppi.test.jld2"
    @load file graph X y ids
    graph, X, y, ids
end

# function testdata(ent::Entities, dataset::Symbol)
#     check_precondition(ent, dataset)
#     file = @datadep_str "Entities/$(dataset).test.jld2"
#     @load file graph test_X test_y
#     graph, test_X, test_y
# end



function graphdata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    file = @datadep_str "Planetoid/$(dataset).graph.jld2"
    @load file sg
    sg
end

function graphdata(cora::Cora)
    file = datadep"Cora/cora.graph.jld2"
    @load file sg
    sg
end

function graphdata(::Reddit)
    file = datadep"Reddit/reddit.graph.jld2"
    @load file sg
    sg
end



function alldata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    file = @datadep_str "Planetoid/$(dataset).all.jld2"
    @load file all_X all_y
    all_X, all_y
end

function alldata(cora::Cora)
    file = datadep"Cora/cora.all.jld2"
    @load file all_X all_y
    all_X, all_y
end

function alldata(::Reddit)
    file = datadep"Reddit/reddit.all.jld2"
    @load file all_X all_y
    all_X, all_y
end



function rawdata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    file = @datadep_str "Planetoid/$(dataset).raw.jld2"
    @load file raw
    raw
end

function rawdata(cora::Cora)
    file = datadep"Cora/cora.raw.jld2"
    @load file raw
    raw
end

function rawdata(::Reddit)
    file = datadep"Reddit/reddit.raw.jld2"
    @load file raw
    raw
end

function rawdata(::QM7b)
    file = datadep"QM7b/qm7b.raw.jld2"
    @load file raw
    raw
end



function metadata(pla::Planetoid, dataset::Symbol)
    check_precondition(pla, dataset)
    file = @datadep_str "Planetoid/$(dataset).metadata.jld2"
    @load file meta
    meta
end

function metadata(cora::Cora)
    file = datadep"Cora/cora.metadata.jld2"
    @load file meta
    meta
end

function metadata(::Reddit)
    file = datadep"Reddit/reddit.metadata.jld2"
    @load file meta
    meta
end
