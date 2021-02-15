`include "AHB_Lite_defines.sv"

module AHB_Lite_mux(HCLK, HRESETn, HSEL0, HSEL1, HSEL2, HSEL3, HRDATA, HRESP, HREADY, HRDATA0, HRESP0, HREADYOUT0,  HRDATA1, HRESP1, HREADYOUT1,  HRDATA2, HRESP2, HREADYOUT2,  HRDATA3, HRESP3, HREADYOUT3);

input HCLK;
input HRESETn;

input  HSEL0, HSEL1, HSEL2, HSEL3;
output reg [`BUS_WIDTH-1:0] HRDATA;
output reg HRESP;
output reg HREADY;

input [`BUS_WIDTH-1:0] HRDATA0, HRDATA1, HRDATA2, HRDATA3;
input HRESP0, HRESP1, HRESP2, HRESP3;
input HREADYOUT0, HREADYOUT1, HREADYOUT2, HREADYOUT3;


localparam SLAVE0 = 4'b0001;
localparam SLAVE1 = 4'b0010;
localparam SLAVE2 = 4'b0100;
localparam SLAVE3 = 4'b1000;



wire [3:0] hsel = {HSEL3, HSEL2, HSEL1, HSEL0};
reg  [3:0] hsel_reg;


always @(posedge HCLK, negedge HRESETn) begin
    if(~HRESETn)
        hsel_reg <= 4'h0;
    else
        hsel_reg <= hsel;
end


//HREADY control
always @(hsel_reg, HREADYOUT0, HREADYOUT1, HREADYOUT2, HREADYOUT3) begin
    case(hsel_reg) 
        SLAVE0: HREADY <= HREADYOUT0;
        SLAVE1: HREADY <= HREADYOUT1;
        SLAVE2: HREADY <= HREADYOUT2;
        SLAVE3: HREADY <= HREADYOUT3;
        default: HREADY = 1'b1;
    endcase
end



//DATA control
always @(hsel_reg, HRDATA0, HRDATA1, HRDATA2, HRDATA3) begin
    case(hsel_reg) 
        SLAVE0: HRDATA <= HRDATA0;
        SLAVE1: HRDATA <= HRDATA1;
        SLAVE2: HRDATA <= HRDATA2;
        SLAVE3: HRDATA <= HRDATA3;
        default: HRDATA = 32'b0;
    endcase
end



//Response control
always @(hsel_reg, HRESP0, HRESP1, HRESP2, HRESP3) begin
    case(hsel_reg) 
        SLAVE0: HRESP <= HRESP0;
        SLAVE1: HRESP <= HRESP1;
        SLAVE2: HRESP <= HRESP2;
        SLAVE3: HRESP <= HRESP3;
        default: HRESP = 1'b1;
    endcase
end



endmodule