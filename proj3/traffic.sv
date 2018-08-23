// shell for your DUT -- Lab 3   traffic   summer 2018  CSE140L
module traffic(
   input              clk,
                      rst,
                      Ta,
                      Tb,  // NS traffic present; EW traffic present
   output logic [1:0] La, 
                      Lb   // traffic light NS; traffic signal EW
);

// map La=0 to green, La=1 to yellow, La=2 to red; same for Lb

// your (Moore) state machine goes here


   logic la, lb;

   assign la = La[1];
   assign lb = Lb[1];

   traffic_fsm NS(.clk(clk)
                 ,.rst(rst)
                 ,.Ta(Ta)
                 ,.Tb(Tb)
                 ,.Lb(lb)
                 ,.priority(1'b1)
                 ,.La(La));

   traffic_fsm EW(.clk(clk)
                 ,.rst(rst)
                 ,.Ta(Tb)
                 ,.Tb(Ta)
                 ,.Lb(la)
                 ,.priority(1'b0)
                 ,.La(Lb));


endmodule


