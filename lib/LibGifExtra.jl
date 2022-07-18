module LibGifExtra

using libgifextra_jll
export libgifextra_jll

using CEnum

function LoadRGB(FileName, InFileName, OneFileFlag, RedBuffer, GreenBuffer, BlueBuffer, Width, Height)
    ccall((:LoadRGB, libgifextra), Cvoid, (Ptr{Cchar}, Ptr{Cchar}, Cint, Ptr{Ptr{Cint}}, Ptr{Ptr{Cint}}, Ptr{Ptr{Cint}}, Cint, Cint), FileName, InFileName, OneFileFlag, RedBuffer, GreenBuffer, BlueBuffer, Width, Height)
end

function GIF2RGB(NumFiles, FileName, OneFileFlag, OutFileName)
    ccall((:GIF2RGB, libgifextra), Cvoid, (Cint, Ptr{Cchar}, Bool, Ptr{Cchar}), NumFiles, FileName, OneFileFlag, OutFileName)
end

function DumpScreen2RGB(FileName, OneFileFlag, ColorMap, ScreenBuffer, ScreenWidth, ScreenHeight)
    ccall((:DumpScreen2RGB, libgifextra), Cvoid, (Ptr{Cchar}, Cint, Ptr{Cint}, Ptr{Cint}, Cint, Cint), FileName, OneFileFlag, ColorMap, ScreenBuffer, ScreenWidth, ScreenHeight)
end

function RGB2GIF(OneFileFlag, NumFiles, FileName, InFileName, ExpNumOfColors, Width, Height)
    ccall((:RGB2GIF, libgifextra), Cvoid, (Bool, Cint, Ptr{Cchar}, Ptr{Cchar}, Cint, Cint, Cint), OneFileFlag, NumFiles, FileName, InFileName, ExpNumOfColors, Width, Height)
end

function SaveGif(FileName, OutputBuffer, Width, Height, ExpColorMapSize, OutputColorMap)
    ccall((:SaveGif, libgifextra), Cvoid, (Ptr{Cchar}, Ptr{Cint}, Cint, Cint, Cint, Ptr{Cint}), FileName, OutputBuffer, Width, Height, ExpColorMapSize, OutputColorMap)
end

function returnGIF(FileName)
    ccall((:returnGIF, libgifextra), Ptr{Cint}, (Ptr{Cchar},), FileName)
end

end # module