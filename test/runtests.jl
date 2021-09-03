using GraphMLDatasets
using LightGraphs
using SparseArrays
using Test

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
