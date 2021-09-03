function dataset_preprocess(dataset::Type{Planetoid})
    return function preprocess(local_path)
        for subds in subdatasets(dataset)
            graph_file = @datadep_str "Planetoid/ind.$(subds).graph"
            trainX_file = @datadep_str "Planetoid/ind.$(subds).x"
            trainy_file = @datadep_str "Planetoid/ind.$(subds).y"
            testX_file = @datadep_str "Planetoid/ind.$(subds).tx"
            testy_file = @datadep_str "Planetoid/ind.$(subds).ty"
            allX_file = @datadep_str "Planetoid/ind.$(subds).allx"
            ally_file = @datadep_str "Planetoid/ind.$(subds).ally"
    
            train_X = read_data(trainX_file)
            train_y = read_data(trainy_file)
            test_X = read_data(testX_file)
            test_y = read_data(testy_file)
            all_X = read_data(allX_file)
            all_y = read_data(ally_file)
            graph = read_graph(graph_file)
    
            num_V = length(graph)
            sg = to_simplegraph(graph, num_V)
            num_E = ne(sg)
            feat_dim = size(all_X, 2)
            label_dim = size(all_y, 2)
            train_X, train_y = sparse(train_X'), sparse(train_y')
            test_X, test_y = sparse(test_X'), sparse(test_y')
            all_X, all_y = sparse(all_X'), sparse(all_y')
            raw = Dict(:graph=>graph, :train_X=>train_X, :train_y=>train_y,
                       :test_X=>test_X, :test_y=>test_y, :all_X=>all_X, :all_y=>all_y)
            meta = (graph=(num_V=num_V, num_E=num_E),
                    train=(features_dim=(feat_dim, size(train_X, 2)), labels_dim=(label_dim, size(train_y, 2))),
                    test=(features_dim=(feat_dim, size(test_X, 2)), labels_dim=(label_dim, size(test_y, 2))),
                    all=(features_dim=(feat_dim, size(all_X, 2)), labels_dim=(label_dim, size(all_y, 2)))
                    )
    
            graphfile = replace(graph_file, "ind.$(subds).graph"=>"$(subds).graph.jld2")
            trainfile = replace(graph_file, "ind.$(subds).graph"=>"$(subds).train.jld2")
            testfile = replace(graph_file, "ind.$(subds).graph"=>"$(subds).test.jld2")
            allfile = replace(graph_file, "ind.$(subds).graph"=>"$(subds).all.jld2")
            rawfile = replace(graph_file, "ind.$(subds).graph"=>"$(subds).raw.jld2")
            metadatafile = replace(graph_file, "ind.$(subds).graph"=>"$(subds).metadata.jld2")
    
            save(graphfile, :sg, sg)
            save(trainfile, :train_X, train_X, :train_y, train_y)
            save(testfile, :test_X, test_X, :test_y, test_y)
            save(allfile, :all_X, all_X, :all_y, all_y)
            save(rawfile, raw)
            save(metadatafile, meta)
        end
    end
end

read_data(filename) = Pickle.npyload(filename)
read_index(filename) = map(x -> parse(Int64, x), readlines(filename))

function read_graph(filename)
    py"""
    import pickle

    with open($filename,"rb") as f:
        u = pickle._Unpickler(f)
        u.encoding = "latin1"
        data = u.load()
    """
    return Dict(py"data")
end


## Cora dataset

function dataset_preprocess(dataset::Type{Cora})
    return function preprocess(local_path)
        reader = ZipFile.Reader(local_path)
        mA, nA = read_npzarray(reader, "adj_shape")
        adj_data = read_npzarray(reader, "adj_data")
        adj_indptr = read_npzarray(reader, "adj_indptr")
        adj_indices = read_npzarray(reader, "adj_indices")
        mX, nX = read_npzarray(reader, "attr_shape")
        attr_data = read_npzarray(reader, "attr_data")
        attr_indptr = read_npzarray(reader, "attr_indptr")
        attr_indices = read_npzarray(reader, "attr_indices")

        nzA, colptrA, rowvalA = Pickle.csr_to_csc(mA, nA, adj_data, adj_indptr, adj_indices)
        nzX, colptrX, rowvalX = Pickle.csr_to_csc(mX, nX, attr_data, attr_indptr, attr_indices)
        graph = SparseMatrixCSC(mA, nA, colptrA, rowvalA, nzA)
        X = SparseMatrixCSC(mX, nX, colptrX, rowvalX, nzX)
        y = read_npzarray(reader, "labels")
    
        all_X = sparse(X')
        all_y = Matrix{UInt16}(y')
        sg = to_simpledigraph(graph)
        meta = (graph=(num_V=nv(sg), num_E=ne(sg)),
                all=(features_dim=size(all_X), labels_dim=size(all_y))
                )
    
        graphfile = replace(local_path, "cora.npz"=>"cora.graph.jld2")
        # trainfile = replace(local_path, "cora.npz"=>"cora.train.jld2")
        # testfile = replace(local_path, "cora.npz"=>"cora.test.jld2")
        allfile = replace(local_path, "cora.npz"=>"cora.all.jld2")
        rawfile = replace(local_path, "cora.npz"=>"cora.raw.jld2")
        metadatafile = replace(local_path, "cora.npz"=>"cora.metadata.jld2")
    
        save(graphfile, :sg, sg)
        # save(trainfile, :train_X, train_X, :train_y, train_y)
        # save(testfile, :test_X, test_X, :test_y, test_y)
        save(allfile, Dict(:all_X=>all_X, :all_y=>all_y))
        save(rawfile, Dict(:graph=>graph, :all_X=>X, :all_y=>y))
        save(metadatafile, meta)
    end
end


## PPI dataset

function dataset_preprocess(dataset::Type{PPI})
    return function preprocess(local_path)
        unzip_zip(local_path)

        for phase in ["train", "test", "valid"]
            graph_file = @datadep_str "PPI/$(phase)_graph.json"
            id_file = @datadep_str "PPI/$(phase)_graph_id.npy"
            X_file = @datadep_str "PPI/$(phase)_feats.npy"
            y_file = @datadep_str "PPI/$(phase)_labels.npy"

            ids = NPZ.npzread(id_file)
            X = Matrix{Float32}(NPZ.npzread(X_file))
            y = SparseMatrixCSC{Int32,Int64}(NPZ.npzread(y_file))
            graph = read_ppi_graph(graph_file)

            jld2file = replace(local_path, "ppi.zip"=>"ppi.$(phase).jld2")
            save(jld2file, Dict(:graph=>graph, :X=>X, :y=>y, :ids=>ids))
        end
    end
end

function read_ppi_graph(filename::String)
    d = JSON.Parser.parsefile(filename)
    g = SimpleDiGraph{Int32}(length(d["nodes"]))

    for pair in d["links"]
        add_edge!(g, pair["source"], pair["target"])
    end
    g
end


## Reddit dataset

function dataset_preprocess(dataset::Type{Reddit})
    return function preprocess(local_path)
        unzip_zip(local_path)

        graph_file = datadep"Reddit/reddit_graph.npz"
        data_file = datadep"Reddit/reddit_data.npz"

        graphfile = replace(local_path, "reddit.zip"=>"reddit.graph.jld2")
        allfile = replace(local_path, "reddit.zip"=>"reddit.all.jld2")
        rawfile = replace(local_path, "reddit.zip"=>"reddit.raw.jld2")
        metadatafile = replace(local_path, "reddit.zip"=>"reddit.metadata.jld2")

        graph, X, y = to_reddit_rawfile(graph_file, data_file, rawfile)

        sg = to_simplegraph(graph)
        all_X = Matrix(X')
        all_y = Matrix{UInt16}(y')
        meta = (graph=(num_V=nv(sg), num_E=ne(sg)),
                all=(features_dim=size(all_X), labels_dim=size(all_y))
                )

        save(graphfile, :sg, sg)
        save(allfile, :all_X, all_X, :all_y, all_y)
        save(metadatafile, :meta, meta)
    end
end

function to_reddit_rawfile(graph_file, data_file, rawfile)
    reader = ZipFile.Reader(data_file)
    graph = read_reddit_graph(graph_file)
    X = Matrix{Float32}(read_npzarray(reader, "feature"))
    y = Vector{Int32}(read_npzarray(reader, "label"))
    ids = Vector{Int32}(read_npzarray(reader, "node_ids"))
    types = Vector{UInt8}(read_npzarray(reader, "node_types"))
    save(rawfile, Dict(:graph=>graph, :X=>X, :y=>y, :ids=>ids, :types=>types))

    graph, X, y
end

function read_reddit_graph(graph_file)
    reader = ZipFile.Reader(graph_file)
    row = read_npzarray(reader, "row") .+ 1
    col = read_npzarray(reader, "col") .+ 1
    data = read_npzarray(reader, "data")
    return sparse(row, col, data)
end


## QM7b dataset

function dataset_preprocess(dataset::Type{QM7b})
    return function preprocess(local_path)
        vars = matread(local_path)
        names = vars["names"]
        X = vars["X"]
        T = Matrix{Float32}(vars["T"])

        rawfile = replace(local_path, "qm7b.mat"=>"qm7b.raw.jld2")
        save(rawfile, Dict(:names=>names, :X=>X, :T=>T))
    end
end


## Entities dataset

function dataset_preprocess(dataset::Type{Entities})
    return function preprocess(local_path)
        for subds in subdatasets(dataset)
            tgz_file = @datadep_str "Entities/$(subds).tgz"
            dir = joinpath(dirname(tgz_file), "$(subds)")
            unzip_tgz(tgz_file, dir)

            # nt_file = joinpath(dir, "$(dataset)_stripped.nt.gz")
            # train_file = joinpath(dir, "trainingSet.tsv")
            # test_file = joinpath(dir, "testSet.tsv")

            # py"""
            # import rdflib as rdf
            # import gzip
            # g = rdf.Graph()
            # with gzip.open($nt_file, 'rb') as file:
            #     g.parse(file, format='nt')
            # """

            # train = CSV.read(train_file, delim='\t')
            # test = CSV.read(test_file, delim='\t')
            # uri = HTTP.URI("http://data.bgs.ac.uk/id/Geochronology/Division/CN")
        end
    end
end
