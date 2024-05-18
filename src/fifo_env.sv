`ifndef FIFO_ENVIRONMENT__SV
`define FIFO_ENVIRONMENT__SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_env extends uvm_env;
   `uvm_component_utils(fifo_env)
   fifo_agent f_agt;
   fifo_scoreboard f_scb;
   virtual fifo_if vif;
   
   // Constructor
   function new(string name = "fifo_env", uvm_component parent);
	 super.new(name, parent);
   endfunction
 
   // Build phase: Creating instances of agent and scoreboard
   virtual function void build_phase(uvm_phase phase);
	 super.build_phase(phase);
	 f_agt = fifo_agent::type_id::create("f_agt", this);
	 f_scb = fifo_scoreboard::type_id::create("f_scb", this);
	 
	 // Interface retrieval should typically be done in the connect_phase or higher phases
	 if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
	   `uvm_error("NOVIF", "Virtual interface not set for fifo_environment.");
	 end
	 
	 // Setting virtual interface for agent and scoreboard
	 uvm_config_db#(virtual fifo_if)::set(this, "f_agt.*", "vif", vif);
	 uvm_config_db#(virtual fifo_if)::set(this, "f_scb.*", "vif", vif);
   endfunction
 
   // Connect phase: Connect monitor's item port to scoreboard's analysis port
   virtual function void connect_phase(uvm_phase phase);
	 super.connect_phase(phase);
	 f_agt.f_monitor.item_port.connect(f_scb.item_got_imp);
	 `uvm_info("FIFO_ENV", "connect_phase: Monitor connected to the scoreboard", UVM_LOW);
   endfunction
 
endclass

`endif
