// Counter that decrements from WIDTH to 0 at every positive clock edge.
// CSE140L   Summer 2018   lab 2
module counter_down  #(parameter WIDTH = 8) (
  input                    clk,
  input                    reset,
  input                    en,
  output logic [WIDTH-1:0] result
);

   always @(posedge clk)
      if(reset) 
         result <= 7;
      else if(en) 
         result <= result - 1;

// fill in guts -- 
//reset   ena     result
//  1      X         7
//  0      1       decrease by 1
//  0      0       hold

endmodule   