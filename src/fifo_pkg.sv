`ifndef FIFO__SV
`define FIFO__SV

`include "uvm_pkg.sv"
`include "uvm_macros.svh"
`include "fifo_interface.sv"
`include "fifo_defines.sv"

package fifo_pkg; 
  import uvm_pkg::*;

  `include "fifo_seq_item.sv"
  `include "fifo_sequence.sv"
  `include "fifo_sequencer.sv"
  `include "fifo_driver.sv"
  `include "fifo_monitor.sv"
  `include "fifo_scoreboard.sv"
  `include "fifo_agent.sv"
  `include "fifo_env.sv"

endpackage

`endif  // FIFO__SV
