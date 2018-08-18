// Asynchronous load and store register with signals to control 
// high and low bits seperately or at the same time
module register_hl # (parameter WIDTH = 16) (
   input                       clk,
   input        [WIDTH/2-1:0]  inh,
   input        [WIDTH/2-1:0]  inl,
   input                       loadh,
   input                       loadl,
   input                       clear,
   output logic [WIDTH-1:0]    out
);
   
   always_ff @ (posedge clk, posedge clear) begin
      if(clear)
         out <= 0;
      else begin
         if(loadh) out[WIDTH-1:WIDTH/2] <= inh;
         if(loadl) out[WIDTH/2-1:0]     <= inl;
      end


//fill in the guts
//  clear   loadh    loadl  out[WIDTH-1:WIDTH/2]   out[WIDTH/2-1:0] 
//    1       x         x       0             0
//    0       0        1       hold             inl
//    0       1        0       inh              hold
//    0       1        1       inh              inl
//    0       0        0       hold             hold
  end 
endmodule
