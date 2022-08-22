module GIFImages

include("../lib/LibGif.jl")
include("../lib/LibGifExtra.jl")

using .LibGif
using .LibGifExtra

include("decode.jl")

export gif_decode


end # module
