`include "AHB_Lite_defines.v"

module AHB_Lite_decoder(HADDR, HSEL0, HSEL1, HSEL2, HSEL3);

input [`BUS_WIDTH-1:0] HADDR;
output reg HSEL0, HSEL1, HSEL2, HSEL3;



always @(*) begin
    casex(HADDR)
    32'h_0?_??_??_??: begin
                      HSEL0 <= 1'b1;
                      HSEL1 <= 1'b0;
                      HSEL2 <= 1'b0;
                      HSEL3 <= 1'b0;
                      end

    32'h_1?_??_??_??: begin
                      HSEL0 <= 1'b0;
                      HSEL1 <= 1'b1;
                      HSEL2 <= 1'b0;
                      HSEL3 <= 1'b0;
                      end

    
    32'h_2?_??_??_??: begin
                      HSEL0 <= 1'b0;
                      HSEL1 <= 1'b0;
                      HSEL2 <= 1'b1;
                      HSEL3 <= 1'b0;
                      end
    
    
    32'h_3?_??_??_??: begin
                      HSEL0 <= 1'b0;
                      HSEL1 <= 1'b0;
                      HSEL2 <= 1'b0;
                      HSEL3 <= 1'b1;
                      end

    default:          begin
                      HSEL0 <= 1'b0;
                      HSEL1 <= 1'b0;
                      HSEL2 <= 1'b0;
                      HSEL3 <= 1'b0;
                      end
    endcase    
end


endmodule