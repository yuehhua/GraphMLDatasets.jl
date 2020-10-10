function unzip_zip(src::String, dest::String=dirname(src))
    run(`unzip $src -d $dest`)
end

function unzip_tgz(src::String, dest::String)
    isdir(dest) || mkdir("$dest")
    run(`tar zxf $src -C $dest`)
end

function to_simplegraph(data::Dict, num_V::Int)
    g = SimpleGraph{UInt32}(num_V)
    for (i, js) in data
        for j in Set(js)
            add_edge!(g, i, j)
        end
    end
    g
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
