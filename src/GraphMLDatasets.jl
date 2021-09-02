module GraphMLDatasets
    using InteractiveUtils: subtypes
    using SparseArrays: SparseMatrixCSC, sparse, findnz

    using CSV
    using DataDeps: DataDep, register, @datadep_str
    using HTTP
    using JLD2
    using JSON
    using LightGraphs: SimpleGraph, SimpleDiGraph, add_edge!, nv, ne
    using MAT
    using Pickle
    using PyCall

    export
        Dataset,
        Planetoid,
        Cora,
        PPI,
        Reddit,
        QM7b,
        Entities,
        traindata,
        validdata,
        testdata,
        graphdata,
        rawdata,
        alldata,
        metadata

    include("dataset.jl")
    include("preprocess.jl")
    include("interfaces.jl")
    include("utils.jl")
    include("register.jl")

    function __init__()
        init_dataset(Dataset)
    end
end
