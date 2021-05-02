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
    
            @save graphfile sg
            @save trainfile train_X train_y
            @save testfile test_X test_y
            @save allfile all_X all_y
            @save rawfile raw
            @save metadatafile meta
        end
    end
end

function read_data(filename)
    py"""
    import pickle
    from scipy.sparse import csr_matrix

    with open($filename,"rb") as f:
        u = pickle._Unpickler(f)
        u.encoding = "latin1"
        data = u.load()

    if type(data) is csr_matrix:
        data = data.toarray()
    """
    return SparseMatrixCSC(Array(py"data"))
end

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
        py"""
        import numpy as np
        import scipy.sparse as sp
        data = np.load($local_path, allow_pickle=True)
        A = sp.csr_matrix((data['adj_data'], data['adj_indices'], data['adj_indptr']), shape=data['adj_shape'])
        X = sp.csr_matrix((data['attr_data'], data['attr_indices'], data['attr_indptr']), shape=data['attr_shape'])
        """
    
        graph = SparseMatrixCSC(Array(py"A.toarray()"))
        X = SparseMatrixCSC(Array(py"X.toarray()"))
        y = py"data['labels']"
        raw = Dict(:graph=>graph, :all_X=>X, :all_y=>y)
    
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
    
        @save graphfile sg
        # @save trainfile train_X train_y
        # @save testfile test_X test_y
        @save allfile all_X all_y
        @save rawfile raw
        @save metadatafile meta
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

            py"""
            import numpy as np
            ids = np.load($id_file)
            X = np.load($X_file)
            y = np.load($y_file)
            """

            X = Matrix{Float32}(py"X")
            y = SparseMatrixCSC{Int32,Int64}(Array(py"y"))
            ids = Array(py"ids")
            graph = read_ppi_graph(graph_file)

            jld2file = replace(local_path, "ppi.zip"=>"ppi.$(phase).jld2")
            @save jld2file graph X y ids
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

        @save graphfile sg
        @save allfile all_X all_y
        @save metadatafile meta
    end
end

function to_reddit_rawfile(graph_file, data_file, rawfile)
    py"""
    import numpy as np
    import scipy.sparse as sp
    graph = np.load($graph_file, allow_pickle=True)
    data = np.load($data_file, allow_pickle=True)
    """

    graph = sparse(Vector(py"graph['row']") .+ 1,
                   Vector(py"graph['col']") .+ 1,
                   Vector{Int32}(py"graph['data']"))
    X = Matrix{Float32}(py"data['feature']")
    y = Vector{Int32}(py"data['label']")
    ids = Vector{Int32}(py"data['node_ids']")
    types = Vector{UInt8}(py"data['node_types']")
    raw = Dict(:graph=>graph, :X=>X, :y=>y, :ids=>ids, :types=>types)

    @save rawfile raw

    graph, X, y
end


## Reddit dataset

function dataset_preprocess(dataset::Type{QM7b})
    return function preprocess(local_path)
        vars = matread(local_path)
        names = vars["names"]
        X = vars["X"]
        T = Matrix{Float32}(vars["T"])
        raw = Dict(:names=>names, :X=>X, :T=>T)

        rawfile = replace(local_path, "qm7b.mat"=>"qm7b.raw.jld2")
        @save rawfile raw
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
