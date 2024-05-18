`ifndef FIFO_ITEM__SV
`define FIFO_ITEM__SV

class fifo_item extends uvm_sequence_item;

  // Rand Members
	rand bit                      wr_en;
	rand bit                      rd_en;
	rand logic [`DATA_WIDTH-1:0]  data_in;
	logic                         full;
	logic                         empty;
	logic      [`DATA_WIDTH-1:0]  data_out;

  // Field Macros
	`uvm_object_utils_begin(fifo_item)
	`uvm_field_int(data_in, UVM_ALL_ON)
	`uvm_field_int(rd_en, UVM_ALL_ON)
	`uvm_field_int(wr_en, UVM_ALL_ON)
	`uvm_field_int(full, UVM_ALL_ON)
	`uvm_field_int(empty, UVM_ALL_ON)
	`uvm_field_int(data_out, UVM_ALL_ON)
	`uvm_object_utils_end

  // Consraints
  //  if any..

  // Constructor
  function new (string name = "fifo_item");
	super.new(name);
  endfunction: new
   
   function string convert2string();
	  return $psprintf("data_in=%0h,data_out=%0h,wr_en=%0d,rd_en=%0h,full=%0h,empty=%0d",data_in,data_out,wr_en,rd_en,full,empty);
	endfunction

	function void post_randomize();
		if(!wr_en)
		  data_in = 'x;
	endfunction
	
endclass: fifo_item

`endif // FIFO_ITEM__SV