module traffic_fsm(
   input clk,
   input rst,
   input Tself,
   input Tother,
   input Lother,
   input hasPriority,
   output logic [1:0] Lself
);

   parameter S00 = 4'h0;
   parameter S01 = 4'h1;
   parameter S02 = 4'h2;
   parameter S03 = 4'h3;
   parameter S04 = 4'h4;
   parameter S05 = 4'h5;
   parameter S06 = 4'h6;
   parameter S07 = 4'h7;
   parameter S08 = 4'h8;
   parameter S09 = 4'h9;
   parameter S10 = 4'hA;

   logic [3:0] state;
   logic [3:0] next_state;

   always_ff @(posedge clk, posedge rst)
      if(rst)
         state <= 0;
      else
         state <= next_state;


   always_comb 
      if(rst) 
         next_state = S00;
      else
         case(state) 
            S00:                                // RED STATE
               if(Tself && Tother)
                  next_state = hasPriority ? S01 : S00;   
               else if(Tself && Lother)
                  next_state = S01;
               else 
                  next_state = S00;

            S01: next_state = S02;              // RED STATE
            S02: next_state = Tother ? S08      // GREEN STATE
                                     : (Tself ? S02 : S03);
            S03: next_state = S04;              // GREEN STATE 
            S04: next_state = S05;              // GREEN STATE 
            S05: next_state = S06;              // GREEN STATE  
            S06: next_state = S07;              // YELLOW  STATE
            S07: next_state = S00;              // YELLOW  STATE
            S08: next_state = S09;              // GREEN STATE    
            S09: next_state = S03;              // GREEN STATE 
          
            default: next_state = S00;
         endcase

      always_comb
         case(state)
            S00:     Lself = 2'b10; // RED OUTPUT
            S01:     Lself = 2'b10; // RED OUTPUT
            S06:     Lself = 2'b01; // YELLOW OUTPUT
            S07:     Lself = 2'b01; // YELLOW OUTPUT
            default: Lself = 2'b00; // GREEN OUTPUT
         endcase

endmodule