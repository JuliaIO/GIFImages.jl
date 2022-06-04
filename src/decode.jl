using ColorTypes
using ColorVectorSpace
using FixedPointNumbers
using FileIO

function gif_decode(path)
    Error = Cint(0)
    gif = LibGif.DGifOpenFileName(path, Ref(Error))

    if (gif == C_NULL) 
        println("Failed to open .gif, return error with type \n")
        return false;
    end

    slurpReturn = LibGif.DGifSlurp(gif)
    if (slurpReturn != LibGif.GIF_OK)
        println("Failed to read .gif file")
        return false
    end


    N = unsafe_load(gif)
    components = unsafe_wrap(Array, N.SavedImages, N.ImageCount)
    final = []
    for i in 1:N.ImageCount
        #erro handling for this
        img = unsafe_wrap(Array, components[i].RasterBits, N.SWidth * N.SHeight) 
        # get type of colorspace n make it all fast by doing it all in cpp
        res = reinterpret(Gray{N0f8}, img)

        res = reshape(res, Int64(N.SWidth), Int64(N.SHeight))
        res =  res'
        push!(final, res)
    end

    # too many opened files issue
    # error handling issue in error here
    LibGif.EGifCloseFile(gif, Ref(Error));
    return final
end