`ifndef FIFO_MONITOR__SV
`define FIFO_MONITOR__SV
`endif
`ifndef MON_IF_CB 
`define MON_IF_CB vif.monitor.cb_monitor
`endif
parameter DATA_WIDTH = 8;

class fifo_monitor extends uvm_monitor;
   `uvm_component_utils(fifo_monitor)
	virtual fifo_if vif;
   uvm_analysis_port#(fifo_item) item_port; // Analysis port for sending monitored items
   
   // Sampled signals for monitoring
   logic rd_en_sample;
   logic wr_en_sample;
   logic [DATA_WIDTH-1:0] data_in_sample;
   
   // Constructor
	function new(string name = "fifo_monitor", uvm_component parent);
	  super.new(name, parent);
	  rd_en_sample=0;
	  wr_en_sample=0;
	  data_in_sample='x;
	endfunction

	// Build phase: Configures the virtual interface and sets up analysis port
	virtual function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
	  if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
		 `uvm_fatal("Monitor: ", "No vif is found!");
	  end
	  item_port = new ("item_port", this);
	endfunction
	
	// Main monitor task: Monitors the FIFO interface signals and sends monitored items to analysis port
	virtual task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  forever begin
		 fifo_item item_got;
		 item_got = new ();
		 begin
			@(`MON_IF_CB);
			if( rd_en_sample || wr_en_sample) begin
				// Assign sampled signals to item properties
				item_got.data_out = `MON_IF_CB.data_out;
				item_got.data_in = data_in_sample;
				item_got.rd_en = rd_en_sample;
				item_got.wr_en = wr_en_sample;
				item_got.empty = `MON_IF_CB.empty;
				item_got.full = `MON_IF_CB.full;
				`uvm_info(get_full_name(), $sformatf("Monitored item %s",item_got.convert2string()),UVM_NONE)
				item_port.write(item_got);
			end
			// Update sampled signals
			rd_en_sample = `MON_IF_CB.rd_en;
			wr_en_sample = `MON_IF_CB.wr_en;
			data_in_sample = `MON_IF_CB.data_in;   
		 	end
		 end
	endtask
endclass