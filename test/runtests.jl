using GIFImages
using GIFImages.LibGif
using Test
using Downloads

_wrap(name) = "https://github.com/ashwani-rathee/gif-sampleimages/blob/main/$(name)?raw=true"
get_example(x) = Downloads.download(_wrap(x))

@testset "GIFImages.jl" begin
    @test size(gif_decode(get_example("fire.gif")))[1] == 33
    @test size(gif_decode(get_example("gifgrid.gif")))[1] == 1
    @test size(gif_decode(get_example("porsche.gif")))[1] == 1
    @test size(gif_decode(get_example("solid2.gif")))[1] == 1
    @test size(gif_decode(get_example("treescap-interlaced.gif")))[1] == 1
    @test size(gif_decode(get_example("treescap.gif")))[1] == 1
    @test size(gif_decode(get_example("welcome2.gif")))[1] == 6
    @test size(gif_decode(get_example("x-trans.gif")))[1] == 1


    @test size(gif_decode(get_example("fire.gif"))[1]) == (60, 30)
    @test size(gif_decode(get_example("gifgrid.gif"))[1]) == (100, 100)
    @test size(gif_decode(get_example("porsche.gif"))[1]) == (200, 320)
    @test size(gif_decode(get_example("solid2.gif"))[1]) == (400, 640)
    @test size(gif_decode(get_example("treescap-interlaced.gif"))[1]) == (40, 40)
    @test size(gif_decode(get_example("treescap.gif"))[1]) ==(40, 40)
    @test size(gif_decode(get_example("welcome2.gif"))[1]) == (48, 290)
    @test size(gif_decode(get_example("x-trans.gif"))[1]) == (100, 100)

end