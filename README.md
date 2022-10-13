

![Link](https://s4.gifyu.com/images/GIFImages.jl-1.gif)

---
GIFImages.jl provides support for decoding and encoding GIF images by wrapping LibGif. GIF(Graphics Interchange Format) supports up to 8 bits per pixel for each image, allowing a single image to reference its own palette of up to 256 different colors chosen from the 24-bit RGB color space. It also supports animations and allows a separate palette which are known as local colormap of up to 256 colors for each frame. GIF is palette based, is very widely used and is a loseless data compression format.

[![Docs-dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://ashwani-rathee.github.io/GIFImages.jl) [![Slack](https://img.shields.io/badge/chat-slack-e01e5a)](https://join.slack.com/t/julialang/shared_invite/zt-1hxxb5ryp-Ts_egJ7FRN2muQ7nkTtCNQ) [![License: MIT](https://img.shields.io/badge/License-MIT-success.svg)](https://opensource.org/licenses/MIT) [![Downloads](https://shields.io/endpoint?url=https://pkgs.genieframework.com/api/v1/badge/GIFImages)](https://pkgs.genieframework.com?packages=GIFImages)

### Installation

If you have not yet installed Julia, please follow the [instructions](https://julialang.org/downloads/platform/) for your operating system. 

Stable Version
```julia
# Enter ']' from the REPL to enter Pkg mode.
pkg> add GIFImages.jl
```

Dev Version
```julia
using Pkg
# Enter ']' from the REPL to enter Pkg mode.
pkg> add https://github.com/ashwani-rathee/GIFImages.jl.git
```

### Usage 
For decoding purposes, GIFImages.jl currently supports `gif_decode` which 
decode the GIF image as colorant matrix. The source data needs to be a filename.

#### Arguments
- `filepath::AbstractString` : Path to the gif file
- `use_localpalette::Bool=false` : While decoding, using this argument use of local colormap or global colormap for a particular slice can be specified. Gif files are palette based and have a global colormap(max `256 colors`) but slices/images in gif can have their own local colormap specific to a particular slice/image. These colormap can be used to decode a image if `use_localpalette` as `true`.

#### Examples
```jl
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

#### Examples
```jl
julia> using GIFImages, Downloads

julia> path = "test/data/fire.gif"
"test/data/fire.gif"

julia> img = gif_decode(path)
60×30×33 Array{RGB{N0f8},3} with eltype RGB{N0f8}

julia> gif_encode("fire.gif", img)
```

### Contributions and Issues:

If you have questions about GIFImages.jl, feel free to get in touch via Slack or open an issue :hearts: