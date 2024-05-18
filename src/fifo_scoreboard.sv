`ifndef FIFO_SCOREBOARD__SV
`define FIFO_SCOREBOARD__SV
`ifndef MON_IF 
`define MON_IF vif.monitor
`endif
`ifndef MON_IF_CB 
`define MON_IF_CB vif.monitor.cb_monitor
`endif

class fifo_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(fifo_scoreboard)
	uvm_analysis_imp#(fifo_item, fifo_scoreboard) item_got_imp;
	virtual fifo_if vif;
	fifo_item queue[$];

	// Constructor
	function new(string name = "fifo_scoreboard", uvm_component parent);
		super.new(name, parent);
		item_got_imp = new("item_got_imp", this);
	endfunction
   
	// Build phase: Configures the scoreboard
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
			`uvm_error("build_phase", "No virtual interface specified for this scoreboard instance")
		end
	endfunction
   
	// Method to process received item from analysis port
	function void write(input fifo_item item_got);
		bit full;
		bit empty;
		fifo_item item;
		
		// Check for reset condition
		if (vif.rst) begin
			queue.delete(); // Clear the FIFO queue on reset
			full = 0;
			empty = 0;
			return; // Exit the function without processing the current item when in reset state
		end
		
		if (item_got.rd_en) begin
			if (queue.size() == 0) begin
				`uvm_fatal(get_name(), $sformatf("Error (tried to read from empty queue - underflow)"))
			end
			item = queue.pop_front();
		end  
		
		if (item_got.wr_en) begin
			queue.push_back(item_got);
		end

		// Check FIFO status
		full = queue.size() >= 2**`ADDR_WIDTH;
		empty = queue.size() == 0;
		if (full != item_got.full) begin
			`uvm_error(get_name(), $sformatf("Error (full mismatch, exp %b, act %b)",full, item_got.full))
		end
		// Check for overflow
		if (queue.size() > 2**`ADDR_WIDTH) begin
			`uvm_error(get_name(), $sformatf("Error (overflow mismatch fifo size: %0d)",queue.size()))
		end
		// Check for mismatches in empty flag
		if (empty != item_got.empty) begin
			`uvm_error(get_name(), $sformatf("Error (empty mismatch, exp %b, act %b)",empty, item_got.empty))
		end
		// If an item is read from the FIFO, check for data mismatch
		if (item != null) begin
			if (item.data_in != item_got.data_out) begin
				`uvm_error(get_name(), $sformatf("Error (data out mismatch, exp 0x%0h, act 0x%0h)",item.data_out, item_got.data_out))
			end
		end
	endfunction

endclass
`endif
