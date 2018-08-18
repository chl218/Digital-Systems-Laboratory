module ct_mod24(
   input clk, rst, en,
   output logic[6:0] ct_out,
   output logic      z
);

   always_ff @(posedge clk)
      if(rst)
         ct_out <= 0;
      else if(en)
         ct_out <= (ct_out + 1) % 24;

  always_comb z = !ct_out;

endmodule