// pseudonoise generator
// maximal-length sequence
module prbs8(
   input        clk, 
                rst,
   input [7:0]  mask,
   output logic out
);


// logic [7:0] temp;

// always @ (posedge clk) 
//     if(rst) temp <= 8'hff;
//     else    temp <= {temp[6:0], ^(temp & mask)};

// assign rand1 = temp[0];

   logic [7:0] rand1_next;
   logic [7:0] rand1;
   logic       out_next;


   always_ff @ (posedge clk)
      if(rst) begin
         rand1 <= 8'b1111_1111;
         out   <= 1'b1;
      end
      else begin
         rand1 <= rand1_next;
         out   <= out_next;
      end

   always_comb begin
      out_next = rand1[7];
      rand1_next = {rand1[6:0], ^(rand1 & mask)};
   end

endmodule 