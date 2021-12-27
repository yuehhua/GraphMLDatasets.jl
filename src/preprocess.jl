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
            test_idx_file = @datadep_str "Planetoid/ind.$(subds).test.index"
    
            train_X = Pickle.npyload(trainX_file)
            train_y = Pickle.npyload(trainy_file)
            test_X = Pickle.npyload(testX_file)
            test_y = Pickle.npyload(testy_file)
            all_X = Pickle.npyload(allX_file)
            all_y = Pickle.npyload(ally_file)
            graph = Pickle.npyload(graph_file)
            test_idx = vec(readdlm(test_idx_file, ' ', Int64))
    
            num_V = length(graph)
            sg = to_simplegraph(graph, num_V)
            num_E = ne(sg)
            feat_dim = size(all_X, 2)
            label_dim = size(all_y, 2)
            train_X, train_y = sparse(train_X'), sparse(train_y')
            test_X, test_y = sparse(test_X'), sparse(test_y')
            all_X, all_y = sparse(all_X'), sparse(all_y')
            raw = Dict("graph"=>graph, "train_X"=>train_X, "train_y"=>train_y,
                       "test_X"=>test_X, "test_y"=>test_y, "all_X"=>all_X, "all_y"=>all_y)
            meta = (graph=(num_V=num_V, num_E=num_E),
                    train=(features_dim=(feat_dim, size(train_X, 2)), labels_dim=(label_dim, size(train_y, 2))),
                    test=(features_dim=(feat_dim, size(test_X, 2)), labels_dim=(label_dim, size(test_y, 2))),
                    all=(features_dim=(feat_dim, size(all_X, 2)), labels_dim=(label_dim, size(all_y, 2)))
                    )
    
            graphfile = replace(graph_file, "ind.$(subds).graph"=>"$(subds).graph.jld2")
            trainfile = replace(graph_file, "ind.$(subds).graph"=>"$(subds).train.jld2")
            testfile = replace(graph_file, "ind.$(subds).graph"=>"$(subds).test.jld2")
            allfile = replace(graph_file, "ind.$(subds).graph"=>"$(subds).all.jld2")
            test_idxfile = replace(graph_file, "ind.$(subds).graph"=>"$(subds).indices.jld2")
            rawfile = replace(graph_file, "ind.$(subds).graph"=>"$(subds).raw.jld2")
            metadatafile = replace(graph_file, "ind.$(subds).graph"=>"$(subds).metadata.jld2")
    
            JLD2.save(graphfile, "sg", sg)
            JLD2.save(trainfile, "train_X", train_X, "train_y", train_y)
            JLD2.save(testfile, "test_X", test_X, "test_y", test_y)
            JLD2.save(allfile, "all_X", all_X, "all_y", all_y)
            JLD2.save(test_idxfile, "test_indices", test_idx)
            JLD2.save(rawfile, raw)
            JLD2.save(metadatafile, "meta", meta)
        end
    end
end

read_index(filename) = map(x -> parse(Int64, x), readlines(filename))


## Cora dataset

function dataset_preprocess(dataset::Type{Cora})
    return function preprocess(local_path)
        reader = ZipFile.Reader(local_path)
        mA, nA = read_npyarray(reader, "adj_shape")
        adj_data = read_npyarray(reader, "adj_data")
        adj_indptr = read_npyarray(reader, "adj_indptr") .+ 1
        adj_indices = read_npyarray(reader, "adj_indices") .+ 1
        mX, nX = read_npyarray(reader, "attr_shape")
        attr_data = read_npyarray(reader, "attr_data")
        attr_indptr = read_npyarray(reader, "attr_indptr") .+ 1
        attr_indices = read_npyarray(reader, "attr_indices") .+ 1

        nzA, colptrA, rowvalA = Pickle.csr_to_csc(mA, nA, adj_data, adj_indptr, adj_indices)
        nzX, colptrX, rowvalX = Pickle.csr_to_csc(mX, nX, attr_data, attr_indptr, attr_indices)
        graph = SparseMatrixCSC(mA, nA, colptrA, rowvalA, nzA)
        X = SparseMatrixCSC(mX, nX, colptrX, rowvalX, nzX)
        y = read_npyarray(reader, "labels")
    
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
    
        JLD2.save(graphfile, "sg", sg)
        # JLD2.save(trainfile, "train_X", train_X, "train_y", train_y)
        # JLD2.save(testfile, "test_X", test_X, "test_y", test_y)
        JLD2.save(allfile, Dict("all_X"=>all_X, "all_y"=>all_y))
        JLD2.save(rawfile, Dict("graph"=>graph, "all_X"=>X, "all_y"=>y))
        JLD2.save(metadatafile, "meta", meta)
    end
end


## PPI dataset

function dataset_preprocess(dataset::Type{PPI})
    return function preprocess(local_path)
        reader = ZipFile.Reader(local_path)

        for phase in ["train", "test", "valid"]
            ids = read_npyarray(reader, "$(phase)_graph_id")
            X = Matrix{Float32}(read_npyarray(reader, "$(phase)_feats"))
            y = SparseMatrixCSC{Int32,Int64}(read_npyarray(reader, "$(phase)_labels"))
            i = findfirst(x -> x.name == "$(phase)_graph.json", reader.files)
            graph = read_ppi_graph(reader.files[i])

            jld2file = replace(local_path, "ppi.zip"=>"ppi.$(phase).jld2")
            JLD2.save(jld2file, Dict("graph"=>graph, "X"=>X, "y"=>y, "ids"=>ids))
        end
    end
end

function read_ppi_graph(io::IO)
    d = JSON.parse(io)
    g = SimpleDiGraph{Int32}(length(d["nodes"]))

    for pair in d["links"]
        add_edge!(g, pair["source"], pair["target"])
    end
    g
end


## Reddit dataset

function dataset_preprocess(dataset::Type{Reddit})
    return function preprocess(local_path)
        reader = ZipFile.Reader(local_path)
        graph_file = IOBuffer(read(reader.files[1]))  # reddit_graph.npz
        data_file = IOBuffer(read(reader.files[2]))  # reddit_data.npz

        rawfile = replace(local_path, "reddit.zip"=>"reddit.raw.jld2")
        graph, X, y = to_reddit_rawfile(graph_file, data_file, rawfile)

        sg = to_simplegraph(graph)
        all_X = Matrix(X')
        all_y = Matrix{UInt16}(y')
        meta = (graph=(num_V=nv(sg), num_E=ne(sg)),
                all=(features_dim=size(all_X), labels_dim=size(all_y)))

        graphfile = replace(local_path, "reddit.zip"=>"reddit.graph.jld2")
        allfile = replace(local_path, "reddit.zip"=>"reddit.all.jld2")
        metadatafile = replace(local_path, "reddit.zip"=>"reddit.metadata.jld2")

        JLD2.save(graphfile, "sg", sg)
        JLD2.save(allfile, "all_X", all_X, "all_y", all_y)
        JLD2.save(metadatafile, "meta", meta)
    end
end

function to_reddit_rawfile(graph_file, data_file, rawfile)
    reader = ZipFile.Reader(data_file)
    graph = read_reddit_graph(graph_file)
    X = Matrix{Float32}(read_npyarray(reader, "feature"))
    y = Vector{Int32}(read_npyarray(reader, "label"))
    ids = Vector{Int32}(read_npyarray(reader, "node_ids"))
    types = Vector{UInt8}(read_npyarray(reader, "node_types"))
    JLD2.save(rawfile, Dict("graph"=>graph, "X"=>X, "y"=>y, "ids"=>ids, "types"=>types))

    graph, X, y
end

function read_reddit_graph(graph_file)
    reader = ZipFile.Reader(graph_file)
    row = read_npyarray(reader, "row") .+ 1
    col = read_npyarray(reader, "col") .+ 1
    data = read_npyarray(reader, "data")
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
        JLD2.save(rawfile, Dict("names"=>names, "X"=>X, "T"=>T))
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


## OGBNProteins dataset

function dataset_preprocess(dataset::Type{OGBNProteins})
    return function preprocess(local_path)
        reader = ZipFile.Reader(local_path)
        train_indices, valid_indices, test_indices = read_indices(dataset, reader, "proteins")
        V, E, edges = read_graph(reader, "proteins/raw")
        edge_feat = read_features(dataset, reader, "proteins/raw", "edge")
        node_label = read_labels(dataset, reader, "proteins/raw", "node")
        graph = to_simplegraph(edges, V)
        indices = Dict("train_indices"=>train_indices, "valid_indices"=>valid_indices, "test_indices"=>test_indices)

        indicesfile = replace(local_path, "proteins.zip"=>"indices.jld2")
        graphfile = replace(local_path, "proteins.zip"=>"graph.jld2")
        featfile = replace(local_path, "proteins.zip"=>"edge_feat.jld2")
        labelfile = replace(local_path, "proteins.zip"=>"node_label.jld2")
        
        JLD2.save(indicesfile, indices)
        JLD2.save(graphfile, "sg", graph)
        JLD2.save(featfile, "edge_feat", edge_feat)
        JLD2.save(labelfile, "node_label", node_label)
    end
end

function read_node_species(reader, dir::String)
    filename = joinpath(dir, "node_species.csv.gz")
    header = [:species]
    df = read_zipfile(reader, filename, header)
    return df
end


## OGBNProducts dataset

function dataset_preprocess(dataset::Type{OGBNProducts})
    return function preprocess(local_path)
        reader = ZipFile.Reader(local_path)
        train_indices, valid_indices, test_indices = read_indices(dataset, reader, "products")
        V, E, edges = read_graph(reader, "products/raw")
        node_feat = read_features(dataset, reader, "products/raw", "node")
        node_label = read_labels(dataset, reader, "products/raw", "node")
        graph = to_simplegraph(edges, V)
        indices = Dict("train_indices"=>train_indices, "valid_indices"=>valid_indices, "test_indices"=>test_indices)

        indicesfile = replace(local_path, "products.zip"=>"indices.jld2")
        graphfile = replace(local_path, "products.zip"=>"graph.jld2")
        featfile = replace(local_path, "products.zip"=>"node_feat.jld2")
        labelfile = replace(local_path, "products.zip"=>"node_label.jld2")
        
        JLD2.save(indicesfile, indices)
        JLD2.save(graphfile, "sg", graph)
        JLD2.save(featfile, "node_feat", node_feat)
        JLD2.save(labelfile, "node_label", node_label)
    end
end


## OGBNArxiv dataset

function dataset_preprocess(dataset::Type{OGBNArxiv})
    return function preprocess(local_path)
        reader = ZipFile.Reader(local_path)
        train_indices, valid_indices, test_indices = read_indices(dataset, reader, "arxiv")
        V, E, edges = read_graph(reader, "arxiv/raw")
        node_feat = read_features(dataset, reader, "arxiv/raw", "node")
        node_label = read_labels(dataset, reader, "arxiv/raw", "node")
        graph = to_simpledigraph(edges, V)
        indices = Dict("train_indices"=>train_indices, "valid_indices"=>valid_indices, "test_indices"=>test_indices)

        indicesfile = replace(local_path, "arxiv.zip"=>"indices.jld2")
        graphfile = replace(local_path, "arxiv.zip"=>"graph.jld2")
        featfile = replace(local_path, "arxiv.zip"=>"node_feat.jld2")
        labelfile = replace(local_path, "arxiv.zip"=>"node_label.jld2")
        
        JLD2.save(indicesfile, indices)
        JLD2.save(graphfile, "sg", graph)
        JLD2.save(featfile, "node_feat", node_feat)
        JLD2.save(labelfile, "node_label", node_label)
    end
end


## OGBNMag dataset

# function dataset_preprocess(dataset::Type{OGBNMag})
#     return function preprocess(local_path)
#         reader = ZipFile.Reader(local_path)
#         train_indices, valid_indices, test_indices = read_indices(dataset, reader, "mag")
#         graph = read_heterogeneous_graph(reader, "mag/raw")
#         node_year = read_mag_year(reader, "mag/raw/node-feat/paper")
#         node_feat = read_features(dataset, reader, "mag/raw/node-feat/paper", "node")
#         node_label = read_labels(dataset, reader, "mag/raw/node-label/paper", "node")
#         indices = Dict("train_indices"=>train_indices, "valid_indices"=>valid_indices, "test_indices"=>test_indices)

#         indicesfile = replace(local_path, "mag.zip"=>"indices.jld2")
#         graphfile = replace(local_path, "mag.zip"=>"graph.jld2")
#         featfile = replace(local_path, "mag.zip"=>"node_feat.jld2")
#         labelfile = replace(local_path, "mag.zip"=>"node_label.jld2")
        
#         JLD2.save(indicesfile, indices)
#         JLD2.save(graphfile, "g", graph)
#         JLD2.save(featfile, "node_feat", node_feat, "node_year", node_year)
#         JLD2.save(labelfile, "node_label", node_label)
#     end
# end

# function read_mag_year(reader, dir::String)
#     filename = joinpath(dir, "node_year.csv.gz")
#     header = [:year]
#     df = read_zipfile(reader, filename, header)
#     return df
# end


## OGBNPapers100M dataset

function dataset_preprocess(dataset::Type{OGBNPapers100M})
    return function preprocess(local_path)
        reader = ZipFile.Reader(local_path)
        # train_indices, valid_indices, test_indices = read_indices(dataset, reader, "products")
        # V, E, edges = read_graph(reader, "products/raw")
        # edge_feat = read_edge_feat(dataset, reader, "products/raw")
        # node_label = read_node_label(dataset, reader, "products/raw")
        # graph = to_simplegraph(edges, V)
        # indices = Dict("train_indices"=>train_indices, "valid_indices"=>valid_indices, "test_indices"=>test_indices)

        # indicesfile = replace(local_path, "proteins.zip"=>"indices.jld2")
        # graphfile = replace(local_path, "proteins.zip"=>"graph.jld2")
        # featfile = replace(local_path, "proteins.zip"=>"edge_feat.jld2")
        # labelfile = replace(local_path, "proteins.zip"=>"node_label.jld2")
        
        # JLD2.save(indicesfile, indices)
        # JLD2.save(graphfile, "sg", graph)
        # JLD2.save(featfile, "edge_feat", edge_feat)
        # JLD2.save(labelfile, "node_label", node_label)
    end
end
