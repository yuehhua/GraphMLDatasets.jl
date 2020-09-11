const ENTITIES_URL = "https://s3.us-east-2.amazonaws.com/dgl.ai/dataset/"
const ENTITIES_DATASETS = [:aifb, :am, :mutag, :bgs]

entities_init() = register(DataDep(
    "Entities",
    """
    The relational entities networks "AIFB", "MUTAG", "BGS" and "AM" from
    the `"Modeling Relational Data with Graph Convolutional Networks"
    <https://arxiv.org/abs/1703.06103>`_ paper.
    Training and test splits are given by node indices.
    """,
    [joinpath(ENTITIES_URL, "$(d).tgz") for d in ENTITIES_DATASETS],
    "e58bcfddd240d9bbc830bcae74e9854f1f778a96d3072930395f47d3c8e6f342";
    post_fetch_method=preprocess_entities,
))

function preprocess_entities(local_path)
    for dataset in ENTITIES_DATASETS
        tgz_file = @datadep_str "Entities/$(dataset).tgz"
        dir = joinpath(dirname(tgz_file), "$(dataset)")
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

struct Entities <:Dataset
    dataset::Symbol

    function Entities(dataset::Symbol)
        @assert dataset in ENTITIES_DATASETS "`dataset` should be one of :aifb, :am, :mutag, :bgs."
        new(dataset)
    end
end

# function traindata(ent::Entities)
#     file = @datadep_str "Entities/$(ent.dataset).train.jld2"
#     @load file graph train_X train_y
#     graph, train_X, train_y
# end

# function testdata(ent::Entities)
#     file = @datadep_str "Entities/$(ent.dataset).test.jld2"
#     @load file graph test_X test_y
#     graph, test_X, test_y
# end