// CSE140L  summer 2018
//    Test bench for lab 3, part 2
//
//    Complete and functional, but you will need to add logic to count cycles
//    for repetition of the prbs8 pattern 
//
//    Hint: see lecture material on how to use "xray" vision to look down inside
//          a submodule
//
module prbs8_tb();

   logic       clk  = 0; 
   logic       rst  = 1;
   logic [7:0] mask = 8'hE1;  // PNG feedback pattern 
  
   wire out; // output of PNG
  
   prbs8 pr(.clk(clk), .rst(rst), .mask(mask), .out(out)); // DUT
  
   always begin
      #5ns clk <= 1;
      #5ns clk <= 0;
   end
  
   initial begin
      #  20ns rst = 0;
      #8000ns rst = 1;
      #  20ns $stop;
   end

endmodule 
