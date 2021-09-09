function unzip_zip(src::String, dest::String=dirname(src))
    run(`unzip $src -d $dest`)
end

function unzip_tgz(src::String, dest::String)
    isdir(dest) || mkdir("$dest")
    run(`tar zxf $src -C $dest`)
end

function to_simplegraph(data::AbstractDict, num_V::Int)
    g = SimpleGraph{UInt32}(num_V)
    for (i, js) in data
        for j in Set(js)
            add_edge!(g, i, j)
        end
    end
    g
end

function to_simplegraph(data::SparseMatrixCSC)
    num_V = size(data, 1)
    g = SimpleGraph{UInt32}(num_V)
    for (i, j, nz) in zip(findnz(data)...)
        if nz == 1
            add_edge!(g, i, j)
        end
    end
    g
end

function to_simplegraph(edges::DataFrame, num_V::Integer)
    g = SimpleGraph{Int32}(num_V)
    for row in eachrow(edges)
        add_edge!(g, row.node1, row.node2)
    end
    return g
end

function to_simpledigraph(data::SparseMatrixCSC)
    num_V = size(data, 1)
    g = SimpleDiGraph{UInt32}(num_V)
    for (i, j, nz) in zip(findnz(data)...)
        if nz == 1
            add_edge!(g, i, j)
        end
    end
    g
end

function read_npzarray(reader, index::String)
    i = findfirst(x -> x.name == (index * ".npy"), reader.files)
    return NPZ.npzreadarray(reader.files[i])
end

function read_zipfile(reader, filename::String, header)
    file = filter(x -> x.name == filename, reader.files)[1]
    df = CSV.File(transcode(GzipDecompressor, read(file)); header=header) |> DataFrame
    return df
end
