// Altera signed multiplication. Used to test the testbench.
module signed_mult (out, clk, a, b);

   input               clk;
   input signed [7:0]  a;
   input signed [7:0]  b;
   output       [15:0] out;
   
   logic signed [7:0]  a_reg;
   logic signed [7:0]  b_reg;
   logic signed [15:0] out;

   wire signed  [15:0] mult_out;

   assign mult_out = a_reg * b_reg;

   always@(posedge clk) begin
      a_reg <= a;
      b_reg <= b;
      out   <= mult_out;
   end

endmodule
