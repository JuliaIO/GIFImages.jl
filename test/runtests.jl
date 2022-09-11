using GIFImages
using GIFImages.LibGif
using Test
using Downloads
using ColorTypes
using FixedPointNumbers

_wrap(name) = "https://github.com/ashwani-rathee/gif-sampleimages/blob/main/$(name)?raw=true"
get_example(x) = Downloads.download(_wrap(x))

include("decode.jl")
include("encode.jl")
include("quantizers.jl")