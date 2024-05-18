`ifndef FIFO_SEQUENCER__SV
`define FIFO_SEQUENCER__SV

class fifo_sequencer extends uvm_sequencer#(fifo_item);
  `uvm_component_utils(fifo_sequencer)

  // Constructor
  function new (string name = "fifo_sequencer", uvm_component parent = null);
	super.new(name, parent);
  endfunction: new

endclass: fifo_sequencer

`endif // FIFO_SEQUENCER__SV