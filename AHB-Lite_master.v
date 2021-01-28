module AHB-Lite_master(HCLK, HRESETn, HREADY, HRESP, HRDATA, HADDR, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HMASTLOCK, HWDATA);

//BURST TYPES
localparam [2:0] SINGLE = 3'b000, INCR = 3'b001, WRAP4 = 3'b010, INCR4 = 3'b011, WRAP8 = 3'b100, INCR8 = 3'b101, WRAP16 = 3'b110, INCR16 = 3'b111;

//HTRANS TYPES
localparam [1:0] IDLE = 2'b00,  BUSY = 2'b01, NONSEQ = 2'b10, SEQ = 2'b11;

//HSIZE (Transfer size)
localparam [2:0] Byte = 3'b000, Halfword = 3'b001, Word = 3'b010, Doubleword = 3'b011, FourWord_line = 3'b100, EightWord_line = 3'b101, SixteenWord_line = 3'b110, ThirtyTwoWord_line = 3'b111;

//HRESP 
localparam OKAY = 1'b0, ERROR = 1'b1;

//TRANSFER_STATE
localparam [1:0] IDLE_PHASE = 0, ADDR_PHASE = 1, DATA_PHASE = 2;

//--------------------INPUT---------------------
//Global signals
input HCLK;
input HRESETn;


//Transfer response
input HREADY;
input HRESP;

//Data input
input HRDATA[31:0];



input transaction_type [2:0];
input read_or_write;
input package_size;
input burst_type [2:0];
//------------------------------------------------



//-----------------OUTPUT-------------------------

//Address and control
output reg HADDR[31:0];
output reg HWRITE;
output HSIZE[2:0];
output HBURST[2:0];
output HPROT[3:0];
output reg HTRANS[1:0];
output HMASTLOCK;

//Data out
output HWDATA[31:0];

//--------------------------------------------------




reg current_state;
reg next_state;

reg address_for_slave [31:0];
reg data_for_slave [31:0];
reg data_from_slave [31:0];


always @(posedge HCLK, negedge HRESETn) begin
    if(~HRESETn) begin
        HTRANS <= IDLE;
        current_state <= IDLE_PHASE;
        next_state <= IDLE_PHASE;
    end else begin
        current_state <= next_state;
    end
end


always @(*) begin
    case (current_state)

    ADDR_PHASE: begin
        HADDR <= address_for_slave;
        HWRITE <= read_or_write;

        next_state <= DATA_PHASE;
    end

    DATA_PHASE: begin


    endcase
end


endmodule