push!(LOAD_PATH,"../src/")
using GIFImages
using Documenter

DocMeta.setdocmeta!(GIFImages, :DocTestSetup, :(using GIFImages); recursive=true)

makedocs(;
    modules=[GIFImages],
    authors="Ashwani Rathee",
    repo="github.com/ashwani-rathee/GIFImages.jl/blob/{commit}{path}#{line}",
    sitename="GIFImages.jl",
    format=Documenter.HTML(;
        prettyurls=Base.get(ENV, "CI", "false") == "true",
        canonical="https://ashwani-rathee.github.io/GIFImages.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ashwani-rathee/GIFImages.jl",
    devbranch="main",
    push_preview = true
) 