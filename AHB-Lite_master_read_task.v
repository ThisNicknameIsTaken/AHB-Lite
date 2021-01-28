`include "AHB-Lite_defines.v"

module AHB-Lite_master_read_task();

    task read_from_slave;

    input  [31:0] HRADDR;
    input  [2:0]  HRSIZE;

    output [31:0] HADDR;
    output HWRITE;
    output [2:0]  HSIZE;
    output HWRITE;
    output [2:0] HBURST;
    output [3:0] HPROT;
    output [1:0] HTRANS;
    output HMASTLOCK;

    output [31:0] HRADDR;

    begin
        HADDR  <= HRADDR;

        HWRITE <= 1'b0; 
        HSIZE <= HRSIZE;

        HBURST <= `SINGLE;
        HTRANS <= `NONSEQ;

        HMASTLOCK <= 1'b0;
        
        HPROT <= 4'b0011; //recommended by ARM Limited
    end



    endtask;



endmodule;



