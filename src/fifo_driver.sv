`ifndef FIFO_DRIVER__SV
`define FIFO_DRIVER__SV
`ifndef DRIV_IF_CB
`define DRIV_IF_CB vif.driver.cb_driver
`endif

class fifo_driver extends uvm_driver #(fifo_item);
	`uvm_component_utils(fifo_driver)
	
	virtual fifo_if vif; // FIFO interface instance
	
	// Constructor
	function new(string name = "fifo_driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	// Build phase: Configures the virtual interface
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
				if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
					`uvm_fatal("DRV", "Could not get virtual interface");
	endfunction
	
	// Main driver task
	virtual task run_phase(uvm_phase phase);
		fifo_item item;
		wait (vif.rst === 0); // Wait for reset signal to deassert
		forever begin
			seq_item_port.get_next_item(item);
			`uvm_info(get_full_name(), $sformatf("Sequence push: item %s",item.convert2string()),UVM_NONE)
			drive_vif(item); // Drive item onto the interface
			seq_item_port.item_done();
		end
	endtask
	
	// Helper method to handle write operation: Drives item onto the FIFO interface
	protected task drive_vif(fifo_item item);
		`DRIV_IF_CB.wr_en <= item.wr_en;
		`DRIV_IF_CB.rd_en <= item.rd_en;
		`DRIV_IF_CB.data_in <= item.data_in;
		@(`DRIV_IF_CB);
		`DRIV_IF_CB.wr_en <= 0;
		`DRIV_IF_CB.rd_en <= 0;
		`DRIV_IF_CB.data_in <= 'x;
	endtask
	
endclass
`endif