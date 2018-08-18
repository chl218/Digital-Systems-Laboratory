// load and store register
module register # (parameter N = 8)
   (input clk,
    input [N-1:0] in,
    output logic [N-1:0] out,
    input load,
    input clear
    );
	 
	always @ (posedge clk, posedge clear)
// fill in guts
//   clear   load    out
// 	   1       0      0
//     1       1      0
//     0       0     hold
//     0       1      in   

// What would be the impact of leaving posedge clear out of 
//  the sensitivity list? 
		
endmodule

