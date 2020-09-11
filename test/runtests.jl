using GraphMLDatasets
using LightGraphs: SimpleDiGraph, add_edge!, nv, ne
using SparseArrays: SparseMatrixCSC
using Test

tests = [
    "planetoid",
    "cora",
    "ppi",
    "reddit",
    "qm7b",
    "entities"
]

@testset "GraphMLDatasets.jl" begin
    for t in tests
        include("$(t).jl")
    end
end
