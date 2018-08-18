// 3:1 mux    
module mux3 #(parameter WIDTH = 8) (
   input        [WIDTH-1:0] d0, d1, d2,
   input        [1:0]       s, 
   output logic [WIDTH-1:0] y
);

   always_comb begin
      case(s)
         2'b00: y = d0;
         2'b01: y = d1;
         2'b10: y = d2;
         2'b11: y = d2;
      endcase
   end



// fill in guts
//  s1   s0    y
//  0     0   d0
//  0     1   d1
//  1     0   d2
//  1     1   d2

endmodule


