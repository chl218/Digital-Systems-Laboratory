// Asynchronous load and store register
module register # (parameter WIDTH = 8) (
    input                    clk,
    input        [WIDTH-1:0] in,
    input                    load,
    input                    clear,
    output logic [WIDTH-1:0] out
);
    
    always @ (posedge clk, posedge clear)
        if(clear)
            out <= 0;
        else if(load)
            out <= in;
        // else
        //     out <= in;
            
// fill in guts
//   clear   load    out
//     1       0      0
//     1       1      0
//     0       0     hold
//     0       1      in

endmodule

