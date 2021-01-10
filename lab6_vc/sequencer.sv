class sequencer extends component_base;

   int portno;
   
   function new (string name, component_base parent);
      super.new(name, parent);
   endfunction

   function void get_next_item(output packet pkt);
      int ok;
      randcase
	   1: begin : single_packet
	      psingle ps = new("Single packet", portno);
	      ok = ps.randomize();
	      pkt = ps;
	   end
	   1: begin : multicast_packet
	      pmulticast pm = new("Multicast packet", portno);
	      ok = pm.randomize();
	      pkt = pm;
	   end
	   1: begin : broadcast_packet
	      pbroadcast pb = new("Broadcast packet", portno);
	      ok = pb.randomize();
	      pkt = pb;
	   end
      endcase
   endfunction   
   
endclass
   
      
