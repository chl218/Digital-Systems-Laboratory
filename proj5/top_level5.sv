// this is a dummy DUT and "placeholder" in the Lab 5 test bench 
//   -- you will substitute your own top_level module here
// CSE141L -- lab 5
// applies done flag when cycle_ct = 255
module top_level5(
   input        clk, init, 
   output logic done

);
   logic      initQ;
   logic[15:0] cycle_ct = 0;
  
   dmen dm(.*);                  // instantiate data memory
  
  logic[7:0] LFSR[64];              // 64 states of winning LFSR
  logic[7:0] taps;                  // LFSR feedback pattern
  logic[7:0] prel;
  logic[7:0] lfsr_trial[8][9];      // 9-cycle histories of 8 LFSRs
  logic[7:0] LFSR_ptrn[8];          // 8 candidate LFSR feedback patterns
  
  assign LFSR_ptrn[0] = 8'he1;      // 
  assign LFSR_ptrn[1] = 8'hd4;      //  we need to test all to see which
  assign LFSR_ptrn[2] = 8'hc6;      //  one was used in the message
  assign LFSR_ptrn[3] = 8'hb8;
  assign LFSR_ptrn[4] = 8'hb4;
  assign LFSR_ptrn[5] = 8'hb2;
  assign LFSR_ptrn[6] = 8'hfa;
  assign LFSR_ptrn[7] = 8'hf3;

  logic[7:0] foundit;               // tracks which LFSR ptrn matched
  logic[7:0] space_ct = 0;          // count leading space characters in message

   always @(posedge clk) begin  :clock_loop
      initQ <= init;
      
      if(!init)
         cycle_ct <= cycle_ct + 1;          // cycle counter -- mainly for interest
    
      if(!init && initQ) begin :init_loop  // falling init
         for(int jl=0;jl<9;jl++)
            LFSR[jl] = dm.core[64+jl]^8'hA0;
         
         lfsr_trial[0][0] = dm.core[64]^8'hA0;
         lfsr_trial[1][0] = dm.core[64]^8'hA0;
         lfsr_trial[2][0] = dm.core[64]^8'hA0;
         lfsr_trial[3][0] = dm.core[64]^8'hA0;
         lfsr_trial[4][0] = dm.core[64]^8'hA0;
         lfsr_trial[5][0] = dm.core[64]^8'hA0;
         lfsr_trial[6][0] = dm.core[64]^8'hA0;
         lfsr_trial[7][0] = dm.core[64]^8'hA0;
         
         for(int kl=0;kl<8;kl++) begin
            lfsr_trial[0][kl+1] = (lfsr_trial[0][kl]<<1)+(^(lfsr_trial[0][kl]&LFSR_ptrn[0]));   
            lfsr_trial[1][kl+1] = (lfsr_trial[1][kl]<<1)+(^(lfsr_trial[1][kl]&LFSR_ptrn[1]));   
            lfsr_trial[2][kl+1] = (lfsr_trial[2][kl]<<1)+(^(lfsr_trial[2][kl]&LFSR_ptrn[2]));   
            lfsr_trial[3][kl+1] = (lfsr_trial[3][kl]<<1)+(^(lfsr_trial[3][kl]&LFSR_ptrn[3]));   
            lfsr_trial[4][kl+1] = (lfsr_trial[4][kl]<<1)+(^(lfsr_trial[4][kl]&LFSR_ptrn[4]));   
            lfsr_trial[5][kl+1] = (lfsr_trial[5][kl]<<1)+(^(lfsr_trial[5][kl]&LFSR_ptrn[5]));   
            lfsr_trial[6][kl+1] = (lfsr_trial[6][kl]<<1)+(^(lfsr_trial[6][kl]&LFSR_ptrn[6]));   
            lfsr_trial[7][kl+1] = (lfsr_trial[7][kl]<<1)+(^(lfsr_trial[7][kl]&LFSR_ptrn[7]));   
            
            $display("trials %d %h %h %h %h %h %h %h %h   %h",  kl,
               lfsr_trial[0][kl+1], lfsr_trial[1][kl+1], lfsr_trial[2][kl+1],
               lfsr_trial[3][kl+1], lfsr_trial[4][kl+1], lfsr_trial[5][kl+1],
               lfsr_trial[6][kl+1], lfsr_trial[7][kl+1], LFSR[kl+1]);          
         end

         for(int mm=0;mm<8;mm++) begin
            $display("mm = %d  lfsr_trial[mm] = %h, LFSR[8] = %h", mm, lfsr_trial[mm][8], LFSR[8]); 
          
            if(lfsr_trial[mm][8] == LFSR[8]) begin
               foundit = mm;
               $display("foundit = %d LFSR[8] = %h",foundit,LFSR[8]);
            end
        end

         $display("foundit fer sure = %d",foundit);                         
         for(int jm=0;jm<63;jm++)
            LFSR[jm+1] = (LFSR[jm]<<1)+(^(LFSR[jm]&LFSR_ptrn[foundit]));
        
         for(int mn=0;mn<64;mn++) begin
            dm.core[mn-0] = dm.core[64+mn]^LFSR[mn];
            $display("%dth core = %h LFSR = %h",mn,dm.core[64+mn-9],LFSR[mn-9]);
         end
        
         for(int mm=0;mm<25;mm++)         // counts leading space characters
            if(dm.core[mm][6:0]==7'h20) space_ct++;
         else 
            break;
        
         for(int mq=0;mq<64;mq++)        // move first nonspace to address 0
            dm.core[mq] = dm.core[mq+space_ct];
    
    end :init_loop
  end  :clock_loop

  always_comb
    done = &cycle_ct[6:1];   // holds for two clocks

endmodule