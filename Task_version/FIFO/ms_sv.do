

# Delete old compilation results
if { [file exists "work"] } {
    vdel -all
}

# Create new modelsim working library

vlib work

# Compile all the Verilog sources in current folder into working library

vlog test_non_one_slave.sv AHB_Lite_master_task.sv AHB_Lite_slave.sv AHB_Lite_defines.sv AHB_Lite_decoder.sv AHB_Lite_mux.sv FIFO.sv

# Open testbench module for simulation

vsim -t 1ns -voptargs="+acc" work.test_non_one_slave

# Add all testbench signals to waveform diagram


add wave /test_non_one_slave/*
add wave /test_non_one_slave/master/pipelined_data
add wave /test_non_one_slave/master/*

add wave /test_non_one_slave/slave0/memory
add wave /test_non_one_slave/slave1/memory

add wave /test_non_one_slave/slave0/pipelined_haddr
add wave /test_non_one_slave/slave0/pipelined_hsel
add wave /test_non_one_slave/slave0/pipelined_hwrite
add wave /test_non_one_slave/slave0/pipelined_hwdata


add wave /test_non_one_slave/slave1/pipelined_haddr
add wave /test_non_one_slave/slave1/pipelined_hsel
add wave /test_non_one_slave/slave1/pipelined_hwrite
add wave /test_non_one_slave/slave1/pipelined_hwdata

add wave /test_non_one_slave/master/mem
add wave /test_non_one_slave/slave0/max_addr_calc
add wave /test_non_one_slave/slave1/max_addr_calc
add wave /test_non_one_slave/slave1/MEMORY_SIZE
add wave /test_non_one_slave/slave0/delay_counter
add wave /test_non_one_slave/slave1/delay_counter

onbreak resume

# Run simulation
run -all

wave zoom full