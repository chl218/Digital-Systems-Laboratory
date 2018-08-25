module traffic(
   input              clk,
                      rst,
                      Ta,
                      Tb,  // NS traffic present; EW traffic present
   output logic [1:0] La, 
                      Lb   // traffic light NS; traffic signal EW
);

   // map La=0 to green, La=1 to yellow, La=2 to red; same for Lb

   logic la, lb;

   assign la = La[1];
   assign lb = Lb[1];

   traffic_fsm NS(.clk(clk)
                 ,.rst(rst)
                 ,.Tself(Ta)
                 ,.Tother(Tb)
                 ,.Lother(lb)
                 ,.hasPriority(1'b1)
                 ,.Lself(La));

   traffic_fsm EW(.clk(clk)
                 ,.rst(rst)
                 ,.Tself(Tb)
                 ,.Tother(Ta)
                 ,.Lother(la)
                 ,.hasPriority(1'b0)
                 ,.Lself(Lb));


endmodule


