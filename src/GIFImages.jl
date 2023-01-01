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
using HistogramThresholding
using DataStructures
using ImageCore


include("decode.jl")
include("encode.jl")
include("fileio.jl")
include("quantizers.jl")

export gif_decode, gif_encode
export mediancutquantisation, mediancutquantisation!
export octreequantisation, octreequantisation!
export kdtreequantisation, kdtreequantisation!

end # module
