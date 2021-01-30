`include "AHB_Lite_defines.v"
`timescale 1ns/1ps

module Top_tb_slave();
parameter MEMORY_SIZE = 1024;
parameter CLK_PERIOD = 20;

//Global signals
reg HCLK;
reg HRESETn;

reg HSEL;
reg [31:0] HADDR;
reg HWRITE;
reg [2:0] HSIZE;
reg [2:0] HBURST;
reg [3:0] HPROT;
reg [1:0] HTRANS;
reg HMASTLOCK;
reg HREADY;



reg [`BUS_WIDTH-1:0] HWDATA;

wire HREADYOUT;
wire HRESP;

wire [`BUS_WIDTH-1:0] HRDATA;

AHB_Lite_slave slave(HCLK, HRESETn, HSEL, HADDR, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HMASTLOCK, HREADY, HWDATA, HREADYOUT, HRESP, HRDATA);

initial begin
    HCLK = 1'b0;
    HRESETn = 1'b0;
    HSEL = 1'b1;
    HREADY = 1'b1;
end


always begin
    #10 HCLK = ~HCLK;
end

initial begin
    #CLK_PERIOD HRESETn = 1'b1;
end

initial begin
    #40 HSIZE = `Word;
    HADDR = 32'hA;
    HWRITE = 1'b0;

    #40
    HADDR = 32'h0;
    HSIZE = `Word;
    HWRITE = 1'b1;

    #20
    HWDATA = 32'hffddccaa;

    #20
    HWRITE = 1'b0;
    HWDATA = 32'h00000000;
end


initial begin
    #240 $finish;
end

endmodule