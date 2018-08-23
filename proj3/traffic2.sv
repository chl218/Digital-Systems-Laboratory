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
   parameter S11 = 4'hB;
   parameter S12 = 4'hC;
   parameter S13 = 4'hD;
   parameter S14 = 4'hE;
   parameter S15 = 4'hF;

   logic [3:0] state;
   logic [3:0] next_state;

   assign Lb = 2'bxx;

   always_ff @(posedge clk, posedge  rst)
      if(rst) begin
         state      <= 0;
         next_state <= 0;
      end
      else
         state <= next_state;


   always_comb 
      case(state) 
         S00: next_state = Tb ? S00 : S01;   // RED
         S01: next_state = S02;              // RED
         S02: if(Tb)      next_state = S08;  // GREEN
              else if(Ta) next_state = S02;        
              else        next_state = S03;
         S03: next_state = S04;              // GREEN
         S04: next_state = S05;              // GREEN
         S05: next_state = S06;              // GREEN 
         S06: next_state = S07;              // YELLOW
         S07: next_state = S00;              // YELLOW
         S08: if(Tb) next_state = S09;       // GREEN
              else   next_state = S02;
         S09: if(Tb) next_state = S10;       // GREEN
              else   next_state = S02;
         S10: if(Tb) next_state = S11;       // GREEN
              else   next_state = S02;
         S11: if(Tb) next_state = S09;       // GREEN
              else   next_state = S02;
         S12: if(Tb) next_state = S06;       // GREEN
              else   next_state = S02;
         default:    next_state = S00;
      endcase

      always_comb
         case(state)
            S00:     La = 1'b10; // RED
            S01:     La = 1'b10; // RED
            S06:     La = 2'b01; // YELLOW
            S07:     La = 2'b01; // YELLOW
            default: La = 1'b00; // GREEN
         endcase
endmodule


