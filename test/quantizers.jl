@testset "Quantizers" begin
    
    @testset "Median Cut Color Quantizer" begin

        # this has some issues with number of colors generated
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

    @testset "KDtree Color Quantizer" begin
        img = gif_decode(get_example("fire.gif"))
        kdtreequantisation!(img; numcolors=32)
        @test length(unique(img)) == 32

        # has around 15k colors n color quantiser brings it to 256 
        img = testimage("mandrill")
        kdtreequantisation!(img; numcolors=256)
        @test length(unique(img)) == 256
    end
end