// Right shift register with an arithmetic or logical shift mode
module right_shift_register(clk, enable, in, mode, out);
    parameter width = 16;
    input clk;
    input enable;
    input [width-1:0] in; // input to shift
    input mode; // arithmetic (0) or logical (1) shift
    output logic [width-1:0] out; // shifted input

	
	always @(posedge clk) 	begin
// fill in the guts	-- holds or shifts by 1 bit position
//    enable   mode      out  
//      0       0        hold
//		0       1	     hold
//		1       0	     logical right shift
//		1		1	     arithmetic right shift
    end

endmodule
