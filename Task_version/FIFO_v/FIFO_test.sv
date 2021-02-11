`include "AHB_Lite_defines.v"

module FIFO_test();

reg HCLK, resetn;
reg hwrite;
reg [1:0] hsize;
reg [`BUS_WIDTH-1:0] hdata;
reg [`BUS_WIDTH-1:0] haddr;

FIFO fifo(HCLK, resetn);

initial begin
    HCLK = 1'b0;
    resetn = 1'b0;
end


always begin
#10 HCLK = ~HCLK;
end

initial begin
    #20 resetn = 1'b1;
end

initial begin
    #350 $finish;
end


initial begin
    
    #20
    
    @(posedge HCLK) begin
        fifo.write_in_fifo(1'b1,32'h00_00_00_01, 32'hFF, `Halfword);
    end

    @(posedge HCLK) begin
        fifo.write_in_fifo(1'b0,32'h00_00_00_02, 32'hCC, `Halfword);
    end

    @(posedge HCLK) begin
        fifo.write_in_fifo(1'b1,32'h00_00_20_00, 32'hAA, `Byte);
    end

    @(posedge HCLK) begin
        fifo.write_in_fifo(1'b0,32'h00_00_00_01, 32'hCF, `Halfword);
    end

    @(posedge HCLK) begin
        fifo.write_in_fifo(1'b1,32'h00_00_00_01, 32'hBF, `Halfword);
    end




    @(posedge HCLK) begin
        fifo.read_from_fifo(hwrite,hsize,haddr,hdata);
    end
    
    @(posedge HCLK) begin
        fifo.read_from_fifo(hwrite,hsize,haddr,hdata);
    end

    @(posedge HCLK) begin
        fifo.read_from_fifo(hwrite,hsize,haddr,hdata);
    end
    
    @(posedge HCLK) begin
        fifo.read_from_fifo(hwrite,hsize,haddr,hdata);
    end
    
    @(posedge HCLK) begin
        fifo.read_from_fifo(hwrite,hsize,haddr,hdata);
    end
    
    @(posedge HCLK) begin
        fifo.read_from_fifo(hwrite,hsize,haddr,hdata);
    end
    
    @(posedge HCLK) begin
        fifo.read_from_fifo(hwrite,hsize,haddr,hdata);
    end
    

    
end



endmodule