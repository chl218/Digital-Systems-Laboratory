module traffic_tb();

   logic      clk, rst;
   logic      Ta,  Tb;      // traffic sensors
   wire [1:0] La,  Lb;      // traffic lights
   
   typedef enum {green, yellow, red} colors;
   colors Ma, Mb;         // maps colors

   traffic t1(.*);        // DUT

   assign Ma = colors'(La);
   assign Mb = colors'(Lb);
  
   initial begin
      $monitor("NS = %s, EW = %s, time = %t", Ma, Mb, $time);
      clk = 0;
      rst = 1;
      Ta  = 0;
      Tb  = 0;
      #20ns rst = 0;
      #50ns Tb = 1;
      #50ns Tb = 0;
      wait(!Lb);

      #15ns Tb = 0;
      #60ns Ta = 1;    
      wait(!La);
      #15ns Ta = 0;

      #250ns 
         fork 
            begin
               Ta = 1;
               wait(!La);
               #15ns Ta = 0;
            end
            
            begin
               Tb = 1;
               wait(!Lb);
               #15ns Tb = 0;
            end
         join
      #200ns $stop;
   end
  
   always begin
      #5ns clk = 1;
      #5ns clk = 0;
   end

endmodule


