tests = [
    "planetoid",
    "cora",
    "ppi",
    "reddit",
    "qm7b",
    "entities"
]

@testset "datasets" begin
    @test_throw ArgumentError traindata(Reddit())
    @test_throw ArgumentError validdata(Reddit())
    @test_throw ArgumentError testdata(Reddit())
    @test_throw AssertionError traindata(Planetoid(), :abc)

    for t in tests
        include("$(t).jl")
    end
end