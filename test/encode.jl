using ImageQualityIndexes
@testset "Encoding" begin
    
    @testset "Basic Encoding" begin
        img1 = gif_decode(get_example("fire.gif"))
        gif_encode("test1.gif", img1)
        @test size(gif_decode("test1.gif")) == (60,30,33)
        
        img1 = gif_decode(get_example("gifgrid.gif"))
        gif_encode("test1.gif", img1)
        @test size(gif_decode("test1.gif")) == (100,100,1)
    end

    @testset "Encode, Decode compatibility" begin
        QUALITY = 100
        # ensure encodes are same as what was decoded
        img = gif_decode(get_example("fire.gif"))
        gif_encode("test12.gif", img)
        @test assess_psnr(gif_decode("test12.gif"), img) > QUALITY

        img = gif_decode(get_example("gifgrid.gif"))
        gif_encode("test12.gif", img)
        @test assess_psnr(gif_decode("test12.gif"), img) > QUALITY

        img = gif_decode(get_example("porsche.gif"))
        gif_encode("test12.gif", img)
        @test assess_psnr(gif_decode("test12.gif"), img) > QUALITY

        img = gif_decode(get_example("solid2.gif"))
        gif_encode("test12.gif", img)
        @test assess_psnr(gif_decode("test12.gif"), img) > QUALITY

        img = gif_decode(get_example("treescap-interlaced.gif"))
        gif_encode("test12.gif", img)
        @test assess_psnr(gif_decode("test12.gif"), img) > QUALITY

        img = gif_decode(get_example("treescap.gif"))
        gif_encode("test12.gif", img)
        @test assess_psnr(gif_decode("test12.gif"), img) > QUALITY

        img = gif_decode(get_example("welcome2.gif"))
        gif_encode("test12.gif", img)
        @test assess_psnr(gif_decode("test12.gif"), img) > QUALITY

        img = gif_decode(get_example("x-trans.gif"))
        gif_encode("test12.gif", img)
        @test assess_psnr(gif_decode("test12.gif"), img) > QUALITY
    end

    # restricting colorspace to RGB for now
    @testset "ColorSpaces" begin
        img = BGR.(gif_decode(get_example("x-trans.gif")))
        @test_throws ErrorException gif_encode("test12.gif", img)
    end

    @testset "Other Exceptions" begin
        # colormap number out of range
        img = gif_decode(get_example("x-trans.gif"))
        @test_throws BoundsError gif_encode("test12.gif", img; colormapnum= 270)

        # dimension error
        img = testimage("mandrill")
        @test_throws DimensionMismatch gif_encode("test12.gif", img)

        img = gif_decode(get_example("welcome2.gif"))
        @test_throws ErrorException gif_encode("", img)
    end
end