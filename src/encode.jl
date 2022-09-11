

"""
    gif_encode(filepath::AbstractString, img::AbstractArray; num::Int = 64)

Encode the GIF colorant matrix to file. 

#### Arguments
- `filepath` : Name of the file to which image is written.
- `img` : 3D GIF colorant matrix which has structure of height*width*numofimags and all the images are present as slices of the 3D matrix 
- `colormapnum` : Specifies the number of colors to be used for the global colormap

### Examples
```jldoctest
julia> using GIFImages, Downloads

julia> path = "test/data/fire.gif"
"test/data/fire.gif"

julia> img = gif_decode(path)
60×30×33 Array{RGB{N0f8},3} with eltype RGB{N0f8}

julia> gif_encode("fire.gif", img)
```
"""
function gif_encode(filepath::AbstractString, img::AbstractArray; colormapnum::Int = 256)
    error = Cint(0)
    gif_file = LibGif.EGifOpenFileName(filepath, 0, Ref(error))
    colors = []

    gif_file == C_NULL && error("EGifOpenFileName() failed to open the gif file: null pointer")
    
    # checks if colormapnum is in valid range
    if (colormapnum < 1 || colormapnum > 256)
        error("colormapnum is out of range and needs to be in range 1-256(both inclusive)")
    end

    # generation of a colormap
    palette = octreequantisation!(img; numcolors=colormapnum, return_palette=true)
    append!(colors, palette)

    mapping = Dict()
    for (i, j) in enumerate(colors)
        mapping[j] = UInt8(i)
    end

    # defining the global colormap
    colors = map(x -> LibGif.GifColorType(x.r, x.g, x.b), colors * 255)
    colormap = LibGif.GifMakeMapObject(colormapnum, colors)

    # features of the file
    gif_file.SWidth = size(img)[2]
    gif_file.SHeight = size(img)[1]
    gif_file.SColorResolution = 8
    gif_file.SBackGroundColor = 0
    gif_file.SColorMap = colormap
    
    # encoding
    for i = 1:size(img)[3]
        # flatten the image
        img1 = vec(img[:, :, i]')
        pix = map(x -> mapping[x], img1)

        # saving a new image in gif_file
        desc = LibGif.GifImageDesc(0, 0, size(img)[2], size(img)[1], 0, C_NULL)
        c = LibGif.SavedImage(desc, pointer(pix), 0, C_NULL)
        LibGif.GifMakeSavedImage(gif_file, Ref(c))
    end

    # writing and closing the file
    if (LibGif.EGifSpew(gif_file) == LibGif.GIF_ERROR)
        error("Failed to write to file!")
    end
end