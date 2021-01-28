`include "AHB_Lite_defines.v"


module AHB_Lite_master_top(HREADY, HRESP, HRESETn, HCLK, HRDATA, HADDR, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HMASTLOCK, HWDATA, write_or_read, address_in, data_in, data_size, stay_idle);

//--------------------INPUT---------------------
//Global signals
input HCLK;
input HRESETn;


//Transfer response
input HREADY;
input HRESP;

//Data input
input [31:0] HRDATA;


//User control from testbench
input write_or_read;         // HIGH for write, LOW for READ
input [31:0] address_in;    
input [31:0] data_in;
input [2:0] data_size;
input stay_idle;
//------------------------------------------------



//-----------------OUTPUT-------------------------

//Address and control
output reg  [31:0]   HADDR;
output reg           HWRITE;
output reg  [2:0]    HSIZE;
output reg  [2:0]    HBURST;
output reg  [3:0]    HPROT;
output reg  [1:0]    HTRANS;
output reg           HMASTLOCK;

//Data out
output reg [31:0] HWDATA;

//--------------------------------------------------

reg [31:0] pipelined_addr [1:0];
reg [31:0] pipelined_data [2:0];
reg [2:0]  pipelined_size [1:0];
reg [2:0]  pipelined_hwrite;
reg [31:0] rdata;

always @(*) begin
    HADDR  <= pipelined_addr[1];
    HWDATA <= pipelined_data[2];
    HSIZE  <= pipelined_size[1];
    HWRITE <= pipelined_hwrite[1];
end



//Address phase
always @(posedge HCLK, negedge HRESETn) begin
    HBURST <= `SINGLE;
    HMASTLOCK <= 1'b0;
    HPROT <= 4'b0011;

   if (~HRESETn) begin
        HTRANS <= `IDLE;
   end else begin
       if(stay_idle || !HREADY)
        HTRANS <=`IDLE ;  
       else begin
           if(HREADY && HRESP == `OKAY) begin
            HTRANS <= `NONSEQ;

            pipelined_size[0] <= data_size;
            pipelined_size[1] <= pipelined_size[0];

            pipelined_addr[0] <= address_in;
            pipelined_addr[1] <= pipelined_addr[0];
        
 
            pipelined_hwrite[0] <= write_or_read;
            pipelined_hwrite[1] <= pipelined_hwrite[0];
           end else begin
                HTRANS <= `IDLE;
           end
       end
   end
    
end


//Write phase
always @(posedge HCLK) begin
    if(HREADY && HRESP == `OKAY) begin
        pipelined_data[0] <= data_in;
        pipelined_data[1] <= pipelined_data[0];
        pipelined_data[2] <= pipelined_data[1];    
    end
end

//Read phase
always @(posedge HCLK) begin
    if(HREADY && !pipelined_hwrite[2] && HRESP == `OKAY)
        rdata <= HRDATA;
end

endmodule