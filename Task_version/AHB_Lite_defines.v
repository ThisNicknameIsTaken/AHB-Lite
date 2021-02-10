
//BURST TYPES
`define SINGLE  3'b000
`define INCR    3'b001
`define WRAP4   3'b010
`define INCR4   3'b011
`define WRAP8   3'b100
`define INCR8   3'b101
`define WRAP16  3'b110
`define INCR16  3'b111

//HTRANS TYPES
`define IDLE   2'b00
`define BUSY   2'b01
`define NONSEQ 2'b10
`define SEQ    2'b11

//HSIZE (Transfer size)
`define Byte        3'b000
`define Halfword    3'b001
`define Word        3'b010
`define Doubleword  3'b011
`define FourWord_line    3'b100
`define EightWord_line   3'b101
`define SixteenWord_line 3'b110
`define ThirtyTwoWord_line  3'b111

//HRESP 
`define OKAY    1'b0
`define ERROR   1'b1

`define BUS_WIDTH  32
