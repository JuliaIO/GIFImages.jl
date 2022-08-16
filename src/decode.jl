using ColorTypes
using ColorVectorSpace
using FixedPointNumbers
using FileIO

function gif_decode(path)
    Error = Cint(0)
    gif = LibGif.DGifOpenFileName(path, Ref(Error))
    final = []
    try
        gif == C_NULL && error("failed to open the gif file: null pointer")
        slurpReturn = LibGif.DGifSlurp(gif)
        if (slurpReturn != LibGif.GIF_OK)
            println("Failed to read .gif file")
            return false
        end


        N = unsafe_load(gif)
        components = unsafe_wrap(Array, N.SavedImages, N.ImageCount)
        
        for i in 1:N.ImageCount
            #erro handling for this
            img = unsafe_wrap(Array, components[i].RasterBits, N.SWidth * N.SHeight) 
            # get type of colorspace n make it all fast by doing it all in cpp
            res = reinterpret(Gray{N0f8}, img)

            res = reshape(res, Int(N.SWidth), Int(N.SHeight))
            res =  res'
            push!(final, res)
        end
    finally
        # too many opened files issue
        # error handling issue in error here
        LibGif.EGifCloseFile(gif, Ref(Error));
    end
    return final
end