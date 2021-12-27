module GraphMLDatasets
    using InteractiveUtils: subtypes
    using SparseArrays: SparseMatrixCSC, sparse, findnz
    using DelimitedFiles

    using CSV, DataFrames
    using CodecZlib
    using DataDeps: DataDep, register, @datadep_str
    using FileIO
    using HTTP
    using JLD2
    using JSON
    using Graphs: SimpleGraph, SimpleDiGraph, add_edge!, nv, ne
    using MAT
    using NPZ
    using Pickle
    using PyCall
    using ZipFile

    include("dataset.jl")
    include("ogb.jl")
    include("preprocess.jl")
    include("interfaces.jl")
    include("utils.jl")
    include("register.jl")

    function __init__()
        init_dataset(Dataset)
    end

    # precompile(read_heterogeneous_graph, (ZipFile.Reader, String))
end
