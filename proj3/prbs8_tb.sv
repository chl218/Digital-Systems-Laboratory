// test bench for lab 3, part 2
// CSE140L  summer 2018
// complete and functional, but you will 
//  need to add logic to count cycles for
//  repetition of the prbs8 pattern 
// hint: see lecture material on how to
//   use "xray" vision to look down inside
//   a submodule
module prbs8_tb();

  logic      clk   =  0, 
             reset =  1;
  logic[7:0] mask  = 8'he1;	// PNG feedback pattern 
  
  wire rand1;			        // output of PNG
  
  prbs8 pr (.*);		      // your DUT
  
  always begin
    #5ns clk <= 1;
    #5ns clk <= 0;
  end
  
  initial begin
    #  20ns reset = 0;
    #8000ns reset = 1;
    #  20ns $stop;
  end

endmodule 