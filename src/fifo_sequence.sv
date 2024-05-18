`ifndef FIFO_SEQUENCE__SV
`define FIFO_SEQUENCE__SV

class fifo_sequence extends uvm_sequence#(fifo_item);
	`uvm_object_utils(fifo_sequence)

   typedef enum {WR_EN, RD_EN, RD_WR} fifo_mode;
   rand fifo_mode mode;
   static int queue_count = 0;
   
   // Constructor
	function new(string name = "fifo_sequence");
	  super.new(name);
	  
	endfunction
   
	// Function to set the mode of the sequence
   function void set_mode(fifo_mode fmode);
	   	mode.rand_mode(0);
		mode = fmode;
   endfunction
   
   // This task initializes the sequence by randomizing its mode,
   // Adjusts the queue count based on the mode.
	virtual task pre_body();
		super.pre_body();
		if (!this.randomize()) begin
			`uvm_fatal(get_name(), "Seq Randomize fail - mode")
		end
		`uvm_info(get_full_name(), $sformatf("Start Queue count %d: mode %s",queue_count, mode.name()),UVM_NONE)
		if (mode == WR_EN) begin
			if(queue_count == 16) begin
				mode = RD_EN;
				queue_count--;
			end else begin
				queue_count++;
			end
		end
		else if (mode == RD_EN) begin
			if(queue_count == 0)begin
				mode = WR_EN;
				queue_count++;
			end else begin
				queue_count--;
			end
		end
		else if (mode == RD_WR) begin
			if(queue_count == 0) begin
				mode = WR_EN;
				queue_count++;
			end
			else if(queue_count == 16) begin
				mode = RD_EN;
				queue_count--;
			end else begin
				// Perform both read and write operations simultaneously
				fork
					begin
						// Read operation
						queue_count--;
					end
					begin
						// Write operation
						queue_count++;
					end
				join
			end
		end
		`uvm_info(get_full_name(), $sformatf("End Queue count %d: mode %s",queue_count, mode.name()),UVM_NONE)
	endtask
   
	virtual task body();
	  fifo_item item;
	  // 1. Write Request Only
	  if (mode == WR_EN) begin
		  item = fifo_item::type_id::create("item");
		  start_item(item);
		  assert(item.randomize() with {wr_en == 1'b1;rd_en == 1'b0;}) else `uvm_error("SEQ", "Randomization failed");
		  `uvm_info(get_full_name(), $sformatf("Sequence before finish: item %s",item.convert2string()),UVM_NONE)
		  finish_item(item);
		  `uvm_info(get_full_name(), $sformatf("Sequence bedore finish: item %s",item.convert2string()),UVM_NONE)

	  end
	  
	  // 2. Read Request Only
	  if (mode == RD_EN) begin
		  item = fifo_item::type_id::create("item");
		  start_item(item);
		  assert(item.randomize() with {rd_en == 1'b1;wr_en == 1'b0;}) else `uvm_error("SEQ", "Randomization failed");
		  `uvm_info(get_full_name(), $sformatf("Sequence before finish: item %s",item.convert2string()),UVM_NONE)
		  finish_item(item);
		  `uvm_info(get_full_name(), $sformatf("Sequence bedore finish: item %s",item.convert2string()),UVM_NONE)

	  end
	  
	  // 3. Simultaneous Read and Write
	  if (mode == RD_WR) begin
		  item = fifo_item::type_id::create("item");
		  start_item(item);
		  assert(item.randomize() with {wr_en == 1'b1;rd_en == 1'b1;}) else `uvm_error("SEQ", "Randomization failed");
		  `uvm_info(get_full_name(), $sformatf("Sequence before finish: item %s",item.convert2string()),UVM_NONE)
		  finish_item(item);
		  `uvm_info(get_full_name(), $sformatf("Sequence bedore finish: item %s",item.convert2string()),UVM_NONE)

	  end
	endtask
	
endclass
`endif // FIFO_SEQUENCE__SV