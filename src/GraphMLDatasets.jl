module GraphMLDatasets
    using CSV
    using DataDeps: DataDep, register, @datadep_str
    using HTTP
    using JLD2
    using JSON
    using LightGraphs: SimpleDiGraph, add_edge!
    using MAT
    using PyCall
    using SparseArrays: SparseMatrixCSC, sparse

    export
        Dataset,
        Planetoid,
        Cora,
        PPI,
        Reddit,
        QM7b,
        Entities,
        dataset,
        traindata,
        validdata,
        testdata

    include("./dataset.jl")
    include("./planetoid.jl")
    include("./cora.jl")
    include("./ppi.jl")
    include("./reddit.jl")
    include("./qm7b.jl")
    include("./entities.jl")
    include("./utils.jl")

    function __init__()
        planetoid_init()
        cora_init()
        ppi_init()
        reddit_init()
        qm7b_init()
        entities_init()
    end
end
