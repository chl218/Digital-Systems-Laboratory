// Lab5b_tb   
// testbench for programmable message encryption
// CSE140L  Summer 2018    
// Sequence:  
//  run program 2 (decrypt second message)
module Lab5_tb                   ;
   logic      clk                ; // advances simulation step-by-step
   logic      init               ; // init (reset, start) command to DUT
   wire       done               ; // done flag returned by DUT
   logic[7:0] message2[46]       , // program 2 decrypted message
              pre_length[4]      , // bytes before first character in message
              lfsr_ptrn[4]       , // one of 8 maximal length 8-tap shift reg. ptrns
              lfsr_init[4]       , // starting pattern of program[i] LFSR
              lfsr2[64]          , // states of program 2 decrypting LFSR         
              msg_padded2[64]    , // original message, plus pre- and post-padding
              msg_crypto2[64]    , // encrypted message according to the DUT
              LFSR_ptrn[8]       , // 8 possible maximal-length 8-bit LFSR tap ptrns
              LFSR_init[4]       ; // four of 255 possible NONZERO starting states        

// our original American Standard Code for Information Interchange message follows
// note in practice your design should be able to handle ANY ASCII string
//  string     str2  = " Mr. Watson, come here. I want to see you."; // 1st program 1 input
//  string     str2  = "Knowledge comes, but wisdom lingers.     ";  // program 2 output
//  string     str2  = "                                         ";  // program 2 output
//  string     str2  = "  01234546789abcdefghijklmnopqrstuvwxyz. ";  // 2nd program 1 input
   string     str2  = "          A joke is a very serious thing."; // program 3 output

   // displayed encrypted string will go here:
   string     str_enc2[64]   ;     // program 2 input

   // the 8 possible maximal-length feedback tap patterns from which to choose
   assign LFSR_ptrn[0] = 8'he1;
   assign LFSR_ptrn[1] = 8'hd4;
   assign LFSR_ptrn[2] = 8'hc6;
   assign LFSR_ptrn[3] = 8'hb8;
   assign LFSR_ptrn[4] = 8'hb4;
   assign LFSR_ptrn[5] = 8'hb2;
   assign LFSR_ptrn[6] = 8'hfa;
   assign LFSR_ptrn[7] = 8'hf3;    

   // starting LFSR state for program -- logical OR guarantees nonzero
   assign LFSR_init[1] = $random | 8'h20;  // for program 2 run

   // set preamble lengths for the four program runs (always > 8)
   assign pre_length[1] = 10;
   int ct = 0;

   top_level5 dut(.*); // your top level design goes here 

   initial begin
      clk         = 0; // initialize clock
      init        = 1; // activate reset

      // program 2 -- precompute encrypted message
      lfsr_ptrn[1] = LFSR_ptrn[3];         // select one of 8 permitted
      lfsr2[0]     = LFSR_init[1];         // any nonzero value (zero may be helpful for debug)
    
      $display("run program 2");
      $display("%s",str2);         // print original message in transcript window
      $display("LFSR_ptrn = %h, LFSR_init = %h",lfsr_ptrn[1],lfsr2[0]);    
      
      for(int j=0; j<64; j++)          // pre-fill message_padded with ASCII space characters
         msg_padded2[j] = 8'hA0;         
    
      for(int l=0; l<46; l++)          // overwrite up to 41 of these spaces w/ message itself
         msg_padded2[pre_length[1]+l] = {^str2[l][6:0],str2[l][6:0]}; 

      // compute the LFSR sequence
      for (int ii=0;ii<63;ii++) begin 
         lfsr2[ii+1] = (lfsr2[ii]<<1)+(^(lfsr2[ii]&lfsr_ptrn[1]));//{LFSR[6:0],(^LFSR[5:3]^LFSR[7])};       // roll the rolling code
         $display("lfsr_ptrn %d = %h",ii,lfsr2[ii]);
      end

      // encrypt the message
      for (int i=0; i<64; i++) begin            // testbench will change on falling clocks
         msg_crypto2[i]        = msg_padded2[i] ^ lfsr2[i];  //{1'b0,LFSR[6:0]};    // encrypt 7 LSBs
         str_enc2[i]           = string'(msg_crypto2[i]);
      end
   
      for(int jj=0; jj<64; jj++)
         $write("%s",str_enc2[jj]);
         
      $display("\n");

      // run program 2
      init = 0;
      #60ns init = 1;     // activate reset
      for(int n=64; n<128; n++)
         dut.dm1.core[n] = msg_crypto2[n-64];//{^msg_crypto2[n-64][6:0],msg_crypto2[n-64][6:0]};
    
      #20ns init = 0;
      #60ns;                // wait for 6 clock cycles of nominal 10ns each
      wait(done);           // wait for DUT's done flag to go high
      #10ns $display();
      $display("program 2:");

      for(int n=0; n<46; n++)
         $display("%d bench msg: %h dut msg: %h    %s", n, str2[n], dut.dm1.core[n+ct][6:0], dut.dm1.core[n+ct][6:0] );   
 
    #20ns $stop;
  end

   always begin      // continuous loop
      #5ns clk = 1;  // clock tick
      #5ns clk = 0;  // clock tock
   end               // continue

endmodule