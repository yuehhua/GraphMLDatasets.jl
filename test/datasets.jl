tests = [
    "planetoid",
    "cora",
    "ppi",
    "reddit",
    "qm7b",
    "entities"
]

@testset "datasets" begin
    for t in tests
        include("$(t).jl")
    end
end