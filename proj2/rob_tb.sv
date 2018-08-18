// CSE140L   Summer 2018   Lab 2
module rob_tb;

   // Inputs
   logic clk;
   logic reset;
   logic [7:0] multiplier;
   logic [7:0] multiplicand;

   // Outputs
   wire [15:0] product;
   wire done;
      
   // keep track of execution status
   logic  [31:0] cycle;
      
   // expected results
   logic [15:0] expected_product;

   // Instantiate the Unit Under Test (UUT)
   toprobertsons uut (.clk(clk)
                     ,.reset(reset) 
                     ,.multiplier(multiplier) 
                     ,.multiplicand(multiplicand) 
                     ,.product(product)
                     ,.done(done));

   static int N = 100;
   static int M = 100;

   int error = 0;
   int skip  = 0;

   initial begin
         // Initialize Inputs
         clk   = 0;
         reset = 0;
         cycle = 0;

         multiplier       = 0;
         multiplicand     = 0;
         expected_product = 0;
         rslt_disp;

         // Add stimulus here

//1.1 Positive Multiplicand and Positive Multiplier
         multiplier       = 5;
         multiplicand     = 6;
         expected_product = 30;
         rslt_disp;

// 1.2 Positive Multiplicand and Positive Multiplier
         multiplier = 7;
         multiplicand = 5;
         expected_product = 35;
         rslt_disp;

// 2.1 Negative Multiplicand and Positive Multiplier
         multiplier = 5;
         multiplicand = -6;
         expected_product = -30;
         rslt_disp;

// 2.2 Negative Multiplicand and Positive Multiplier
         multiplier       = 7;
         multiplicand     = -5;
         expected_product = -35;
         rslt_disp;

// 3.1 Positive Multiplicand and Negative Multiplier
         multiplier       = -5;
         multiplicand     = 6;
         expected_product = -30;
         rslt_disp;

// 3.2 Positive Multiplicand and Negative Multiplier
         multiplier       = -7;
         multiplicand     = 8;
         expected_product = -56;
         rslt_disp;

// 4.1 Negative Multiplicand and Negative Multiplier
         multiplier       = -5;
         multiplicand     = -6;
         expected_product = 30;
         rslt_disp;

// 4.2 Negative Multiplicand and Negative Multiplier
         multiplier       = -9;
         multiplicand     = -4;
         expected_product = 36;
         rslt_disp;


         $display("\nTesting 0 x 0 to %3d x %3d:", N, M);

         error = 0;
         skip  = 1;
         for(int i = 0; i < N; i++) begin
            for(int j = 0; j < M; j++) begin
               for(int k = 0; k < 4; k++) begin
                  case(k)
                     0: begin 
                        multiplier   = i;
                        multiplicand = j;
                        expected_product = $signed(multiplier) * $signed(multiplicand);
                     end 
                     1:begin 
                        multiplier   = -i;
                        multiplicand = j;
                        expected_product = $signed(multiplier) * $signed(multiplicand);
                     end
                     2:begin 
                        multiplier   = i;
                        multiplicand = -j;
                        expected_product = $signed(multiplier) * $signed(multiplicand);
                     end
                     3:begin 
                        multiplier   = -i;
                        multiplicand = -j;
                        expected_product = $signed(multiplier) * $signed(multiplicand);
                      end
                  endcase
                  rslt_disp;
                  if(error == 5)
                     break;
               end
                  if(error == 5)
                     break;
            end
               if(error == 5)
                  break;
         end

         #40 $stop;
    end
         
      // generate clock to sequence tests
      always begin
         #5 clk = 1; 
         #5 clk = 0; 
         cycle++;
      end

   task rslt_disp;
      reset = 1; 
      #10 reset = 0;
      
      cycle++;
      #10 wait(done);
      
      if (product != expected_product) begin 
         $display("Simulation failed: %3d * %3d", $signed(multiplier), $signed(multiplicand));
         $display("\tExpected: %b (%d)", expected_product, $signed(expected_product));
         $display("\tActual:   %b (%d)", product, $signed(product));
         error++;
      end
      else if(!skip)
         $display("Simulation succeeded %3d * %3d  = %d",  
              $signed(multiplier),  $signed(multiplicand), $signed(product));
        
      #40;
   endtask

             
endmodule


