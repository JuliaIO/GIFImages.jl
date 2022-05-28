using GIFImages
using Documenter

format = Documenter.HTML(
    prettyurls = get(ENV, "CI", nothing) == "true"
)

makedocs(;
    modules=[GIFImages],
    sitename="GIFImages.jl",
    format=format,
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ashwani-rathee/GIFImages.jl",
    devbranch="master",
)