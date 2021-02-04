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


reg [2:0] write_counter;
reg [1:0] read_counter;

reg read_finished;
reg write_finished;

wire task_finished = read_finished && write_finished;


wire error_low     =  (!HREADY && HRESP); // Hready is low and ERROR

always @(*) begin
    if(task_finished || !HREADY || error_low)
            HTRANS <= `IDLE;
    else begin
            HTRANS <= `NONSEQ;
              if(pipeline_command[1] == 1'b1)
                HWDATA <= pipelined_data[1];  

    end
end


always @(posedge HCLK, negedge HRESETn) begin
    if(~HRESETn) begin
        HTRANS <= `IDLE;
    end else begin
        if(HTRANS == `NONSEQ) begin
            
         
            pipelined_data[1]   <= pipelined_data[0];
            pipeline_command[1] <= pipeline_command[0];
            pipeline_command[2] <= pipeline_command[1];


          
            if(write_counter < 2'b10) begin
                inner_write();
                write_finished <= 1'b0;
            end else begin
                write_finished <= 1'b1;
            end


            if(read_counter < 2'b11) begin
                inner_read();
                read_finished <= 1'b0;
            end else begin
                read_finished <= 1'b1;
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
    @(posedge HCLK) begin
        
    write_counter = 2'b00;
    write_finished = 1'b0;

    pipelined_addr = addr;
    pipelined_data[0] = data;
    pipeline_size = size;
    pipeline_command[0] = 1'b1;
    inner_write();
    end
end

endtask


//Task only for inner module usage
task  inner_write;
begin
           $display($time);
        $display("write");
        
        if(pipeline_command[0] == 1'b1 && HREADY && !error_low) begin
            write_counter = write_counter + 1'b1;
              $display($time);
              $display("Write addr phase");
    

            HADDR  = pipelined_addr;
            HWRITE = 1'b1;
            HSIZE  = pipeline_size;
            HTRANS = `NONSEQ;
            HBURST = `SINGLE;
            HPROT  = 4'b0011;
            HMASTLOCK = 1'b0;
            

        end

        if(pipeline_command[1] == 1'b1) begin
            $display($time);
            $display("Write data phase");
            write_counter = write_counter + 1'b1;
            
        end
  //  end
end


endtask



//User should call only this task
task  read;
input [`BUS_WIDTH-1:0] addr;
input [2:0] size;

begin
        @(posedge HCLK) begin
            read_counter = 2'b00;    
            read_finished = 1'b0;

            pipelined_addr = addr;
            pipeline_size = size;
            pipeline_command[0] = 1'b0;

            inner_read();
        end
end

endtask


//Task only for inner module usage
task  inner_read;
begin
           $display($time);
        $display("read");
        if(pipeline_command[0] == 1'b0 && HREADY && !error_low) begin

            $display($time);
            $display("Read addr phase");

            read_counter <= read_counter + 1'b1;
            HADDR  = pipelined_addr;
            HWRITE = 1'b0;
            HSIZE  = pipeline_size;
            HTRANS = `NONSEQ;
            HBURST = `SINGLE;
            HPROT  = 4'b0011;
            HMASTLOCK = 1'b0;
            

        end

        if(pipeline_command[1] == 1'b0) begin
            $display($time);
            $display("Read capture data phase");

            read_counter <= read_counter + 1'b1;
            mem = HRDATA;
        end
end


endtask

endmodule