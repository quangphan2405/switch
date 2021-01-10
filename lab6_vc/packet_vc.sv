class packet_vc extends component_base;
   
   agent agn;

   function new(string name, component_base parent);
      super.new(name, parent);
      agn = new("agn", this);
   endfunction

   function void configure(virtual interface port_if pif, int portno);
      agn.drv.pif = pif;
      agn.mnt.pif = pif;
      agn.seq.portno = portno;
      agn.mnt.portno = portno;
   endfunction  

   task run(int runs);
      fork
	 agn.mnt.run();
      join_none
      agn.drv.run(runs);
   endtask

endclass
   
