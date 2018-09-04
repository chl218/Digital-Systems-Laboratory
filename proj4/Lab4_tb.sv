// CSE140L  Summer 2018    
// Lab4_tb
// full testbench for programmable message encryption
module Lab4_tb                 ;
  logic      clk               ;     // advances simulation step-by-step
  logic      init              ;     // init (reset, start) command to DUT
  wire       done              ;     // done flag returned by DUT
  logic[7:0] message[41]       ,     // original message, in binary
             msg_padded[60]    ,     // original message, plus pre- and post-padding
             msg_crypto[60]    ,     // encrypted message to test against DUT
             msg_crypto_DUT[60],     // encrypted message according to the DUT
             pre_length        ,     // bytes before first character in message
             lfsr_ptrn         ,     // one of 8 maximal length 8-tap shift reg. ptrns
             lfsr_state        ;     // initial state of encrypting LFSR         
                        
   logic[7:0] LFSR             ;     // linear feedback shift register, makes PN code
   logic[7:0] i    = 0         ;     // index counter -- increments on each clock cycle

   // our original American Standard Code for Information Interchange message follows
   // note in practice your design should be able to handle ANY ASCII string
   string str  = "Mr. Watson, come here. I want to see you.";
   int str_len                  ;     // length of string (character count)
   assign str_len = str.len     ;

   // displayed encrypted string will go here:
   string str_enc[64]           ; 

   encoder dut(.*)              ;    // your top level design goes here 

   initial begin
      clk         = 0            ;  // initialize clock
      init        = 1            ;  // activate reset
      pre_length  = 9            ;  // set preamble length
      lfsr_ptrn   = 8'hb8        ;  // select one of 8 permitted
      lfsr_state  = 8'h11        ;  // any nonzero value (0 may be useful for debug teseting)
      LFSR        = lfsr_state   ;  // initalize test bench's LFSR
      
      $display("%s",str)         ;  // print original message in transcript window
      for(int j=0; j<60; j++)       // pre-fill message_padded with ASCII space characters
         msg_padded[j] = 8'hA0;     //   with parity in bit [7]
      
      for(int k=0; k<str_len; k++)  // add parity bit to each message character
         str[k][7] = ^str[k][6:0];          
    
      for(int l=0; l<str_len; l++)  // overwrite up to 48 of these spaces w/ message itself
         msg_padded[pre_length+l] = str[l]; 
    
      for(int m=0; m<48; m++)  
         dut.dm.mem[m] = str[m];    // copy original string into device's data memory[0:40]
    
      dut.dm.mem[61] = pre_length;  // number of bytes preceding message 
      dut.dm.mem[62] = lfsr_ptrn;   // LFSR feedback tap positions (8 possible ptrns)
      dut.dm.mem[63] = lfsr_state;  // LFSR starting state (nonzero)

//    $display("%d  %h  %h  %h  %s",i,message[i],msg_padded[i],msg_crypto[i],str[i]);
      #20ns init = 0             ;
      #60ns;    
      for(int ij = 0; ij < 60; ij++) begin
         // $display("%2d Solution steps: %h %h", ij, msg_padded[ij], LFSR);
         msg_crypto[ij] = msg_padded[ij] ^ LFSR;//{1'b0,LFSR[6:0]};    // encrypt 7 LSBs
         LFSR           = (LFSR << 1) + (^(LFSR & lfsr_ptrn));//{LFSR[6:0],(^LFSR[5:3]^LFSR[7])};        // roll the rolling code
         str_enc[ij]    = string'(msg_crypto[ij]);
      end
                               // wait for 6 clock cycles of nominal 10ns each
      wait(done);              // wait for DUT's done flag to go high

      for(int n=0; n<60; n++)
         $display("%d bench msg: %h dut msg: %h",n, msg_crypto[n], dut.dm.mem[n+64]);   
    
      $stop;
   end

   always begin      // continuous loop
      #5ns clk = 1;  // clock tick
      #5ns clk = 0;  // clock tock
   end               // continue


endmodule