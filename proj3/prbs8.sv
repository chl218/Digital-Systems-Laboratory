// pseudonoise generator
// maximal-length sequence
module prbs8(
   input       clk, 
               reset,
   input [7:0] mask,
   output      rand1
);


  logic [7:0] temp;
  
  always @ (posedge clk) 
      if(reset) temp <= 8'hff;
      else      temp <= {temp[6:0],^(temp & mask)};

  assign rand1 = temp[0];

endmodule 