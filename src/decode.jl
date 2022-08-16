using ColorTypes
using ColorVectorSpace
using FixedPointNumbers
using FileIO

"""
    gif_decode(filepath::AbstractString)

Decode the GIF image as colorant matrix. The source data needs to be a filename.

#### Arguments
- `filepath::AbstractString` : Path to the gif file

#### Examples
```jldoctest
julia> using GIFImages, Downloads

julia> path = "test/data/fire.gif"
"test/data/fire.gif"

julia> img = gif_decode(path)
60×30×33 Array{RGB{N0f8},3} with eltype RGB{N0f8}
"""
function gif_decode(filepath::AbstractString)
    Error = Cint(0)
    gif = LibGif.DGifOpenFileName(filepath, Ref(Error))

    try
        gif == C_NULL && error("failed to open the gif file: null pointer")
        slurpReturn = LibGif.DGifSlurp(gif)

        if (slurpReturn != LibGif.GIF_OK)
            println("Failed to read .gif file")
            return false
        end
        N = unsafe_load(gif)
        components = unsafe_wrap(Array, N.SavedImages, N.ImageCount)
        d = unsafe_load(N.SColorMap)
        palette = unsafe_wrap(Array, d.Colors, d.ColorCount)
        final = zeros(RGB{N0f8}, N.SHeight, N.SWidth, N.ImageCount)
        for i = 1:N.ImageCount
            #erro handling for this
            img = unsafe_wrap(Array, components[i].RasterBits, N.SWidth * N.SHeight)
            colortypes = map(x -> palette[x+1], img)
            res = map(x -> RGB{N0f8}(x.Red / 255, x.Green / 255, x.Blue / 255), colortypes)
            res = reshape(res, Int(N.SWidth), Int(N.SHeight))
            res = res'
            final[:, :, i] = res
        end
        return final
    finally
        # too many opened files issue
        # error handling issue in error here
        LibGif.EGifCloseFile(gif, Ref(Error))
    end
end
