using GraphMLDatasets
using Graphs
using SparseArrays
using Test

ENV["DATADEPS_ALWAYS_ACCEPT"] = true

tests = [
    "planetoid",
    "cora",
    "ppi",
    "reddit",
    "qm7b",
    "entities",
    "ogb",
    "utils",
]

@testset "GraphMLDatasets.jl" begin
    for t in tests
        include("$(t).jl")
    end
end
