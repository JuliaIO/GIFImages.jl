```@meta
CurrentModule = GIFImages
```

# GIFImages

This is the documentation for [GIFImages](https://github.com/ashwani-rathee/GIFImages.jl).

GIFImages.jl provides support for decoding and encoding GIF images.

# Usage 
For decoding purposes, GIFImages.jl currently supports `gif_decode` which 
decode the GIF image as colorant matrix. The source data needs to be a filename.

#### Arguments
- `filepath::AbstractString` : Path to the gif file
- `use_localpalette::Bool=true` : While decoding, using this argument use of local color map or global color map can be specified

#### Examples
```jldoctest
julia> using GIFImages, Downloads

julia> path = "test/data/fire.gif"
"test/data/fire.gif"

julia> img = gif_decode(path)
60×30×33 Array{RGB{N0f8},3} with eltype RGB{N0f8}
```

```@autodocs
Modules = [GIFImages]
```