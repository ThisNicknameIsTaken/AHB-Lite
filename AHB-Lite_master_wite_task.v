`include "AHB-Lite_defines.v"

module AHB-Lite_master_write_task();

task write;


endtask;
    



endmodule;


















































task write_to_slave;

    input  [31:0] HRADDR, HRDATA;
    input  [2:0]  HRSIZE;
    input address_phase;

    output [31:0] HADDR;
    output HWRITE;
    output [2:0]  HSIZE;
    output HWRITE;
    output [2:0] HBURST;
    output [3:0] HPROT;
    output [1:0] HTRANS;
    output HMASTLOCK;
    output

    output [31:0] HWDATA;

    begin

        HADDR  <= HRADDR;
        HWDATA <= HRDATA;

        HWRITE <= 1'b1; 
        HSIZE <= HRSIZE;

        HBURST <= `SINGLE;
        HTRANS <= `NONSEQ;

        HMASTLOCK <= 1'b0;
        
        HPROT <= 4'b0011; //recommended by ARM Limited
    end



    endtask;