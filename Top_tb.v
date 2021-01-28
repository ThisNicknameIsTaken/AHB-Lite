`include "AHB_Lite_defines.v"
`timescale 1ns/1ps

module Top_tb();

parameter CLK_PERIOD = 20;

//Global signals
reg HCLK;
reg HRESETn;


//Random or user input
reg [31:0] data;
reg [31:0] addr;
reg [2:0] data_size;
reg write;
reg idle;

reg HREADY;
reg HRESP;
reg HRDATA;

wire [31:0] HADDR;
wire HWRITE;
wire [2:0] HSIZE;
wire [2:0] HBURST;
wire [3:0] HPROT;
wire [1:0] HTRANS;
wire HMASTLOCK;

wire [31:0] HWDATA;

AHB_Lite_master_top master(HREADY, HRESP, HRESETn, HCLK, HRDATA, HADDR, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HMASTLOCK, HWDATA, write, addr, data, data_size, idle);

initial begin
    data_size = `Word;
    HCLK = 1'b0;
    HRESETn = 1'b0;
    HREADY = 1'b1;
    HRESP = `OKAY;
    idle = 1'b0;
end


always begin
    #10 HCLK = ~HCLK;
end

initial begin
    #CLK_PERIOD HRESETn = 1'b1;
end

initial begin
    #200 $finish;
end


initial begin
    #40 addr = 32'hAABB;
    data = 32'hAABB;
    write = 1'b1;
    #20 addr = 32'hBBCC;
    data = 32'hBBCC;
    write = 1'b1;
    #20 addr = 32'h00FF;
    write = 1'b0;
    data = 32'h00FF;
    #20 HREADY = 1'b1;
    write = 1'b1;
    addr = 32'h9999;
    data = 32'h9999;
end

endmodule