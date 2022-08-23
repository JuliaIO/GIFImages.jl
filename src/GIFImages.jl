module GIFImages

include("../lib/LibGif.jl")
include("../lib/LibGifExtra.jl")

using .LibGif
using .LibGifExtra
using ColorTypes
using ColorVectorSpace
using FixedPointNumbers
using FileIO
using Noise

include("decode.jl")
include("encode.jl")

export gif_decode, gif_encode

end # module
