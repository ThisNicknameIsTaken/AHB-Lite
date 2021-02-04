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

reg addr_phase_finished, data_phase_finished; //are these phases awaiting


wire task_finished = (addr_phase_finished && data_phase_finished);

wire error_low     =  (!HREADY && HRESP); // Hready is low and ERROR

always @(*) begin
    if(task_finished || !HREADY || error_low)
            HTRANS <= `IDLE;
    else
            HTRANS <= `NONSEQ;
end


always @(posedge HCLK, negedge HRESETn) begin
    if(~HRESETn) begin
        addr_phase_finished <= 1'b1;
        data_phase_finished <= 1'b1;
        HTRANS <= `IDLE;
    end else begin
        if(HTRANS == `NONSEQ) begin
            
         
            pipelined_data[1]   <= pipelined_data[0];
            pipeline_command[2] <= pipeline_command[1];


            inner_write();
            inner_read();

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
    addr_phase_finished = 1'b0;
    data_phase_finished = 1'b0;
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
  //  @(posedge HCLK) begin
           $display($time);
        $display("write");
        
        if(pipeline_command[0] == 1'b1 && HREADY && ~error_low) begin
           
              $display($time);
            $display("Write addr phase");
              pipeline_command[1] <= pipeline_command[0];


            HADDR  = pipelined_addr;
            HWRITE = 1'b1;
            HSIZE  = pipeline_size;
            HTRANS = `NONSEQ;
            HBURST = `SINGLE;
            HPROT  = 4'b0011;
            HMASTLOCK = 1'b0;
            addr_phase_finished = 1'b1;
        end

        if(pipeline_command[1] == 1'b1) begin
            $display($time);
            $display("Write data phase");
            

            HWDATA = pipelined_data[0];
            data_phase_finished = 1'b1;
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
            addr_phase_finished = 1'b0;
            data_phase_finished = 1'b0;
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
  //  @(posedge HCLK) begin
           $display($time);
        $display("read");
        if(pipeline_command[0] == 1'b0 && HREADY && ~error_low) begin

            $display($time);
            $display("Read addr phase");
               pipeline_command[1] <= pipeline_command[0];

            HADDR  = pipelined_addr;
            HWRITE = 1'b0;
            HSIZE  = pipeline_size;
            HTRANS = `NONSEQ;
            HBURST = `SINGLE;
            HPROT  = 4'b0011;
            HMASTLOCK = 1'b0;
            addr_phase_finished = 1'b1;
        end

        if(pipeline_command[2] == 1'b0) begin
            $display($time);
            $display("Read capture data phase");


            mem = HRDATA;
            data_phase_finished = 1'b1;
        end
   // end
end


endtask

endmodule