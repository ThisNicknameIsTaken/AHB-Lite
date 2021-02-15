`include "AHB_Lite_defines.sv"

// if HADDR is 32 bits long. 16 bits responsible for slave addr and rest 16 bits correspond to inner slave memory address space.



module test_non_one_slave();

reg HCLK;
reg HRESETn;



wire [31:0] HADDR;
wire [31:0] HWDATA;
wire [31:0] HRDATA,HRDATA0,HRDATA1,HRDATA2,HRDATA3;
wire HWRITE;
wire [2:0] HSIZE;
wire [2:0] HBURST;
wire [3:0] HPROT;
wire [1:0] HTRANS;
wire HMASTLOCK;



wire HRESP, HRESP0, HRESP1, HRESP2, HRESP3;
wire HREADY,HREADYOUT0,HREADYOUT1,HREADYOUT2,HREADYOUT3;
wire HSEL0, HSEL1, HSEL2, HSEL3;


AHB_Lite_master_task master(HREADY, HRESP, HRESETn, HCLK, HRDATA, HADDR, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HMASTLOCK, HWDATA);

AHB_Lite_slave #(.DELAY(0)) slave0(HCLK, HRESETn, HSEL0, HADDR, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HMASTLOCK, HREADY, HWDATA, HREADYOUT0, HRESP0, HRDATA0);
AHB_Lite_slave #(.DELAY(1)) slave1(HCLK, HRESETn, HSEL1, HADDR, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HMASTLOCK, HREADY, HWDATA, HREADYOUT1, HRESP1, HRDATA1);

AHB_Lite_mux   mux(HCLK, HRESETn, HSEL0, HSEL1, HSEL2, HSEL3, HRDATA, HRESP, HREADY, HRDATA0, HRESP0, HREADYOUT0,  HRDATA1, HRESP1, HREADYOUT1,  HRDATA2, HRESP2, HREADYOUT2,  HRDATA3, HRESP3, HREADYOUT3);
AHB_Lite_decoder decoder(HADDR, HSEL0, HSEL1, HSEL2, HSEL3);


initial begin
    HCLK = 1'b0;
    HRESETn = 1'b0;
end

always begin
    #10 HCLK = ~HCLK;
end


initial begin
    #20 HRESETn = 1'b1;
end



initial begin
    #500 $finish;
end



initial begin
    
    #20
  

    @(posedge HCLK) begin
        master.push_command(1'b1,32'h00_00_00_01, 32'hFF, `Halfword);
        master.push_command(1'b0,32'h10_00_00_02, 32'hCC, `Halfword);
        master.push_command(1'b1,32'h00_00_00_10, 32'hAA, `Byte);
        master.push_command(1'b0,32'h00_00_00_04, 32'hCF, `Halfword);
        master.push_command(1'b1,32'h10_00_00_05, 32'hBF, `Halfword);
    end

    

end

endmodule