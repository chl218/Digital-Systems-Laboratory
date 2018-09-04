// shell for 
module encoder #(parameter WIDTH = 8)(
   input        clk, 
   input        init,
   output logic done
);


   parameter STATE00 = 0;
   parameter STATE01 = 1;
   parameter STATE02 = 2;
   parameter STATE03 = 3;
   parameter STATE04 = 4;
   parameter STATE05 = 5;

   logic [3:0] state;
   logic [3:0] state_next;

   logic [WIDTH-1:0] raddr, raddr_next;
   logic [WIDTH-1:0] waddr, waddr_next;

   logic [WIDTH-1:0] data_i;
   logic [WIDTH-1:0] data_o;

   logic [WIDTH-1:0] padding, padding_next;
   logic dmem_wen;

   dmem dm (.clk(clk)
           ,.init(init)
           ,.wen(dmem_wen)
           ,.raddr(raddr)
           ,.waddr(waddr)
           ,.data_i(data_i)
           ,.data_o(data_o));

   logic [WIDTH-1:0] lfsr_tab;
   logic [WIDTH-1:0] lfsr_init_state;
   logic [WIDTH-1:0] lfsr_state;

   logic lfsr_init;
   logic lfsr_en;

   LFSR lfsr(.clk(clk)
            ,.lfsr_init(lfsr_init)
            ,.lfsr_en(lfsr_en)
            ,.lfsr_tab(lfsr_tab)
            ,.lfsr_init_state(data_o)
            ,.state_o(lfsr_state));



   logic [WIDTH-1:0] msg_padded;

   assign msg_padded = state == STATE03 ? 8'b1010_0000 : data_o; // {^data_o, data_o[6:0]};

   assign data_i = state == STATE03 ? (lfsr_state ^ 8'b1010_0000)
                                    : (lfsr_state ^ data_o);// {^data_o, data_o[6:0]});

   always_comb begin
      
      case(state) 
         STATE02: lfsr_init = 1;
         default: lfsr_init = 0;
      endcase

      case(state) 
         STATE03: begin lfsr_en = 1; dmem_wen = 1; end
         STATE04: begin lfsr_en = 1; dmem_wen = 1; end
         
         // STATE04: begin lfsr_en = 1; dmem_wen = 1; end
         // STATE05: begin lfsr_en = 1; dmem_wen = 1; end
         default: begin lfsr_en = 0; dmem_wen = 0; end
      endcase

      case(state)
         STATE01: state_next = STATE02;
         STATE02: state_next = padding == 0 ? STATE04 : STATE03;
         STATE03: state_next = padding == 1 ? STATE04 : STATE03;
         STATE04: state_next = STATE04;
         // STATE03: state_next = STATE04;
         // STATE04: state_next = padding == 0 ? STATE05 : STATE04;
         // STATE05: state_next = STATE05;
         default: state_next = init ? STATE00 : STATE01;
      endcase

      case(state)
         STATE01: raddr_next = 63;
         STATE02: raddr_next = 0;
         STATE03: raddr_next = 0;
         STATE04: raddr_next = raddr + 1'b1;
         // STATE05: raddr_next = raddr + 1'b1;
         default: raddr_next = 62;
      endcase;

      case(state)
         STATE03: waddr_next = waddr + 1'b1;
         STATE04: waddr_next = waddr + 1'b1;
         default: waddr_next = 64;
      endcase 

      case(state)
         STATE00: padding_next = data_o;
         STATE03: padding_next = padding - 1'b1;
         default: padding_next = padding;
      endcase 

   end



   logic[5:0] counter;

   always_ff @(posedge clk)
      if(init) begin
         counter  <= 0;
         state    <= 0;
         raddr    <= 61;
      end
      else begin
         counter <= counter + 1'b1;
         state   <= state_next;
         waddr   <= waddr_next;
         raddr   <= raddr_next;
         padding <= padding_next;
         // if(state == STATE01) lfsr_init_state <= data_o;
         if(state == STATE01) lfsr_tab        <= data_o;


      end

   assign done = &counter;

endmodule
