@testset "qm7b" begin
    raw = rawdata(QM7b())
    @test typeof(raw[:names]) == Vector{String}
    @test size(raw[:names]) == (14,)
    @test typeof(raw[:X]) == Array{Float32,3}
    @test size(raw[:X]) == (7211, 23, 23)
    @test typeof(raw[:T]) == Matrix{Float32}
    @test size(raw[:T]) == (7211, 14)
end
