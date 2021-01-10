class driver extends component_base;

   packet pkt;
   sequencer seq_ref;
   
   virtual interface port_if pif;

   function new (string name, component_base parent);
      super.new(name, parent);
   endfunction

   task run(int runs);
      repeat (runs) begin : GENERATE
	 seq_ref.get_next_item(pkt);
	 $display("\nAt time @%t, driver (%s) sends packet!", $time, pathname());
	 pkt.print(BIN);
	 pif.drive_packet(pkt);	 
      end
   endtask

endclass
