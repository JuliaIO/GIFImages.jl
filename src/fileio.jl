using FileIO

function fileio_load(f::File{format"GIF"}; kwargs...)
    open(f.filename, "r") do io
        gif_decode(io; kwargs...)
    end
end
fileio_load(io::Stream{format"GIF"}; kwargs...) = gif_decode(read(io); kwargs...)

function fileio_save(f::File{format"GIF"}, img::AbstractArray; kwargs...)
    open(f.filename, "w") do io
        gif_encode(io, img; kwargs...)
    end
end