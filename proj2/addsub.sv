// 8-bit Adder/Subtractor (active low subtract)
// CSE140L   Summer 2018   lab 2
module addsub #(parameter WIDTH = 8) (
  input                    clk,
  input [WIDTH-1:0]        dataa,
  input [WIDTH-1:0]        datab,
  input                    add_sub,	  // if this is 1, add; else subtract
  output logic [WIDTH-1:0] result
);

   assign result = add_sub ? (dataa + datab) : (dataa - datab);

// fill in guts        
//add_sub       result
//1             dataa + datab;
//0             dataa - datab;   


endmodule
