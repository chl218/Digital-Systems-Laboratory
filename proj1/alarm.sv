// CSE140 lab 1  Summer 2018
// drives buzzer if alarm setting matches current time
module alarm(
   input[6:0]  tmin,
               amin,
               thrs,
               ahrs,
  output logic buzz
);

   assign buzz = (tmin == amin) && (thrs == ahrs);

endmodule