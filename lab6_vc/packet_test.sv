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
   packet p_arr[16];
   psingle ps;
   pmulticast pm;
   pbroadcast pb;
   string inst_name;

   // Randomize return value
   int ok;

   // Test block
/* -----\/----- EXCLUDED -----\/-----
   initial begin : TEST
      foreach ( p_arr[i] ) begin : INST
	 inst_name.itoa(i);
	 inst_name = { "inst_", inst_name };
	 randcase
	   1: begin : single_packet
	      ps = new(inst_name, 0);
	      ok = ps.randomize();
	      p_arr[i] = ps;
	   end
	   1: begin : multicast_packet
	      pm = new(inst_name, 1);
	      ok = pm.randomize();
	      p_arr[i] = pm;
	   end
	   1: begin : broadcast_packet
	      pb = new(inst_name, 2);
	      ok = pb.randomize();
	      p_arr[i] = pb;
	   end
	 endcase
      end

      foreach ( p_arr[i] ) begin : PRINT
	 p_arr[i].print(BIN);
	 validate(p_arr[i]);
	 $display("\n");	 
      end	     
   end
 -----/\----- EXCLUDED -----/\----- */

   // Verification component handle
   packet_vc vc;

   // Stimulus
   initial begin : STIMULUS
      vc = new("VC", null);
      vc.run;
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
  if (ap.ptype == BROADCAST) begin
    if  (ap.target != 4'hf) 
       $display("ERROR: broadcast packet target is %h not 4'hf", ap.target);
  end
  else 
  begin
    if ( |(ap.source & ap.target) == 1'b1)   
      $display("ERROR: non-broadcast packet %s has same source %h and target %h bit set", ap.getname(), ap.source, ap.target);
    if ((ap.ptype == SINGLE) & (tco != 1)) 
      $display("ERROR: single packet %s does not have only one bit set in target %h", ap.getname(), ap.target);
    if ((ap.ptype == MULTICAST) & (tco < 2)) 
      $display("ERROR: multicast packet %s does not have more than one bit set in target %h", ap.getname(), ap.target);
  end
endfunction
    
endmodule
   

