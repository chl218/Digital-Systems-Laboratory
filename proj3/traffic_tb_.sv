// traffic test bench for lab 3, summer 2018
// CSE140L
module traffic_tb();

   logic      clk, rst;
   logic      Ta,  Tb;       // traffic sensors
   wire [1:0] La,  Lb;      // traffic lights
   
   typedef enum {green, yellow, red} colors;
   colors Ma, Mb;         // maps colors

   traffic t1(.*);         // your DUT

   assign Ma = colors'(La);
   assign Mb = colors'(Lb);
  
   initial begin
      $monitor("NS = %s, EW = %s, time = %t",Ma,Mb,$time);
//  $monitor("NS = %d, EW = %d, time = %t",La,Lb,$time);
      clk = 0;
      rst = 1;
      Ta  = 0;
      Tb  = 0;
      #20ns rst = 0;
      #50ns Tb = 1;
      wait(!Lb);//(La == 2'b0);
   
      #15ns Tb = 0;
      #60ns Ta = 1;
      wait(!La);// == 2'b0);
   
      #15ns Ta = 0;
      #250ns 
         fork 
            begin
               Ta = 1;
               wait(!La);// == 2'b0);
               #15ns Ta = 0;
            end
            
            begin
               Tb = 1;
               wait(!Lb);// == 2'b0);
               #15ns Tb = 0;
            end
         join
      #200ns $stop;
   end
  
   always begin
      #5ns clk = 1;
      #5ns clk = 0;
//    $display();
   end

endmodule


