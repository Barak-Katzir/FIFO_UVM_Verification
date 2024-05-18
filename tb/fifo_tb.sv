
`ifndef TB_TOP__SV
`define TB_TOP__SV

import uvm_pkg::*;

//`include "uvm_macros.svh"

`include "fifo_pkg.sv"
import fifo_pkg::*;

// Interfaces
//`include "fifo_interface.sv"

`timescale 1ns/100ps

module fifo_tb;
  bit clk;
  bit reset;
  always #2 clk = ~clk;
  
  initial begin
	clk = 0;
	reset = 1;
	#6;
	reset = 0;
  end
  
  //add  fifo_if
  fifo_if fifo_vif(clk, reset);
  
  //add DUT(.clk(vif.clk),.reset(vif.reset),.in1(vif.ip1),.in2(vif.ip2),.out(vif.out));
 fifo #(
	  .DATA_WIDTH    (8),
	  .ADDR_WIDTH    (4)
	) u_fifo(
	  .clk           (fifo_vif.clk),
	  .rst           (fifo_vif.rst),
	  .rd_en         (fifo_vif.rd_en),
	  .wr_en         (fifo_vif.wr_en),
	  .data_in       (fifo_vif.data_in),
	  .data_out      (fifo_vif.data_out),
	  .empty         (fifo_vif.empty),
	  .full          (fifo_vif.full)
	);

  initial begin
	// set interface in config_db
	uvm_config_db#(virtual fifo_if)::set(uvm_root::get(), "*", "vif", fifo_vif);
  end
  initial begin
	run_test("fifo_test");
  end
endmodule

`endif // TB_TOP__SV