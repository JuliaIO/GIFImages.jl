@testset "Quantizers" begin
    
    @testset "Median Cut Color Quantizer" begin
        #known issue
        # this has some issues with number of colors generated
        img = gif_decode(get_example("fire.gif")) # cuz this has less number of colors
        @test length(unique(mediancutquantisation(img; numcolors=32))) == 16

        # images with ample number of distinct colors
        img = testimage("mandrill")
        @test length(unique(mediancutquantisation(img; numcolors=256))) == 256

        # test on different color ColorTypes
        img = BGR.(testimage("mandrill"))
        @test_throws ErrorException mediancutquantisation(img; numcolors=256)

        # test on unique colors less than asked amount 
        img = gif_decode(get_example("fire.gif"))
        mediancutquantisation!(img; numcolors=256, precheck = true)
        @test length(unique(img)) == 231
    end

    @testset "Octree Color Quantizer" begin
        img = gif_decode(get_example("fire.gif"))
        octreequantisation!(img; numcolors=120)
        @test length(unique(img)) == 120 

        img = gif_decode(get_example("fire.gif"))
        octreequantisation!(img; numcolors=256, precheck = true)
        @test length(unique(img)) == 231


        img = BGR.(testimage("mandrill"))
        @test_throws ErrorException octreequantisation(img; numcolors=256)
    end

    @testset "KDtree Color Quantizer" begin
        img = gif_decode(get_example("fire.gif"))
        kdtreequantisation!(img; numcolors=32)
        @test length(unique(img)) == 32

        img = gif_decode(get_example("fire.gif"))
        kdtreequantisation!(img; numcolors=256, precheck = true)
        @test length(unique(img)) == 231
        
        # has around 15k colors n color quantiser brings it to 256 
        img = testimage("mandrill")
        kdtreequantisation!(img; numcolors=256)
        @test length(unique(img)) == 256

        img = testimage("mandrill")
        palette = kdtreequantisation!(img; numcolors=256)
        @test length(palette) == 256
        @test eltype(palette) == RGB{N0f8}

        img = testimage("mandrill")
        img_copy, palette = kdtreequantisation(img; numcolors=256)
        @test length(palette) == 256
        @test eltype(palette) == RGB{N0f8}

        img = BGR.(testimage("mandrill"))
        @test_throws ErrorException kdtreequantisation(img; numcolors=256)
    end
end