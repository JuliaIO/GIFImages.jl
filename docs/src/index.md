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
- `use_localpalette::Bool=false` : While decoding, using this argument use of local colormap or global colormap for a particular slice can be specified. Gif files are palette based and have a global colormap(max `256 colors`) but slices/images in gif can have their own local colormap specific to a particular slice/image. These colormap can be used to decode a image if `use_localpalette` as `true`.

#### Examples
```jldoctest
julia> using GIFImages, Downloads

julia> path = "test/data/fire.gif"
"test/data/fire.gif"

julia> img = gif_decode(path)
60×30×33 Array{RGB{N0f8},3} with eltype RGB{N0f8}
```

---
For encoding, GIFImages.jl provides `gif_encode` which encode the GIF colorant matrix to file. 

#### Arguments
- `filepath` : Name of the file to which image is written.
- `img` : 3D GIF colorant matrix which has structure of height* width * numofimages and all the images are present as slices of the 3D matrix 
- `colormapnum` : Specifies the number of colors to be used for the global colormap

### Examples
```jldoctest
julia> using GIFImages, Downloads

julia> path = "test/data/fire.gif"
"test/data/fire.gif"

julia> img = gif_decode(path)
60×30×33 Array{RGB{N0f8},3} with eltype RGB{N0f8}

julia> gif_encode("fire.gif", img)
```

```@autodocs
Modules = [GIFImages]
```