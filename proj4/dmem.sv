// Create Date:    2017.01.25
// Module Name:    reg_file 
//
// Additional Comments:  works as data_mem as well   $clog2

module dmem #(parameter WIDTH = 8) (
   input              clk,
   input              init,
   input              wen,    // write (store) enable
   input  [WIDTH-1:0] raddr,  // read pointer
   input  [WIDTH-1:0] waddr,  // write (store) pointer
   input  [WIDTH-1:0] data_i,
   output [WIDTH-1:0] data_o
);



   // memory core
   // [0:47]   = original message
   // [61]     = preamble length
   // [62]     = feedback taps
   // [63]     = LFSR starting position
   // [64:123] = padded & encrypted message

   // W bits wide [W-1:0] and byte_count registers deep   
   logic [WIDTH-1:0] mem[2**WIDTH];   


   initial begin

   end

   // combinational reads w/ blanking of address 0
   assign data_o = mem[raddr] ;   

   // sequential (clocked) writes   
   always_ff @ (posedge clk)
      if(init) 
         for(int i = 0; i < 60; i++) 
            mem[i] = 8'hA0;
      else
         if(wen)
            mem[waddr] <= data_i;

endmodule
