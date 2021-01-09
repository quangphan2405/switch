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
typedef enum bit[1:0] {ANY, SINGLE, MULTICAST, BROADCAST} ptype_t;

typedef enum {HEX, DEC, BIN} format_t;

typedef enum bit {UNIDED, IDED} mode_t;

// packet class
class packet;

   // add properties here
   local string name;
   bit [3:0] 	source;
   rand bit [3:0] target;
   rand bit [7:0] data;
   rand ptype_t ptype;
   static int 	pktcount;
   int 		tag;
   mode_t         tagmode;
   

   constraint target_nz { target != 0; }
   constraint not_same_bit { (target & source) == 4'b0; }
   constraint packet_type { ptype == SINGLE    -> target inside { 1,2,4,8 };
                            ptype == MULTICAST -> target inside { 3,[5:7],[9:14] };
                            ptype == BROADCAST -> target == 15; }

   // add constructor to set instance name and source by arguments and packet type
   function new(input string name_i,
		input int source_i,
		input mode_t mode);
      this.name   = name_i;
      source = 4'b1 << source_i;
      ptype  = ANY;
      pktcount++;
      tag = pktcount;
      tagmode = mode;
   endfunction : new

   static function int getcount();
     return (pktcount);
   endfunction : getcount

   function void post_randomize();
      if (tagmode == IDED)
	data = tag;
   endfunction : post_randomize

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
      $display("Pktcount: %0d, tag: %0d, tagmode: %s", getcount(), tag, tagmode.name());
      case ( format )
	DEC    : $display("Source: %d, target: %d, data: %d\n", source, target, data);
	BIN    : $display("Source: %b, target: %b, data: %b\n", source, target, data);
	default: $display("Source: %h, target: %h, data: %h\n", source, target, data);
      endcase
   endfunction : print
   
endclass

