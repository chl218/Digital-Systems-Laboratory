// shell for your DUT -- Lab 3   traffic   summer 2018  CSE140L
module traffic(
   input              Ta,
                      Tb,  // NS traffic present; EW traffic present
                      clk,
                      Reset,
   output logic [1:0] La, 
                      Lb // traffic light NS; traffic signal EW
);

// map La=0 to green, La=1 to yellow, La=2 to red; same for Lb

// your (Moore) state machine goes here

endmodule


