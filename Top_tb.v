`include "AHB_Lite_defines.v"


module Top_tb();


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




AHB_Lite_slave slave(HCLK, HRESETn, HSEL, HADDR, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HMASTLOCK, HREADYOUT, HWDATA, HREADYOUT, HRESP, HRDATA);
AHB_Lite_master_task master(HREADYOUT, HRESP, HRESETn, HCLK, HRDATA, HADDR, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HMASTLOCK, HWDATA);



initial begin
    HCLK = 1'b0;
    HRESETn = 1'b0;
    HSEL = 1'b1;
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
    $display($time);
    $display("Call write task");
    master.write(32'h00, 32'hAA, `Halfword);
  
    
    #20
    $display($time);
    $display("Call read task");
    master.read(32'h02,`Byte);

    
    #20 
    $display($time);
    $display("Call write task");
    master.write(32'h04, 32'hFFFF, `Word);
   
   
    #20 
    $display($time);
    $display("Call write task");
    master.write(32'h08, 32'hAA, `Byte);  

end

endmodule