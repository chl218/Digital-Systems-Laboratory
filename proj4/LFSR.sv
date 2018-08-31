module LFSR(
   input       clk,
   input       lfsr_init,
   input       lfsr_en,
   input [7:0] lfsr_tab,
   input [7:0] lfsr_init_state,
   output logic [7:0] state_o
);

   logic [7:0] state;

   always_ff @(posedge clk) begin
      
      if(lfsr_init) begin
         state <= lfsr_init_state;
      end
      else begin
         if(lfsr_en) begin
            state <= {^(state & lfsr_tab), state[7:1]};
         end
      end

   end // end-always_ff

   assign state_o = state;

endmodule