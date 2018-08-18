// this datapath implements hardware required to perform signed
// Robertson's multiplication described in toprobertsons.v.
module robs_datapath #(parameter WIDTH = 8) (
   input                clk,
   input                reset,
   input  [WIDTH-1:0]   multiplier, 
   input  [WIDTH-1:0]   multiplicand,
   input  [14:0]        c,
   output [WIDTH*2-1:0] product,
   output               zq,
   output               zr
);
   
   // Internal signals of the datapath module
   wire [WIDTH-1:0] y, a, in_x, x, in_rh, in_rl, alu_out, q;
   wire [WIDTH*2-1:0] r, sr;
   
   register reg_y(.clk(clk)
                 ,.in(multiplicand)
                 ,.load(c[0])
                 ,.clear(1'b0)
                 ,.out(y));

   register reg_a(.clk(clk)
                 ,.in(r[WIDTH*2-1:WIDTH])
                 ,.load(c[14])
                 ,.clear(c[2])
                 ,.out(a));

   register reg_x(.clk(clk)
                 ,.in(in_x)
                 ,.load(c[3])
                 ,.clear(1'b0)
                 ,.out(x));

   register_hl reg_r(clk, in_rh, in_rl, c[8], c[9], 1'b0, r);
   
   right_shift_register sign_ext(clk, c[12], r, c[11], sr); 
   
   mux2 #(8) mux_x(multiplier, r[WIDTH-1:0], c[7], in_x);
   mux3 #(8) mux_rh(a, sr[WIDTH*2-1:WIDTH], alu_out, c[5:4], in_rh);
   mux2 #(8) mux_rl(x, sr[WIDTH-1:0], c[6], in_rl);
   
   addsub addsub(.clk(clk)
                ,.dataa(r[WIDTH*2-1:WIDTH])
                ,.datab(y)
                ,.add_sub(c[10])
                ,.result(alu_out));
   
   counter_down decrement8(clk, c[1], c[13], q);
   
   // External: signals to control unit and outbus
   assign product = {a,x};

// fill in guts
//    zr = 1 if r is even
//    zq = 1 if q is divisible by 8
   assign zr = ~r[0];
   assign zq = ~q[0] & ~q[1] & ~q[2];
   
endmodule
