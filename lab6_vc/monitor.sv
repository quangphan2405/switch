class monitor extends component_base;
   int portno;
   packet pkt;
   
   virtual interface port_if pif;

   function new(string name, component_base parent);
      super.new(name, parent);
   endfunction

   task run();
      forever begin : MONITOR
	 pif.collect_packet(pkt);
	 $display("\nAt time @%t, port%0d monitor (%s) captures packet!", $time, portno, pathname());	 
	 pkt.print(BIN);
      end   
   endtask  

endclass

