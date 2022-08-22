using ColorTypes
using ColorVectorSpace
using FixedPointNumbers
using FileIO

"""
    gif_decode(filepath::AbstractString; info = false)

Decode the GIF image as colorant matrix. The source data needs to be a filename.

#### Arguments
- `filepath::AbstractString` : Path to the gif file
- `info::Bool` : Describes presence of local color map and description of a image

#### Examples
```jldoctest
julia> using GIFImages, Downloads

julia> path = "test/data/fire.gif"
"test/data/fire.gif"

julia> img = gif_decode(path)
60×30×33 Array{RGB{N0f8},3} with eltype RGB{N0f8}
"""
function gif_decode(filepath::AbstractString; info = false)
    error = Cint(0)
    gif = LibGif.DGifOpenFileName(filepath, Ref(error))

    try
        gif == C_NULL && error("failed to open the gif file: null pointer")
        slurp_return = LibGif.DGifSlurp(gif)

        if (slurp_return == LibGif.GIF_ERROR)
            error("failed to read .gif file")
        end

        loaded_gif = unsafe_load(gif)

        img_count = loaded_gif.ImageCount
        components = unsafe_wrap(Array, loaded_gif.SavedImages, loaded_gif.ImageCount)

        # Gif's are palette based and can have upto 256 colors in a image
        colormap = unsafe_load(loaded_gif.SColorMap)
        palette = unsafe_wrap(Array, colormap.Colors, colormap.ColorCount)

        final = zeros(RGB{N0f8}, loaded_gif.SHeight, loaded_gif.SWidth, loaded_gif.ImageCount)

        # read the images
        for i = 1:img_count
            img = unsafe_wrap(Array, components[i].RasterBits, loaded_gif.SWidth * loaded_gif.SHeight)
            desc = components[i].ImageDesc
            if info == true
                print("Image $i at [$(desc.Left), $(desc.Top)] and size [$(desc.Width), $(desc.Height)]")
                (desc.ColorMap !=C_NULL) ? print(" and has a local colormap.\n") : print(" and doesn't have a local colormap.\n")
            end
             # add support for working with local colormaps
            
            colortypes = map(x -> palette[x+1], img)
            res = map(x -> RGB{N0f8}(x.Red / 255, x.Green / 255, x.Blue / 255), colortypes)
            res = reshape(res, Int(loaded_gif.SWidth), Int(loaded_gif.SHeight))
            res = res'
            final[:, :, i] = res
        end

        # return the final matrix
        return final
    finally
        LibGif.DGifCloseFile(gif, Ref(error))
    end
end
