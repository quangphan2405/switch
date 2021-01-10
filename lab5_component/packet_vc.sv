class packet_vc extends component_base;
   agent agnt;

   function new(string name, component_base parent);
      super.new(name, parent);
      agnt = new("Agent", this);
   endfunction // new

   task run();
      agnt.drv.run();
      agnt.mnt.run();
   endtask

endclass
   
