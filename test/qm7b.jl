@testset "qm7b" begin
    names, X, T = rawdata(QM7b())
    @test names isa Vector{String}
    @test size(names) == (14,)
    @test X isa Array{Float32,3}
    @test size(X) == (7211, 23, 23)
    @test T isa Matrix{Float32}
    @test size(T) == (7211, 14)
end
