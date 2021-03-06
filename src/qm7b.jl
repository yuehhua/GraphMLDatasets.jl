qm7b_init() = register(DataDep(
    "QM7b",
    """
    The QM7b dataset from the `"MoleculeNet: A Benchmark for Molecular
    Machine Learning" <https://arxiv.org/abs/1703.00564>`_ paper, consisting of
    7,211 molecules with 14 regression targets.
    """,
    "http://deepchem.io.s3-website-us-west-1.amazonaws.com/datasets/qm7b.mat",
    "e2a9d670d86eba769fa7b5eadeb592184067d2ec12468b1a220bfc38502dda61";
    post_fetch_method=preprocess_qm7b,
))

function preprocess_qm7b(local_path)
    vars = matread(local_path)
    names = vars["names"]
    X = vars["X"]
    T = Matrix{Float32}(vars["T"])
    raw = Dict(:names=>names, :X=>X, :T=>T)

    rawfile = replace(local_path, "qm7b.mat"=>"qm7b.raw.jld2")
    @save rawfile raw
end

struct QM7b <:Dataset end

function rawdata(::QM7b)
    file = datadep"QM7b/qm7b.raw.jld2"
    @load file raw
    raw
end
