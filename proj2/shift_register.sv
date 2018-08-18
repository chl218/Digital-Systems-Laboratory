// Right shift register with an arithmetic or logical shift mode
module right_shift_register #(parameter WIDTH = 16) ( 
   input                    clk,
   input                    enable,
   input        [WIDTH-1:0] in,     // input to shift
   input                    mode,   // arithmetic (0) or logical (1) shift
   output logic [WIDTH-1:0] out     // shifted input
);


   always @(posedge clk) begin
      if(enable) begin
         out[WIDTH-2:0] <= in[WIDTH-1:1];
         // out[WIDTH-1]   <= mode ? in[WIDTH-1] : 1'b0;
         out[WIDTH-1]   <= mode ? 1'b0 : in[WIDTH-1]; 
      end
   end


// fill in the guts  -- holds or shifts by 1 bit position
//    enable   mode      out  
//      0       0        hold
//      0       1        hold
//      1       0        logical right shift
//      1       1        arithmetic right shift
    


    
endmodule
