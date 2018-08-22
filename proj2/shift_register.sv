// Right shift register with an arithmetic or logical shift mode
module right_shift_register #(parameter WIDTH = 16) ( 
   input                    clk,
   input                    enable,
   input        [WIDTH-1:0] in,     // input to shift
   input                    mode,   // arithmetic (0) or logical (1) shift
   output logic [WIDTH-1:0] out     // shifted input
);


   logic [WIDTH-1:0] sr_out;


   always @(posedge clk) begin
      if(enable) begin
         sr_out[WIDTH-2:0] <= in[WIDTH-1:1];
         sr_out[WIDTH-1]   <= mode ? 1'b0 : in[WIDTH-1]; 
      end
   end

   assign out = sr_out;

// fill in the guts  -- holds or shifts by 1 bit position
//    enable   mode      out  
//      0       0        hold
//      0       1        hold
//      1       1        logical right shift
//      1       0        arithmetic right shift
    


    
endmodule
