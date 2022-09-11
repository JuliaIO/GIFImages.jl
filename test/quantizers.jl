@testset "Quantizers" begin
    
    @testset "Median Cut Color Quantizer" begin
        img = gif_decode(get_example("fire.gif"))
        @test length(unique(mediancut(img, 5))) == 16

        # test on different color ColorTypes

        # test on unique colors less than asked amount 
    end

    @testset "Octree Color Quantizer" begin
        img = gif_decode(get_example("fire.gif"))
        octreequantisation!(img; numcolors=120)
        @test length(unique(img)) == 120 
    end
end