using GraphMLDatasets
using Documenter

makedocs(;
    modules=[GraphMLDatasets],
    authors="Yueh-Hua Tu",
    repo="https://github.com/yuehhua/GraphMLDatasets.jl/blob/{commit}{path}#L{line}",
    sitename="GraphMLDatasets.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://yuehhua.github.io/GraphMLDatasets.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/yuehhua/GraphMLDatasets.jl",
)
