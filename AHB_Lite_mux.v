module AHB_Lite_mux(HADDR, HRDATA, HRESP, HREADY, HRDATA0, HRESP0, HREADYOUT0,  HRDATA1, HRESP1, HREADYOUT1,  HRDATA2, HRESP2, HREADYOUT2,  HRDATA3, HRESP3, HREADYOUT3);

input  [`BUS_WIDTH-1:0] HADDR;
output reg [`BUS_WIDTH-1:0] HRDATA;
output reg HRESP;
output reg HREADY;

input [`BUS_WIDTH-1:0] HRDATA0, HRDATA1, HRDATA2, HRDATA3;
input HRESP0, HRESP1, HRESP2, HRESP3;
input HREADYOUT0, HREADYOUT1, HREADYOUT2, HREADYOUT3;


always @(*) begin
    
    casex (HADDR)
    32'h_0?_??_??_??: begin
                      HRDATA <= HRDATA0;
                      HRESP  <= HRESP0;
                      HREADY <= HREADYOUT0;
                      end

    32'h_1?_??_??_??: begin
                      HRDATA <= HRDATA1;
                      HRESP  <= HRESP1;
                      HREADY <= HREADYOUT1;
                      end

    
    32'h_2?_??_??_??: begin
                      HRDATA <= HRDATA2;
                      HRESP  <= HRESP2;
                      HREADY <= HREADYOUT2;
                      end
    
    
    32'h_3?_??_??_??: begin
                      HRDATA <= HRDATA3;
                      HRESP  <= HRESP3;
                      HREADY <= HREADYOUT3;
                      end

    default:          begin
                      HRDATA <= 32'hx;
                      HRESP  <= 32'hx;
                      HREADY <= 32'hx;
                      end
    endcase


end

endmodule