`ifndef DUT_TEST_BASE__SV
`define DUT_TEST_BASE__SV

`include "uvm_macros.svh"
// Uncomment the following lines if needed, ensuring fifo_pkg is correctly implemented
// `include "fifo_pkg.sv"
 import fifo_pkg::*;
 import uvm_pkg::*;

class fifo_test extends uvm_test;
	fifo_env f_env;
	`uvm_component_utils(fifo_test)
	virtual fifo_if vif;  
    int fifo_count;
	
	// Constructor
	function new(string name = "fifo_test", uvm_component parent = null);
		super.new(name, parent);
		fifo_count = 0;
	endfunction
  
	// Build phase: Create an instance of the FIFO environment
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		f_env = fifo_env::type_id::create("f_env", this);
		if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
			`uvm_error("NOVIF", "Virtual interface not set for fifo_test.");
		end
		uvm_config_db#(virtual fifo_if)::set(this, "f_env.*", "vif", vif);
	endfunction

	function void enable_debug();
		`ifdef DEBUG
			$fsdbDumpvars;
		`endif
	endfunction

	// Task to perform random FIFO testing
	task fifo_random_test();
		int delay;
		$display("%t run phase start: ", $time);
		for(int i = 0; i < (3000); i++) begin
			fifo_sequence seq;
//			void'(std::randomize(delay) with {
//				delay dist {0:/40, [1:3]:/20, [4:10]:/20, [11:15]:/15, [16:100]:/5};
//					});
//			repeat(delay) begin
//				#4;	
//			end
			$display("\n********** Writing/Reading operation %d", i + 1);
			seq = fifo_sequence::type_id::create("seq", this); 
			//seq.set_mode(fifo_sequence::WR_EN);// Set mode to write
			seq.start(f_env.f_agt.f_sequencer);
			end
		#100;
	endtask
	
	// Task to perform FIFO full test
	task fifo_full_test();
		$display("%t run phase start: ", $time);
		for(int i = 0; i < 16; i++) begin
			if(fifo_count<=16) begin
				fifo_sequence seq;
				$display("\n********** Writing operation %d", i + 1);
				seq = fifo_sequence::type_id::create("seq", this); 
				seq.set_mode(fifo_sequence::WR_EN);// Set mode to write
				seq.start(f_env.f_agt.f_sequencer); 
				fifo_count++;
			end
		end
		#100;
	endtask
	
	// Task to perform FIFO empty test
	task fifo_empty_test();
		$display("%t run phase start: ", $time);
		for(int i = 0; i < 16; i++) begin
			if(fifo_count<16) begin
				fifo_sequence seq;
				$display("\n********** Writing operation %d", i + 1);
				seq = fifo_sequence::type_id::create("seq", this); 
				seq.set_mode(fifo_sequence::WR_EN);// Set mode to Write
				seq.start(f_env.f_agt.f_sequencer);
				fifo_count++;
			end
		end
		for(int i = 0; i < 16; i++) begin
			if(fifo_count>0) begin
			fifo_sequence seq;
			$display("\n********** Reading operation %d", i + 1);
			seq = fifo_sequence::type_id::create("seq", this); 
			seq.set_mode(fifo_sequence::RD_EN);// Set mode to Read
			seq.start(f_env.f_agt.f_sequencer);
			fifo_count--;
			end
		end
		#100;
	endtask 
	
	// Task to perform FIFO fill & reset test
	task fifo_fill_reset_test();
		$display("%t run phase start: ", $time);
		for(int i = 0; i < 8; i++) begin
			if(fifo_count<8) begin
				fifo_sequence seq;
				$display("\n********** Writing operation %d", i + 1);
				seq = fifo_sequence::type_id::create("seq", this); 
				seq.set_mode(fifo_sequence::WR_EN);// Set mode to Write
				seq.start(f_env.f_agt.f_sequencer);
				fifo_count++;
			end
		end
		// Perform the reset
		f_env.f_agt.vif.rst = 1'b1;
		#5
		f_env.f_agt.vif.rst = 1'b0; // Release the reset
		#100;
		`uvm_info("FIFO_RESET_INFO", $psprintf("\nFIFO state after reset: data_in=%0h,data_out=%0h,wr_en=%0d,rd_en=%0h,full=%0h,empty=%0d\n", f_env.f_agt.vif.data_in,f_env.f_agt.vif.data_out,f_env.f_agt.vif.wr_en,f_env.f_agt.vif.rd_en,f_env.f_agt.vif.full,f_env.f_agt.vif.empty), UVM_LOW);
	endtask 
	
	// Task to perform FIFO Write and Read Simultaneous test
	task fifo_read_write_test();
		$display("%t run phase start: ", $time);
		for(int i = 0; i < 12; i++) begin
			if(fifo_count<=12) begin
				fifo_sequence seq;
				$display("\n********** Write/Read operation %d", i + 1);
				seq = fifo_sequence::type_id::create("seq", this); 
				seq.set_mode(fifo_sequence::RD_WR);// Set mode to Write/Read
				seq.start(f_env.f_agt.f_sequencer);
				fifo_count++;
			end
		end
		#100;
	endtask
	
	// Task to perform FIFO Read from empty test
	task read_from_empty_test();
		$display("%t run phase start: ", $time);
		vif.rd_en = 1;
		begin
			fifo_sequence seq;
			$display("\n********** Reading operation %d", 1);
			seq = fifo_sequence::type_id::create("seq", this); 
			seq.set_mode(fifo_sequence::RD_WR);// Set mode to Read
			vif.wr_en = 0;
			seq.start(f_env.f_agt.f_sequencer);
			fifo_count--;
		end
		#100;
	endtask
	
	// Task to perform FIFO Write from full test
	task write_to_full_test();
		$display("%t run phase start: ", $time);
		for(int i = 0; i < 17; i++) begin
			if(fifo_count<17) begin
				fifo_sequence seq;
				$display("\n********** Writing operation %d", i + 1);
				seq = fifo_sequence::type_id::create("seq", this); 
				seq.set_mode(fifo_sequence::WR_EN);// Set mode to Write
				seq.start(f_env.f_agt.f_sequencer);
				fifo_count++;
			end
		end
		#100;
	endtask
	
	// Task to perform FIFO Writing to last place test
	task write_to_last_test();
		$display("%t run phase start: ", $time);
		for(int i = 0; i < 15; i++) begin
			if(fifo_count<15) begin
				fifo_sequence seq;
				$display("\n********** Writing operation %d", i + 1);
				seq = fifo_sequence::type_id::create("seq", this); 
				seq.set_mode(fifo_sequence::WR_EN);// Set mode to Write
				seq.start(f_env.f_agt.f_sequencer);
				fifo_count++;
			end
		end
		begin
		// Write to the last available place in the FIFO
		fifo_sequence last_seq;
		$display("\n********** Writing to the last available place");
		last_seq = fifo_sequence::type_id::create("last_seq", this);
		last_seq.set_mode(fifo_sequence::WR_EN); // Set mode to Write
		last_seq.start(f_env.f_agt.f_sequencer); 
		fifo_count++;
		end
		#100;
	endtask
	
	// Task to perform FIFO Read from first place test
	task read_from_first_test();
		$display("%t run phase start: ", $time);
		for(int i = 0; i < 8; i++) begin
			if(fifo_count<8) begin
				fifo_sequence seq;
				$display("\n********** Writing operation %d", i + 1);
				seq = fifo_sequence::type_id::create("seq", this); 
				seq.set_mode(fifo_sequence::WR_EN);// Set mode to Write
				seq.start(f_env.f_agt.f_sequencer);
				fifo_count++;
			end
		end
		for(int i = 0; i < 1; i++) begin
			if(fifo_count>=0) begin
			fifo_sequence seq;
			$display("\n********** Reading operation %d", i + 1);
			seq = fifo_sequence::type_id::create("seq", this); 
			seq.set_mode(fifo_sequence::RD_EN);// Set mode to Read
			seq.start(f_env.f_agt.f_sequencer);
			fifo_count--;
			end
		end
		#100;
	endtask

	virtual task run_phase(uvm_phase phase);
		enable_debug();
		phase.raise_objection(this);
		wait(f_env.f_agt.vif.rst === 0);
		@(f_env.f_agt.vif.cb_driver)
		fifo_random_test();
		//fifo_full_test(); 
		//fifo_empty_test();
		//fifo_fill_reset_test();
		//fifo_read_write_test();
		//read_from_empty_test();
		//write_to_full_test();
		//write_to_last_test();
		//read_from_first_test();
		enable_debug();
		phase.drop_objection(this);
		`uvm_info(get_type_name(), "End of test", UVM_LOW);
	endtask
  
endclass

`endif // DUT_TEST_BASE__SV