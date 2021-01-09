/*-----------------------------------------------------------------
File name     : packet_test.sv
Developers    : Brian Dickinson
Created       : 01/08/19
Description   : lab1  module for testing packet data
Notes         : From the Cadence "Essential SystemVerilog for UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/

module packet_test;
   // Import package
   import packet_pkg::*;

   // Create class handle
   packet p1;

   // Randomize return value
   int ok;

   // Test block
   initial begin : TEST
/* -----\/----- EXCLUDED -----\/-----
      p1 = new("My package", 2);
      repeat (30) begin	 
	 ok = p1.randomize() with { ptype != ANY; };	 
	 p1.print(BIN);
      end

      $display("\nTarget is violating constraint");
      ok = p1.randomize() with { target == 4'b1111; };	 
      p1.print(BIN);
 -----/\----- EXCLUDED -----/\----- */
      $display("\nPktcount: %0d", packet::getcount());
      p1 = new("UNIDED package", 2, UNIDED);
      ok = p1.randomize() with { ptype != ANY; };
      p1.print(DEC);
      p1 = new("IDED package", 2, IDED);
      ok = p1.randomize() with { ptype != ANY; };
      p1.print(DEC);
      $display("\nPktcount: %0d", packet::getcount());
   end

//--------------------validate functions for verification --------------------
//--------------------Do not edit below this line          --------------------

function int countones (input logic[3:0] vec);
  countones = 0;
  foreach (vec [i])
    if (vec[i]) countones++;
endfunction

function void validate (input packet ap);
  int sco, tco;
  sco = countones(ap.source);
  tco = countones(ap.target);
  if (sco != 1) 
     $display("ERROR in source %h - no. bits set = %0d", ap.source, sco);
  if (ap.ptype == "broadcast") begin
    if  (ap.target != 4'hf) 
       $display("ERROR: broadcast packet target is %h not 4'hf", ap.target);
  end
  else 
  begin
    if ( |(ap.source & ap.target) == 1'b1)   
      $display("ERROR: non-broadcast packet %s has same source %h and target %h bit set", ap.getname(), ap.source, ap.target);
    if ((ap.ptype == "single") & (tco != 1)) 
      $display("ERROR: single packet %s does not have only one bit set in target %h", ap.getname(), ap.target);
    if ((ap.ptype == "multicast") & (tco < 2)) 
      $display("ERROR: multicast packet %s does not have more than one bit set in target %h", ap.getname(), ap.target);
  end
endfunction
    
endmodule
   

