`include "AHB_Lite_defines.v"

module AHB_Lite_decoder(HADDR, HSEL0, HSEL1, HSEL2, HSEL3);

//parameter addr_size = 4;  



input [`BUS_WIDTH-1:0] HADDR;
output reg HSEL0, HSEL1, HSEL2, HSEL3;

//wire addr[addr_size-1:0] = HADDR[`BUS_WIDTH-1:`BUS_WIDTH-addr_size];

wire [3:0]  addr= HADDR[31:28]; 

always @(*) begin
    casex(addr)
    4'h_0: begin
                      HSEL0 <= 1'b1;
                      HSEL1 <= 1'b0;
                      HSEL2 <= 1'b0;
                      HSEL3 <= 1'b0;
                      end

    4'h_1: begin
                      HSEL0 <= 1'b0;
                      HSEL1 <= 1'b1;
                      HSEL2 <= 1'b0;
                      HSEL3 <= 1'b0;
                      end

    
    4'h_2: begin
                      HSEL0 <= 1'b0;
                      HSEL1 <= 1'b0;
                      HSEL2 <= 1'b1;
                      HSEL3 <= 1'b0;
                      end
    
    
    4'h_3: begin
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