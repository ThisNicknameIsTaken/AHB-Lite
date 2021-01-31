`include "AHB_Lite_defines.v"

module AHB_Lite_slave(HCLK, HRESETn, HSEL, HADDR, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HMASTLOCK, HREADY, HWDATA, HREADYOUT, HRESP, HRDATA);



parameter MEMORY_SIZE = 1024; //in bytes. 1kb is a minimum address space
parameter MAX_HSIZE =  4; // BUS_WIDTH / MEM_SIZE (byte) =>  32 / 8 = 4
//localparam MAX_ADDR_REG = $clog2(MEMORY_SIZE);

//--------------------INPUT---------------------
//Global signals
input HCLK;
input HRESETn;

//Select
input HSEL;

//Address and control
input [`BUS_WIDTH-1:0] HADDR;
input HWRITE;
input [2:0] HSIZE; // Must be less or equal to bus size. For example, with a 32-bit data bus, HSIZE must only use the values b000, b001, or b010.
input [2:0] HBURST;
input [3:0] HPROT;
input [1:0] HTRANS;
input HMASTLOCK;
input HREADY;

//Data input
input [`BUS_WIDTH-1:0] HWDATA;
//------------------------------------------------



//-----------------OUTPUT-------------------------

//Transfer response
output reg HREADYOUT;
output reg HRESP;

//Data out
output reg [`BUS_WIDTH-1:0] HRDATA;

//--------------------------------------------------




//pipelined registers for input signals
reg [31:0] pipelined_haddr  [1:0];
reg [31:0] pipelined_hwdata;
reg [2:0]  pipelined_hsize  [1:0];
reg        pipelined_hwrite [1:0];    // if hwrite == 1'b1 -> master wants to write data into slave


//slave memory
reg [7:0] memory [0:MEMORY_SIZE-1];
reg [`BUS_WIDTH-1:0] paral_reg_for_data;
reg [`BUS_WIDTH-1:0] paral_reg_for_addr;

//slave registers
reg [32:0] max_addr_calc;
reg error;
reg [1:0] error_cnt;


always @(*) begin
  HRDATA <= paral_reg_for_data;
end

always @(posedge HCLK, negedge HRESETn) begin
    if(~HRESETn) begin
      $readmemh("memory_data.hex", memory);
    end
end


//Pipelining inputs
always @(posedge HCLK, negedge HRESETn) begin
  if(~HRESETn) begin
    HREADYOUT <= 1'b1;
    HRESP <= `OKAY;
  end else begin
    if(HSEL && HREADY) begin
      pipelined_haddr[0] <= HADDR;
      pipelined_haddr[1] <= pipelined_haddr[0];
      
      pipelined_hwdata <= HWDATA;

      pipelined_hsize[0] <= HSIZE;
      if(pipelined_hsize[0] === 3'b010)
        pipelined_hsize[1] <= 3'b011;
      else 
        pipelined_hsize[1] <= pipelined_hsize[0];

      pipelined_hwrite[0] <= HWRITE;
      pipelined_hwrite[1] <= pipelined_hwrite[0];
    end
  end
end


//Response
always @(posedge HCLK, negedge HRESETn) begin
  if(~HRESETn) begin
    error_cnt <= 1'b0;
    error <= 1'b0;
  end else begin
      if(error) begin
         if(error_cnt == 2'b0)begin
           HREADYOUT <= 1'b0;
           HRESP <= `ERROR;
           error_cnt <= error_cnt + 1'b1;
        end else if(error_cnt == 2'b1) begin
           HREADYOUT <= 1'b1;
           HRESP <= `ERROR;
           error_cnt <= error_cnt + 1'b1;
        end else begin
           HRESP <= `OKAY;
           error <= 1'b0;
           HREADYOUT <= 1'b1;
        end
      end else begin
        HRESP <= `OKAY;
        HREADYOUT <= 1'b1;
      end
  end
end



always @(posedge HCLK) begin
  if(HSEL) begin
    max_addr_calc <= pipelined_haddr[1] + pipelined_hsize[1];
    if(max_addr_calc >= MEMORY_SIZE)begin
      error <= 1'b1;
      error_cnt <= 2'b01;
      HRESP <= `ERROR;
    end
  end
end


genvar i;
//read from memory
      generate
        for (i = 0;i < MAX_HSIZE ; i = i + 1) begin
          always @(posedge HCLK, negedge HRESETn) begin
            if(~HRESETn) begin
               paral_reg_for_data[((i+1)*8)-1:i*8] <= 8'h00;
            end else if(i <= pipelined_hsize[1] && ~pipelined_hwrite[1])begin
              paral_reg_for_data[((i+1)*8)-1:i*8] <= memory[pipelined_haddr[1][10:0]+i];
            end
          end
        end
      endgenerate
    


//write to memory
      generate
        for (i = 0;i < MAX_HSIZE ; i = i + 1) begin
          always @(posedge HCLK) begin
            if(i <= pipelined_hsize[1]  && pipelined_hwrite[1])begin
              memory[pipelined_haddr[1]+i] <= pipelined_hwdata[((i+1)*8)-1:i*8];
            end 
          end
        end
      endgenerate


endmodule