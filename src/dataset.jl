export
    Dataset,
    Planetoid,
    Cora,
    PPI,
    Reddit,
    QM7b,
    Entities,
    OGBNProteins,
    OGBNProducts,
    OGBNArxiv,
    # OGBNMag,
    OGBNPapers100M,
    OGBLPPA,
    OGBLCollab,
    OGBLDDI,
    OGBLCitation2,
    OGBLWikiKG2,
    OGBLBioKG


abstract type Dataset end
abstract type OGBDataset <: Dataset end
abstract type NodePropPredDataset <: OGBDataset end
abstract type LinkPropPredDataset <: OGBDataset end
abstract type GraphPropPredDataset <: OGBDataset end

"""
    Planetoid()

Planetoid dataset contains Cora, CiteSeer, PubMed three citation networks.
Nodes represent documents and edges represent citation links.

Implements: [`graphdata`](@ref), [`traindata`](@ref), [`testdata`](@ref), [`alldata`](@ref), [`rawdata`](@ref),
    [`metadata`](@ref)
"""
struct Planetoid <: Dataset end

"""
    Cora()

Cora dataset contains full Cora citation networks.
Nodes represent documents and edges represent citation links.

Implements: [`graphdata`](@ref), [`alldata`](@ref), [`rawdata`](@ref), [`metadata`](@ref)
"""
struct Cora <: Dataset end

"""
    PPI()

PPI dataset contains the protein-protein interaction networks.
Nodes represent proteins and edges represent if proteins have interaction with each other.
Positional gene sets, motif gene sets and immunological signatures as features (50 in total)
and gene ontology sets as labels (121 in total).

Implements: [`traindata`](@ref), [`validdata`](@ref), [`testdata`](@ref)
"""
struct PPI <: Dataset end

"""
    Reddit()

Reddit dataset contains Reddit post networks. Reddit is a large online discussion forum where
users post and comment in 50 communities. Reddit posts belonging to different communities.
Nodes represent posts and edges represent if the same user comments on both posts.
The task is to predict post categories of community.

Implements: [`graphdata`](@ref), [`alldata`](@ref), [`rawdata`](@ref), [`metadata`](@ref)
"""
struct Reddit <: Dataset end

"""
    QM7b()

QM7b dataset contains molecular structure graphs and is subset of the GDB-13 database.
It contains stable and synthetically organic molecular structures.
Nodes represent atoms in a molecule and edges represent there is a chemical bond between atoms.
The 3D Cartesian coordinates of the stable conformation is given as features.
The task is to predict the electronic properties. It contains 7,211 molecules with 14 regression
targets.

Implements: [`rawdata`](@ref)
"""
struct QM7b <: Dataset end

"""
    Entities()

Entities dataset contains relational entities networks "AIFB", "MUTAG", "BGS" and "AM".
Nodes represent entities and directed edges represent subject-object relations.
The task is to predict properties of a group of entities in a knowledge graph.

Implements: [`graphdata`](@ref), [`traindata`](@ref), [`testdata`](@ref)
"""
struct Entities <: Dataset end

"""
    OGBNProteins()

`OGBNProteins` dataset contains protein-protein interaction network.
The task to predict the presence of protein functions in a multi-label binary classification.
Training/validation/test splits are given by node indices.

# Description

- Graph: undirected, weighted, and typed (according to species) graph.
- Node: proteins.
- Edge: different types of biologically meaningful associations
    between proteins, e.g., physical interactions, co-expression or homology.

# References

1. Damian Szklarczyk, Annika L Gable, David Lyon, Alexander Junge, Stefan Wyder,
    Jaime Huerta- Cepas, Milan Simonovic, Nadezhda T Doncheva, John H Morris, Peer Bork, et al.
    STRING v11: protein–protein association networks with increased coverage, supporting functional
    discovery in genome-wide experimental datasets. Nucleic Acids Research, 47(D1):D607–D613, 2019.
2. Gene Ontology Consortium. The gene ontology resource: 20 years and still going strong.
    Nucleic Acids Research, 47(D1):D330–D338, 2018.

Implements: [`graphdata`](@ref), [`train_indices`](@ref), [`valid_indices`](@ref), [`test_indices`](@ref), [`edge_features`](@ref),
    [`node_labels`](@ref)
"""
struct OGBNProteins <: NodePropPredDataset end

"""
    OGBNProducts()

`OGBNProducts` dataset contains an Amazon product co-purchasing network.
The task to predict the category of a product in a multi-class classification.
Training/validation/test splits are given by node indices.

# Description

- Graph: undirected and unweighted graph.
- Node: products sold in Amazon.
- Edge: the products are purchased together.

# References

1. http://manikvarma.org/downloads/XC/XMLRepository.html

Implements: [`graphdata`](@ref), [`train_indices`](@ref), [`valid_indices`](@ref), [`test_indices`](@ref), [`node_features`](@ref),
    [`node_labels`](@ref)
"""
struct OGBNProducts <: NodePropPredDataset end

"""
    OGBNArxiv()

`OGBNArxiv` dataset contains the citation network between all Computer Science (CS) arXiv papers
indexed by MAG.
The task to predict the primary categories of the arXiv papers from 40 subject areas
in a multi-class classification.
Training/validation/test splits are given by node indices.

# Description

- Graph: directed graph.
- Node: arXiv paper.
- Edge: each directed edge indicates that one paper cites another one.

# References

1. Kuansan Wang, Zhihong Shen, Chiyuan Huang, Chieh-Han Wu, Yuxiao Dong, and Anshul Kanakia.
    Microsoft academic graph: When experts are not enough. Quantitative Science Studies,
    1(1):396–413, 2020.
2. Tomas Mikolov, Ilya Sutskever, Kai Chen, Greg S Corrado, and Jeff Dean.
    Distributed representationsof words and phrases and their compositionality.
    In Advances in Neural Information Processing Systems (NeurIPS), pp. 3111–3119, 2013.

Implements: [`graphdata`](@ref), [`train_indices`](@ref), [`valid_indices`](@ref), [`test_indices`](@ref), [`node_features`](@ref),
    [`node_labels`](@ref)
"""
struct OGBNArxiv <: NodePropPredDataset end

# """
#     OGBNMag()

# `OGBNMag` dataset contains a heterogeneous network composed of a subset of the Microsoft Academic Graph (MAG).
# The task to predict the venue (conference or journal) of each paper, given its content, references,
# authors, and authors’ affiliations, in a multi-class classification setting.
# Training/validation/test splits are given by node indices. Only paper nodes have features and labels.

# # Description

# - Graph: directed heterogeneous graph.
# - Node: four types of entities.
#     - papers (736,389 nodes)
#     - authors (1,134,649 nodes)
#     - institutions (8,740 nodes)
#     - fields of study (59,965 nodes)
# - Edge: four types of directed relations.
#     - an author is "affiliated with" an institution
#     - an author "writes" a paper
#     - a paper "cites" a paper
#     - a paper "has a topic of" a field of study

# # References

# 1. Kuansan Wang, Zhihong Shen, Chiyuan Huang, Chieh-Han Wu, Yuxiao Dong, and Anshul Kanakia.
#     Microsoft academic graph: When experts are not enough. Quantitative Science Studies, 1(1):396–413, 2020.

# Implements: [`graphdata`](@ref), [`train_indices`](@ref), [`valid_indices`](@ref), [`test_indices`](@ref), [`node_features`](@ref),
#     [`node_labels`](@ref)
# """
# struct OGBNMag <: NodePropPredDataset end

"""
    OGBNPapers100M()

`OGBNPapers100M` dataset contains a citation graph of 111 million papers indexed by MAG.
The task is to predict the subject areas of the subset of papers that are published in arXiv
in a multi-class classification setting.
Training/validation/test splits are given by node indices.

# Description

- Graph: directed graph.
- Node: arXiv paper.
- Edge: each directed edge indicates that one paper cites another one.

# References

1. Kuansan Wang, Zhihong Shen, Chiyuan Huang, Chieh-Han Wu, Yuxiao Dong, and Anshul Kanakia.
    Microsoft academic graph: When experts are not enough. Quantitative Science Studies, 1(1):396–413, 2020.

Implements: [`graphdata`](@ref), [`train_indices`](@ref), [`valid_indices`](@ref), [`test_indices`](@ref), [`node_features`](@ref),
    [`node_labels`](@ref)
"""
struct OGBNPapers100M <: NodePropPredDataset end

struct OGBLPPA <: LinkPropPredDataset end

"""
    OGBLCollab()

`OGBLCollab` dataset contains a subset of the collaboration network between authors indexed by MAG.
The task is to predict the future author collaboration relationships given the past collaborations.

# Description

- Graph: undirected graph
- Node: author.
- Edge: the collaboration between authors.

Implements: [`graphdata`](@ref), [`train_indices`](@ref), [`valid_indices`](@ref), [`test_indices`](@ref), [`node_features`](@ref)
"""
struct OGBLCollab <: LinkPropPredDataset end

"""
    OGBLDDI()

`OGBLDDI` dataset contains the drug-drug interaction network.
The task is to predict drug-drug interactions given information on already known drug-drug
interactions.

# Description

- Graph: homogeneous, unweighted, undirected graph, representing the drug-drug interaction network.
- Node: an FDA-approved or experimental drug.
- Edge: interactions between drugs.

Implements: [`graphdata`](@ref), [`train_indices`](@ref), [`valid_indices`](@ref), [`test_indices`](@ref), [`metadata`](@ref)
"""
struct OGBLDDI <: LinkPropPredDataset end

"""
    OGBLCitation2()

`OGBLCitation2` dataset contains the citation network between a subset of papers extracted from MAG.
The task is to predict missing citations given existing citations.

# Description

- Graph: directed graph.
- Node: a paper with 128-dimensional word2vec features, which summarizes its title and abstract.
- Edge: directed edge indicates that one paper cites another.

Implements: [`graphdata`](@ref), [`train_indices`](@ref), [`valid_indices`](@ref), [`test_indices`](@ref), [`node_features`](@ref)
"""
struct OGBLCitation2 <: LinkPropPredDataset end
struct OGBLWikiKG2 <: LinkPropPredDataset end
struct OGBLBioKG <: LinkPropPredDataset end


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
dataset_name(::Type{OGBNProteins}) = "OGBN-Proteins"
dataset_name(::Type{OGBNProducts}) = "OGBN-Products"
dataset_name(::Type{OGBNArxiv}) = "OGBN-Arxiv"
# dataset_name(::Type{OGBNMag}) = "OGBN-Mag"
dataset_name(::Type{OGBNPapers100M}) = "OGBN-Papers100M"
dataset_name(::Type{OGBLPPA}) = "OGBL-PPA"
dataset_name(::Type{OGBLCollab}) = "OGBL-Collab"
dataset_name(::Type{OGBLDDI}) = "OGBL-DDI"
dataset_name(::Type{OGBLCitation2}) = "OGBL-Citation2"
dataset_name(::Type{OGBLWikiKG2}) = "OGBL-WikiKG2"
dataset_name(::Type{OGBLBioKG}) = "OGBL-BioKG"



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

function dataset_message(::Type{OGBNProteins})
    """
    The dataset contains protein-protein interaction network.
    The task to predict the presence of protein functions in a multi-label binary classification.
    Training/validation/test splits are given by node indices.

    # Description

    - Graph: undirected, weighted, and typed (according to species) graph.
    - Node: proteins.
    - Edge: different types of biologically meaningful associations
        between proteins, e.g., physical interactions, co-expression or homology.
    
    # References

    1. Damian Szklarczyk, Annika L Gable, David Lyon, Alexander Junge, Stefan Wyder,
        Jaime Huerta- Cepas, Milan Simonovic, Nadezhda T Doncheva, John H Morris, Peer Bork, et al.
        STRING v11: protein–protein association networks with increased coverage, supporting functional
        discovery in genome-wide experimental datasets. Nucleic Acids Research, 47(D1):D607–D613, 2019.
    2. Gene Ontology Consortium. The gene ontology resource: 20 years and still going strong.
        Nucleic Acids Research, 47(D1):D330–D338, 2018.
    """
end

function dataset_message(::Type{OGBNProducts})
    """
    The dataset contains an Amazon product co-purchasing network.
    The task to predict the category of a product in a multi-class classification.
    Training/validation/test splits are given by node indices.

    # Description

    - Graph: undirected and unweighted graph.
    - Node: products sold in Amazon.
    - Edge: the products are purchased together.
    
    # References

    1. http://manikvarma.org/downloads/XC/XMLRepository.html
    """
end

function dataset_message(::Type{OGBNArxiv})
    """
    The dataset contains the citation network between all Computer Science (CS) arXiv papers
    indexed by MAG.
    The task to predict the primary categories of the arXiv papers from 40 subject areas
    in a multi-class classification.
    Training/validation/test splits are given by node indices.

    # Description

    - Graph: directed graph.
    - Node: arXiv paper.
    - Edge: each directed edge indicates that one paper cites another one.
    
    # References

    1. Kuansan Wang, Zhihong Shen, Chiyuan Huang, Chieh-Han Wu, Yuxiao Dong, and Anshul Kanakia.
        Microsoft academic graph: When experts are not enough. Quantitative Science Studies,
        1(1):396–413, 2020.
    2. Tomas Mikolov, Ilya Sutskever, Kai Chen, Greg S Corrado, and Jeff Dean.
        Distributed representationsof words and phrases and their compositionality.
        In Advances in Neural Information Processing Systems (NeurIPS), pp. 3111–3119, 2013.
    """
end

# function dataset_message(::Type{OGBNMag})
#     """
#     The dataset contains a heterogeneous network composed of a subset of the Microsoft Academic Graph (MAG).
#     The task to predict the venue (conference or journal) of each paper, given its content, references,
#     authors, and authors’ affiliations, in a multi-class classification setting.
#     Training/validation/test splits are given by node indices.

#     # Description

#     - Graph: directed heterogeneous graph.
#     - Node: four types of entities.
#         - papers (736,389 nodes)
#         - authors (1,134,649 nodes)
#         - institutions (8,740 nodes)
#         - fields of study (59,965 nodes)
#     - Edge: four types of directed relations.
#         - an author is "affiliated with" an institution
#         - an author "writes" a paper
#         - a paper "cites" a paper
#         - a paper "has a topic of" a field of study
    
#     # References

#     1. Kuansan Wang, Zhihong Shen, Chiyuan Huang, Chieh-Han Wu, Yuxiao Dong, and Anshul Kanakia.
#         Microsoft academic graph: When experts are not enough. Quantitative Science Studies, 1(1):396–413, 2020.
#     """
# end

function dataset_message(::Type{OGBNPapers100M})
    """
    The dataset contains a citation graph of 111 million papers indexed by MAG.
    The task to predict the subject areas of the subset of papers that are published in arXiv
    in a multi-class classification setting.
    Training/validation/test splits are given by node indices.

    # Description

    - Graph: directed graph.
    - Node: arXiv paper.
    - Edge: each directed edge indicates that one paper cites another one.
    
    # References

    1. Kuansan Wang, Zhihong Shen, Chiyuan Huang, Chieh-Han Wu, Yuxiao Dong, and Anshul Kanakia.
        Microsoft academic graph: When experts are not enough. Quantitative Science Studies, 1(1):396–413, 2020.
    """
end

function dataset_message(::Type{OGBLPPA})
    """

    # Description

    - Graph: undirected and unweighted graph.
    - Node: proteins.
    - Edge: biologically meaningful associations between proteins, e.g., physical interactions, co-expression,
        homology or genomic neighborhood.
    
    # References
    
    1. Damian Szklarczyk, Annika L Gable, David Lyon, Alexander Junge, Stefan Wyder, Jaime Huerta- Cepas,
        Milan Simonovic, Nadezhda T Doncheva, John H Morris, Peer Bork, et al. STRING v11: protein–protein
        association networks with increased coverage, supporting functional discovery in genome-wide experimental
        datasets. Nucleic Acids Research, 47(D1):D607–D613, 2019.
    """
end

function dataset_message(::Type{OGBLCollab})
    """

    # Description

    - Graph: undirected and weighted graph.
    - Node: authors.
    - Edge: the collaboration between authors.
    
    # References
    
    1. 
    """
end

function dataset_message(::Type{OGBLDDI})
    """
    """
end

function dataset_message(::Type{OGBLCitation2})
    """
    """
end

function dataset_message(::Type{OGBLWikiKG2})
    """
    """
end

function dataset_message(::Type{OGBLBioKG})
    """
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
dataset_remote_path(::Type{OGBNProteins}) = "http://snap.stanford.edu/ogb/data/nodeproppred/proteins.zip"
dataset_remote_path(::Type{OGBNProducts}) = "http://snap.stanford.edu/ogb/data/nodeproppred/products.zip"
dataset_remote_path(::Type{OGBNArxiv}) = "http://snap.stanford.edu/ogb/data/nodeproppred/arxiv.zip"
# dataset_remote_path(::Type{OGBNMag}) = "http://snap.stanford.edu/ogb/data/nodeproppred/mag.zip"
dataset_remote_path(::Type{OGBNPapers100M}) = "http://snap.stanford.edu/ogb/data/nodeproppred/papers100M-bin.zip"
dataset_remote_path(::Type{OGBLPPA}) = "http://snap.stanford.edu/ogb/data/linkproppred/ppassoc.zip"
dataset_remote_path(::Type{OGBLCollab}) = "http://snap.stanford.edu/ogb/data/linkproppred/collab.zip"
dataset_remote_path(::Type{OGBLDDI}) = "http://snap.stanford.edu/ogb/data/linkproppred/ddi.zip"
dataset_remote_path(::Type{OGBLCitation2}) = "http://snap.stanford.edu/ogb/data/linkproppred/citation-v2.zip"
dataset_remote_path(::Type{OGBLWikiKG2}) = "http://snap.stanford.edu/ogb/data/linkproppred/wikikg-v2.zip"
dataset_remote_path(::Type{OGBLBioKG}) = "http://snap.stanford.edu/ogb/data/linkproppred/biokg.zip"


dataset_checksum(::Type{Planetoid}) = "f52b3d47f5993912d7509b51e8090b6807228c4ba8c7d906f946868005c61c18"
dataset_checksum(::Type{Cora}) = "62e054f93be00a3dedb15b7ac15a2a07168ceab68b40bf95f54d2289d024c6bc"
dataset_checksum(::Type{PPI}) = "1f5b2b09ac0f897fa6aa1338c64ab75a5473674cbba89380120bede8cddb2a6a"
dataset_checksum(::Type{Reddit}) = "9a16353c28f8ddd07148fc5ac9b57b818d7911ea0fbe9052d66d49fc32b372bf"
dataset_checksum(::Type{QM7b}) = "e2a9d670d86eba769fa7b5eadeb592184067d2ec12468b1a220bfc38502dda61"
dataset_checksum(::Type{Entities}) = "e58bcfddd240d9bbc830bcae74e9854f1f778a96d3072930395f47d3c8e6f342"
dataset_checksum(::Type{OGBNProteins}) = "1cd3113dc2a6f0c87a549332b77d78be45cf99804c254c18d9c72029164a0859"
dataset_checksum(::Type{OGBNProducts}) = "5ea0a112edaec2141c0a2a612dd4aed58df97ff3e1ab1a0ca8238f43cbbb50a8"
dataset_checksum(::Type{OGBNArxiv}) = "49f85c801589ecdcc52cfaca99693aaea7b8af16a9ac3f41dd85a5f3193fe276"
# dataset_checksum(::Type{OGBNMag}) = "2afe62ead87f2c301a7398796991d347db85b2d01c5442c95169372bf5a9fca4"
dataset_checksum(::Type{OGBNPapers100M}) = "xxx"
dataset_checksum(::Type{OGBLPPA}) = "6d2f751fee541253162ea5e777a8e0b4d95e327bc5cc0cad8536e94be541b6c8"
dataset_checksum(::Type{OGBLCollab}) = "c5563198e041c338f0a78e11322bb2eb2de76b68f0e9ae3e3b6d6af2d8ca64cc"
dataset_checksum(::Type{OGBLDDI}) = "0d0371d3dbd2d30a6801af245b226c6b25bf0dcebc6f26f162a6057d8d78d5f4"
dataset_checksum(::Type{OGBLCitation2}) = "f8502b935ea8f0a7bea5eb130991ca337cd26cad7f231cc9f5546fe076f4be53"
dataset_checksum(::Type{OGBLWikiKG2}) = "e992c627cefb1856d30435be85f28073c9214633525eea4693a66db8978c3dbd"
dataset_checksum(::Type{OGBLBioKG}) = "f20b9c4459b8ed95a0340e79bcc814dd401af46b60134ff0ca3edb93a14c488e"
