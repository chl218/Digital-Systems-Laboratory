// N-bit Adder/Subtractor (active low subtract)
// CSE140L   Summer 2018   lab 2
module addsub #(parameter dw=8)
(
  input [dw-1:0] dataa,
  input [dw-1:0] datab,
  input       add_sub,	  // if this is 1, add; else subtract
  input       clk,
  output logic [dw-1:0] result
);

// fill in guts        
//add_sub       result
//1             dataa + datab;
//0             dataa - datab;   


endmodule
