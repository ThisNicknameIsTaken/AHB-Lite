`include "AHB_Lite_defines.v"
`timescale 1ns/1ps

module Top_testbench();

parameter CLK_PERIOD = 20;

//Global signals
reg HCLK;
reg HRESETn;

wire [31:0] HADDR;
wire [31:0] HWDATA;
wire [31:0] HRDATA;
wire HWRITE;
wire [2:0] HSIZE;
wire [2:0] HBURST;
wire [3:0] HPROT;
wire [1:0] HTRANS;
wire HMASTLOCK;



reg HSEL;
wire HREADYOUT;
wire HRESP;


//Random or user input
reg [31:0] data;
reg [31:0] addr;
reg [2:0] data_size;
reg write;
reg idle;


AHB_Lite_slave slave(HCLK, HRESETn, HSEL, HADDR, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HMASTLOCK, HREADYOUT, HWDATA, HREADYOUT, HRESP, HRDATA);
AHB_Lite_master_top master(HREADYOUT, HRESP, HRESETn, HCLK, HRDATA, HADDR, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HMASTLOCK, HWDATA, write, addr, data, data_size, idle);



initial begin
    HSEL = 1'b1;
    data_size = `Word;
    HCLK = 1'b0;
    HRESETn = 1'b0;
    idle = 1'b0;
end

always begin
    #10 HCLK = ~HCLK;
end

initial begin
    #CLK_PERIOD HRESETn = 1'b1;
end



initial begin
    #240 $finish;
end




initial begin
  
    #40
    addr = 32'h00;
    data = 32'hAA;
    data_size = `Halfword;
    write = 1'b1;
    
    #20 addr = 32'hAA;
      data_size = `Byte;
    write = 1'b0;
    
    #20 addr = 32'hFFF;
    write = 1'b1;
    data = 32'hFFFF;
    data_size = `Word;  

    #20 addr = 32'hAA;
    write = 1'b1;
    data = 32'hFFFF;
    data_size = `Word;  

end

endmodule



