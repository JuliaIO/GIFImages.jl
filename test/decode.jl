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
end