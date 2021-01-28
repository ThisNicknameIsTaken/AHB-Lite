module AHB-Lite_slave(HCLK, HRESETn, HSELx, HADDR, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HMASTLOCK, HREADY, HWDATA, HREADYOUT, HRESP, HRDATA);

//BURST TYPES
localparam [2:0] SINGLE = 3'b000, INCR = 3'b001, WRAP4 = 3'b010, INCR4 = 3'b011, WRAP8 = 3'b100, INCR8 = 3'b101, WRAP16 = 3'b110, INCR16 = 3'b111;

//HTRANS TYPES
localparam [1:0] IDLE = 2'b00,  BUSY = 2'b01, NONSEQ = 2'b10, SEQ = 2'b11;

//HSIZE (Transfer size)
localparam [2:0] Byte = 3'b000, Halfword = 3'b001, Word = 3'b010, Doubleword = 3'b011, FourWord_line = 3'b100, EightWord_line = 3'b101, SixteenWord_line = 3'b110, ThirtyTwoWord_line = 3'b111;

//HRESP 
localparam OKAY = 1'b0, ERROR = 1'b1;

localparam WRITE_TO_SLAVE = 1'b1, READ_FROM_SLAVE = 1'b0;

//TRANSFER_STATE
localparam [1:0] IDLE_STATE = 0, MASTER_IS_BUSY_STATE = 1, NONSEQ_STATE = 2, SEQ_STATE = 3;


//TESTING
parameter MAX_ADDRESS = 32'hAAFF;

//--------------------INPUT---------------------
//Global signals
input HCLK;
input HRESETn;

//Select
input HSEL;

//Address and control
input HADDR[31:0];
input HWRITE;
input HSIZE[2:0];
input HBURST[2:0];
input HPROT[3:0];
input HTRANS[1:0];
input HMASTLOCK;
input HREADY;

//Data input
input HWDATA[31:0];
//------------------------------------------------



//-----------------OUTPUT-------------------------

//Transfer response
output reg HREADYOUT;
output reg HRESP;

//Data out
output reg HRDATA[31:0];

//--------------------------------------------------


reg current_state [1:0];
reg next_state [1:0];

reg address [31:0];
reg data_from_bus [31:0];
reg data_from_memory [31:0];



always @(posedge HCLK, negedge HRESETn) begin
    if(~HRESETn) begin
        data_from_memory <= 32'b1;

        HREADYOUT <= 1'b1;
        HRESP <= OKAY;

        next_state <= IDLE_STATE;
        current_state <= IDLE_STATE

    end else begin
        current_state <= next_state;
    end
end


always @(*) begin
    case (current_state)
      IDLE_STATE: begin
          HRESP <= OKAY;
          HREADYOUT <= 1'b1;
        address <= HADDR;

        case(HTRANS)
            IDLE: next_state <= IDLE_STATE;
            BUSY: next_state <= MASTER_IS_BUSY_STATE;
            NONSEQ: next_state <= NONSEQ_STATE;
            SEQ: next_state <= SEQ_STATE;
        endcase

      end
        
      MASTER_IS_BUSY_STATE: begin
          HRESP <= OKAY;
          HREADYOUT <= 1'b1;
          next_state <= IDLE_STATE;
      end

     NONSEQ_STATE: begin
          if(address > MAX_ADDRESS) begin
                HRESP <= ERROR;
                next_state <= IDLE_STATE;
          end  else begin
              if(HWRITE == WRITE_TO_SLAVE)
                data_from_bus <= HWRITE;
              else
                HRDATA <= data_from_memory;
          end
     end

    
     SEQ_STATE: begin
         if(address > MAX_ADDRESS) begin
                HRESP <= ERROR;
                next_state <= IDLE_STATE;
          end  else begin
              if(HWRITE == WRITE_TO_SLAVE)
                data_from_bus <= HWRITE;
              else
               HRDATA <= data_from_memory;
          end

  


endmodule