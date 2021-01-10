/*-----------------------------------------------------------------
File name     : packet_data.sv
Developers    : Brian Dickinson
Created       : 01/08/19
Description   : lab1 packet data item 
Notes         : From the Cadence "Essential SystemVerilog for UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/
 
// add print and type policies here
typedef enum bit[1:0] { ANY, SINGLE, MULTICAST, BROADCAST } ptype_t;

typedef enum {HEX, DEC, BIN} format_t;

// packet class
class packet;

   // add properties here
   local string name;
   bit [3:0] 	source;
   rand bit [3:0] target;
   rand bit [7:0] data;
   ptype_t ptype;

   constraint target_nz { target != 0; }
   constraint not_same_bit { (target & source) == 4'b0; }
/* -----\/----- EXCLUDED -----\/-----
   constraint packet_type { ptype == SINGLE    -> target inside { 1,2,4,8 };
                            ptype == MULTICAST -> target inside { 3,[5:7],[9:14] };
                            ptype == BROADCAST -> target == 15; }
   constraint ptype_order { solve ptype before target; }
 -----/\----- EXCLUDED -----/\----- */

   // add constructor to set instance name and source by arguments and packet type
   function new(input string name_i,
		input int    source_i);
      this.name   = name_i;
      source = 4'b1 << source_i;
      ptype  = ANY;
   endfunction : new

   function string gettype();
      return ptype.name();
   endfunction : gettype

   function string getname();
      return name;
   endfunction : getname

   // add print with policy
   function void print(input format_t format = HEX);
      $display("Current packet properties with format: %s", format.name());
      $display("Name: %s, packet type: %s", getname(), gettype());
      case ( format )
	DEC    : $display("Source: %d, target: %d, data: %d", source, target, data);
	BIN    : $display("Source: %b, target: %b, data: %b", source, target, data);
	default: $display("Source: %h, target: %h, data: %h", source, target, data);
      endcase
   endfunction : print   
   
endclass : packet

// psingle subclass
class psingle extends packet;

   constraint target_1b { target inside { 1,2,4,8 }; }

   function new(input string name_i,
		input int    source_i);
      super.new(name_i, source_i);
      ptype = SINGLE;
   endfunction : new

endclass : psingle

// pmulticast subclass
class pmulticast extends packet;

   constraint target_23b { target inside { 3,[5:7],[9:14] }; }
   
   function new(input string name_i,
		input int    source_i);
      super.new(name_i, source_i);
      ptype = MULTICAST;
   endfunction : new

endclass : pmulticast

// pbroadcast subclass
class pbroadcast extends packet;

   constraint not_same_bit { } 
   constraint target_4b { target == 15; }
   
   function new(input string name_i,
		input int    source_i);
      super.new(name_i, source_i);
      ptype = BROADCAST;
   endfunction : new

endclass : pbroadcast
     

