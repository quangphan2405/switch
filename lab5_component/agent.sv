class agent extends component_base;
   sequencer seq;
   driver drv;
   monitor mnt;

   function new(string name, component_base parent);
      super.new(name, parent);
      seq = new("Sequencer", this);
      drv = new("Driver", this);
      mnt = new("Monitor", this);
      drv.seq_ref = seq;
   endfunction

endclass


