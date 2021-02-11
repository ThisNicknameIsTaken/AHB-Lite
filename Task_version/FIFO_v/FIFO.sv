`include "AHB_Lite_defines.v"

module FIFO (clk, resetn);

localparam  WIDTH = `BUS_WIDTH*2 + 3; //write->(1 bit) size->(2 bits) addr->(BUS_WIDTH bits) data->(BUS_WIDTH bits)


typedef struct {
    reg hwrite;
    reg [2:0] hsize;
    reg [`BUS_WIDTH-1:0] haddr;
    reg [`BUS_WIDTH-1:0] hdata;
} fifo_package;



reg empty;


input clk;
input resetn;

fifo_package mem [];
int rd_pointer;
int wr_pointer;

assign empty = ((wr_pointer - rd_pointer) == 0) ? 1'b1 : 1'b0;


always @(posedge clk, negedge resetn) begin
	if (~resetn) begin
        mem.delete();
		wr_pointer <= 0;
		rd_pointer <= 0;
	end
end


task write_in_fifo;

input i_write;
input [`BUS_WIDTH-1:0] i_addr;
input [`BUS_WIDTH-1:0] i_data;
input [2:0] i_size;

begin
   // @(posedge clk) begin
        mem = new [mem.size() + 1] (mem);
        mem[wr_pointer].hwrite = i_write;
        mem[wr_pointer].hsize = i_size;
        mem[wr_pointer].haddr = i_addr;
        mem[wr_pointer].hdata = i_data;
        wr_pointer = wr_pointer + 1;
   // end
end

endtask




task read_from_fifo;
    output write;
    output [2:0] size;
    output [`BUS_WIDTH-1:0] addr;
    output [`BUS_WIDTH-1:0] data;

    begin
      // @(posedge clk) begin
            if(~empty)begin
            write =  mem[rd_pointer].hwrite;
            size =   mem[rd_pointer].hsize;
            addr =   mem[rd_pointer].haddr;
            data =   mem[rd_pointer].hdata;
            rd_pointer = rd_pointer + 1;
            end
        //end
    end

endtask

endmodule