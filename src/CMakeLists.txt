set(SOURCES
    fifo_pkg.sv
    ../tb/fifo_tb.sv
    ../test/fifo_test.sv
    
)
 
set(HEADERS
    fifo_defines.sv
    fifo_seq_item.sv
    fifo_sequence.sv
    fifo_interface.sv
    fifo_sequencer.sv
    fifo_driver.sv
    fifo_monitor.sv
    fifo_scoreboard.sv
    fifo_agent.sv
    fifo_env.sv
  )

add_verilog_analysis(fifo_tb_lab SOURCES ${SOURCES} HEADERS ${HEADERS} UVM 1.2)
target_include_directories(fifo_tb_lab PRIVATE .)

add_verilog_exe(fifo_tb_lab.simv TOP fifo_tb)
target_link_libraries(fifo_tb_lab.simv PRIVATE fifo_tb_lab fifo)

add_test(NAME fifo_tb_lab_fifo_test}
            COMMAND fifo_tb_lab.simv +TEST=fifo_test -exitstatus -l fifo_test.simv.log +fsdbfile+fifo_test.fsdb)
