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
    #350 $finish;
end




initial begin
    
    //Не работает нормально чтение 
    //Сделать два слейва (1 с wait state, второй без)
    //Соответсвено сделать дешифратор и мультиплексор для двух этих слейвов
    //
    //


    @(posedge HCLK) begin
        if(HRESETn) begin
        $display($time);
        $display("Call write task 1");
        master.write(32'h01, 32'hAA, `Halfword);
        end
    end
    

    
    @(posedge HCLK) begin
        if(HRESETn) begin
        $display($time);
        $display("Call write task 2");
        master.write(32'h02, 32'hAA, `Halfword);
        end
    end
    
    
    @(posedge HCLK) begin
        if(HRESETn) begin
        $display($time);
        $display("Call write task 3");
        master.write(32'h03, 32'hAB, `Halfword);
        end
    end
    
        
    @(posedge HCLK) begin
        if(HRESETn) begin
        $display($time);
        $display("Call write task 4");
        master.write(32'h04, 32'hAC, `Halfword);
        end
    end

    @(posedge HCLK) begin
        if(HRESETn) begin
        $display($time);
        $display("Call write task 5");
        master.write(32'h04, 32'hAC, `Halfword);
        end
    end

    @(posedge HCLK) begin
        if(HRESETn) begin
        $display($time);
        $display("Call write task 6");
        master.write(32'h04, 32'hAC, `Halfword);
        end
    end
    
        
    @(posedge HCLK) begin
        if(HRESETn) begin
        $display($time);
        $display("Call write task 7");
        master.write(32'h05, 32'hAF, `Halfword);
        end
    end
    

    @(posedge HCLK) begin
        if(HRESETn) begin
        $display($time);
        $display("Call read task 0");
        master.read(32'h10,`Byte);
        end
    end
    
    @(posedge HCLK) begin
        if(HRESETn) begin
        $display($time);
        $display("Call read task 1");
        master.read(32'h11,`Byte);
        end
    end
    
    @(posedge HCLK) begin
        if(HRESETn) begin
        $display($time);
        $display("Call read task 2");
        master.read(32'h12,`Byte);
        end
    end
    

    @(posedge HCLK) begin
        if(HRESETn) begin
        $display($time);
        $display("Call read task 3");
        master.read(32'h13,`Byte);
        end
    end
    
    @(posedge HCLK) begin
        if(HRESETn) begin
        $display($time);
        $display("Call write task 8");
        master.write(32'h06, 32'hBA, `Halfword);
        end
    end
    
    
    @(posedge HCLK) begin
        if(HRESETn) begin
        $display($time);
        $display("Call read task 4");
        master.read(32'h14,`Byte);
        end
    end

       @(posedge HCLK) begin
        if(HRESETn) begin
        $display($time);
        $display("Call read task 5");
        master.read(32'h15,`Byte);
        end
    end

      @(posedge HCLK) begin
        if(HRESETn) begin
        $display($time);
        $display("Call write task 9");
        master.write(32'h09, 32'hCC, `Halfword);
        end
    end

    /*
    #20
    $display($time);
    $display("Call read task");
    master.read(32'h02,`Byte);

    
    #20
    $display($time);
    $display("Call read task");
    master.read(32'h10,`Halfword);
    
    #20 
    $display($time);
    $display("Call write task");
    master.write(32'h04, 32'hFFFF, `Word);
   
   
    #20 
    $display($time);
    $display("Call write task");
    master.write(32'h08, 32'hAA, `Byte);  
    */

end

endmodule