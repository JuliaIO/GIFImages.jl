using GIFImages
using GIFImages.LibGif
using Test
using Downloads

_wrap(name) = "https://github.com/ashwani-rathee/gif-sampleimages/blob/main/$(name)?raw=true"
get_example(x) = Downloads.download(_wrap(x))

@testset "GIFImages.jl" begin
    @test size(gif_decode(get_example("fire.gif"))) == (60,30,33)
    @test size(gif_decode(get_example("gifgrid.gif")))== (100,100,1)
    @test size(gif_decode(get_example("porsche.gif"))) == (200,320,1)
    @test size(gif_decode(get_example("solid2.gif"))) == (400,640,1)
    @test size(gif_decode(get_example("treescap-interlaced.gif"))) == (40,40,1)
    @test size(gif_decode(get_example("treescap.gif"))) == (40,40,1)
    @test size(gif_decode(get_example("welcome2.gif"))) == (48,290,6)
    @test size(gif_decode(get_example("x-trans.gif"))) == (100,100,1)
end