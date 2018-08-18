// CSE140L  Summer 2018
// see Structural Diagram in Lab1.pdf

module struct_diag(
   input Reset,
         Clk,
         Timeset,    // manual buttons
         Alarmset,   // (five total)
         Minadv,
         Hrsadv,
         Alarmon,
         Pulse,      // assume 1/sec.

   // 6 decimal digit display (7 segment)
   output logic[6:0] S1disp, S0disp, 
                     M1disp, M0disp,
                     H1disp, H0disp,
   output logic buzz        // alarm sounds


);

   logic[6:0] TSec, TMin, THrs, AMin, AHrs;
   logic[6:0] Min, Hrs;
   logic Szero, Mzero, Hzero, TMen, THen, AMen, AHen; 
   logic Buz_drive;

   // free-running seconds counter
   ct_mod60 Sct(.clk(Pulse), .rst(Reset), .en(1'b1), .ct_out(TSec), .z(Szero));

   // minutes counter -- runs at either 1/sec or 1/60sec
   ct_mod60 Mct(.clk(Pulse), .rst(Reset), .en(TMen), .ct_out(TMin), .z(Mzero));

   // hours counter -- runs at either 1/sec or 1/60min
   ct_mod24 Hct(.clk(Pulse), .rst(Reset), .en(THen), .ct_out(THrs), .z(Hzero));

   // time set switch logic
   assign TMen = Timeset && Minadv ? Pulse : Szero;
   assign THen = Timeset && Hrsadv ? Pulse : Mzero; 

   // alarm set registers -- either hold or advance 1/sec
   ct_mod60 Mreg(.clk(Pulse), .rst(Reset), .en(AMen), .ct_out(AMin), .z()); 
   ct_mod24 Hreg(.clk(Pulse), .rst(Reset), .en(AHen), .ct_out(AHrs), .z()); 

   assign AMen = Alarmset && Minadv;
   assign AHen = Alarmset && Hrsadv;
  
   assign Min = Alarmset ? AMin : TMin;
   assign Hrs = Alarmset ? AHrs : THrs;

   // display drivers (2 digits each, 6 digits total)
   lcd_int Sdisp(.bin_in(TSec), .Segment1(S1disp), .Segment0(S0disp));
   lcd_int Mdisp(.bin_in(Min),  .Segment1(M1disp), .Segment0(M0disp));
   lcd_int Hdisp(.bin_in(Hrs),  .Segment1(H1disp), .Segment0(H0disp));

   // buzz off
  alarm a1(.tmin(TMin), .amin(AMin), .thrs(THrs), .ahrs(AHrs), .buzz(Buz_drive));
  
  assign Buzz = Buz_drive && Alarmon;

endmodule