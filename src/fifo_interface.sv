`ifndef FIFO_IF__SV
`define FIFO_IF__SV

//`timescale 1ns/100ps
parameter DATA_WIDTH = 8;

interface fifo_if(input bit clk_in, input bit rst_in);
	logic                  clk;
	logic                  rst;
	logic                  rd_en;
	logic                  wr_en;
	logic [DATA_WIDTH-1:0] data_in;
	logic                  full;
	logic                  empty;
	logic [DATA_WIDTH-1:0] data_out;
	
	assign clk = clk_in;
	assign rst = rst_in ;
   
	// Clocking block for driver
   clocking cb_driver @(posedge clk);
		output   rd_en;
		output   wr_en;
		output   data_in;
		input    full;
		input    empty;
		input    data_out;
	endclocking

	// Clocking block for monitor
	clocking cb_monitor @(posedge clk);
		input    rd_en;
		input    wr_en;
		input    data_in;
		input    full;
		input    empty;
		input    data_out;
	endclocking
   
	modport driver (input clk, rst, clocking cb_driver);
	modport monitor (input clk, rst, clocking cb_monitor); 

endinterface: fifo_if

`endif // FIFO_IF__SV