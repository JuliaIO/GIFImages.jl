
function gif_encode(filepath::AbstractString, img::AbstractArray, num::Int = 256)
    Error = Cint(0)
    gifFile = LibGif.EGifOpenFileName(filepath, 0, Ref(Error))
    colors = []

    if (gifFile == C_NULL)
        println("EGifOpenFileName() failed - ")
        return false
    end

    # generation of a colormap
    quantization!(img, num) 
    append!(colors, unique(img))

    mapping = Dict()
    for (i, j) in enumerate(colors)
        mapping[j] = UInt8(i)
    end

    # defining the global colormap
    colors = map(x -> LibGif.GifColorType(x.r, x.g, x.b), colors * 255)
    ColorMap = LibGif.GifMakeMapObject(num, colors)

    # features of the file
    gifFile.SWidth = size(img)[2]
    gifFile.SHeight = size(img)[1]
    gifFile.SColorResolution = 8
    gifFile.SBackGroundColor = 0
    gifFile.SColorMap = ColorMap

    # encoding
    for i = 1:size(img)[3]
        # flatten the image
        img1 = vec(img[:, :, i]')
        pix = map(x -> mapping[x], img1)

        # saving a new image in giffile
        desc = LibGif.GifImageDesc(0, 0, size(img)[2], size(img)[1], 0, C_NULL)
        c = LibGif.SavedImage(desc, pointer(pix), 0, C_NULL)
        LibGif.GifMakeSavedImage(gifFile, Ref(c))
    end

    # writing and closing the file
    if (LibGif.EGifSpew(gifFile) == LibGif.GIF_ERROR)
        error("Failed to write to file!")
    end
end
