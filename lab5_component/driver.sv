class driver extends component_base;

   sequencer seq_ref;

   function new (string name, component_base parent);
      super.new(name, parent);
   endfunction

   task run();
      $display("Driver path name: %s", pathname());
      $display("Sequencer path name: %s", seq_ref.pathname());
   endtask

endclass
