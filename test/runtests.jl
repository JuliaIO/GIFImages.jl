using GIFImages
using GIFImages.LibGif
using Test
using Downloads
using ColorTypes
using FixedPointNumbers
using TestImages

_wrap(name) = "https://github.com/ashwani-rathee/gif-sampleimages/blob/main/$(name)?raw=true"
get_example(x) = Downloads.download(_wrap(x))

include("decode.jl")
include("encode.jl")
# include("fileio.jl")
include("quantizers.jl")