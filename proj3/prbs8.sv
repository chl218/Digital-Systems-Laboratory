// pseudonoise generator
// maximal-length sequence
module prbs8(
   input       clk, 
               rst,
   input [7:0] mask,
   output      rand1
);


  logic [7:0] temp;
  
  always @ (posedge clk) 
      if(rst) temp <= 8'hff;
      else    temp <= {temp[6:0], ^(temp & mask)};

  assign rand1 = temp[0];

endmodule 