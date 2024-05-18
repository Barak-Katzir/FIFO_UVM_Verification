`ifndef FIFO_AGENT__SV
`define FIFO_AGENT__SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_agent extends uvm_agent;
  `uvm_component_utils(fifo_agent)

  fifo_sequencer f_sequencer;
  fifo_driver f_driver;
  fifo_monitor f_monitor;
  virtual fifo_if vif;
  
  // Constructor
  function new(string name = "fifo_agent", uvm_component parent);
	super.new(name, parent);
  endfunction

  // Build phase: Creating instances of sequencer, driver, and monitor
  virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	f_sequencer = fifo_sequencer::type_id::create("f_sequencer", this);
	f_driver = fifo_driver::type_id::create("f_driver", this);
	f_monitor = fifo_monitor::type_id::create("f_monitor", this);

	// Check and retrieve the virtual interface from configuration database
	if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
	  `uvm_error("NOVIF", "Virtual interface not set for fifo_agent.");
	end else begin
	  uvm_config_db#(virtual fifo_if)::set(this, "*", "vif", vif);
	end
  endfunction

  // Connect phase: Connect driver to sequencer
  virtual function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	f_driver.seq_item_port.connect(f_sequencer.seq_item_export);
	`uvm_info("FIFO_AGENT", "connect_phase: Driver connected to the sequencer.", UVM_LOW)
  endfunction

endclass

`endif
