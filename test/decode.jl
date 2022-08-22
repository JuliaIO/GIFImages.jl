@testset "GIFImages.jl" begin

    path = get_example("fire.gif")
    @testset "Basics" begin
        @test typeof(gif_decode(path)) == Array{ColorTypes.RGB{FixedPointNumbers.N0f8}, 3}
        @test eltype(gif_decode(path)) == ColorTypes.RGB{FixedPointNumbers.N0f8}

    end

    @testset "Output Shapes" begin
        @test size(gif_decode(get_example("fire.gif"))) == (60,30,33)
        @test size(gif_decode(get_example("gifgrid.gif")))== (100,100,1)
        @test size(gif_decode(get_example("porsche.gif"))) == (200,320,1)
        @test size(gif_decode(get_example("solid2.gif"))) == (400,640,1)
        @test size(gif_decode(get_example("treescap-interlaced.gif"))) == (40,40,1)
        @test size(gif_decode(get_example("treescap.gif"))) == (40,40,1)
        @test size(gif_decode(get_example("welcome2.gif"))) == (48,290,6)
        @test size(gif_decode(get_example("x-trans.gif"))) == (100,100,1)
    end

    @testset "Local ColorMaps" begin
        img1 = gif_decode(get_example("welcome2.gif"); use_localpalette=true)
        img2 = gif_decode(get_example("welcome2.gif"))

        @test img1 != img2

        # only certain images in welcome2.gif have local palette
        # need to ensure the global and local color palettes are maintained separately
        @test img1[:,:,1] == img1[:,:,1]
        @test img1[:,:,2] == img1[:,:,2]
        @test img1[:,:,3] == img1[:,:,3]
    end
end