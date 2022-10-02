
"""
    gif_decode(filepath::AbstractString; use_localpalette=false)

Decode the GIF image as colorant matrix. The source data needs to be a filename.

#### Arguments
- `filepath::AbstractString` : Path to the gif file
- `use_localpalette::Bool=false` : While decoding, using this argument use of local colormap or global colormap for a particular slice can be specified. Gif files are palette based and have a global colormap(max `256 colors`) but slices/images in gif can have their own local colormap specific to a particular slice/image.

#### Examples
```jldoctest
julia> using GIFImages, Downloads

julia> path = "test/data/fire.gif"
"test/data/fire.gif"

julia> img = gif_decode(path)
60×30×33 Array{RGB{N0f8},3} with eltype RGB{N0f8}
"""
function gif_decode(filepath::AbstractString; use_localpalette=false)
    error1 = Cint(0)
    gif = LibGif.DGifOpenFileName(filepath, Ref(error1))

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
        colormap = unsafe_load(loaded_gif.SColorMap) # global colormap
        palette = unsafe_wrap(Array, colormap.Colors, colormap.ColorCount)

        final = zeros(RGB{N0f8}, loaded_gif.SHeight, loaded_gif.SWidth, loaded_gif.ImageCount)

        # read the images
        for i = 1:img_count
            img = unsafe_wrap(Array, components[i].RasterBits, loaded_gif.SWidth * loaded_gif.SHeight)
            desc = components[i].ImageDesc
            
            @debug "Image $i at [$(desc.Left), $(desc.Top)] and size [$(desc.Width), $(desc.Height)]" * ((desc.ColorMap !=C_NULL) ? " and has a local colormap.\n" : " and doesn't have a local colormap.\n")
            
            # support for using local colormaps
            if desc.ColorMap !=C_NULL && use_localpalette == true
                localcolormap = unsafe_load(desc.ColorMap)
                @debug "Image $i : using Local ColorMap with $(localcolormap.ColorCount) colors."
                lpalette = unsafe_wrap(Array, localcolormap.Colors, localcolormap.ColorCount)
                colortypes = map(x -> lpalette[x+1], img)
            else
                colortypes = map(x -> palette[x+1], img)
            end

            
            res = map(x -> RGB{N0f8}(x.Red / 255, x.Green / 255, x.Blue / 255), colortypes)
            res = reshape(res, Int(loaded_gif.SWidth), Int(loaded_gif.SHeight))
            res = res'
            final[:, :, i] = res
        end

        # return the final matrix
        return final
    finally
        LibGif.DGifCloseFile(gif, Ref(error1))
    end
end
