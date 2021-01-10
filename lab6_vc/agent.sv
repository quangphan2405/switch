class agent extends component_base;
   sequencer seq;
   driver drv;
   monitor mnt;

   function new(string name, component_base parent);
      super.new(name, parent);
      seq = new("seq", this);
      drv = new("drv", this);
      mnt = new("mnt", this);
      drv.seq_ref = seq;
   endfunction

endclass


