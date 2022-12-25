@testset "FileIO" begin
    img = testimage("cameraman")
    ref = gif_decode(gif_encode(img))
    tmpfile = File{format"GIF"}(joinpath(tmpdir, "tmp.gif"))

    GIFImages.fileio_save(tmpfile, img)
    data = GIFImages.fileio_load(tmpfile)
    @test data == ref

    open(tmpfile, "w") do s
        GIFImages.fileio_save(s, img)
    end
    data = open(tmpfile) do s
        GIFImages.fileio_load(s)
    end
    @test data == ref
end