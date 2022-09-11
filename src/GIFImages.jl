module GIFImages

include("../lib/LibGif.jl")
include("../lib/LibGifExtra.jl")

using .LibGif
using .LibGifExtra
using ColorTypes
using ColorVectorSpace
using FixedPointNumbers
using StatsBase
using RegionTrees, StaticArrays


include("decode.jl")
include("encode.jl")
include("quantizers.jl")

export gif_decode, gif_encode
export split_buckets, mediancut!, mediancut
export octreequantisation, octreequantisation!

end # module
