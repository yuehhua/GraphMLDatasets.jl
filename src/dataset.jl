abstract type Dataset end

struct Planetoid <: Dataset end
struct Cora <: Dataset end
struct PPI <: Dataset end
struct Reddit <: Dataset end
struct QM7b <:Dataset end
struct Entities <:Dataset end



dataset_url(::Type{Planetoid}) = "https://github.com/kimiyoung/planetoid/raw/master/data"
dataset_url(::Type{Entities}) = "https://s3.us-east-2.amazonaws.com/dgl.ai/dataset/"

subdatasets(::Type{Planetoid}) = [:citeseer, :cora, :pubmed]
subdatasets(::Type{Entities}) = [:aifb, :am, :mutag, :bgs]

dataset_exts(::Type{Planetoid}) = ["allx", "ally", "graph", "test.index", "tx", "ty", "x", "y"]



dataset_name(::Type{Planetoid}) = "Planetoid"
dataset_name(::Type{Cora}) = "Cora"
dataset_name(::Type{PPI}) = "PPI"
dataset_name(::Type{Reddit}) = "Reddit"
dataset_name(::Type{QM7b}) = "QM7b"
dataset_name(::Type{Entities}) = "Entities"



function dataset_message(::Type{Planetoid})
    """
    The citation network datasets "Cora", "CiteSeer", "PubMed" from
    "Revisiting Semi-Supervised Learning with Graph Embeddings"
    <https://arxiv.org/abs/1603.08861> paper.
    Nodes represent documents and edges represent citation links.
    """
end

function dataset_message(::Type{Cora})
    """
    The full Cora citation network dataset from the
    `"Deep Gaussian Embedding of Graphs: Unsupervised Inductive Learning via
    Ranking" <https://arxiv.org/abs/1707.03815>`_ paper.
    Nodes represent documents and edges represent citation links.
    """
end

function dataset_message(::Type{PPI})
    """
    The protein-protein interaction networks from the `"Predicting
    Multicellular Function through Multi-layer Tissue Networks"
    <https://arxiv.org/abs/1707.04638>`_ paper, containing positional gene
    sets, motif gene sets and immunological signatures as features (50 in
    total) and gene ontology sets as labels (121 in total).
    """
end

function dataset_message(::Type{Reddit})
    """
    The Reddit dataset from the `"Inductive Representation Learning on
    Large Graphs" <https://arxiv.org/abs/1706.02216>`_ paper, containing
    Reddit posts belonging to different communities.
    """
end

function dataset_message(::Type{QM7b})
    """
    The QM7b dataset from the `"MoleculeNet: A Benchmark for Molecular
    Machine Learning" <https://arxiv.org/abs/1703.00564>`_ paper, consisting of
    7,211 molecules with 14 regression targets.
    """
end

function dataset_message(::Type{Entities})
    """
    The relational entities networks "AIFB", "MUTAG", "BGS" and "AM" from
    the `"Modeling Relational Data with Graph Convolutional Networks"
    <https://arxiv.org/abs/1703.06103>`_ paper.
    Training and test splits are given by node indices.
    """
end



function dataset_remote_path(dataset::Type{Planetoid})
    url = dataset_url(dataset)
    subds = subdatasets(dataset)
    exts = dataset_exts(dataset)
    dataurls = [joinpath(url, "ind.$(d).$(ext)") for d in subds, ext in exts]
    return reshape(dataurls, :)
end

dataset_remote_path(::Type{Cora}) = "https://github.com/abojchevski/graph2gauss/raw/master/data/cora.npz"
dataset_remote_path(::Type{PPI}) = "https://data.dgl.ai/dataset/ppi.zip"
dataset_remote_path(::Type{Reddit}) = "https://data.dgl.ai/dataset/reddit.zip"
dataset_remote_path(::Type{QM7b}) = "http://deepchem.io.s3-website-us-west-1.amazonaws.com/datasets/qm7b.mat"
dataset_remote_path(dataset::Type{Entities}) = [joinpath(dataset_url(dataset), "$(d).tgz") for d in subdatasets(dataset)]



dataset_checksum(::Type{Planetoid}) = "f52b3d47f5993912d7509b51e8090b6807228c4ba8c7d906f946868005c61c18"
dataset_checksum(::Type{Cora}) = "62e054f93be00a3dedb15b7ac15a2a07168ceab68b40bf95f54d2289d024c6bc"
dataset_checksum(::Type{PPI}) = "1f5b2b09ac0f897fa6aa1338c64ab75a5473674cbba89380120bede8cddb2a6a"
dataset_checksum(::Type{Reddit}) = "9a16353c28f8ddd07148fc5ac9b57b818d7911ea0fbe9052d66d49fc32b372bf"
dataset_checksum(::Type{QM7b}) = "e2a9d670d86eba769fa7b5eadeb592184067d2ec12468b1a220bfc38502dda61"
dataset_checksum(::Type{Entities}) = "e58bcfddd240d9bbc830bcae74e9854f1f778a96d3072930395f47d3c8e6f342"
