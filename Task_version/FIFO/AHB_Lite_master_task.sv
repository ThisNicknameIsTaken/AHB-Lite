`include "AHB_Lite_defines.v"

module AHB_Lite_master_task(HREADY, HRESP, HRESETn, HCLK, HRDATA, HADDR, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HMASTLOCK, HWDATA);

//--------------------INPUT---------------------
//Global signals
input HCLK;
input HRESETn;


//Transfer response
input HREADY;
input HRESP;

//Data input
input [`BUS_WIDTH-1:0] HRDATA;


//-----------------OUTPUT-------------------------

//Address and control
output reg  [`BUS_WIDTH-1:0]   HADDR;
output reg           HWRITE;
output reg  [2:0]    HSIZE;
output reg  [2:0]    HBURST;
output reg  [3:0]    HPROT;
output reg  [1:0]    HTRANS;
output reg           HMASTLOCK;

//Data out
output reg [`BUS_WIDTH-1:0] HWDATA;

//Master temp memory
reg [`BUS_WIDTH-1:0] mem;

//Pipelining
reg [`BUS_WIDTH-1:0] pipelined_addr;
reg [`BUS_WIDTH-1:0] pipelined_data [1:0];
reg [2:0] pipeline_size;
reg [2:0] pipeline_command;


reg [1:0] write_counter;
reg [1:0] read_counter;

reg read_finished;
reg write_finished;

reg data_pending;
reg read_pending;

wire task_finished = read_finished && write_finished;


wire error_low     =  (!HREADY && HRESP); // Hready is low and ERROR


FIFO task_fifo(HCLK, HRESETn);


//state control
always @(*) begin
    if(task_finished || !HREADY || error_low) begin
            HTRANS = `IDLE;
    end
end





//write control
always @(*) begin
    if(data_pending && write_counter > 2'b01) begin
         HWDATA = pipelined_data[1];
         write_finished = 1'b1;
    end else begin
            if(pipeline_command[1] == 1'b1) begin
                HWDATA = pipelined_data[1];
            end

            if(write_counter > 2'b01) begin
                write_finished = 1'b1;
            end
    end
end


// read control
always @(*) begin
    if(read_pending && read_counter > 2'b00) begin
        if(read_counter > 2'b01) begin
            read_finished = 1'b1;
            mem = HRDATA;
        end
        mem = HRDATA;
    end
end


always @(posedge HCLK) begin
        if(HREADY) begin
            pop_command();
        end 
end



always @(posedge HCLK, negedge HRESETn) begin
    if(~HRESETn) begin
        HTRANS <= `IDLE;
        write_finished <= 1'b1;
        read_finished <= 1'b1;
    end else begin
        
      


        if(HREADY && HTRANS == `NONSEQ) begin
            pipelined_data[1]   <= pipelined_data[0];
            pipeline_command[1] <= pipeline_command[0];
            pipeline_command[2] <= pipeline_command[1];


          
            if(write_counter <= 2'b01 || data_pending) begin
                inner_write();
                write_finished <= 1'b0;
                if(write_counter > 2'b01 && data_pending) begin
                    data_pending <= 1'b0;
                end
            end 


            if((read_counter <= 2'b10 || read_pending) && !read_finished) begin
                inner_read();              
                read_finished <= 1'b0;
            end 
            
            if (read_finished) begin
                read_pending <= 1'b0;
            end

            

        end       
    end
end



//User should call only this task
task write;


input [`BUS_WIDTH-1:0] addr;
input [`BUS_WIDTH-1:0] data;
input [2:0] size;

begin 
    //@(posedge HCLK) begin
    $display("%0t START WRITE TASK CALLED",$time);    
    write_counter = 2'b00;
    write_finished = 1'b0;

    pipelined_addr = addr;
    pipelined_data[0] = data;
    pipeline_size = size;
    pipeline_command[0] = 1'b1;
    inner_write();
    //end
end

endtask


//Task only for inner module usage
task  inner_write;
begin   
        $display($time);
        $display("%0t Call write task", $time);
        
        if(pipeline_command[0] == 1'b1 && HREADY && !error_low) begin
           // write_counter = write_counter + 1'b1;
              $display("%0t Write addr phase", $time);

            //pipeline_command[1] = 1'b1;
            HADDR  = pipelined_addr;
            HWRITE = 1'b1;
            HSIZE  = pipeline_size;
            HTRANS = `NONSEQ;
            HBURST = `SINGLE;
            HPROT  = 4'b0011;
            HMASTLOCK = 1'b0;
            

        end

        if(pipeline_command[1] == 1'b1 && HREADY) begin
            $display("%0t Write data phase", $time);
            write_counter = write_counter + 1'b1;
            data_pending = 1'b1;
        end
end


endtask



//User should call only this task
task  read;
input [`BUS_WIDTH-1:0] addr;
input [2:0] size;

begin
        //@(posedge HCLK) begin
            read_counter = 2'b00;    
            read_finished = 1'b0;

            pipelined_addr = addr;
            pipeline_size = size;
            pipeline_command[0] = 1'b0;

            inner_read();
        //end
end

endtask


//Task only for inner module usage
task  inner_read;
begin
        $display($time);
        $display("%0t Call read task", $time);
        if(pipeline_command[0] == 1'b0 && HREADY && !error_low) begin

            $display("%0t Read addr phase", $time);

            read_counter <= read_counter + 1'b1;
            HADDR  = pipelined_addr;
            HWRITE = 1'b0;
            HSIZE  = pipeline_size;
            HTRANS = `NONSEQ;
            HBURST = `SINGLE;
            HPROT  = 4'b0011;
            HMASTLOCK = 1'b0;

        end

        if((pipeline_command[1] == 1'b0 || read_counter == 2'b01) && HREADY) begin
            read_pending = 1'b1;
            $display("%0t Read capture data phase", $time);
            read_counter = read_counter + 1'b1;
        end

end


endtask

// User should only use this in testbecnh
task automatic push_command;
input i_write;
input [`BUS_WIDTH-1:0] i_addr;
input [`BUS_WIDTH-1:0] i_data;
input [2:0] i_size; 

begin
   task_fifo.write_in_fifo(i_write, i_addr, i_data, i_size); 
end
endtask


task pop_command;

reg write_r;
reg [2:0] size_r;
reg [`BUS_WIDTH-1:0] addr_r;
reg [`BUS_WIDTH-1:0] data_r;
reg empty_r;

begin
    task_fifo.read_from_fifo(write_r, addr_r, data_r, size_r, empty_r);
    
    if(~empty_r) begin
        case (write_r)
            1'b1: write(addr_r, data_r, size_r);
            1'b0: read(addr_r,size_r);
        endcase
    end 
end
endtask





endmodule

