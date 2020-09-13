@testset "utils" begin
    source = joinpath(pkgdir(GraphMLDatasets), "test", "data")
    zipfile = joinpath(source, "test.zip")
    tgzfile = joinpath(source, "test.tgz")
    target_file = joinpath(source, "random.file")

    GraphMLDatasets.unzip_zip(zipfile)
    @test isfile(target_file)
    rm(target_file, force=true)

    GraphMLDatasets.unzip_tgz(tgzfile, source)
    @test isfile(target_file)
    rm(target_file, force=true)
end