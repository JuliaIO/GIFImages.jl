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
        # ensure encodes are same as what was decoded

        # major issue here
    end
end